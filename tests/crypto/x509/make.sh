#!/usr/bin/env bash
# Regenerates the synthetic certificates in this directory with openssl.
# The AMD (amd-ark-*.der, amd-ask-*.der) and AWS Nitro (aws-nitro-root.der)
# certificates are the vendors' published ones, fetched once:
#   https://kdsintf.amd.com/vcek/v1/{Milan,Genoa}/cert_chain
#   https://aws-nitro-enclaves.amazonaws.com/AWS_NitroEnclaves_Root-G1.zip
# Keys are thrown away; only the certificates are kept.
set -euo pipefail
cd "$(dirname "$0")"
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT
DAYS=36500

cat > "$T/ca.cnf" <<'CNF'
[req]
distinguished_name = dn
prompt = no
[dn]
CN = placeholder
[ca]
basicConstraints = critical,CA:TRUE
keyUsage = critical,keyCertSign,cRLSign
subjectKeyIdentifier = hash
[leaf]
basicConstraints = critical,CA:FALSE
keyUsage = critical,digitalSignature
subjectAltName = DNS:leaf.test
CNF

# ca <name> <keyfile> <digest> [sigopts...]: a self-signed CA.
ca() {
    local name="$1" key="$2" md="$3"; shift 3
    openssl req -new -x509 -key "$T/$key" -subj "/CN=$name" -days $DAYS -"$md" \
        -config "$T/ca.cnf" -extensions ca "$@" -outform der -out "$name.der"
}
# leaf <name> <leafkey> <issuer> <issuerkey> <digest> <ext> [sigopts...]
leaf() {
    local name="$1" key="$2" iss="$3" ikey="$4" md="$5" ext="$6"; shift 6
    openssl req -new -key "$T/$key" -subj "/CN=$name" -config "$T/ca.cnf" -out "$T/$name.csr"
    openssl x509 -req -in "$T/$name.csr" -CA "$iss.der" -CAform DER -CAkey "$T/$ikey" \
        -set_serial "0x$(openssl rand -hex 8)" -days $DAYS -"$md" -extfile "$T/ca.cnf" -extensions "$ext" \
        "$@" -outform der -out "$name.der"
}

openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-384 -out "$T/p384a.key"
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-384 -out "$T/p384b.key"
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -out "$T/p256a.key"
openssl genpkey -algorithm RSA-PSS -pkeyopt rsa_keygen_bits:4096 -out "$T/pss4096.key"
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -out "$T/rsa4096.key"
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:3072 -out "$T/rsa3072.key"
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out "$T/rsa2048.key"
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:1024 -out "$T/rsa1024.key"
openssl genpkey -algorithm ED25519 -out "$T/ed1.key"
openssl genpkey -algorithm ED25519 -out "$T/ed2.key"
PSS384=(-sigopt rsa_padding_mode:pss -sigopt rsa_pss_saltlen:48 -sigopt rsa_mgf1_md:sha384)

# P-384 throughout, as AWS Nitro and Arm CCA tokens use.
ca p384-ca p384a.key sha384
leaf p384-leaf p384b.key p384-ca p384a.key sha384 leaf
leaf p384-leaf-sha512 p384b.key p384-ca p384a.key sha512 leaf
# A P-256 key under a P-384 CA, and a P-384 key under P-256 with SHA-512.
leaf p256-under-p384 p256a.key p384-ca p384a.key sha384 leaf
ca p256-ca p256a.key sha512
leaf p384-under-p256 p384b.key p256-ca p256a.key sha512 leaf

# The AMD SEV shape: RSA-4096 RSASSA-PSS SHA-384 (salt 48) issuing an
# EC P-384 leaf (a VCEK). The CA here has an id-RSASSA-PSS key.
ca pss-ca pss4096.key sha384 "${PSS384[@]}"
leaf vcek-like p384b.key pss-ca pss4096.key sha384 leaf "${PSS384[@]}"
# PSS with other parameters: SHA-512 salt 64, and a salt of 20.
leaf pss-sha512 p384b.key pss-ca pss4096.key sha512 leaf -sigopt rsa_padding_mode:pss -sigopt rsa_pss_saltlen:64 -sigopt rsa_mgf1_md:sha512
leaf pss-salt20 p384b.key pss-ca pss4096.key sha384 leaf -sigopt rsa_padding_mode:pss -sigopt rsa_pss_saltlen:20 -sigopt rsa_mgf1_md:sha384
# Refused by policy: MGF1 with a hash other than the message hash.
leaf pss-mgf-mismatch p384b.key pss-ca pss4096.key sha384 leaf -sigopt rsa_padding_mode:pss -sigopt rsa_pss_saltlen:48 -sigopt rsa_mgf1_md:sha256

# rsaEncryption keys with PKCS#1 v1.5 over SHA-384 and SHA-512, and PSS.
ca rsa4096-ca rsa4096.key sha512
leaf rsa3072-leaf rsa3072.key rsa4096-ca rsa4096.key sha384 leaf
leaf rsa2048-pss-leaf rsa2048.key rsa4096-ca rsa4096.key sha256 leaf -sigopt rsa_padding_mode:pss -sigopt rsa_pss_saltlen:32 -sigopt rsa_mgf1_md:sha256
# Refused: an RSA-1024 CA.
ca rsa1024-ca rsa1024.key sha256
leaf under-rsa1024 p256a.key rsa1024-ca rsa1024.key sha256 leaf

# Ed25519 (RFC 8410).
openssl req -new -x509 -key "$T/ed1.key" -subj "/CN=ed-ca" -days $DAYS -config "$T/ca.cnf" -extensions ca -outform der -out ed-ca.der
openssl req -new -key "$T/ed2.key" -subj "/CN=ed-leaf" -config "$T/ca.cnf" -out "$T/ed.csr"
openssl x509 -req -in "$T/ed.csr" -CA ed-ca.der -CAform DER -CAkey "$T/ed1.key" -set_serial 7 -days $DAYS \
    -extfile "$T/ca.cnf" -extensions leaf -outform der -out ed-leaf.der

# SHA-1 is refused even when the key would verify.
leaf sha1-leaf p384b.key p384-ca p384a.key sha1 leaf
echo "fixtures written"
