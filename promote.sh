#!/bin/bash

from_db=$1
to_db=$2

mongodump --archive --ssl --uri "${MONGOCLIENT_DEFAULT_CONNECTION_URL}" --db=${from_db} | mongorestore --ssl --uri "${MONGOCLIENT_DEFAULT_CONNECTION_URL}" --archive  --nsFrom="${from_db}.*" --nsTo="${to_db}.*" --drop