#!/usr/bin/env bash
# The SPDM requester (lib/spdm_requester.resid) against DMTF's spdm-emu
# responder: SPDM 1.0 to 1.3 over MCTP, PCI DOE and TCP; every signature
# algorithm, hash, DHE group and AEAD the library implements; mutual
# authentication (basic, encapsulated with and without the responder's
# encapsulated GET_DIGESTS), PSK with and without context, the handshake
# encrypted and in the clear, heartbeat, key update, measurements in a
# session, chunking both ways, multi-key, and the secured-message
# versions. Each case's output must equal its line block in cases.out.
# Skipped unless RESID_SPDM_EMU names the emulator's build/bin
# (tests/spdm/emu/build.sh builds it).
#
# Usage: tests/spdm/run.sh [-c COMPILER] [NAME...]
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
COMPILER="$ROOT/build/boot/stage2.bin"
while getopts "c:" opt; do
    case "$opt" in
        c) COMPILER="$(realpath "$OPTARG")" ;;
        *) exit 2 ;;
    esac
done
shift $((OPTIND - 1))
EMU="${RESID_SPDM_EMU:-}"
if [ -z "$EMU" ] || [ ! -x "$EMU/spdm_responder_emu" ]; then
    echo "SKIP spdm (set RESID_SPDM_EMU to spdm-emu's build/bin; tests/spdm/emu/build.sh builds it)"
    exit 0
fi
W="$(mktemp -d)"
EMUPID=""
trap '[ -n "$EMUPID" ] && kill "$EMUPID" 2>/dev/null; rm -rf "$W"' EXIT
export RESID_HOME="${RESID_HOME:-$ROOT/build/boot}"
(cd "$ROOT" && "$COMPILER" tests/spdm/requester.resid --profile debug -o "$W/rq") > "$W/build.log" 2>&1 || {
    echo "FAIL build requester"; grep -i -A3 error "$W/build.log" | head -8; exit 1; }

