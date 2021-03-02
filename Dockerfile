FROM debian:stable-slim

# https://docs.mongodb.com/manual/tutorial/install-mongodb-on-debian/

# Install required gnupg package
RUN apt-get update && \
    # Install security updates:
    apt-get -y upgrade && \
    apt-get -y install gnupg curl && \
    # Install required ca-certificates to prevent the error in the certificate verification
    apt-get -y install ca-certificates && update-ca-certificates && \
    # Download the Amazon DocumentDB Certificate Authority (CA) certificate required to authenticate to your cluster
    curl https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem -o /usr/local/bin/rds-combined-ca-bundle.pem && \
    curl https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add - && \
    echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.4 main" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list && \
    # Install the MongoDB packages
    apt-get update && \
    apt-get -y install mongodb-org-shell && \
    apt-get -y install mongodb-org-tools && \
    apt-get -y install awscli && \
    apt-get clean autoclean && \
    apt-get autoremove --yes && \
    # Delete cached files we don't need anymore:
    apt-get clean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

ENV AWS_DEFAULT_REGION=us-east-1

COPY promote.sh /usr/local/bin/promote
COPY backup.sh /usr/local/bin/backup

RUN chmod +777 /usr/local/bin/promote
RUN chmod +777 /usr/local/bin/backup

CMD ["tail", "-f", "/dev/null"]
