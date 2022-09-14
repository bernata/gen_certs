# Generate Certificate Chain

Using cloudflare tooling to generate: root, issuing ca, server certificates.

1. ca_config.json: defines profiles that describe key size, EKUs, etc...
1. root_ca.json: description of the root cert; csr will be created from this description
1. issuer_ca.json: description of the issuing ca cert; csr will be created from this description
1. server.json: description of the server cert; csr will be created from this description

Generated csr, keys, certs appear in the `certs` directory.

Run `./gen_certs.sh` to produce the cert chain
