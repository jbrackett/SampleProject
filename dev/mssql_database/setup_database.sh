#!/usr/bin/env bash
# Wait for database to startup
sleep 20
./opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P mssqlDockerPW! -i setup.sql