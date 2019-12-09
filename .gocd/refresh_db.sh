#!/bin/bash

echo "User: $(id -u)"
echo "Working Directory: $(pwd)"

source_db_server=$1
echo "Source DB server: $source_db_server"

dest_db_server=$2
echo "Destination DB server: $dest_db_server"

database=$3
echo "Database name: $database"

echo "Refresh $database database. Source: $source_db_server, Destination: $dest_db_server"
ssh root@$dest_db_server "docker run --network mongonetwork --rm mongo:3.6-jessie mongo --host mongocontainer --eval \"db = db.getSiblingDB('$database'); db.dropDatabase(); db.copyDatabase('$database', '$database', '$source_db_server');\""
