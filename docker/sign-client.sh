#!/usr/bin/env sh
# usage: ./sign-client.sh

# create key
openssl genrsa -out client.key.pem 4096

# create csr
openssl req -subj '/CN=client' -new -key client.key.pem -out client.csr

# create extfile
echo extendedKeyUsage = clientAuth > client-extfile.cnf

# sign
openssl x509 -req -days 3650 -sha256 -in client.csr -CA ca.pem -CAkey ca.key.pem \
    -CAcreateserial -out client.cert.pem -extfile client-extfile.cnf

# access
chmod -v 0400 client.key.pem
chmod -v 0444 client.cert.pem

# clean
rm -f client-extfile.cnf client.csr
