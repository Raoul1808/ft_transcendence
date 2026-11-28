#!/bin/sh

openssl req \
    -x509 \
    -newkey rsa:4096 \
    -keyout secrets/ssl_key.pem \
    -out secrets/ssl_cert.pem \
    -sha256 \
    -days 3650 \
    -nodes \
    -subj "/C=FR/CN=$DOMAIN_NAME"
