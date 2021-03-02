#!/usr/bin/env sh

# from https://github.com/Drivetech/mongodump-s3
# Environent variables to set
# MONGO_USER
# MONDO_PASSWORD
# MONGO_SERVER
# MONGO_SERVER_PORT
# S3_BUCKET
# S3_PATH

BACKUP_NAME="$(date -u +%Y-%m-%d_%H-%M-%S)_UTC.gz"
CERT_FILE="/usr/local/bin/rds-combined-ca-bundle.pem"

# Run backup
mongodump --archive \
  --ssl \
  --uri "mongodb://${MONGO_USER}:${MONDO_PASSWORD}@${MONGO_SERVER}:${MONGO_SERVER_PORT}/?tls=true&tlsCAFile=${CERT_FILE}&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false" \
	--out=/backup/dump \
	--db=fhir_dev

# Compress backup
cd /backup/ && tar -cvzf "${BACKUP_NAME}" dump
# Upload backup
aws s3 cp "/backup/${BACKUP_NAME}" "s3://${S3_BUCKET}/${S3_PATH}/${BACKUP_NAME}"
# Delete temp files
rm -rf /backup/dump
