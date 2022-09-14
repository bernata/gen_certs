#!/bin/bash

GOPATH=$(go env GOPATH)
CFSSL=$GOPATH/bin/cfssl
CFSSLJSON=$GOPATH/bin/cfssljson
CA_CONFIG=./ca_config.json

echo "*** INSTALL CFSSL/CFSSLJSON ***"
go install github.com/cloudflare/cfssl/cmd/cfssl@latest
go install github.com/cloudflare/cfssl/cmd/cfssljson@latest

echo
echo "*** ROOT CA CERT ***"
mkdir -p ./certs
$CFSSL genkey \
      -initca \
      -config=${CA_CONFIG} \
      ./root_ca.json | ${CFSSLJSON} -bare ./certs/root_ca

echo
echo "*** ISSUING CA CERT ***"
$CFSSL genkey \
      -initca \
      -config=${CA_CONFIG} \
      ./issuer_ca.json | ${CFSSLJSON} -bare ./certs/self_signed_issuer_ca

$CFSSL sign \
      -config=${CA_CONFIG} \
      -profile=ca \
      -ca ./certs/root_ca.pem \
      -ca-key ./certs/root_ca-key.pem \
      -csr ./certs/self_signed_issuer_ca.csr | ${CFSSLJSON} -bare ./certs/issuer_ca

echo
echo "*** SERVER CERT ***"
$CFSSL gencert \
      -config=${CA_CONFIG} \
      -profile=server \
      -ca ./certs/issuer_ca.pem \
      -ca-key ./certs/self_signed_issuer_ca-key.pem \
      -hostname=localhost,127.0.0.1,"${HOSTNAME}" \
      ./server.json | ${CFSSLJSON} -bare ./certs/server