pass=0; fail=0
# case NAME BINDING VERSIONS FLOWS IDENTITY ASYM -- RESPONDER ARGS...
case_() {
    local name="$1" bind="$2" vers="$3" flows="$4" ident="$5" asym="$6"; shift 7
    if [ -n "${SEL:-}" ] && [[ " $SEL " != *" $name "* ]]; then return; fi
    local trans=MCTP port=2323
    [ "$bind" = doe ] && trans=PCI_DOE
    [ "$bind" = tcp ] && { trans=TCP; port=4194; }
    (cd "$EMU" && exec ./spdm_responder_emu --trans "$trans" "$@" > "$W/emu-$name.log" 2>&1) &
    EMUPID=$!
    # Wait for the listener without connecting: the responder serves one
    # connection.
    for _ in $(seq 50); do ss -ltnH "sport = :$port" 2>/dev/null | grep -q . && break; sleep 0.1; done
    local idd="-"
    [ "$ident" != "-" ] && idd="$EMU/$ident"
    (cd "$EMU" && timeout 120 "$W/rq" "$bind" "$port" "$vers" "$flows" "$idd" "$asym") > "$W/$name.out" 2>&1
    kill "$EMUPID" 2>/dev/null; wait "$EMUPID" 2>/dev/null; EMUPID=""
    sed -n "/^== $name\$/,/^== /p" "$ROOT/tests/spdm/cases.out" | sed '1d;/^== /d' > "$W/$name.want"
    if cmp -s "$W/$name.out" "$W/$name.want"; then echo "PASS $name"; pass=$((pass + 1));
    else echo "FAIL $name"; diff "$W/$name.want" "$W/$name.out" | head -6; fail=$((fail + 1)); fi
    # RESID_SPDM_GOT=FILE collects every case's output in cases.out's form.
    [ -n "${RESID_SPDM_GOT:-}" ] && { echo "== $name"; cat "$W/$name.out"; } >> "$RESID_SPDM_GOT"
}
SEL="$*"
A="digests,cert,challenge,meas,unsigned"
S="sess,hb,ku,kua,smeas,end"
case_ v10-mctp-p384 mctp 10 "$A" - - -- --ver 1.0 --asym ECDSA_P384 --hash SHA_384
case_ v11-mctp-p384 mctp 11 "$A,$S" - - -- --ver 1.1 --asym ECDSA_P384 --hash SHA_384 --dhe SECP_384_R1 --aead AES_256_GCM
case_ v12-doe-rsassa3072 doe 12 "$A,$S" - - -- --ver 1.2 --asym RSASSA_3072 --hash SHA_256 --dhe SECP_256_R1 --aead AES_128_GCM
case_ v12-tcp-rsapss2048 tcp 12 "$A,$S" - - -- --ver 1.2 --asym RSAPSS_2048 --hash SHA_384 --dhe SECP_384_R1 --aead CHACHA20_POLY1305
case_ v12-mctp-rsassa4096 mctp 12 "$A" - - -- --ver 1.2 --asym RSASSA_4096 --hash SHA_512
case_ v12-mctp-rsapss4096 mctp 12 "$A" - - -- --ver 1.2 --asym RSAPSS_4096 --hash SHA_512
case_ v12-clear mctp 12 "$A,$S" - - -- --ver 1.2 --asym ECDSA_P384 --hash SHA_384 --cap CERT,CHAL,MEAS_SIG,ENCRYPT,MAC,KEY_EX,HBEAT,KEY_UPD,HANDSHAKE_IN_CLEAR
case_ v13-mctp-p256 mctp 13 "$A,$S" - - -- --ver 1.3 --asym ECDSA_P256 --hash SHA_256 --dhe SECP_256_R1 --aead AES_128_GCM
case_ v13-doe-ed25519 doe 13 "$A,$S" - - -- --ver 1.3 --asym EDDSA_25519 --hash SHA_512 --dhe SECP_384_R1
case_ v13-tcp-p521 tcp 13 "$A,$S" - - -- --ver 1.3 --asym ECDSA_P521 --hash SHA_512 --meas_hash SHA_512
# (No raw-bitstream case: with RAW_BIT negotiated the emulator refuses
# GET_MEASUREMENTS, libspdm's own requester included.)
case_ v12-psk mctp 12 "psk,hb,ku,end" - - -- --ver 1.2 --cap CERT,CHAL,MEAS_SIG,ENCRYPT,MAC,PSK,HBEAT,KEY_UPD
case_ v13-psk-ctx tcp 13 "psk,hb,kua,end" - - -- --ver 1.3
case_ v12-mut-wo-encap mctp 12 "sess,hb,end" ecp256 p256 -- --ver 1.2 --mut_auth WO_ENCAP --req_asym ECDSA_P256
case_ v12-mut-w-encap mctp 12 "sess,end" ecp384 p384 -- --ver 1.2 --mut_auth W_ENCAP --req_asym ECDSA_P384
case_ v13-mut-digests mctp 13 "sess,end" ed25519 ed25519 -- --ver 1.3 --mut_auth DIGESTS --req_asym EDDSA_25519
case_ v12-basic-mut mctp 12 "digests,cert,challenge" ecp256 p256 -- --ver 1.2 --basic_mut_auth BASIC --req_asym ECDSA_P256
case_ v11-basic-mut mctp 11 "digests,cert,challenge" ecp384 p384 -- --ver 1.1 --basic_mut_auth BASIC --req_asym ECDSA_P384
case_ v13-multi-key mctp 13 "multikey,$A,sess,end" - - -- --ver 1.3 --cap CERT,CHAL,MEAS_SIG,ENCRYPT,MAC,KEY_EX,HBEAT,KEY_UPD,MULTI_KEY_ONLY
case_ v12-secver10 mctp 12 "sess,hb,end" - - -- --ver 1.2 --sec_ver 1.0
case_ v13-secver11 doe 13 "sess,hb,end" - - -- --ver 1.3 --sec_ver 1.1
case_ v13-chunk mctp 13 "small,$A,sess,end" - - -- --ver 1.3 --cap CERT,CHAL,MEAS_SIG,ENCRYPT,MAC,KEY_EX,HBEAT,KEY_UPD,CHUNK
case_ versions-negotiated mctp 10,11,12,13 "$A" - - -- --ver 1.2
echo "spdm: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
