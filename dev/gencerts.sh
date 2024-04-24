#!/bin/bash

set -e -x

while getopts e: flag
do
    case "${flag}" in
        e) ENVIRONMENT="${OPTARG}";;
        *) echo "Invalid flag -${flag}" && exit 1
    esac
done

if [ -z "$ENVIRONMENT" ]; then
  echo "Environment value should be one of the following: integration, us2, eu2. Setting default environment to integration."
  ENVIRONMENT="integration"
fi

SECRET_SERVER="dss.$ENVIRONMENT.concur.global"
case $ENVIRONMENT in
    "integration"|"us2"|"eu2")
        SECRET_SERVER="dss.$ENVIRONMENT.concur.global"
        ;;
    *)
        echo "Invalid environment: $ENVIRONMENT. Should be one of the following: integration, us2, eu2."
        exit 1
        ;;
esac

USER_ACCOUNT=$(id -un | sed 's/GLOBAL+//')
DOMAIN_USER="$ENVIRONMENT\\$USER_ACCOUNT-a"

K8S_NAMESPACE="travel-admin"
# this is the Travel cluster in Integration
K8S_CLUSTER="$(kubectl config current-context)"
VAULT_NAMESPACE="t2/config"
VAULT_ROLE="travel-config-orchestrator"
CSR_EMAIL="DL_5D83AF05700BE20280D64243@global.corp.sap"
CSR_ORG="TRAVEL"
CSR_DOMAIN="com.concur.travel-admin.travel-config-orchestrator"
CSR_NAME="client"
CSR_SIZE="2048"
CSR_TTL=$(( 7 * 24 ))
CSR_REQ="${CSR_NAME}:
  cn: ${CSR_DOMAIN}
  dns:
  - ${CSR_DOMAIN}
"
KEYTOOL_OPTS="-providerpath src/test/resources/bc-fips-1.0.2.jar -providerclass org.bouncycastle.jcajce.provider.BouncyCastleFipsProvider"

K8S_TOKEN_NAME=$(kubectl --namespace ${K8S_NAMESPACE} get secrets -o name | grep default-token)

docker run -v $(pwd):/certs quay.cnqr.delivery/servicemesh/csrgen:3.0.3 create -email ${CSR_EMAIL} -keysize ${CSR_SIZE} -org ${CSR_ORG} -out /certs -req "${CSR_REQ}"

K8S_JWT=$(kubectl --namespace ${K8S_NAMESPACE} get ${K8S_TOKEN_NAME} -o json | jq -r '.data.token' | base64 -D)

REMOTE_CMD_1="curl -s -k -X POST -H \"X-Vault-Namespace: ${VAULT_NAMESPACE}\" https://vault.service.cnqr.tech/v1/auth/kraken/${K8S_CLUSTER}/login -d \"{\\\"role\\\": \\\"${VAULT_ROLE}\\\", \\\"jwt\\\": \\\"${K8S_JWT}\\\"}\" | jq -r \".auth.client_token\""
VAULT_TOKEN=$(tSSH -t $SECRET_SERVER -s $DOMAIN_USER -u $USER_ACCOUNT -d bast.service.cnqr.tech "$REMOTE_CMD_1")

echo "Received VAULT_TOKEN: ${VAULT_TOKEN}"
if [[ -z ${VAULT_TOKEN} || ${VAULT_TOKEN} == "null" ]]; then
  echo "Failed to retrieve VAULT_TOKEN"
  exit 1
fi
CSR_PEM=$(jq -n --arg csr "$(cat client.csr.pem)" --arg format pem_bundle --arg ttl ${CSR_TTL}h '{csr: $csr, format: $format, ttl: $ttl}')
CSR_PEM_UPDATED=$(echo "${CSR_PEM}" | sed 's/"/\\"/g')
REMOTE_CMD_2="curl -s -X POST -H \"X-Vault-Token: $VAULT_TOKEN\" --insecure https://vault.service.cnqr.tech/v1/${VAULT_NAMESPACE}/pki/client/sign/${VAULT_ROLE} -d \"${CSR_PEM_UPDATED}\""
VAULT_RESP=$(tSSH -t $SECRET_SERVER -s $DOMAIN_USER -u $USER_ACCOUNT -d bast.service.cnqr.tech "$REMOTE_CMD_2")
CERTIFICATE=$(echo "${VAULT_RESP}" | jq -r '.data.certificate')
CA_CHAIN=$(echo "${VAULT_RESP}" | jq -r '.data.ca_chain | join("\n")')

echo "${CERTIFICATE}" > "${CSR_NAME}.cert.pem"
echo "${CA_CHAIN}" > "${CSR_NAME}.chain.pem"

REMOTE_CMD_3="curl -sk https://ca.service.cnqr.tech/v1/trust/bundle.crt"
ROOT_CA=$(tSSH -t $SECRET_SERVER -s $DOMAIN_USER -u $USER_ACCOUNT -d bast.service.cnqr.tech "$REMOTE_CMD_3")
echo "${ROOT_CA}" > "root_bundle.crt"

if [[ -z ${JAVA_HOME} ]]; then
  JAVA_HOME=$(/usr/libexec/java_home)
fi

keytool -importkeystore -noprompt \
    -srckeystore ${JAVA_HOME}/lib/security/cacerts -srcstorepass "changeit" \
    -destkeystore certificate.bcfks -deststorepass "changeit" \
    -destprovidername BCFIPS -deststoretype BCFKS \
    ${KEYTOOL_OPTS}

openssl pkcs12 -export -out certificate.pfx -inkey client.key.pem -in client.cert.pem -password pass:changeit
keytool -noprompt -importkeystore -srckeystore certificate.pfx -srcstoretype PKCS12 -destkeystore certificate.bcfks -deststoretype BCFKS -destprovidername BCFIPS -srcstorepass "changeit" -deststorepass "changeit" ${KEYTOOL_OPTS}

awk 'BEGIN {n=1}
	split_after == 1 {n++;split_after=0} /-----END CERTIFICATE-----/ {split_after=1}{print > ("vault-ca-" n ".pem")}' < "root_bundle.crt"
for CERT in vault-ca-*; do
	keytool -import -file $CERT -alias ${CERT##*/} -storepass changeit -keystore certificate.bcfks -noprompt ${KEYTOOL_OPTS}
	rm $CERT
done

mv certificate.bcfks src/main/resources
mv certificate.pfx dev/certs

rds_bundle_name="rds_bundle.pem"
rds_pem_endpoint="https://truststore.pki.rds.amazonaws.com/us-west-2/us-west-2-bundle.pem"
echo "Downloading pem from ${rds_pem_endpoint}"
curl -k -sS ${rds_pem_endpoint} > ${rds_bundle_name}
echo "Finished downloading pem"

rm root_bundle.crt
