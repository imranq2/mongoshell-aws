FROM debian:stable

# https://docs.mongodb.com/manual/tutorial/install-mongodb-on-debian/

# Install required gnupg package
RUN apt-get update && apt-get -y install gnupg wget curl

# Install required ca-certificates to prevent the error in the certificate verification
RUN apt-get -y install ca-certificates && update-ca-certificates

# Download the Amazon DocumentDB Certificate Authority (CA) certificate required to authenticate to your cluster
RUN curl https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem -o /usr/local/bin/rds-combined-ca-bundle.pem

RUN curl https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add -
RUN echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.4 main" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list

RUN apt-get update

# Install the MongoDB packages
RUN apt-get -y install mongodb-org-shell && \
    apt-get -y install mongodb-org-tools && \
    apt-get -y install awscli

ENV AWS_DEFAULT_REGION=us-east-1

COPY promote.sh /usr/local/bin/promote
COPY backup.sh /usr/local/bin/backup

RUN chmod +777 /usr/local/bin/promote
RUN chmod +777 /usr/local/bin/backup

CMD ["tail", "-f", "/dev/null"]
