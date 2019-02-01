#!/usr/bin/env sh
# usage: HOST=example.com IP=127.0.0.1 ./sign-server.sh

# create key
openssl genrsa -out server.key.pem 4096

# create csr
openssl req -subj "/CN=${HOST}" -sha256 -new -key server.key.pem -out server.csr

# create extfile
echo subjectAltName = DNS:${HOST},IP:${IP} > server-extfile.cnf
echo extendedKeyUsage = serverAuth >> server-extfile.cnf

# sign
openssl x509 -req -days 3650 -sha256 -in server.csr -CA ca.pem -CAkey ca.key.pem \
    -CAcreateserial -out server.cert.pem -extfile server-extfile.cnf

# access
chmod -v 0400 server.key.pem
chmod -v 0444 server.cert.pem

# clean
rm -f server-extfile.cnf
