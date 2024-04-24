#!/bin/bash

START_DEPS_CMD="docker compose up -d --build postgres redis sql-server-db"
START_CMD="exec java -jar -Dserver.port=8099"
DEBUG_CMD="-Xms128m -Xmx128m -Xdebug -Xrunjdwp:transport=dt_socket,address=*:5004,server=y,suspend=y"
JAR="build/libs/SampleProject.jar"

# load the local environment variable settings
#export $(cat local.env | xargs)
export $(grep -v '^#' local.env | xargs)

ARGS="-m"
if [[ "$1" != "" ]]; then
  ARGS=$1
fi

case $ARGS in
  -m|--minimal)
    eval $START_DEPS_CMD
    LOG_APPENDER=console $START_CMD $JAR
    ;;
  -j|--json)
    eval $START_DEPS_CMD
    $START_CMD $JAR | sed -l 's/^[^{]*//' | jq -r --unbuffered ' .exception_obj.stacktrace as $stack | if $stack then (.exception_obj.stacktrace)="...stacktrace..." | ., "\($stack)" else . end'
    ;;
  -r|--raw)
    LOG_APPENDER=json
    eval $START_DEPS_CMD
    $START_CMD $JAR
    ;;
  -D|--debug)
    eval $START_DEPS_CMD
    $START_CMD $DEBUG_CMD $JAR
    ;;
  -d|--docker)
    docker build -t travel-config-orchestrator .
    docker compose up -d
    docker compose logs -f -t travel-config-orchestrator
    ;;
  -h|--help)
    cat <<EOM
Usage: ./run.sh [-d|--docker] [-m|--minimal] [-j|--json] [-r|--raw] [-h|--help]
   -m --minimal   tiny messages (default)
   -j --json      pretty json
   -r --raw       unformatted json
   -d --docker    run in docker container
   -D --debug     run in remote JVM debug mode
EOM
    ;;
esac
