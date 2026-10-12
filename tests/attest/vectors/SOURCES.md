# Test vector sources

Fixtures copied verbatim (original filenames) from upstream repositories, shallow-cloned on 2026-10-09.
Each upstream license/NOTICE is in `LICENSES/<repo>-LICENSE` (and `-NOTICE`). Paths below are relative to `tests/attest/vectors/` (moved from the retired resid-attest repository).
Byte-identical files found in more than one source were copied once; see *Duplicates*.

## Source commits

| Repo | Commit |
|---|---|
| virtee/cvmtool | `a9525f517c55bb561bf0065685b03e5e76780a06` |
| NVIDIA/nvtrust | `858ada9a17f58c482f578414ea2455498fa51e17` |
| blocky/nitrite | `a6f5b6da1e509d7600dfdf9ba5000e38f7113186` |
| confidential-containers/guest-components | `c04e5ad58089477c4793f04a9a95c6f9e0e2b3e1` |
| confidential-containers/trustee | `55cbc0cd4a5e2dca2fb8f6076eafb41d6bdb1040` |
| evervault/attestation-doc-validation | `a296a77c2b23fef8214131287423fe47c755eb3c` |
| google/go-eventlog | `9e88b4ebab1e08c8e6fbabd73f4ccf8587fdc612` |
| google/go-sev-guest | `9c5dffcd8230247336e07c70804a31f6b39ab3c9` |
| google/go-tdx-guest | `b0a2dd8100a04a52310c6f7869dbc14297e39e8b` |
| google/go-tpm-tools | `829ec3137784ea87185b4fda5e34d2d2ae59b749` |
| kinvolk/azure-cvm-tooling | `e4e440748fc155f75c573bc842474d19cba4c653` |
| veraison/c-ear | `a928486cb6e866946f7c53494896bcab2614c8be` |
| veraison/ccatoken | `4b95c09a70de03de3688ccc6976728b7cb1dd90c` |
| veraison/corim | `156e2dda8092bd340fc6f679d678fdb48e1f5b70` |
| veraison/corim-rs | `65ef90ed2059171f5881d210eb4c8ddcb3f9d29b` |
| veraison/ear | `9771e2b9fe95b9a31bfa5a340311f4ffd297bd9b` |
| veraison/rust-ccatoken | `e3591c87dbdfc3f4c71c4a72fbcb03e121f65f55` |
| veraison/rust-ear | `5dfe47d4d81c0d8db5e2ba70679021acf9de1e16` |
| veraison/services | `b1cd67e3b2644d0aa52ccd93d6e02b356d7a13ab` |
| virtee/sev | `a966d06d9bf0e68afe2733e7bfbf278fd7fd65b5` |

## Counts by platform

| Platform | Files |
|---|---|
| snp | 19 |
| tdx | 38 |
| cca | 86 |
| nitro | 5 |
| tpm | 26 |
| azure | 26 |
| gcp | 13 |
| nvidia | 16 |
| corim | 169 |
| coswid | 2 |
| ear | 11 |
| roots | 17 |

## Files

| Local path | Source repo | Commit | Original path | License | What it is |
|---|---|---|---|---|---|
| `snp/cvmtool/sev.report` | virtee/cvmtool | `a9525f517c55` | `tests/fixtures/sev.report` | Used by permission of the virtee owner; AGPL-3.0 not applied | SNP report v2, Milan, real hardware |
| `snp/cvmtool/sev-certs/ark.pem` | virtee/cvmtool | `a9525f517c55` | `tests/fixtures/sev-certs/ark.pem` | Used by permission of the virtee owner; AGPL-3.0 not applied | AMD ARK (Milan) for sev.report |
| `snp/cvmtool/sev-certs/ask.pem` | virtee/cvmtool | `a9525f517c55` | `tests/fixtures/sev-certs/ask.pem` | Used by permission of the virtee owner; AGPL-3.0 not applied | AMD ASK (Milan) for sev.report |
| `snp/cvmtool/sev-certs/vcek.pem` | virtee/cvmtool | `a9525f517c55` | `tests/fixtures/sev-certs/vcek.pem` | Used by permission of the virtee owner; AGPL-3.0 not applied | VCEK for sev.report |
| `snp/cvmtool/sev-fake-certs/ark.pem` | virtee/cvmtool | `a9525f517c55` | `tests/fixtures/sev-fake-certs/ark.pem` | Used by permission of the virtee owner; AGPL-3.0 not applied | Fake ARK (negative case: chain must fail) |
| `snp/cvmtool/sev-fake-certs/ask.pem` | virtee/cvmtool | `a9525f517c55` | `tests/fixtures/sev-fake-certs/ask.pem` | Used by permission of the virtee owner; AGPL-3.0 not applied | Fake ASK (negative case) |
| `snp/cvmtool/sev-fake-certs/vcek.pem` | virtee/cvmtool | `a9525f517c55` | `tests/fixtures/sev-fake-certs/vcek.pem` | Used by permission of the virtee owner; AGPL-3.0 not applied | Fake VCEK (negative case) |
| `tdx/cvmtool/tdx.report` | virtee/cvmtool | `a9525f517c55` | `tests/fixtures/tdx.report` | Used by permission of the virtee owner; AGPL-3.0 not applied | TDX quote v4, real hardware |
| `tdx/cvmtool/tdx-certs/pck.pem` | virtee/cvmtool | `a9525f517c55` | `tests/fixtures/tdx-certs/pck.pem` | Used by permission of the virtee owner; AGPL-3.0 not applied | PCK certificate for tdx.report |
| `tdx/cvmtool/tdx-certs/pck_chain.pem` | virtee/cvmtool | `a9525f517c55` | `tests/fixtures/tdx-certs/pck_chain.pem` | Used by permission of the virtee owner; AGPL-3.0 not applied | PCK chain for tdx.report |
| `tdx/cvmtool/tdx-certs/pck_issuer_chain.pem` | virtee/cvmtool | `a9525f517c55` | `tests/fixtures/tdx-certs/pck_issuer_chain.pem` | Used by permission of the virtee owner; AGPL-3.0 not applied | PCK issuer chain for tdx.report |
| `tdx/cvmtool/tdx-fake-certs/pck.pem` | virtee/cvmtool | `a9525f517c55` | `tests/fixtures/tdx-fake-certs/pck.pem` | Used by permission of the virtee owner; AGPL-3.0 not applied | Fake PCK (negative case) |
| `tdx/cvmtool/tdx-fake-certs/pck_chain.pem` | virtee/cvmtool | `a9525f517c55` | `tests/fixtures/tdx-fake-certs/pck_chain.pem` | Used by permission of the virtee owner; AGPL-3.0 not applied | Fake PCK chain (negative case) |
| `tdx/cvmtool/tdx-fake-certs/pck_issuer_chain.pem` | virtee/cvmtool | `a9525f517c55` | `tests/fixtures/tdx-fake-certs/pck_issuer_chain.pem` | Used by permission of the virtee owner; AGPL-3.0 not applied | Fake PCK issuer chain (negative case) |
| `snp/virtee-sev/report_milan.hex` | virtee/sev | `a966d06d9bf0` | `tests/certs_data/report_milan.hex` | Apache-2.0 | SNP report v2 (hex text), Milan, VCEK-signed |
| `snp/virtee-sev/vcek_milan.der` | virtee/sev | `a966d06d9bf0` | `tests/certs_data/vcek_milan.der` | Apache-2.0 | VCEK cert (DER), Milan, signs report_milan |
| `snp/virtee-sev/cert_chain_milan` | virtee/sev | `a966d06d9bf0` | `tests/certs_data/cert_chain_milan` | Apache-2.0 | ASK+ARK chain (PEM), Milan |
| `snp/virtee-sev/vcek_turin.der` | virtee/sev | `a966d06d9bf0` | `tests/certs_data/vcek_turin.der` | Apache-2.0 | VCEK cert (DER), Turin |
| `snp/virtee-sev/cert_chain_turin` | virtee/sev | `a966d06d9bf0` | `tests/certs_data/cert_chain_turin` | Apache-2.0 | ASK+ARK chain (PEM), Turin |
| `snp/go-sev-guest/attestation.bin` | google/go-sev-guest | `9c5dffcd8230` | `verify/testdata/attestation.bin` | Apache-2.0 | SNP report v2 (raw 1184 B), Milan, VCEK-signed, no ID block |
| `snp/go-sev-guest/vcek.testcer` | google/go-sev-guest | `9c5dffcd8230` | `verify/testdata/vcek.testcer` | Apache-2.0 | VCEK cert (DER), Milan, signs attestation.bin |
| `snp/go-sev-guest/milanvlek.testcer` | google/go-sev-guest | `9c5dffcd8230` | `verify/testdata/milanvlek.testcer` | Apache-2.0 | ASVK+ARK chain (PEM), Milan VLEK chain |
| `snp/trustee/test-report.bin` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/snp/test-report.bin` | Apache-2.0 | SNP report v2 (raw), Milan, VCEK-signed |
| `snp/trustee/test-vcek.der` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/snp/test-vcek.der` | Apache-2.0 | VCEK cert (DER), Milan, for test-report.bin |
| `snp/trustee/test-vcek-invalid-legacy.der` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/snp/test-vcek-invalid-legacy.der` | Apache-2.0 | VCEK cert (DER), Milan, malformed legacy TCB extension (negative) |
| `snp/trustee/test-vcek-invalid-new.der` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/snp/test-vcek-invalid-new.der` | Apache-2.0 | VCEK cert (DER), Milan, malformed TCB extension (negative) |
| `snp/trustee/test-vlek-report.bin` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/snp/test-vlek-report.bin` | Apache-2.0 | SNP report v3 (raw), Milan, VLEK-signed |
| `snp/trustee/test-vlek.der` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/snp/test-vlek.der` | Apache-2.0 | VLEK cert (DER), Milan, for test-vlek-report.bin |
| `snp/veraison-services/sevsnp-tsm-report.cbor` | veraison/services | `b1cd67e3b264` | `scheme/sevsnp/test/evidence/sevsnp-tsm-report.cbor` | Apache-2.0 | configfs-tsm report (CBOR CMW) wrapping SNP report + cert table |
| `snp/veraison-services/sevsnp-tsm-report.json` | veraison/services | `b1cd67e3b264` | `scheme/sevsnp/test/evidence/sevsnp-tsm-report.json` | Apache-2.0 | configfs-tsm report (JSON form of above) |
| `snp/veraison-services/sevsnp-ratsd-token` | veraison/services | `b1cd67e3b264` | `scheme/sevsnp/test/evidence/sevsnp-ratsd-token` | Apache-2.0 | ratsd EAT/CMW token carrying SNP tsm report |
| `snp/veraison-services/sevsnp-ratsd-claims.json` | veraison/services | `b1cd67e3b264` | `scheme/sevsnp/test/evidence/sevsnp-ratsd-claims.json` | Apache-2.0 | ratsd claims input for token |
| `snp/veraison-services/sevsnp-ratsd-env.json` | veraison/services | `b1cd67e3b264` | `scheme/sevsnp/test/evidence/sevsnp-ratsd-env.json` | Apache-2.0 | ratsd environment input for token |
| `tdx/go-tdx-guest/tdx_prod_quote_SPR_E4.dat` | google/go-tdx-guest | `b0a2dd8100a0` | `testing/testdata/tdx_prod_quote_SPR_E4.dat` | Apache-2.0 | TDX quote v4, production Sapphire Rapids E4, ECDSA-P256 + PCK chain |
| `tdx/go-tdx-guest/quote_sample_v5.dat` | google/go-tdx-guest | `b0a2dd8100a0` | `testing/testdata/quote_sample_v5.dat` | Apache-2.0 | TDX quote v5 (TDX 1.5 body) |
| `tdx/go-tdx-guest/quote_sample_dice.dat` | google/go-tdx-guest | `b0a2dd8100a0` | `testing/testdata/quote_sample_dice.dat` | Apache-2.0 | TDX DICE-based quote (CBOR/COSE) |
| `tdx/go-tdx-guest/report.dat` | google/go-tdx-guest | `b0a2dd8100a0` | `testing/testdata/report.dat` | Apache-2.0 | TDREPORT (1024 B) |
| `tdx/go-tdx-guest/pckcrl` | google/go-tdx-guest | `b0a2dd8100a0` | `testing/testdata/pckcrl` | Apache-2.0 | Intel PCS PCK CRL response (platform CA) |
| `tdx/go-tdx-guest/rootcrl.der` | google/go-tdx-guest | `b0a2dd8100a0` | `testing/testdata/rootcrl.der` | Apache-2.0 | Intel SGX Root CA CRL (DER) |
| `tdx/go-tdx-guest/sample_tcbInfo_response` | google/go-tdx-guest | `b0a2dd8100a0` | `testing/testdata/sample_tcbInfo_response` | Apache-2.0 | Intel PCS TDX TCB info v3 response (JSON + issuer chain) |
| `tdx/go-tdx-guest/sample_tcbinfo_response_v5` | google/go-tdx-guest | `b0a2dd8100a0` | `testing/testdata/sample_tcbinfo_response_v5` | Apache-2.0 | Intel PCS TDX TCB info response, TDX 1.5 |
| `tdx/go-tdx-guest/sample_qeIdentity_response` | google/go-tdx-guest | `b0a2dd8100a0` | `testing/testdata/sample_qeIdentity_response` | Apache-2.0 | Intel PCS TD QE identity response |
| `tdx/go-tdx-guest/README.md` | google/go-tdx-guest | `b0a2dd8100a0` | `testing/testdata/README.md` | Apache-2.0 | Description of the go-tdx-guest PCS collateral samples |
| `tdx/trustee/tdx_quote_4.dat` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/tdx_quote_4.dat` | Apache-2.0 | TDX quote v4 |
| `tdx/trustee/tdx_quote_5.dat` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/tdx_quote_5.dat` | Apache-2.0 | TDX quote v5 |
| `tdx/trustee/tdx_quote_6.dat` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/tdx_quote_6.dat` | Apache-2.0 | TDX quote v4 (second sample) |
| `tdx/trustee/parse_tdx_claims_expected.json` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/parse_tdx_claims_expected.json` | Apache-2.0 | Expected parsed claims for trustee TDX quote + CCEL |
| `tdx/trustee/tcbInfo.json` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/tcbInfo.json` | Apache-2.0 | Intel TDX TCB info (JSON) |
| `tdx/trustee/enclaveIdentity.json` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/enclaveIdentity.json` | Apache-2.0 | Intel TD QE identity (JSON) |
| `tdx/trustee-eventlog/CCEL_data` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/eventlog/test_data/CCEL_data` | Apache-2.0 | TDX CCEL event log (raw) [CCEL_data] |
| `tdx/trustee-eventlog/CCEL_data_out.json` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/eventlog/test_data/CCEL_data_out.json` | Apache-2.0 | Expected parsed event log for CCEL_data |
| `tdx/trustee-eventlog/CCEL_data_ovmf` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/eventlog/test_data/CCEL_data_ovmf` | Apache-2.0 | TDX CCEL event log (raw) [CCEL_data_ovmf] |
| `tdx/trustee-eventlog/CCEL_data_ovmf_out.json` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/eventlog/test_data/CCEL_data_ovmf_out.json` | Apache-2.0 | Expected parsed event log for CCEL_data_ovmf |
| `tdx/trustee-eventlog/CCEL_data_grub` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/eventlog/test_data/CCEL_data_grub` | Apache-2.0 | TDX CCEL event log (raw) [CCEL_data_grub] |
| `tdx/trustee-eventlog/CCEL_data_grub_out.json` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/eventlog/test_data/CCEL_data_grub_out.json` | Apache-2.0 | Expected parsed event log for CCEL_data_grub |
| `tdx/trustee-eventlog/CCEL_AAEL_alibabacloud` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/eventlog/test_data/CCEL_AAEL_alibabacloud` | Apache-2.0 | TDX CCEL event log (raw) [CCEL_AAEL_alibabacloud] |
| `tdx/trustee-eventlog/CCEL_AAEL_alibabacloud_out.json` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/eventlog/test_data/CCEL_AAEL_alibabacloud_out.json` | Apache-2.0 | Expected parsed event log for CCEL_AAEL_alibabacloud |
| `tdx/trustee-eventlog/CCEL_data_grub_gke` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/eventlog/test_data/CCEL_data_grub_gke` | Apache-2.0 | TDX CCEL event log (raw) [CCEL_data_grub_gke] |
| `tdx/trustee-eventlog/CCEL_data_grub_gke_out.json` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/eventlog/test_data/CCEL_data_grub_gke_out.json` | Apache-2.0 | Expected parsed event log for CCEL_data_grub_gke |
| `tdx/guest-components/tdx_report_1.bin` | confidential-containers/guest-components | `c04e5ad58089` | `attestation-agent/attester/test/tdx_report_1.bin` | Apache-2.0 | TDREPORT (1024 B) |
| `tdx/go-eventlog-ccel/CCEL.bin` | google/go-eventlog | `9e88b4ebab1e` | `testdata/eventlogs/ccel/CCEL.bin` | Apache-2.0 | CCEL ACPI table (56 B) |
| `tdx/go-eventlog-ccel/CCEL_unpadded.data.bin` | google/go-eventlog | `9e88b4ebab1e` | `testdata/eventlogs/ccel/CCEL_unpadded.data.bin` | Apache-2.0 | TDX CCEL event log (CCEL_unpadded.data.bin) |
| `tdx/go-eventlog-ccel/cos-113-intel-tdx-dupe-separator-unpadded.bin` | google/go-eventlog | `9e88b4ebab1e` | `testdata/eventlogs/ccel/cos-113-intel-tdx-dupe-separator-unpadded.bin` | Apache-2.0 | TDX CCEL event log (cos-113-intel-tdx-dupe-separator-unpadded.bin) |
| `tdx/go-eventlog-ccel/cos-113-intel-tdx-dupe-separator.bin` | google/go-eventlog | `9e88b4ebab1e` | `testdata/eventlogs/ccel/cos-113-intel-tdx-dupe-separator.bin` | Apache-2.0 | TDX CCEL event log (cos-113-intel-tdx-dupe-separator.bin) |
| `tdx/go-eventlog-ccel/cos-113-intel-tdx.bin` | google/go-eventlog | `9e88b4ebab1e` | `testdata/eventlogs/ccel/cos-113-intel-tdx.bin` | Apache-2.0 | TDX CCEL event log (cos-113-intel-tdx.bin) |
| `tdx/go-eventlog-ccel/cos-113-intel-tdx.table.bin` | google/go-eventlog | `9e88b4ebab1e` | `testdata/eventlogs/ccel/cos-113-intel-tdx.table.bin` | Apache-2.0 | CCEL ACPI table (56 B) |
| `tdx/go-eventlog-ccel/cs251200CCEL` | google/go-eventlog | `9e88b4ebab1e` | `testdata/eventlogs/ccel/cs251200CCEL` | Apache-2.0 | TDX CCEL event log (cs251200CCEL) |
| `tdx/go-eventlog-ccel/event_log.bin` | google/go-eventlog | `9e88b4ebab1e` | `testdata/eventlogs/ccel/event_log.bin` | Apache-2.0 | TDX CCEL event log (event_log.bin) |
| `tdx/go-eventlog-ccel/gdc-tdx.bin` | google/go-eventlog | `9e88b4ebab1e` | `testdata/eventlogs/ccel/gdc-tdx.bin` | Apache-2.0 | TDX CCEL event log (gdc-tdx.bin) |
| `tdx/go-eventlog-ccel/ubuntu-2404-intel-tdx.bin` | google/go-eventlog | `9e88b4ebab1e` | `testdata/eventlogs/ccel/ubuntu-2404-intel-tdx.bin` | Apache-2.0 | TDX CCEL event log (ubuntu-2404-intel-tdx.bin) |
| `cca/rust-ccatoken/bug-33-repro.cbor` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/bug-33-repro.cbor` | Apache-2.0 | CCA token/claims vector, negative case (bug-33-repro.cbor) |
| `cca/rust-ccatoken/cca-token-01.cbor` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/cca-token-01.cbor` | Apache-2.0 | CCA token/claims vector (cca-token-01.cbor) |
| `cca/rust-ccatoken/cca-token-02.cbor` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/cca-token-02.cbor` | Apache-2.0 | CCA token/claims vector (cca-token-02.cbor) |
| `cca/rust-ccatoken/cca-token-draft-ffm-00.cbor` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/cca-token-draft-ffm-00.cbor` | Apache-2.0 | CCA token/claims vector (cca-token-draft-ffm-00.cbor) |
| `cca/rust-ccatoken/platform-claims.cbor` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/platform-claims.cbor` | Apache-2.0 | CCA token/claims vector (platform-claims.cbor) |
| `cca/rust-ccatoken/realm-claims+spurious-numeric-key.cbor` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/realm-claims+spurious-numeric-key.cbor` | Apache-2.0 | CCA token/claims vector, negative case (realm-claims+spurious-numeric-key.cbor) |
| `cca/rust-ccatoken/realm-claims+spurious-text-key.cbor` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/realm-claims+spurious-text-key.cbor` | Apache-2.0 | CCA token/claims vector, negative case (realm-claims+spurious-text-key.cbor) |
| `cca/rust-ccatoken/realm-claims-missing-challenge.cbor` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/realm-claims-missing-challenge.cbor` | Apache-2.0 | CCA token/claims vector, negative case (realm-claims-missing-challenge.cbor) |
| `cca/rust-ccatoken/realm-claims.cbor` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/realm-claims.cbor` | Apache-2.0 | CCA token/claims vector (realm-claims.cbor) |
| `cca/rust-ccatoken/cca-token-01.diag` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/cca-token-01.diag` | Apache-2.0 | CBOR diagnostic source for sibling .cbor |
| `cca/rust-ccatoken/cca-token-02.diag` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/cca-token-02.diag` | Apache-2.0 | CBOR diagnostic source for sibling .cbor |
| `cca/rust-ccatoken/platform-claims.diag` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/platform-claims.diag` | Apache-2.0 | CBOR diagnostic source for sibling .cbor |
| `cca/rust-ccatoken/realm-claims+spurious-numeric-key.diag` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/realm-claims+spurious-numeric-key.diag` | Apache-2.0 | CBOR diagnostic source for sibling .cbor |
| `cca/rust-ccatoken/realm-claims+spurious-text-key.diag` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/realm-claims+spurious-text-key.diag` | Apache-2.0 | CBOR diagnostic source for sibling .cbor |
| `cca/rust-ccatoken/realm-claims-missing-challenge.diag` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/realm-claims-missing-challenge.diag` | Apache-2.0 | CBOR diagnostic source for sibling .cbor |
| `cca/rust-ccatoken/realm-claims.diag` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/realm-claims.diag` | Apache-2.0 | CBOR diagnostic source for sibling .cbor |
| `cca/rust-ccatoken/impl-id.bin` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/impl-id.bin` | Apache-2.0 | CCA platform id bytes (impl-id.bin) |
| `cca/rust-ccatoken/inst-id.bin` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/inst-id.bin` | Apache-2.0 | CCA platform id bytes (inst-id.bin) |
| `cca/rust-ccatoken/rv.json` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/rv.json` | Apache-2.0 | CCA reference values (JSON) for appraisal |
| `cca/rust-ccatoken/ta-02-bad.json` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/ta-02-bad.json` | Apache-2.0 | CCA trust anchor store (CPAK JWK) for token verification |
| `cca/rust-ccatoken/ta-02-ok.json` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/ta-02-ok.json` | Apache-2.0 | CCA trust anchor store (CPAK JWK) for token verification |
| `cca/rust-ccatoken/ta-tfa.json` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/ta-tfa.json` | Apache-2.0 | CCA trust anchor store (CPAK JWK) for token verification |
| `cca/rust-ccatoken/ta.json` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/ta.json` | Apache-2.0 | CCA trust anchor store (CPAK JWK) for token verification |
| `cca/rust-ccatoken/cpak.json` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/cpak.json` | Apache-2.0 | CCA JSON (public key / claims) (cpak.json) |
| `cca/rust-ccatoken/pkey.json` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/pkey.json` | Apache-2.0 | CCA JSON (public key / claims) (pkey.json) |
| `cca/rust-ccatoken/platform-2024/invalid-extension-certificate-chain-digest.cbor` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/platform-2024/invalid-extension-certificate-chain-digest.cbor` | Apache-2.0 | CCA token/claims vector, negative case (platform-2024/invalid-extension-certificate-chain-digest.cbor) |
| `cca/rust-ccatoken/platform-2024/invalid-extension-certificate-chain-digest.diag` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/platform-2024/invalid-extension-certificate-chain-digest.diag` | Apache-2.0 | CBOR diagnostic source for sibling .cbor |
| `cca/rust-ccatoken/platform-2024/invalid-extension-vca-digest.cbor` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/platform-2024/invalid-extension-vca-digest.cbor` | Apache-2.0 | CCA token/claims vector, negative case (platform-2024/invalid-extension-vca-digest.cbor) |
| `cca/rust-ccatoken/platform-2024/invalid-extension-vca-digest.diag` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/platform-2024/invalid-extension-vca-digest.diag` | Apache-2.0 | CBOR diagnostic source for sibling .cbor |
| `cca/rust-ccatoken/platform-2024/invalid-manufacturing-config.cbor` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/platform-2024/invalid-manufacturing-config.cbor` | Apache-2.0 | CCA token/claims vector, negative case (platform-2024/invalid-manufacturing-config.cbor) |
| `cca/rust-ccatoken/platform-2024/invalid-manufacturing-config.diag` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/platform-2024/invalid-manufacturing-config.diag` | Apache-2.0 | CBOR diagnostic source for sibling .cbor |
| `cca/rust-ccatoken/platform-2024/invalid-tbb-rotpk-hash-length.cbor` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/platform-2024/invalid-tbb-rotpk-hash-length.cbor` | Apache-2.0 | CCA token/claims vector, negative case (platform-2024/invalid-tbb-rotpk-hash-length.cbor) |
| `cca/rust-ccatoken/platform-2024/invalid-tbb-rotpk-hash-length.diag` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/platform-2024/invalid-tbb-rotpk-hash-length.diag` | Apache-2.0 | CBOR diagnostic source for sibling .cbor |
| `cca/rust-ccatoken/platform-2024/missing-client-id.cbor` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/platform-2024/missing-client-id.cbor` | Apache-2.0 | CCA token/claims vector, negative case (platform-2024/missing-client-id.cbor) |
| `cca/rust-ccatoken/platform-2024/missing-client-id.diag` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/platform-2024/missing-client-id.diag` | Apache-2.0 | CBOR diagnostic source for sibling .cbor |
| `cca/rust-ccatoken/platform-2024/missing-extension-encryption-type.cbor` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/platform-2024/missing-extension-encryption-type.cbor` | Apache-2.0 | CCA token/claims vector, negative case (platform-2024/missing-extension-encryption-type.cbor) |
| `cca/rust-ccatoken/platform-2024/missing-extension-encryption-type.diag` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/platform-2024/missing-extension-encryption-type.diag` | Apache-2.0 | CBOR diagnostic source for sibling .cbor |
| `cca/rust-ccatoken/platform-2024/missing-extension-vca-digest.cbor` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/platform-2024/missing-extension-vca-digest.cbor` | Apache-2.0 | CCA token/claims vector, negative case (platform-2024/missing-extension-vca-digest.cbor) |
| `cca/rust-ccatoken/platform-2024/missing-extension-vca-digest.diag` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/platform-2024/missing-extension-vca-digest.diag` | Apache-2.0 | CBOR diagnostic source for sibling .cbor |
| `cca/rust-ccatoken/platform-2024/valid-all.cbor` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/platform-2024/valid-all.cbor` | Apache-2.0 | CCA token/claims vector (platform-2024/valid-all.cbor) |
| `cca/rust-ccatoken/platform-2024/valid-all.diag` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/platform-2024/valid-all.diag` | Apache-2.0 | CBOR diagnostic source for sibling .cbor |
| `cca/rust-ccatoken/platform-2024/valid-mandatory-only.cbor` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/platform-2024/valid-mandatory-only.cbor` | Apache-2.0 | CCA token/claims vector (platform-2024/valid-mandatory-only.cbor) |
| `cca/rust-ccatoken/platform-2024/valid-mandatory-only.diag` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/platform-2024/valid-mandatory-only.diag` | Apache-2.0 | CBOR diagnostic source for sibling .cbor |
| `cca/rust-ccatoken/realm-2024/invalid-mec-policy.cbor` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/realm-2024/invalid-mec-policy.cbor` | Apache-2.0 | CCA token/claims vector, negative case (realm-2024/invalid-mec-policy.cbor) |
| `cca/rust-ccatoken/realm-2024/invalid-mec-policy.diag` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/realm-2024/invalid-mec-policy.diag` | Apache-2.0 | CBOR diagnostic source for sibling .cbor |
| `cca/rust-ccatoken/realm-2024/missing-mec-policy.cbor` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/realm-2024/missing-mec-policy.cbor` | Apache-2.0 | CCA token/claims vector, negative case (realm-2024/missing-mec-policy.cbor) |
| `cca/rust-ccatoken/realm-2024/missing-mec-policy.diag` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/realm-2024/missing-mec-policy.diag` | Apache-2.0 | CBOR diagnostic source for sibling .cbor |
| `cca/rust-ccatoken/realm-2024/valid-all.cbor` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/realm-2024/valid-all.cbor` | Apache-2.0 | CCA token/claims vector (realm-2024/valid-all.cbor) |
| `cca/rust-ccatoken/realm-2024/valid-all.diag` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/realm-2024/valid-all.diag` | Apache-2.0 | CBOR diagnostic source for sibling .cbor |
| `cca/rust-ccatoken/token-2024/cca-token-draft-ffm-03-all-claims.cbor` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/token-2024/cca-token-draft-ffm-03-all-claims.cbor` | Apache-2.0 | CCA token/claims vector (token-2024/cca-token-draft-ffm-03-all-claims.cbor) |
| `cca/rust-ccatoken/token-2024/cca-token-draft-ffm-03-mandatory-claims-only.cbor` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/token-2024/cca-token-draft-ffm-03-mandatory-claims-only.cbor` | Apache-2.0 | CCA token/claims vector (token-2024/cca-token-draft-ffm-03-mandatory-claims-only.cbor) |
| `cca/rust-ccatoken/token-2024/cca-claims-draft-ffm-03-all-claims.json` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/token-2024/cca-claims-draft-ffm-03-all-claims.json` | Apache-2.0 | CCA JSON (public key / claims) (token-2024/cca-claims-draft-ffm-03-all-claims.json) |
| `cca/rust-ccatoken/token-2024/cca-claims-draft-ffm-03-mandatory-claims-only.json` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/token-2024/cca-claims-draft-ffm-03-mandatory-claims-only.json` | Apache-2.0 | CCA JSON (public key / claims) (token-2024/cca-claims-draft-ffm-03-mandatory-claims-only.json) |
| `cca/rust-ccatoken/token-2024/rv-ffm-03-all-claims.json` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/token-2024/rv-ffm-03-all-claims.json` | Apache-2.0 | CCA reference values (JSON) for appraisal |
| `cca/rust-ccatoken/token-2024/ta-ffm-03.json` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/token-2024/ta-ffm-03.json` | Apache-2.0 | CCA trust anchor store (CPAK JWK) for token verification |
| `cca/rust-ccatoken/token-2024/ec256-pub.json` | veraison/rust-ccatoken | `e3591c87dbdf` | `testdata/token-2024/ec256-pub.json` | Apache-2.0 | CCA JSON (public key / claims) (token-2024/ec256-pub.json) |
| `cca/ccatoken/tf-rmm/cca_platform.pub` | veraison/ccatoken | `4b95c09a70de` | `realm/testvectors/tf-rmm/cca_platform.pub` | Apache-2.0 | CPAK public key for TF-RMM token |
| `cca/ccatoken/CcaTokenRev03.diag` | veraison/ccatoken | `4b95c09a70de` | `testvectors/cbor/CcaTokenRev03.diag` | Apache-2.0 | CCA token (draft rev03) CBOR diag |
| `cca/ccatoken/platform/CcaPlatformClaimsAll.diag` | veraison/ccatoken | `4b95c09a70de` | `platform/testvectors/cbor/CcaPlatformClaimsAll.diag` | Apache-2.0 | CCA platform claims CBOR diag (CcaPlatformClaimsAll.diag) |
| `cca/ccatoken/platform/CcaPlatformClaimsInvalidMultiNonce.diag` | veraison/ccatoken | `4b95c09a70de` | `platform/testvectors/cbor/CcaPlatformClaimsInvalidMultiNonce.diag` | Apache-2.0 | CCA platform claims CBOR diag (CcaPlatformClaimsInvalidMultiNonce.diag) |
| `cca/ccatoken/platform/CcaPlatformClaimsMandatoryOnly.diag` | veraison/ccatoken | `4b95c09a70de` | `platform/testvectors/cbor/CcaPlatformClaimsMandatoryOnly.diag` | Apache-2.0 | CCA platform claims CBOR diag (CcaPlatformClaimsMandatoryOnly.diag) |
| `cca/ccatoken/platform/CcaPlatformClaimsMissingMandatoryNonce.diag` | veraison/ccatoken | `4b95c09a70de` | `platform/testvectors/cbor/CcaPlatformClaimsMissingMandatoryNonce.diag` | Apache-2.0 | CCA platform claims CBOR diag (CcaPlatformClaimsMissingMandatoryNonce.diag) |
| `cca/ccatoken/platform/CcaPlatformExample.diag` | veraison/ccatoken | `4b95c09a70de` | `platform/testvectors/cbor/CcaPlatformExample.diag` | Apache-2.0 | CCA platform claims CBOR diag (CcaPlatformExample.diag) |
| `cca/ccatoken/platform/CcaPlatformLegacyClaimsAll.diag` | veraison/ccatoken | `4b95c09a70de` | `platform/testvectors/cbor/CcaPlatformLegacyClaimsAll.diag` | Apache-2.0 | CCA platform claims CBOR diag (CcaPlatformLegacyClaimsAll.diag) |
| `cca/ccatoken/platform/CcaPlatformLegacyClaimsMandatoryOnly.diag` | veraison/ccatoken | `4b95c09a70de` | `platform/testvectors/cbor/CcaPlatformLegacyClaimsMandatoryOnly.diag` | Apache-2.0 | CCA platform claims CBOR diag (CcaPlatformLegacyClaimsMandatoryOnly.diag) |
| `cca/ccatoken/platform/v2/CcaPlatformClaimsV2All.diag` | veraison/ccatoken | `4b95c09a70de` | `platform/testvectors/cbor/v2/CcaPlatformClaimsV2All.diag` | Apache-2.0 | CCA platform claims CBOR diag (v2/CcaPlatformClaimsV2All.diag) |
| `cca/ccatoken/platform/v2/CcaPlatformClaimsV2MandatoryOnly.diag` | veraison/ccatoken | `4b95c09a70de` | `platform/testvectors/cbor/v2/CcaPlatformClaimsV2MandatoryOnly.diag` | Apache-2.0 | CCA platform claims CBOR diag (v2/CcaPlatformClaimsV2MandatoryOnly.diag) |
| `cca/ccatoken/realm/CcaClaimsMissingMandExtendedMeas.diag` | veraison/ccatoken | `4b95c09a70de` | `realm/testvectors/cbor/CcaClaimsMissingMandExtendedMeas.diag` | Apache-2.0 | CCA realm claims CBOR diag (CcaClaimsMissingMandExtendedMeas.diag) |
| `cca/ccatoken/realm/CcaClaimsMissingMandHashAlgID.diag` | veraison/ccatoken | `4b95c09a70de` | `realm/testvectors/cbor/CcaClaimsMissingMandHashAlgID.diag` | Apache-2.0 | CCA realm claims CBOR diag (CcaClaimsMissingMandHashAlgID.diag) |
| `cca/ccatoken/realm/CcaClaimsMissingMandInitialMeas.diag` | veraison/ccatoken | `4b95c09a70de` | `realm/testvectors/cbor/CcaClaimsMissingMandInitialMeas.diag` | Apache-2.0 | CCA realm claims CBOR diag (CcaClaimsMissingMandInitialMeas.diag) |
| `cca/ccatoken/realm/CcaClaimsMissingMandPubKey.diag` | veraison/ccatoken | `4b95c09a70de` | `realm/testvectors/cbor/CcaClaimsMissingMandPubKey.diag` | Apache-2.0 | CCA realm claims CBOR diag (CcaClaimsMissingMandPubKey.diag) |
| `cca/ccatoken/realm/CcaRealmClaimsAll.diag` | veraison/ccatoken | `4b95c09a70de` | `realm/testvectors/cbor/CcaRealmClaimsAll.diag` | Apache-2.0 | CCA realm claims CBOR diag (CcaRealmClaimsAll.diag) |
| `cca/ccatoken/realm/CcaRealmClaimsMissingMandNonce.diag` | veraison/ccatoken | `4b95c09a70de` | `realm/testvectors/cbor/CcaRealmClaimsMissingMandNonce.diag` | Apache-2.0 | CCA realm claims CBOR diag (CcaRealmClaimsMissingMandNonce.diag) |
| `cca/ccatoken/realm/CcaRealmExample.diag` | veraison/ccatoken | `4b95c09a70de` | `realm/testvectors/cbor/CcaRealmExample.diag` | Apache-2.0 | CCA realm claims CBOR diag (CcaRealmExample.diag) |
| `cca/ccatoken/realm/CcaRealmLegacyClaimsAll.diag` | veraison/ccatoken | `4b95c09a70de` | `realm/testvectors/cbor/CcaRealmLegacyClaimsAll.diag` | Apache-2.0 | CCA realm claims CBOR diag (CcaRealmLegacyClaimsAll.diag) |
| `cca/ccatoken/realm/profile-registry/CcaRealmClaimsRegisteredProfile.diag` | veraison/ccatoken | `4b95c09a70de` | `realm/testvectors/cbor/profile-registry/CcaRealmClaimsRegisteredProfile.diag` | Apache-2.0 | CCA realm claims CBOR diag (profile-registry/CcaRealmClaimsRegisteredProfile.diag) |
| `cca/ccatoken/realm/profile-registry/CcaRealmClaimsUnregisteredProfile.diag` | veraison/ccatoken | `4b95c09a70de` | `realm/testvectors/cbor/profile-registry/CcaRealmClaimsUnregisteredProfile.diag` | Apache-2.0 | CCA realm claims CBOR diag (profile-registry/CcaRealmClaimsUnregisteredProfile.diag) |
| `cca/ccatoken/realm/v2/CcaRealmClaimsV2All.diag` | veraison/ccatoken | `4b95c09a70de` | `realm/testvectors/cbor/v2/CcaRealmClaimsV2All.diag` | Apache-2.0 | CCA realm claims CBOR diag (v2/CcaRealmClaimsV2All.diag) |
| `cca/ccatoken/realm/v2/CcaRealmClaimsV2InvalidMECPolicy.diag` | veraison/ccatoken | `4b95c09a70de` | `realm/testvectors/cbor/v2/CcaRealmClaimsV2InvalidMECPolicy.diag` | Apache-2.0 | CCA realm claims CBOR diag (v2/CcaRealmClaimsV2InvalidMECPolicy.diag) |
| `cca/ccatoken/realm/v2/CcaRealmClaimsV2MissingMECPolicy.diag` | veraison/ccatoken | `4b95c09a70de` | `realm/testvectors/cbor/v2/CcaRealmClaimsV2MissingMECPolicy.diag` | Apache-2.0 | CCA realm claims CBOR diag (v2/CcaRealmClaimsV2MissingMECPolicy.diag) |
| `cca/ccatoken/realm/v2/CcaRealmClaimsV2MissingMandInstID.diag` | veraison/ccatoken | `4b95c09a70de` | `realm/testvectors/cbor/v2/CcaRealmClaimsV2MissingMandInstID.diag` | Apache-2.0 | CCA realm claims CBOR diag (v2/CcaRealmClaimsV2MissingMandInstID.diag) |
| `cca/trustee/cca-example-token.cbor` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/cca/misc/cca-example-token.cbor` | Apache-2.0 | CCA example token (CBOR collection, synthetic) |
| `cca/trustee/cca-claims.json` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/cca-claims.json` | Apache-2.0 | Expected parsed CCA claims |
| `cca/trustee/rvstore.json` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/cca/conf/rvstore.json` | Apache-2.0 | CCA reference value store (JSON) |
| `cca/veraison-services/cca-good.cbor` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/evidence/cca-good.cbor` | Apache-2.0 | CCA token (synthetic), Veraison arm-cca scheme |
| `cca/veraison-services/cca-good.json` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/evidence/src/cca-good.json` | Apache-2.0 | Claims source for cca-good.cbor |
| `nitro/nitrite/nitro_attestation.b64` | blocky/nitrite | `a6f5b6da1e50` | `internal/testdata/nitro_attestation.b64` | MIT | NSM attestation document (COSE_Sign1, base64), real Nitro enclave |
| `nitro/nitrite/nitro_attestation_debug.b64` | blocky/nitrite | `a6f5b6da1e50` | `internal/testdata/nitro_attestation_debug.b64` | MIT | NSM attestation document, debug-mode enclave (PCRs zero) |
| `nitro/evervault/valid-attestation-doc-base64` | evervault/attestation-doc-validation | `a296a77c2b23` | `test-data/valid-attestation-doc-base64` | Apache-2.0 | NSM attestation document (base64), real Nitro enclave |
| `nitro/evervault/valid-attestation-doc-bytes` | evervault/attestation-doc-validation | `a296a77c2b23` | `test-data/beta/valid-attestation-doc-bytes` | Apache-2.0 | NSM attestation document (raw CBOR) |
| `nitro/evervault/debug-mode-attestation-doc-bytes` | evervault/attestation-doc-validation | `a296a77c2b23` | `test-data/beta/debug-mode-attestation-doc-bytes` | Apache-2.0 | NSM attestation document, debug mode (raw CBOR) |
| `tpm/go-eventlog/arch-linux-workstation.bin` | google/go-eventlog | `9e88b4ebab1e` | `testdata/eventlogs/tpm/arch-linux-workstation.bin` | Apache-2.0 | TCG PC Client crypto-agile event log (arch-linux-workstation.bin) |
| `tpm/go-eventlog/cos-101-amd-sev.bin` | google/go-eventlog | `9e88b4ebab1e` | `testdata/eventlogs/tpm/cos-101-amd-sev.bin` | Apache-2.0 | TCG PC Client crypto-agile event log (cos-101-amd-sev.bin) |
| `tpm/go-eventlog/cos-121-amd-sev.bin` | google/go-eventlog | `9e88b4ebab1e` | `testdata/eventlogs/tpm/cos-121-amd-sev.bin` | Apache-2.0 | TCG PC Client crypto-agile event log (cos-121-amd-sev.bin) |
| `tpm/go-eventlog/cos-125-intel-tdx-secure-boot.bin` | google/go-eventlog | `9e88b4ebab1e` | `testdata/eventlogs/tpm/cos-125-intel-tdx-secure-boot.bin` | Apache-2.0 | TCG PC Client crypto-agile event log (cos-125-intel-tdx-secure-boot.bin) |
| `tpm/go-eventlog/cos-85-amd-sev.bin` | google/go-eventlog | `9e88b4ebab1e` | `testdata/eventlogs/tpm/cos-85-amd-sev.bin` | Apache-2.0 | TCG PC Client crypto-agile event log (cos-85-amd-sev.bin) |
| `tpm/go-eventlog/cos-93-amd-sev.bin` | google/go-eventlog | `9e88b4ebab1e` | `testdata/eventlogs/tpm/cos-93-amd-sev.bin` | Apache-2.0 | TCG PC Client crypto-agile event log (cos-93-amd-sev.bin) |
| `tpm/go-eventlog/cs251200tpm` | google/go-eventlog | `9e88b4ebab1e` | `testdata/eventlogs/tpm/cs251200tpm` | Apache-2.0 | TCG PC Client crypto-agile event log (cs251200tpm) |
| `tpm/go-eventlog/debian-10.bin` | google/go-eventlog | `9e88b4ebab1e` | `testdata/eventlogs/tpm/debian-10.bin` | Apache-2.0 | TCG PC Client crypto-agile event log (debian-10.bin) |
| `tpm/go-eventlog/gdc-host.bin` | google/go-eventlog | `9e88b4ebab1e` | `testdata/eventlogs/tpm/gdc-host.bin` | Apache-2.0 | TCG PC Client crypto-agile event log (gdc-host.bin) |
| `tpm/go-eventlog/glinux-alex.bin` | google/go-eventlog | `9e88b4ebab1e` | `testdata/eventlogs/tpm/glinux-alex.bin` | Apache-2.0 | TCG PC Client crypto-agile event log (glinux-alex.bin) |
| `tpm/go-eventlog/host-gmes.bin` | google/go-eventlog | `9e88b4ebab1e` | `testdata/eventlogs/tpm/host-gmes.bin` | Apache-2.0 | TCG PC Client crypto-agile event log (host-gmes.bin) |
| `tpm/go-eventlog/rhel8-uefi.bin` | google/go-eventlog | `9e88b4ebab1e` | `testdata/eventlogs/tpm/rhel8-uefi.bin` | Apache-2.0 | TCG PC Client crypto-agile event log (rhel8-uefi.bin) |
| `tpm/go-eventlog/ubuntu-1804-amd-sev.bin` | google/go-eventlog | `9e88b4ebab1e` | `testdata/eventlogs/tpm/ubuntu-1804-amd-sev.bin` | Apache-2.0 | TCG PC Client crypto-agile event log (ubuntu-1804-amd-sev.bin) |
| `tpm/go-eventlog/ubuntu-2104-no-dbx.bin` | google/go-eventlog | `9e88b4ebab1e` | `testdata/eventlogs/tpm/ubuntu-2104-no-dbx.bin` | Apache-2.0 | TCG PC Client crypto-agile event log (ubuntu-2104-no-dbx.bin) |
| `tpm/go-eventlog/ubuntu-2104-no-secure-boot.bin` | google/go-eventlog | `9e88b4ebab1e` | `testdata/eventlogs/tpm/ubuntu-2104-no-secure-boot.bin` | Apache-2.0 | TCG PC Client crypto-agile event log (ubuntu-2104-no-secure-boot.bin) |
| `tpm/go-eventlog/ubuntu-2404-amd-sevsnp.bin` | google/go-eventlog | `9e88b4ebab1e` | `testdata/eventlogs/tpm/ubuntu-2404-amd-sevsnp.bin` | Apache-2.0 | TCG PC Client crypto-agile event log (ubuntu-2404-amd-sevsnp.bin) |
| `tpm/go-eventlog/ubuntu-2404-intel-tdx.bin` | google/go-eventlog | `9e88b4ebab1e` | `testdata/eventlogs/tpm/ubuntu-2404-intel-tdx.bin` | Apache-2.0 | TCG PC Client crypto-agile event log (ubuntu-2404-intel-tdx.bin) |
| `tpm/go-eventlog/legacydata/coreos_36_shielded_vm_no_secure_boot_eventlog` | google/go-eventlog | `9e88b4ebab1e` | `testdata/legacydata/coreos_36_shielded_vm_no_secure_boot_eventlog` | Apache-2.0 | TCG event log, legacy go-attestation corpus (coreos_36_shielded_vm_no_secure_boot_eventlog) |
| `tpm/go-eventlog/legacydata/crypto_agile_eventlog` | google/go-eventlog | `9e88b4ebab1e` | `testdata/legacydata/crypto_agile_eventlog` | Apache-2.0 | TCG event log, legacy go-attestation corpus (crypto_agile_eventlog) |
| `tpm/go-eventlog/legacydata/ebs_event_missing_eventlog` | google/go-eventlog | `9e88b4ebab1e` | `testdata/legacydata/ebs_event_missing_eventlog` | Apache-2.0 | TCG event log, legacy go-attestation corpus (ebs_event_missing_eventlog) |
| `tpm/go-eventlog/legacydata/linux_tpm12.json` | google/go-eventlog | `9e88b4ebab1e` | `testdata/legacydata/linux_tpm12.json` | Apache-2.0 | TCG event log, legacy go-attestation corpus (linux_tpm12.json) |
| `tpm/go-eventlog/legacydata/option_rom_eventlog` | google/go-eventlog | `9e88b4ebab1e` | `testdata/legacydata/option_rom_eventlog` | Apache-2.0 | TCG event log, legacy go-attestation corpus (option_rom_eventlog) |
| `tpm/go-eventlog/legacydata/sb_cert_eventlog` | google/go-eventlog | `9e88b4ebab1e` | `testdata/legacydata/sb_cert_eventlog` | Apache-2.0 | TCG event log, legacy go-attestation corpus (sb_cert_eventlog) |
| `tpm/go-eventlog/legacydata/short_no_action_eventlog` | google/go-eventlog | `9e88b4ebab1e` | `testdata/legacydata/short_no_action_eventlog` | Apache-2.0 | TCG event log, legacy go-attestation corpus (short_no_action_eventlog) |
| `tpm/go-eventlog/legacydata/windows_gcp_shielded_vm.json` | google/go-eventlog | `9e88b4ebab1e` | `testdata/legacydata/windows_gcp_shielded_vm.json` | Apache-2.0 | TCG event log, legacy go-attestation corpus (windows_gcp_shielded_vm.json) |
| `tpm/trustee/tpm_evidence.json` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/tpm_evidence.json` | Apache-2.0 | Generic TPM evidence (AK pub, quote, sig, PCRs, event log) |
| `azure/az-cvm-vtpm/hcl-report-snp.bin` | kinvolk/azure-cvm-tooling | `e4e440748fc1` | `az-cvm-vtpm/test/hcl-report-snp.bin` | MIT | Azure HCL report wrapping SNP report (vTPM NV 0x01400001) |
| `azure/az-cvm-vtpm/hcl-report-tdx.bin` | kinvolk/azure-cvm-tooling | `e4e440748fc1` | `az-cvm-vtpm/test/hcl-report-tdx.bin` | MIT | Azure HCL report wrapping TDREPORT |
| `azure/az-cvm-vtpm/var-data.bin` | kinvolk/azure-cvm-tooling | `e4e440748fc1` | `az-cvm-vtpm/test/var-data.bin` | MIT | HCL runtime data (JSON var data incl. AK pub) |
| `azure/az-cvm-vtpm/quote.bin` | kinvolk/azure-cvm-tooling | `e4e440748fc1` | `az-cvm-vtpm/test/quote.bin` | MIT | Azure vTPM quote (TPMS_ATTEST + sig + PCRs) |
| `azure/az-cvm-vtpm/akpub.pem` | kinvolk/azure-cvm-tooling | `e4e440748fc1` | `az-cvm-vtpm/test/akpub.pem` | MIT | Azure vTPM AK public key (PEM) |
| `azure/az-cvm-vtpm/certs.pem` | kinvolk/azure-cvm-tooling | `e4e440748fc1` | `az-cvm-vtpm/test/certs.pem` | MIT | VCEK+ASK+ARK (PEM), Milan, for hcl-report-snp |
| `azure/trustee/az-snp-vtpm/aael-multi-pcr17-pcr23.bin` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/az-snp-vtpm/aael-multi-pcr17-pcr23.bin` | Apache-2.0 | Azure SNP vTPM evidence/fixture (aael-multi-pcr17-pcr23.bin) |
| `azure/trustee/az-snp-vtpm/aael-pcr17-pull-image.bin` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/az-snp-vtpm/aael-pcr17-pull-image.bin` | Apache-2.0 | Azure SNP vTPM evidence/fixture (aael-pcr17-pull-image.bin) |
| `azure/trustee/az-snp-vtpm/aael-pcr23-pull-image.bin` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/az-snp-vtpm/aael-pcr23-pull-image.bin` | Apache-2.0 | Azure SNP vTPM evidence/fixture (aael-pcr23-pull-image.bin) |
| `azure/trustee/az-snp-vtpm/evidence-genoa.json` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/az-snp-vtpm/evidence-genoa.json` | Apache-2.0 | Azure SNP CVM evidence (HCL report + vTPM quote), Genoa |
| `azure/trustee/az-snp-vtpm/evidence-v0.json` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/az-snp-vtpm/evidence-v0.json` | Apache-2.0 | Azure SNP vTPM evidence/fixture (evidence-v0.json) |
| `azure/trustee/az-snp-vtpm/evidence-v1.json` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/az-snp-vtpm/evidence-v1.json` | Apache-2.0 | Azure SNP vTPM evidence/fixture (evidence-v1.json) |
| `azure/trustee/az-snp-vtpm/evidence-v2.json` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/az-snp-vtpm/evidence-v2.json` | Apache-2.0 | Azure SNP vTPM evidence/fixture (evidence-v2.json) |
| `azure/trustee/az-snp-vtpm/hcl-report.bin` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/az-snp-vtpm/hcl-report.bin` | Apache-2.0 | Azure HCL report wrapping SNP report |
| `azure/trustee/az-snp-vtpm/quote.bin` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/az-snp-vtpm/quote.bin` | Apache-2.0 | Azure vTPM quote |
| `azure/trustee/az-snp-vtpm/tpm-quote-v1.json` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/az-snp-vtpm/tpm-quote-v1.json` | Apache-2.0 | Azure SNP vTPM evidence/fixture (tpm-quote-v1.json) |
| `azure/trustee/az-snp-vtpm/tpm-quote.msg` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/az-snp-vtpm/tpm-quote.msg` | Apache-2.0 | vTPM quote TPMS_ATTEST message |
| `azure/trustee/az-snp-vtpm/tpm-quote.sig` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/az-snp-vtpm/tpm-quote.sig` | Apache-2.0 | vTPM quote signature |
| `azure/trustee/az-snp-vtpm/vcek-genoa.pem` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/az-snp-vtpm/vcek-genoa.pem` | Apache-2.0 | VCEK chain (PEM), Genoa, for evidence-genoa |
| `azure/trustee/az-snp-vtpm/vcek.pem` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/az-snp-vtpm/vcek.pem` | Apache-2.0 | VCEK+ASK+ARK (PEM), Milan |
| `azure/trustee/az-tdx-vtpm/evidence-v0.json` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/az-tdx-vtpm/evidence-v0.json` | Apache-2.0 | Azure TDX vTPM evidence/fixture (evidence-v0.json) |
| `azure/trustee/az-tdx-vtpm/evidence-v1.json` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/az-tdx-vtpm/evidence-v1.json` | Apache-2.0 | Azure TDX vTPM evidence/fixture (evidence-v1.json) |
| `azure/trustee/az-tdx-vtpm/hcl-report.bin` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/az-tdx-vtpm/hcl-report.bin` | Apache-2.0 | Azure HCL report wrapping TDREPORT |
| `azure/trustee/az-tdx-vtpm/quote.bin` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/az-tdx-vtpm/quote.bin` | Apache-2.0 | Azure vTPM quote |
| `azure/trustee/az-tdx-vtpm/td-quote.bin` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/az-tdx-vtpm/td-quote.bin` | Apache-2.0 | TDX quote v4 obtained via Azure IMDS for hcl-report |
| `azure/trustee/az-tdx-vtpm/tpm-quote-v1.json` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/az-tdx-vtpm/tpm-quote-v1.json` | Apache-2.0 | Azure TDX vTPM evidence/fixture (tpm-quote-v1.json) |
| `gcp/go-tpm-tools/gce-cos-85-no-nonce.pb` | google/go-tpm-tools | `829ec3137784` | `internal/test/attestations/gce-cos-85-no-nonce.pb` | Apache-2.0 | GCE Shielded VM vTPM attestation (go-tpm-tools Attestation proto: quotes, event log, AK cert), COS 85 |
| `gcp/go-tpm-tools/gce-cos-85-nonce9009.pb` | google/go-tpm-tools | `829ec3137784` | `internal/test/attestations/gce-cos-85-nonce9009.pb` | Apache-2.0 | GCE Shielded VM vTPM attestation with nonce 9009, COS 85 |
| `gcp/go-tpm-tools/certificates/pca_tpm_ecc_enc_cert.pem` | google/go-tpm-tools | `829ec3137784` | `internal/test/certificates/pca_tpm_ecc_enc_cert.pem` | Apache-2.0 | GCE vTPM EK certificate (pca_tpm_ecc_enc_cert.pem) |
| `gcp/go-tpm-tools/certificates/pca_tpm_ecc_sign_cert.pem` | google/go-tpm-tools | `829ec3137784` | `internal/test/certificates/pca_tpm_ecc_sign_cert.pem` | Apache-2.0 | GCE vTPM AK certificate (pca_tpm_ecc_sign_cert.pem) |
| `gcp/go-tpm-tools/certificates/pca_tpm_rsa_enc_cert.pem` | google/go-tpm-tools | `829ec3137784` | `internal/test/certificates/pca_tpm_rsa_enc_cert.pem` | Apache-2.0 | GCE vTPM EK certificate (pca_tpm_rsa_enc_cert.pem) |
| `gcp/go-tpm-tools/certificates/pca_tpm_rsa_sign_cert.pem` | google/go-tpm-tools | `829ec3137784` | `internal/test/certificates/pca_tpm_rsa_sign_cert.pem` | Apache-2.0 | GCE vTPM AK certificate (pca_tpm_rsa_sign_cert.pem) |
| `gcp/go-tpm-tools/certificates/uca_tpm_ecc_enc_cert.pem` | google/go-tpm-tools | `829ec3137784` | `internal/test/certificates/uca_tpm_ecc_enc_cert.pem` | Apache-2.0 | GCE vTPM EK certificate (uca_tpm_ecc_enc_cert.pem) |
| `gcp/go-tpm-tools/certificates/uca_tpm_ecc_sign_cert.pem` | google/go-tpm-tools | `829ec3137784` | `internal/test/certificates/uca_tpm_ecc_sign_cert.pem` | Apache-2.0 | GCE vTPM AK certificate (uca_tpm_ecc_sign_cert.pem) |
| `gcp/go-tpm-tools/certificates/uca_tpm_rsa_enc_cert.pem` | google/go-tpm-tools | `829ec3137784` | `internal/test/certificates/uca_tpm_rsa_enc_cert.pem` | Apache-2.0 | GCE vTPM EK certificate (uca_tpm_rsa_enc_cert.pem) |
| `gcp/go-tpm-tools/certificates/uca_tpm_rsa_sign_cert.pem` | google/go-tpm-tools | `829ec3137784` | `internal/test/certificates/uca_tpm_rsa_sign_cert.pem` | Apache-2.0 | GCE vTPM AK certificate (uca_tpm_rsa_sign_cert.pem) |
| `gcp/go-tpm-tools/cel.b64` | google/go-tpm-tools | `829ec3137784` | `agent/testdata/cel.b64` | Apache-2.0 | Confidential Space canonical event log (base64) |
| `gcp/go-tdx-guest-ccel/cos-113-tdx-quote.dat` | google/go-tdx-guest | `b0a2dd8100a0` | `testing/testdata/ccel/cos-113-tdx-quote.dat` | Apache-2.0 | TDX quote v4 from GCE C3 TDX VM (COS 113) |
| `gcp/go-tdx-guest-ccel/nonce.dat` | google/go-tdx-guest | `b0a2dd8100a0` | `testing/testdata/ccel/nonce.dat` | Apache-2.0 | Report data/nonce for cos-113-tdx-quote |
| `tdx/trustee-eventlog/CCEL_data_gcp` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/eventlog/test_data/CCEL_data_gcp` | Apache-2.0 | TDX CCEL event log, GCP |
| `nvidia/nvtrust/hopperAttestationReport.txt` | NVIDIA/nvtrust | `858ada9a17f5` | `guest_tools/gpu_verifiers/local_gpu_verifier/src/verifier/samples/hopperAttestationReport.txt` | Apache-2.0 (repo) / BSD-3-Clause (pkg metadata) | H100 SPDM GET_MEASUREMENTS attestation report (hex text) |
| `nvidia/nvtrust/hopperCertChain.txt` | NVIDIA/nvtrust | `858ada9a17f5` | `guest_tools/gpu_verifiers/local_gpu_verifier/src/verifier/samples/hopperCertChain.txt` | Apache-2.0 (repo) / BSD-3-Clause (pkg metadata) | H100 device cert chain (PEM) |
| `nvidia/nvtrust/1010_0200_882_96005E0001_test_no_gpu.swidtag` | NVIDIA/nvtrust | `858ada9a17f5` | `guest_tools/gpu_verifiers/local_gpu_verifier/src/verifier/samples/1010_0200_882_96005E0001_test_no_gpu.swidtag` | Apache-2.0 (repo) / BSD-3-Clause (pkg metadata) | VBIOS RIM, signed SWID XML (test, matches sample report) |
| `nvidia/nvtrust/Driver_RIM_test_no_gpu.swidtag` | NVIDIA/nvtrust | `858ada9a17f5` | `guest_tools/gpu_verifiers/local_gpu_verifier/src/verifier/samples/Driver_RIM_test_no_gpu.swidtag` | Apache-2.0 (repo) / BSD-3-Clause (pkg metadata) | Driver RIM, signed SWID XML (test, matches sample report) |
| `nvidia/nvtrust/1010_0200_882_96005E0001_PROD.swidtag` | NVIDIA/nvtrust | `858ada9a17f5` | `guest_tools/gpu_verifiers/local_gpu_verifier/src/verifier/samples/1010_0200_882_96005E0001_PROD.swidtag` | Apache-2.0 (repo) / BSD-3-Clause (pkg metadata) | VBIOS RIM, signed SWID XML, production |
| `nvidia/nvtrust/g520_0200_885_9600740001_PROD.swidtag` | NVIDIA/nvtrust | `858ada9a17f5` | `guest_tools/gpu_verifiers/local_gpu_verifier/src/verifier/samples/g520_0200_885_9600740001_PROD.swidtag` | Apache-2.0 (repo) / BSD-3-Clause (pkg metadata) | VBIOS RIM, signed SWID XML, production |
| `nvidia/nvtrust/ppcie/gpu_evidence.json` | NVIDIA/nvtrust | `858ada9a17f5` | `guest_tools/ppcie-verifier-sdk-cpp/tests/data/gpu_evidence.json` | Apache-2.0 | 8x H100 GPU evidence (PPCIe HGX), report + cert chain base64 |
| `nvidia/nvtrust/ppcie/switch_evidence.json` | NVIDIA/nvtrust | `858ada9a17f5` | `guest_tools/ppcie-verifier-sdk-cpp/tests/data/switch_evidence.json` | Apache-2.0 | NVSwitch evidence (PPCIe HGX) |
| `nvidia/trustee/hopperAttestationReport-claims.txt` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/nvidia/hopperAttestationReport-claims.txt` | Apache-2.0 | Expected parsed claims for hopperAttestationReport |
| `nvidia/trustee/hopper_cert_chain_case2.txt` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/nvidia/hopper_cert_chain_case2.txt` | Apache-2.0 | H100 report / cert chain test case (hopper_cert_chain_case2.txt) |
| `nvidia/trustee/hopper_cert_chain_case3.txt` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/nvidia/hopper_cert_chain_case3.txt` | Apache-2.0 | H100 report / cert chain test case (hopper_cert_chain_case3.txt) |
| `nvidia/trustee/hopper_cert_chain_case4.txt` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/nvidia/hopper_cert_chain_case4.txt` | Apache-2.0 | H100 report / cert chain test case (hopper_cert_chain_case4.txt) |
| `nvidia/trustee/hopper_coco_certs1.txt` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/nvidia/hopper_coco_certs1.txt` | Apache-2.0 | H100 report / cert chain test case (hopper_coco_certs1.txt) |
| `nvidia/trustee/hopper_coco_report1.txt` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/nvidia/hopper_coco_report1.txt` | Apache-2.0 | H100 report / cert chain test case (hopper_coco_report1.txt) |
| `nvidia/trustee/hopper_signing_cert.pem` | confidential-containers/trustee | `55cbc0cd4a5e` | `deps/verifier/test_data/nvidia/hopper_signing_cert.pem` | Apache-2.0 | H100 attestation leaf cert (PEM) |
| `nvidia/veraison-services/blackwell-evidence.json` | veraison/services | `b1cd67e3b264` | `scheme/nvidia/testdata/blackwell-evidence.json` | Apache-2.0 | Blackwell (GB100) GPU evidence: SPDM report + cert chain, NVAT format |
| `coswid/veraison-corim/ce-coswid.cbor` | veraison/corim | `156e2dda8092` | `coev/testcases/ce-coswid.cbor` | Apache-2.0 | Concise evidence with CoSWID evidence triple |
| `coswid/veraison-corim/ce-coswid.diag` | veraison/corim | `156e2dda8092` | `coev/testcases/src/ce-coswid.diag` | Apache-2.0 | Diag source for ce-coswid.cbor |
| `corim/veraison-corim/corim/corim-1.cbor` | veraison/corim | `156e2dda8092` | `corim/testcases/corim-1.cbor` | Apache-2.0 | CoRIM (corim-1.cbor) |
| `corim/veraison-corim/corim/corim-2.cbor` | veraison/corim | `156e2dda8092` | `corim/testcases/corim-2.cbor` | Apache-2.0 | CoRIM (corim-2.cbor) |
| `corim/veraison-corim/corim/corim-design-cd.cbor` | veraison/corim | `156e2dda8092` | `corim/testcases/corim-design-cd.cbor` | Apache-2.0 | CoRIM (corim-design-cd.cbor) |
| `corim/veraison-corim/corim/corim-firmware-cd.cbor` | veraison/corim | `156e2dda8092` | `corim/testcases/corim-firmware-cd.cbor` | Apache-2.0 | CoRIM (corim-firmware-cd.cbor) |
| `corim/veraison-corim/corim/corim-roles.cbor` | veraison/corim | `156e2dda8092` | `corim/testcases/corim-roles.cbor` | Apache-2.0 | CoRIM (corim-roles.cbor) |
| `corim/veraison-corim/corim/signed-corim-with-extensions.cbor` | veraison/corim | `156e2dda8092` | `corim/testcases/signed-corim-with-extensions.cbor` | Apache-2.0 | Signed CoRIM (COSE_Sign1) (signed-corim-with-extensions.cbor) |
| `corim/veraison-corim/corim/signed-example-corim.cbor` | veraison/corim | `156e2dda8092` | `corim/testcases/signed-example-corim.cbor` | Apache-2.0 | Signed CoRIM (COSE_Sign1) (signed-example-corim.cbor) |
| `corim/veraison-corim/corim/signed-good-corim.cbor` | veraison/corim | `156e2dda8092` | `corim/testcases/signed-good-corim.cbor` | Apache-2.0 | Signed CoRIM (COSE_Sign1) (signed-good-corim.cbor) |
| `corim/veraison-corim/corim/unsigned-corim-with-extensions.cbor` | veraison/corim | `156e2dda8092` | `corim/testcases/unsigned-corim-with-extensions.cbor` | Apache-2.0 | CoRIM (unsigned-corim-with-extensions.cbor) |
| `corim/veraison-corim/corim/unsigned-example-corim.cbor` | veraison/corim | `156e2dda8092` | `corim/testcases/unsigned-example-corim.cbor` | Apache-2.0 | CoRIM (unsigned-example-corim.cbor) |
| `corim/veraison-corim/corim/unsigned-good-corim.cbor` | veraison/corim | `156e2dda8092` | `corim/testcases/unsigned-good-corim.cbor` | Apache-2.0 | CoRIM (unsigned-good-corim.cbor) |
| `corim/veraison-corim/corim/comid-ext.json` | veraison/corim | `156e2dda8092` | `corim/testcases/comid-ext.json` | Apache-2.0 | CoRIM JSON template |
| `corim/veraison-corim/corim/comid.json` | veraison/corim | `156e2dda8092` | `corim/testcases/comid.json` | Apache-2.0 | CoRIM JSON template |
| `corim/veraison-corim/corim/corim-ext.json` | veraison/corim | `156e2dda8092` | `corim/testcases/corim-ext.json` | Apache-2.0 | CoRIM JSON template |
| `corim/veraison-corim/corim/corim.json` | veraison/corim | `156e2dda8092` | `corim/testcases/corim.json` | Apache-2.0 | CoRIM JSON template |
| `corim/veraison-corim/corim/src/corim-1.diag` | veraison/corim | `156e2dda8092` | `corim/testcases/src/corim-1.diag` | Apache-2.0 | CoRIM CBOR diag source |
| `corim/veraison-corim/corim/src/corim-2.diag` | veraison/corim | `156e2dda8092` | `corim/testcases/src/corim-2.diag` | Apache-2.0 | CoRIM CBOR diag source |
| `corim/veraison-corim/corim/src/corim-design-cd.diag` | veraison/corim | `156e2dda8092` | `corim/testcases/src/corim-design-cd.diag` | Apache-2.0 | CoRIM CBOR diag source |
| `corim/veraison-corim/corim/src/corim-firmware-cd.diag` | veraison/corim | `156e2dda8092` | `corim/testcases/src/corim-firmware-cd.diag` | Apache-2.0 | CoRIM CBOR diag source |
| `corim/veraison-corim/corim/src/corim-roles.diag` | veraison/corim | `156e2dda8092` | `corim/testcases/src/corim-roles.diag` | Apache-2.0 | CoRIM CBOR diag source |
| `corim/veraison-corim/comid/comid-1.cbor` | veraison/corim | `156e2dda8092` | `comid/testcases/comid-1.cbor` | Apache-2.0 | CoMID (comid-1.cbor) |
| `corim/veraison-corim/comid/comid-1a.cbor` | veraison/corim | `156e2dda8092` | `comid/testcases/comid-1a.cbor` | Apache-2.0 | CoMID (comid-1a.cbor) |
| `corim/veraison-corim/comid/comid-2.cbor` | veraison/corim | `156e2dda8092` | `comid/testcases/comid-2.cbor` | Apache-2.0 | CoMID (comid-2.cbor) |
| `corim/veraison-corim/comid/comid-2b.cbor` | veraison/corim | `156e2dda8092` | `comid/testcases/comid-2b.cbor` | Apache-2.0 | CoMID (comid-2b.cbor) |
| `corim/veraison-corim/comid/comid-3.cbor` | veraison/corim | `156e2dda8092` | `comid/testcases/comid-3.cbor` | Apache-2.0 | CoMID (comid-3.cbor) |
| `corim/veraison-corim/comid/comid-4.cbor` | veraison/corim | `156e2dda8092` | `comid/testcases/comid-4.cbor` | Apache-2.0 | CoMID (comid-4.cbor) |
| `corim/veraison-corim/comid/comid-5.cbor` | veraison/corim | `156e2dda8092` | `comid/testcases/comid-5.cbor` | Apache-2.0 | CoMID (comid-5.cbor) |
| `corim/veraison-corim/comid/comid-6.cbor` | veraison/corim | `156e2dda8092` | `comid/testcases/comid-6.cbor` | Apache-2.0 | CoMID (comid-6.cbor) |
| `corim/veraison-corim/comid/comid-7.cbor` | veraison/corim | `156e2dda8092` | `comid/testcases/comid-7.cbor` | Apache-2.0 | CoMID (comid-7.cbor) |
| `corim/veraison-corim/comid/comid-cend.cbor` | veraison/corim | `156e2dda8092` | `comid/testcases/comid-cend.cbor` | Apache-2.0 | CoMID (comid-cend.cbor) |
| `corim/veraison-corim/comid/comid-cond-endorse-series.cbor` | veraison/corim | `156e2dda8092` | `comid/testcases/comid-cond-endorse-series.cbor` | Apache-2.0 | CoMID (comid-cond-endorse-series.cbor) |
| `corim/veraison-corim/comid/comid-design-cd.cbor` | veraison/corim | `156e2dda8092` | `comid/testcases/comid-design-cd.cbor` | Apache-2.0 | CoMID (comid-design-cd.cbor) |
| `corim/veraison-corim/comid/comid-domain-dep.cbor` | veraison/corim | `156e2dda8092` | `comid/testcases/comid-domain-dep.cbor` | Apache-2.0 | CoMID (comid-domain-dep.cbor) |
| `corim/veraison-corim/comid/comid-domain-mem.cbor` | veraison/corim | `156e2dda8092` | `comid/testcases/comid-domain-mem.cbor` | Apache-2.0 | CoMID (comid-domain-mem.cbor) |
| `corim/veraison-corim/comid/comid-firmware-cd.cbor` | veraison/corim | `156e2dda8092` | `comid/testcases/comid-firmware-cd.cbor` | Apache-2.0 | CoMID (comid-firmware-cd.cbor) |
| `corim/veraison-corim/comid/comid-flags.cbor` | veraison/corim | `156e2dda8092` | `comid/testcases/comid-flags.cbor` | Apache-2.0 | CoMID (comid-flags.cbor) |
| `corim/veraison-corim/comid/comid-integrity-registers.cbor` | veraison/corim | `156e2dda8092` | `comid/testcases/comid-integrity-registers.cbor` | Apache-2.0 | CoMID (comid-integrity-registers.cbor) |
| `corim/veraison-corim/comid/comid-opaque-instance-id.cbor` | veraison/corim | `156e2dda8092` | `comid/testcases/comid-opaque-instance-id.cbor` | Apache-2.0 | CoMID (comid-opaque-instance-id.cbor) |
| `corim/veraison-corim/comid/comid-raw-value.cbor` | veraison/corim | `156e2dda8092` | `comid/testcases/comid-raw-value.cbor` | Apache-2.0 | CoMID (comid-raw-value.cbor) |
| `corim/veraison-corim/comid/comid-series.cbor` | veraison/corim | `156e2dda8092` | `comid/testcases/comid-series.cbor` | Apache-2.0 | CoMID (comid-series.cbor) |
| `corim/veraison-corim/comid/src/comid-1.diag` | veraison/corim | `156e2dda8092` | `comid/testcases/src/comid-1.diag` | Apache-2.0 | CoMID CBOR diag source |
| `corim/veraison-corim/comid/src/comid-1a.diag` | veraison/corim | `156e2dda8092` | `comid/testcases/src/comid-1a.diag` | Apache-2.0 | CoMID CBOR diag source |
| `corim/veraison-corim/comid/src/comid-2.diag` | veraison/corim | `156e2dda8092` | `comid/testcases/src/comid-2.diag` | Apache-2.0 | CoMID CBOR diag source |
| `corim/veraison-corim/comid/src/comid-2b.diag` | veraison/corim | `156e2dda8092` | `comid/testcases/src/comid-2b.diag` | Apache-2.0 | CoMID CBOR diag source |
| `corim/veraison-corim/comid/src/comid-3.diag` | veraison/corim | `156e2dda8092` | `comid/testcases/src/comid-3.diag` | Apache-2.0 | CoMID CBOR diag source |
| `corim/veraison-corim/comid/src/comid-4.diag` | veraison/corim | `156e2dda8092` | `comid/testcases/src/comid-4.diag` | Apache-2.0 | CoMID CBOR diag source |
| `corim/veraison-corim/comid/src/comid-5.diag` | veraison/corim | `156e2dda8092` | `comid/testcases/src/comid-5.diag` | Apache-2.0 | CoMID CBOR diag source |
| `corim/veraison-corim/comid/src/comid-6.diag` | veraison/corim | `156e2dda8092` | `comid/testcases/src/comid-6.diag` | Apache-2.0 | CoMID CBOR diag source |
| `corim/veraison-corim/comid/src/comid-7.diag` | veraison/corim | `156e2dda8092` | `comid/testcases/src/comid-7.diag` | Apache-2.0 | CoMID CBOR diag source |
| `corim/veraison-corim/comid/src/comid-cend.diag` | veraison/corim | `156e2dda8092` | `comid/testcases/src/comid-cend.diag` | Apache-2.0 | CoMID CBOR diag source |
| `corim/veraison-corim/comid/src/comid-cond-endorse-series.diag` | veraison/corim | `156e2dda8092` | `comid/testcases/src/comid-cond-endorse-series.diag` | Apache-2.0 | CoMID CBOR diag source |
| `corim/veraison-corim/comid/src/comid-design-cd.diag` | veraison/corim | `156e2dda8092` | `comid/testcases/src/comid-design-cd.diag` | Apache-2.0 | CoMID CBOR diag source |
| `corim/veraison-corim/comid/src/comid-domain-dep.diag` | veraison/corim | `156e2dda8092` | `comid/testcases/src/comid-domain-dep.diag` | Apache-2.0 | CoMID CBOR diag source |
| `corim/veraison-corim/comid/src/comid-domain-mem.diag` | veraison/corim | `156e2dda8092` | `comid/testcases/src/comid-domain-mem.diag` | Apache-2.0 | CoMID CBOR diag source |
| `corim/veraison-corim/comid/src/comid-firmware-cd.diag` | veraison/corim | `156e2dda8092` | `comid/testcases/src/comid-firmware-cd.diag` | Apache-2.0 | CoMID CBOR diag source |
| `corim/veraison-corim/comid/src/comid-flags.diag` | veraison/corim | `156e2dda8092` | `comid/testcases/src/comid-flags.diag` | Apache-2.0 | CoMID CBOR diag source |
| `corim/veraison-corim/comid/src/comid-integrity-registers.diag` | veraison/corim | `156e2dda8092` | `comid/testcases/src/comid-integrity-registers.diag` | Apache-2.0 | CoMID CBOR diag source |
| `corim/veraison-corim/comid/src/comid-opaque-instance-id.diag` | veraison/corim | `156e2dda8092` | `comid/testcases/src/comid-opaque-instance-id.diag` | Apache-2.0 | CoMID CBOR diag source |
| `corim/veraison-corim/comid/src/comid-raw-value.diag` | veraison/corim | `156e2dda8092` | `comid/testcases/src/comid-raw-value.diag` | Apache-2.0 | CoMID CBOR diag source |
| `corim/veraison-corim/comid/src/comid-series.diag` | veraison/corim | `156e2dda8092` | `comid/testcases/src/comid-series.diag` | Apache-2.0 | CoMID CBOR diag source |
| `corim/veraison-corim/coev/ce-evidence.cbor` | veraison/corim | `156e2dda8092` | `coev/testcases/ce-evidence.cbor` | Apache-2.0 | Concise evidence (ce-evidence.cbor) |
| `corim/veraison-corim/coev/ce-identity.cbor` | veraison/corim | `156e2dda8092` | `coev/testcases/ce-identity.cbor` | Apache-2.0 | Concise evidence (ce-identity.cbor) |
| `corim/veraison-corim/coev/example-concise-evidence.cbor` | veraison/corim | `156e2dda8092` | `coev/testcases/example-concise-evidence.cbor` | Apache-2.0 | Concise evidence (example-concise-evidence.cbor) |
| `corim/veraison-corim/coev/example-spdm-toc.cbor` | veraison/corim | `156e2dda8092` | `coev/testcases/example-spdm-toc.cbor` | Apache-2.0 | Concise evidence (example-spdm-toc.cbor) |
| `corim/veraison-corim/coev/example-concise-evidence.json` | veraison/corim | `156e2dda8092` | `coev/testcases/example-concise-evidence.json` | Apache-2.0 | Concise evidence JSON template |
| `corim/veraison-corim/coev/example-spdm-toc.json` | veraison/corim | `156e2dda8092` | `coev/testcases/example-spdm-toc.json` | Apache-2.0 | Concise evidence JSON template |
| `corim/veraison-corim/coev/src/ce-evidence.diag` | veraison/corim | `156e2dda8092` | `coev/testcases/src/ce-evidence.diag` | Apache-2.0 | Concise evidence CBOR diag source |
| `corim/veraison-corim/coev/src/ce-identity.diag` | veraison/corim | `156e2dda8092` | `coev/testcases/src/ce-identity.diag` | Apache-2.0 | Concise evidence CBOR diag source |
| `corim/veraison-corim/coev-tdx/ce-pce-evidence.cbor` | veraison/corim | `156e2dda8092` | `coev/tdx/testcases/ce-pce-evidence.cbor` | Apache-2.0 | TDX concise evidence (ce-pce-evidence.cbor) |
| `corim/veraison-corim/coev-tdx/ce-qe-evidence.cbor` | veraison/corim | `156e2dda8092` | `coev/tdx/testcases/ce-qe-evidence.cbor` | Apache-2.0 | TDX concise evidence (ce-qe-evidence.cbor) |
| `corim/veraison-corim/coev-tdx/ce-seam-evidence.cbor` | veraison/corim | `156e2dda8092` | `coev/tdx/testcases/ce-seam-evidence.cbor` | Apache-2.0 | TDX concise evidence (ce-seam-evidence.cbor) |
| `corim/veraison-corim/coev-tdx/src/ce-pce-evidence.diag` | veraison/corim | `156e2dda8092` | `coev/tdx/testcases/src/ce-pce-evidence.diag` | Apache-2.0 | TDX concise evidence CBOR diag source |
| `corim/veraison-corim/coev-tdx/src/ce-qe-evidence.diag` | veraison/corim | `156e2dda8092` | `coev/tdx/testcases/src/ce-qe-evidence.diag` | Apache-2.0 | TDX concise evidence CBOR diag source |
| `corim/veraison-corim/coev-tdx/src/ce-seam-evidence.diag` | veraison/corim | `156e2dda8092` | `coev/tdx/testcases/src/ce-seam-evidence.diag` | Apache-2.0 | TDX concise evidence CBOR diag source |
| `corim/veraison-corim/profiles-cca/cca-platform-invalid-digests.cbor` | veraison/corim | `156e2dda8092` | `profiles/cca/testcases/cca-platform-invalid-digests.cbor` | Apache-2.0 | CCA-profile CoRIM, negative case (cca-platform-invalid-digests.cbor) |
| `corim/veraison-corim/profiles-cca/cca-platform-invalid-impl-id.cbor` | veraison/corim | `156e2dda8092` | `profiles/cca/testcases/cca-platform-invalid-impl-id.cbor` | Apache-2.0 | CCA-profile CoRIM, negative case (cca-platform-invalid-impl-id.cbor) |
| `corim/veraison-corim/profiles-cca/cca-platform-valid.cbor` | veraison/corim | `156e2dda8092` | `profiles/cca/testcases/cca-platform-valid.cbor` | Apache-2.0 | CCA-profile CoRIM (cca-platform-valid.cbor) |
| `corim/veraison-corim/profiles-cca/cca-realm-invalid-missing-rim.cbor` | veraison/corim | `156e2dda8092` | `profiles/cca/testcases/cca-realm-invalid-missing-rim.cbor` | Apache-2.0 | CCA-profile CoRIM, negative case (cca-realm-invalid-missing-rim.cbor) |
| `corim/veraison-corim/profiles-cca/cca-realm-invalid-rim-size.cbor` | veraison/corim | `156e2dda8092` | `profiles/cca/testcases/cca-realm-invalid-rim-size.cbor` | Apache-2.0 | CCA-profile CoRIM, negative case (cca-realm-invalid-rim-size.cbor) |
| `corim/veraison-corim/profiles-cca/cca-realm-valid.cbor` | veraison/corim | `156e2dda8092` | `profiles/cca/testcases/cca-realm-valid.cbor` | Apache-2.0 | CCA-profile CoRIM (cca-realm-valid.cbor) |
| `corim/veraison-corim/profiles-cca/no-profile.cbor` | veraison/corim | `156e2dda8092` | `profiles/cca/testcases/no-profile.cbor` | Apache-2.0 | CCA-profile CoRIM, negative case (no-profile.cbor) |
| `corim/veraison-corim/profiles-tdx/comid_pce_refval.cbor` | veraison/corim | `156e2dda8092` | `profiles/tdx/testcases/comid_pce_refval.cbor` | Apache-2.0 | TDX-profile CoMID ref values (comid_pce_refval.cbor) |
| `corim/veraison-corim/profiles-tdx/comid_qe_refval.cbor` | veraison/corim | `156e2dda8092` | `profiles/tdx/testcases/comid_qe_refval.cbor` | Apache-2.0 | TDX-profile CoMID ref values (comid_qe_refval.cbor) |
| `corim/veraison-corim/profiles-tdx/comid_seam_refval.cbor` | veraison/corim | `156e2dda8092` | `profiles/tdx/testcases/comid_seam_refval.cbor` | Apache-2.0 | TDX-profile CoMID ref values (comid_seam_refval.cbor) |
| `corim/veraison-corim/profiles-tdx/src/comid_pce_refval.diag` | veraison/corim | `156e2dda8092` | `profiles/tdx/testcases/src/comid_pce_refval.diag` | Apache-2.0 | TDX-profile CoMID CBOR diag source |
| `corim/veraison-corim/profiles-tdx/src/comid_qe_refval.diag` | veraison/corim | `156e2dda8092` | `profiles/tdx/testcases/src/comid_qe_refval.diag` | Apache-2.0 | TDX-profile CoMID CBOR diag source |
| `corim/veraison-corim/profiles-tdx/src/comid_seam_refval.diag` | veraison/corim | `156e2dda8092` | `profiles/tdx/testcases/src/comid_seam_refval.diag` | Apache-2.0 | TDX-profile CoMID CBOR diag source |
| `corim/veraison-corim/testdata/endEntity.der` | veraison/corim | `156e2dda8092` | `testdata/endEntity.der` | Apache-2.0 | Test X.509 endEntity cert for signed CoRIM verification |
| `corim/veraison-corim/testdata/intermediateCA.der` | veraison/corim | `156e2dda8092` | `testdata/intermediateCA.der` | Apache-2.0 | Test X.509 intermediateCA cert for signed CoRIM verification |
| `corim/veraison-corim/testdata/rootCA.der` | veraison/corim | `156e2dda8092` | `testdata/rootCA.der` | Apache-2.0 | Test X.509 rootCA cert for signed CoRIM verification |
| `corim/veraison-services/sevsnp/corim-sevsnp-bad-refval-key.cbor` | veraison/services | `b1cd67e3b264` | `scheme/sevsnp/test/corim/corim-sevsnp-bad-refval-key.cbor` | Apache-2.0 | sevsnp endorsement CoRIM, negative case (corim-sevsnp-bad-refval-key.cbor) |
| `corim/veraison-services/sevsnp/corim-sevsnp-bad-refval-no-key.cbor` | veraison/services | `b1cd67e3b264` | `scheme/sevsnp/test/corim/corim-sevsnp-bad-refval-no-key.cbor` | Apache-2.0 | sevsnp endorsement CoRIM, negative case (corim-sevsnp-bad-refval-no-key.cbor) |
| `corim/veraison-services/sevsnp/corim-sevsnp-bad-ta-no-model.cbor` | veraison/services | `b1cd67e3b264` | `scheme/sevsnp/test/corim/corim-sevsnp-bad-ta-no-model.cbor` | Apache-2.0 | sevsnp endorsement CoRIM, negative case (corim-sevsnp-bad-ta-no-model.cbor) |
| `corim/veraison-services/sevsnp/corim-sevsnp-bad-ta-no-vendor.cbor` | veraison/services | `b1cd67e3b264` | `scheme/sevsnp/test/corim/corim-sevsnp-bad-ta-no-vendor.cbor` | Apache-2.0 | sevsnp endorsement CoRIM, negative case (corim-sevsnp-bad-ta-no-vendor.cbor) |
| `corim/veraison-services/sevsnp/corim-sevsnp-valid.cbor` | veraison/services | `b1cd67e3b264` | `scheme/sevsnp/test/corim/corim-sevsnp-valid.cbor` | Apache-2.0 | sevsnp endorsement CoRIM (corim-sevsnp-valid.cbor) |
| `corim/veraison-services/sevsnp/src/comid-bad-refval-key.json` | veraison/services | `b1cd67e3b264` | `scheme/sevsnp/test/corim/src/comid-bad-refval-key.json` | Apache-2.0 | sevsnp CoMID/CoRIM JSON template |
| `corim/veraison-services/sevsnp/src/comid-bad-refval-no-key.json` | veraison/services | `b1cd67e3b264` | `scheme/sevsnp/test/corim/src/comid-bad-refval-no-key.json` | Apache-2.0 | sevsnp CoMID/CoRIM JSON template |
| `corim/veraison-services/sevsnp/src/comid-bad-ta-no-model.json` | veraison/services | `b1cd67e3b264` | `scheme/sevsnp/test/corim/src/comid-bad-ta-no-model.json` | Apache-2.0 | sevsnp CoMID/CoRIM JSON template |
| `corim/veraison-services/sevsnp/src/comid-bad-ta-no-vendor.json` | veraison/services | `b1cd67e3b264` | `scheme/sevsnp/test/corim/src/comid-bad-ta-no-vendor.json` | Apache-2.0 | sevsnp CoMID/CoRIM JSON template |
| `corim/veraison-services/sevsnp/src/comid-sevsnp-refval.json` | veraison/services | `b1cd67e3b264` | `scheme/sevsnp/test/corim/src/comid-sevsnp-refval.json` | Apache-2.0 | sevsnp CoMID/CoRIM JSON template |
| `corim/veraison-services/sevsnp/src/comid-sevsnp-ta.json` | veraison/services | `b1cd67e3b264` | `scheme/sevsnp/test/corim/src/comid-sevsnp-ta.json` | Apache-2.0 | sevsnp CoMID/CoRIM JSON template |
| `corim/veraison-services/sevsnp/src/corim-sevsnp.json` | veraison/services | `b1cd67e3b264` | `scheme/sevsnp/test/corim/src/corim-sevsnp.json` | Apache-2.0 | sevsnp CoMID/CoRIM JSON template |
| `corim/veraison-services/arm-cca/corim-cca-platform-bad-no-class.cbor` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/corim-cca-platform-bad-no-class.cbor` | Apache-2.0 | arm-cca endorsement CoRIM, negative case (corim-cca-platform-bad-no-class.cbor) |
| `corim/veraison-services/arm-cca/corim-cca-platform-bad-refval-cryptokeys.cbor` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/corim-cca-platform-bad-refval-cryptokeys.cbor` | Apache-2.0 | arm-cca endorsement CoRIM, negative case (corim-cca-platform-bad-refval-cryptokeys.cbor) |
| `corim/veraison-services/arm-cca/corim-cca-platform-bad-refval-instance.cbor` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/corim-cca-platform-bad-refval-instance.cbor` | Apache-2.0 | arm-cca endorsement CoRIM, negative case (corim-cca-platform-bad-refval-instance.cbor) |
| `corim/veraison-services/arm-cca/corim-cca-platform-bad-refval-mkey-string.cbor` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/corim-cca-platform-bad-refval-mkey-string.cbor` | Apache-2.0 | arm-cca endorsement CoRIM, negative case (corim-cca-platform-bad-refval-mkey-string.cbor) |
| `corim/veraison-services/arm-cca/corim-cca-platform-bad-refval-mkey.cbor` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/corim-cca-platform-bad-refval-mkey.cbor` | Apache-2.0 | arm-cca endorsement CoRIM, negative case (corim-cca-platform-bad-refval-mkey.cbor) |
| `corim/veraison-services/arm-cca/corim-cca-platform-bad-refval-no-digests.cbor` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/corim-cca-platform-bad-refval-no-digests.cbor` | Apache-2.0 | arm-cca endorsement CoRIM, negative case (corim-cca-platform-bad-refval-no-digests.cbor) |
| `corim/veraison-services/arm-cca/corim-cca-platform-bad-refval-no-mkey.cbor` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/corim-cca-platform-bad-refval-no-mkey.cbor` | Apache-2.0 | arm-cca endorsement CoRIM, negative case (corim-cca-platform-bad-refval-no-mkey.cbor) |
| `corim/veraison-services/arm-cca/corim-cca-platform-bad-refval-no-raw-value.cbor` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/corim-cca-platform-bad-refval-no-raw-value.cbor` | Apache-2.0 | arm-cca endorsement CoRIM, negative case (corim-cca-platform-bad-refval-no-raw-value.cbor) |
| `corim/veraison-services/arm-cca/corim-cca-platform-bad-ta-cert.cbor` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/corim-cca-platform-bad-ta-cert.cbor` | Apache-2.0 | arm-cca endorsement CoRIM, negative case (corim-cca-platform-bad-ta-cert.cbor) |
| `corim/veraison-services/arm-cca/corim-cca-platform-bad-ta-instance.cbor` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/corim-cca-platform-bad-ta-instance.cbor` | Apache-2.0 | arm-cca endorsement CoRIM, negative case (corim-cca-platform-bad-ta-instance.cbor) |
| `corim/veraison-services/arm-cca/corim-cca-platform-bad-ta-no-instance.cbor` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/corim-cca-platform-bad-ta-no-instance.cbor` | Apache-2.0 | arm-cca endorsement CoRIM, negative case (corim-cca-platform-bad-ta-no-instance.cbor) |
| `corim/veraison-services/arm-cca/corim-cca-platform-valid.cbor` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/corim-cca-platform-valid.cbor` | Apache-2.0 | arm-cca endorsement CoRIM (corim-cca-platform-valid.cbor) |
| `corim/veraison-services/arm-cca/corim-cca-realm-bad-instance.cbor` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/corim-cca-realm-bad-instance.cbor` | Apache-2.0 | arm-cca endorsement CoRIM, negative case (corim-cca-realm-bad-instance.cbor) |
| `corim/veraison-services/arm-cca/corim-cca-realm-bad-no-instance.cbor` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/corim-cca-realm-bad-no-instance.cbor` | Apache-2.0 | arm-cca endorsement CoRIM, negative case (corim-cca-realm-bad-no-instance.cbor) |
| `corim/veraison-services/arm-cca/corim-cca-realm-bad-no-integ-regs.cbor` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/corim-cca-realm-bad-no-integ-regs.cbor` | Apache-2.0 | arm-cca endorsement CoRIM, negative case (corim-cca-realm-bad-no-integ-regs.cbor) |
| `corim/veraison-services/arm-cca/corim-cca-realm-bad-no-raw-value.cbor` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/corim-cca-realm-bad-no-raw-value.cbor` | Apache-2.0 | arm-cca endorsement CoRIM, negative case (corim-cca-realm-bad-no-raw-value.cbor) |
| `corim/veraison-services/arm-cca/corim-cca-realm-bad-no-rim.cbor` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/corim-cca-realm-bad-no-rim.cbor` | Apache-2.0 | arm-cca endorsement CoRIM, negative case (corim-cca-realm-bad-no-rim.cbor) |
| `corim/veraison-services/arm-cca/corim-cca-realm-valid.cbor` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/corim-cca-realm-valid.cbor` | Apache-2.0 | arm-cca endorsement CoRIM (corim-cca-realm-valid.cbor) |
| `corim/veraison-services/arm-cca/src/comid-cca-platform-bad-no-class.json` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/src/comid-cca-platform-bad-no-class.json` | Apache-2.0 | arm-cca CoMID/CoRIM JSON template |
| `corim/veraison-services/arm-cca/src/comid-cca-platform-bad-refval-cryptokeys.json` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/src/comid-cca-platform-bad-refval-cryptokeys.json` | Apache-2.0 | arm-cca CoMID/CoRIM JSON template |
| `corim/veraison-services/arm-cca/src/comid-cca-platform-bad-refval-instance.json` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/src/comid-cca-platform-bad-refval-instance.json` | Apache-2.0 | arm-cca CoMID/CoRIM JSON template |
| `corim/veraison-services/arm-cca/src/comid-cca-platform-bad-refval-mkey-string.json` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/src/comid-cca-platform-bad-refval-mkey-string.json` | Apache-2.0 | arm-cca CoMID/CoRIM JSON template |
| `corim/veraison-services/arm-cca/src/comid-cca-platform-bad-refval-mkey.json` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/src/comid-cca-platform-bad-refval-mkey.json` | Apache-2.0 | arm-cca CoMID/CoRIM JSON template |
| `corim/veraison-services/arm-cca/src/comid-cca-platform-bad-refval-no-digests.json` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/src/comid-cca-platform-bad-refval-no-digests.json` | Apache-2.0 | arm-cca CoMID/CoRIM JSON template |
| `corim/veraison-services/arm-cca/src/comid-cca-platform-bad-refval-no-mkey.json` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/src/comid-cca-platform-bad-refval-no-mkey.json` | Apache-2.0 | arm-cca CoMID/CoRIM JSON template |
| `corim/veraison-services/arm-cca/src/comid-cca-platform-bad-refval-no-raw-value.json` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/src/comid-cca-platform-bad-refval-no-raw-value.json` | Apache-2.0 | arm-cca CoMID/CoRIM JSON template |
| `corim/veraison-services/arm-cca/src/comid-cca-platform-bad-ta-cert.json` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/src/comid-cca-platform-bad-ta-cert.json` | Apache-2.0 | arm-cca CoMID/CoRIM JSON template |
| `corim/veraison-services/arm-cca/src/comid-cca-platform-bad-ta-instance.json` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/src/comid-cca-platform-bad-ta-instance.json` | Apache-2.0 | arm-cca CoMID/CoRIM JSON template |
| `corim/veraison-services/arm-cca/src/comid-cca-platform-bad-ta-no-instance.json` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/src/comid-cca-platform-bad-ta-no-instance.json` | Apache-2.0 | arm-cca CoMID/CoRIM JSON template |
| `corim/veraison-services/arm-cca/src/comid-cca-platform-refval.json` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/src/comid-cca-platform-refval.json` | Apache-2.0 | arm-cca CoMID/CoRIM JSON template |
| `corim/veraison-services/arm-cca/src/comid-cca-platform-ta.json` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/src/comid-cca-platform-ta.json` | Apache-2.0 | arm-cca CoMID/CoRIM JSON template |
| `corim/veraison-services/arm-cca/src/comid-cca-realm-bad-instance.json` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/src/comid-cca-realm-bad-instance.json` | Apache-2.0 | arm-cca CoMID/CoRIM JSON template |
| `corim/veraison-services/arm-cca/src/comid-cca-realm-bad-no-instance.json` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/src/comid-cca-realm-bad-no-instance.json` | Apache-2.0 | arm-cca CoMID/CoRIM JSON template |
| `corim/veraison-services/arm-cca/src/comid-cca-realm-bad-no-integ-regs.json` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/src/comid-cca-realm-bad-no-integ-regs.json` | Apache-2.0 | arm-cca CoMID/CoRIM JSON template |
| `corim/veraison-services/arm-cca/src/comid-cca-realm-bad-no-raw-value.json` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/src/comid-cca-realm-bad-no-raw-value.json` | Apache-2.0 | arm-cca CoMID/CoRIM JSON template |
| `corim/veraison-services/arm-cca/src/comid-cca-realm-bad-no-rim.json` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/src/comid-cca-realm-bad-no-rim.json` | Apache-2.0 | arm-cca CoMID/CoRIM JSON template |
| `corim/veraison-services/arm-cca/src/comid-cca-realm-refval.json` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/src/comid-cca-realm-refval.json` | Apache-2.0 | arm-cca CoMID/CoRIM JSON template |
| `corim/veraison-services/arm-cca/src/corim-cca-platform.json` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/src/corim-cca-platform.json` | Apache-2.0 | arm-cca CoMID/CoRIM JSON template |
| `corim/veraison-services/arm-cca/src/corim-cca-realm.json` | veraison/services | `b1cd67e3b264` | `scheme/arm-cca/test/corim/src/corim-cca-realm.json` | Apache-2.0 | arm-cca CoMID/CoRIM JSON template |
| `corim/veraison-services/da-spdm/corim-da-bad-group-set.cbor` | veraison/services | `b1cd67e3b264` | `scheme/da-spdm/test/corim/corim-da-bad-group-set.cbor` | Apache-2.0 | da-spdm endorsement CoRIM, negative case (corim-da-bad-group-set.cbor) |
| `corim/veraison-services/da-spdm/corim-da-bad-instance-set.cbor` | veraison/services | `b1cd67e3b264` | `scheme/da-spdm/test/corim/corim-da-bad-instance-set.cbor` | Apache-2.0 | da-spdm endorsement CoRIM, negative case (corim-da-bad-instance-set.cbor) |
| `corim/veraison-services/da-spdm/corim-da-bad-mkey-not-set.cbor` | veraison/services | `b1cd67e3b264` | `scheme/da-spdm/test/corim/corim-da-bad-mkey-not-set.cbor` | Apache-2.0 | da-spdm endorsement CoRIM, negative case (corim-da-bad-mkey-not-set.cbor) |
| `corim/veraison-services/da-spdm/corim-da-bad-mkey-wrong-type.cbor` | veraison/services | `b1cd67e3b264` | `scheme/da-spdm/test/corim/corim-da-bad-mkey-wrong-type.cbor` | Apache-2.0 | da-spdm endorsement CoRIM, negative case (corim-da-bad-mkey-wrong-type.cbor) |
| `corim/veraison-services/da-spdm/corim-da-bad-multiple-values.cbor` | veraison/services | `b1cd67e3b264` | `scheme/da-spdm/test/corim/corim-da-bad-multiple-values.cbor` | Apache-2.0 | da-spdm endorsement CoRIM, negative case (corim-da-bad-multiple-values.cbor) |
| `corim/veraison-services/da-spdm/corim-da-bad-no-class-id.cbor` | veraison/services | `b1cd67e3b264` | `scheme/da-spdm/test/corim/corim-da-bad-no-class-id.cbor` | Apache-2.0 | da-spdm endorsement CoRIM, negative case (corim-da-bad-no-class-id.cbor) |
| `corim/veraison-services/da-spdm/corim-da-bad-no-class.cbor` | veraison/services | `b1cd67e3b264` | `scheme/da-spdm/test/corim/corim-da-bad-no-class.cbor` | Apache-2.0 | da-spdm endorsement CoRIM, negative case (corim-da-bad-no-class.cbor) |
| `corim/veraison-services/da-spdm/corim-da-bad-no-name.cbor` | veraison/services | `b1cd67e3b264` | `scheme/da-spdm/test/corim/corim-da-bad-no-name.cbor` | Apache-2.0 | da-spdm endorsement CoRIM, negative case (corim-da-bad-no-name.cbor) |
| `corim/veraison-services/da-spdm/corim-da-bad-no-value.cbor` | veraison/services | `b1cd67e3b264` | `scheme/da-spdm/test/corim/corim-da-bad-no-value.cbor` | Apache-2.0 | da-spdm endorsement CoRIM, negative case (corim-da-bad-no-value.cbor) |
| `corim/veraison-services/da-spdm/corim-da-ref.cbor` | veraison/services | `b1cd67e3b264` | `scheme/da-spdm/test/corim/corim-da-ref.cbor` | Apache-2.0 | da-spdm endorsement CoRIM (corim-da-ref.cbor) |
| `corim/veraison-services/da-spdm/src/comid-da-bad-group-set.json` | veraison/services | `b1cd67e3b264` | `scheme/da-spdm/test/corim/src/comid-da-bad-group-set.json` | Apache-2.0 | da-spdm CoMID/CoRIM JSON template |
| `corim/veraison-services/da-spdm/src/comid-da-bad-instance-set.json` | veraison/services | `b1cd67e3b264` | `scheme/da-spdm/test/corim/src/comid-da-bad-instance-set.json` | Apache-2.0 | da-spdm CoMID/CoRIM JSON template |
| `corim/veraison-services/da-spdm/src/comid-da-bad-mkey-not-set.json` | veraison/services | `b1cd67e3b264` | `scheme/da-spdm/test/corim/src/comid-da-bad-mkey-not-set.json` | Apache-2.0 | da-spdm CoMID/CoRIM JSON template |
| `corim/veraison-services/da-spdm/src/comid-da-bad-mkey-wrong-type.json` | veraison/services | `b1cd67e3b264` | `scheme/da-spdm/test/corim/src/comid-da-bad-mkey-wrong-type.json` | Apache-2.0 | da-spdm CoMID/CoRIM JSON template |
| `corim/veraison-services/da-spdm/src/comid-da-bad-multiple-values.json` | veraison/services | `b1cd67e3b264` | `scheme/da-spdm/test/corim/src/comid-da-bad-multiple-values.json` | Apache-2.0 | da-spdm CoMID/CoRIM JSON template |
| `corim/veraison-services/da-spdm/src/comid-da-bad-no-class-id.json` | veraison/services | `b1cd67e3b264` | `scheme/da-spdm/test/corim/src/comid-da-bad-no-class-id.json` | Apache-2.0 | da-spdm CoMID/CoRIM JSON template |
| `corim/veraison-services/da-spdm/src/comid-da-bad-no-class.json` | veraison/services | `b1cd67e3b264` | `scheme/da-spdm/test/corim/src/comid-da-bad-no-class.json` | Apache-2.0 | da-spdm CoMID/CoRIM JSON template |
| `corim/veraison-services/da-spdm/src/comid-da-bad-no-name.json` | veraison/services | `b1cd67e3b264` | `scheme/da-spdm/test/corim/src/comid-da-bad-no-name.json` | Apache-2.0 | da-spdm CoMID/CoRIM JSON template |
| `corim/veraison-services/da-spdm/src/comid-da-bad-no-value.json` | veraison/services | `b1cd67e3b264` | `scheme/da-spdm/test/corim/src/comid-da-bad-no-value.json` | Apache-2.0 | da-spdm CoMID/CoRIM JSON template |
| `corim/veraison-services/da-spdm/src/comid-da-ref.json` | veraison/services | `b1cd67e3b264` | `scheme/da-spdm/test/corim/src/comid-da-ref.json` | Apache-2.0 | da-spdm CoMID/CoRIM JSON template |
| `corim/veraison-services/da-spdm/src/corim-da.json` | veraison/services | `b1cd67e3b264` | `scheme/da-spdm/test/corim/src/corim-da.json` | Apache-2.0 | da-spdm CoMID/CoRIM JSON template |
| `corim/veraison-services/da-spdm/evidence/da-spdm-good.cbor` | veraison/services | `b1cd67e3b264` | `scheme/da-spdm/test/evidence/da-spdm-good.cbor` | Apache-2.0 | SPDM device attestation evidence (synthetic) |
| `corim/veraison-services/da-spdm/evidence/good.diag` | veraison/services | `b1cd67e3b264` | `scheme/da-spdm/test/evidence/src/good.diag` | Apache-2.0 | Diag source for da-spdm-good.cbor |
| `corim/corim-rs/good-corim.json` | veraison/corim-rs | `65ef90ed2059` | `testdata/good-corim.json` | MIT | CoRIM JSON (corim-rs) |
| `corim/corim-rs/meta.json` | veraison/corim-rs | `65ef90ed2059` | `testdata/meta.json` | MIT | CoRIM signer meta (JSON) |
| `corim/corim-rs/certs/root.cert.pem` | veraison/corim-rs | `65ef90ed2059` | `testdata/x509/certs/root.cert.pem` | MIT | Test X.509 cert (root.cert.pem) |
| `corim/corim-rs/certs/int.cert.pem` | veraison/corim-rs | `65ef90ed2059` | `testdata/x509/certs/int.cert.pem` | MIT | Test X.509 cert (int.cert.pem) |
| `corim/corim-rs/certs/leaf.cert.pem` | veraison/corim-rs | `65ef90ed2059` | `testdata/x509/certs/leaf.cert.pem` | MIT | Test X.509 cert (leaf.cert.pem) |
| `ear/c-ear/ear.jwt` | veraison/c-ear | `a928486cb6e8` | `example/data/ear.jwt` | Apache-2.0 | EAR as signed JWT (ES256) |
| `ear/c-ear/pkey.pem` | veraison/c-ear | `a928486cb6e8` | `example/data/pkey.pem` | Apache-2.0 | Public key verifying ear.jwt |
| `ear/veraison-ear/ear-claims-extension-ok.json` | veraison/ear | `9771e2b9fe95` | `arc/data/ear-claims-extension-ok.json` | Apache-2.0 | EAR claims set (JSON) (ear-claims-extension-ok.json) |
| `ear/veraison-ear/ear-claims-key-attestation-ko.json` | veraison/ear | `9771e2b9fe95` | `arc/data/ear-claims-key-attestation-ko.json` | Apache-2.0 | EAR claims set (JSON) (ear-claims-key-attestation-ko.json) |
| `ear/veraison-ear/ear-claims-key-attestation-ok.json` | veraison/ear | `9771e2b9fe95` | `arc/data/ear-claims-key-attestation-ok.json` | Apache-2.0 | EAR claims set (JSON) (ear-claims-key-attestation-ok.json) |
| `ear/veraison-ear/ear-claims-tv-ok.json` | veraison/ear | `9771e2b9fe95` | `arc/data/ear-claims-tv-ok.json` | Apache-2.0 | EAR claims set (JSON) (ear-claims-tv-ok.json) |
| `ear/veraison-ear/ear-claims.json` | veraison/ear | `9771e2b9fe95` | `arc/data/ear-claims.json` | Apache-2.0 | EAR claims set (JSON) (ear-claims.json) |
| `ear/veraison-ear/pkey.json` | veraison/ear | `9771e2b9fe95` | `arc/data/pkey.json` | Apache-2.0 | EAR verification public JWK |
| `ear/rust-ear/claims.json` | veraison/rust-ear | `5dfe47d4d81c` | `misc/claims.json` | Apache-2.0 | EAR claims set (JSON) |
| `ear/rust-ear/ec_key_pub.jwk` | veraison/rust-ear | `5dfe47d4d81c` | `misc/ec_key_pub.jwk` | Apache-2.0 | EAR verification public JWK |
| `ear/rust-ear/ec_key_pub.pem` | veraison/rust-ear | `5dfe47d4d81c` | `misc/ec_key_pub.pem` | Apache-2.0 | EAR verification public key (PEM) |
| `roots/amd/milan/ark.pem` | virtee/sev | `a966d06d9bf0` | `src/certs/snp/builtin/milan/ark.pem` | Apache-2.0 | AMD ARK (Milan), from KDS |
| `roots/amd/milan/ask.pem` | virtee/sev | `a966d06d9bf0` | `src/certs/snp/builtin/milan/ask.pem` | Apache-2.0 | AMD ASK (Milan), from KDS |
| `roots/amd/genoa/ark.pem` | virtee/sev | `a966d06d9bf0` | `src/certs/snp/builtin/genoa/ark.pem` | Apache-2.0 | AMD ARK (Genoa), from KDS |
| `roots/amd/genoa/ask.pem` | virtee/sev | `a966d06d9bf0` | `src/certs/snp/builtin/genoa/ask.pem` | Apache-2.0 | AMD ASK (Genoa), from KDS |
| `roots/amd/turin/ark.pem` | virtee/sev | `a966d06d9bf0` | `src/certs/snp/builtin/turin/ark.pem` | Apache-2.0 | AMD ARK (Turin), from KDS |
| `roots/amd/turin/ask.pem` | virtee/sev | `a966d06d9bf0` | `src/certs/snp/builtin/turin/ask.pem` | Apache-2.0 | AMD ASK (Turin), from KDS |
| `roots/amd/ask_ark_genoa_vlek.pem` | google/go-sev-guest | `9c5dffcd8230` | `verify/trust/ask_ark_genoa_vlek.pem` | Apache-2.0 | AMD ASVK+ARK chain for VLEK (Genoa) |
| `roots/amd/ask_ark_turin_vlek.pem` | google/go-sev-guest | `9c5dffcd8230` | `verify/trust/ask_ark_turin_vlek.pem` | Apache-2.0 | AMD ASVK+ARK chain for VLEK (Turin) |
| `roots/intel/trusted_root.pem` | google/go-tdx-guest | `b0a2dd8100a0` | `verify/trusted_root.pem` | Apache-2.0 | Intel SGX Root CA (PCK chain root for TDX) |
| `roots/intel/trusted_dice_root.pem` | google/go-tdx-guest | `b0a2dd8100a0` | `verify/dice/trusted_dice_root.pem` | Apache-2.0 | DCP DICE Global Root CA (DICE quote root) |
| `roots/aws/nitro.pem` | evervault/attestation-doc-validation | `a296a77c2b23` | `attestation-doc-validation/src/nitro.pem` | Apache-2.0 | AWS Nitro Enclaves Root-G1 (SHA-256 641A0321...BB5B) |
| `roots/nvidia/verifier_device_root.pem` | NVIDIA/nvtrust | `858ada9a17f5` | `guest_tools/gpu_verifiers/local_gpu_verifier/src/verifier/certs/verifier_device_root.pem` | Apache-2.0 (repo) / BSD-3-Clause (pkg metadata) | NVIDIA device identity root CA |
| `roots/nvidia/verifier_RIM_root.pem` | NVIDIA/nvtrust | `858ada9a17f5` | `guest_tools/gpu_verifiers/local_gpu_verifier/src/verifier/certs/verifier_RIM_root.pem` | Apache-2.0 (repo) / BSD-3-Clause (pkg metadata) | NVIDIA RIM signing root CA |
| `roots/gcp/gcp_ek_ak_ca_intermediate_v3.crt` | google/go-tpm-tools | `829ec3137784` | `server/ca-certs/gcp_ek_ak_ca_intermediate_v3.crt` | Apache-2.0 | Google Cloud EK/AK CA cert (gcp_ek_ak_ca_intermediate_v3.crt) |
| `roots/gcp/gcp_ek_ak_ca_root.crt` | google/go-tpm-tools | `829ec3137784` | `server/ca-certs/gcp_ek_ak_ca_root.crt` | Apache-2.0 | Google Cloud EK/AK CA cert (gcp_ek_ak_ca_root.crt) |
| `roots/gcp/tpm_ek_intermediate_2.crt` | google/go-tpm-tools | `829ec3137784` | `server/ca-certs/tpm_ek_intermediate_2.crt` | Apache-2.0 | Google Cloud EK/AK CA cert (tpm_ek_intermediate_2.crt) |
| `roots/gcp/tpm_ek_intermediate_3.crt` | google/go-tpm-tools | `829ec3137784` | `server/ca-certs/tpm_ek_intermediate_3.crt` | Apache-2.0 | Google Cloud EK/AK CA cert (tpm_ek_intermediate_3.crt) |

## Duplicates (not copied again)

- `google_go-sev-guest:verify/testdata/milan.testcer` is byte-identical to `snp/virtee-sev/cert_chain_milan`
- `veraison_ccatoken:realm/testvectors/tf-rmm/cca_token.cbor` is byte-identical to `cca/rust-ccatoken/cca-token-01.cbor`
- `veraison_ccatoken:platform/testvectors/cbor/v2/CcaPlatformClaimsV2InvalidExtensionCertificateChainDigest.diag` is byte-identical to `cca/rust-ccatoken/platform-2024/invalid-extension-certificate-chain-digest.diag`
- `veraison_ccatoken:platform/testvectors/cbor/v2/CcaPlatformClaimsV2InvalidExtensionVCADigest.diag` is byte-identical to `cca/rust-ccatoken/platform-2024/invalid-extension-vca-digest.diag`
- `veraison_ccatoken:platform/testvectors/cbor/v2/CcaPlatformClaimsV2InvalidMfgConfig.diag` is byte-identical to `cca/rust-ccatoken/platform-2024/invalid-manufacturing-config.diag`
- `veraison_ccatoken:platform/testvectors/cbor/v2/CcaPlatformClaimsV2InvalidTbbRotpkHashLength.diag` is byte-identical to `cca/rust-ccatoken/platform-2024/invalid-tbb-rotpk-hash-length.diag`
- `veraison_ccatoken:platform/testvectors/cbor/v2/CcaPlatformClaimsV2MissingClientID.diag` is byte-identical to `cca/rust-ccatoken/platform-2024/missing-client-id.diag`
- `veraison_ccatoken:platform/testvectors/cbor/v2/CcaPlatformClaimsV2MissingExtensionEncryptionType.diag` is byte-identical to `cca/rust-ccatoken/platform-2024/missing-extension-encryption-type.diag`
- `veraison_ccatoken:platform/testvectors/cbor/v2/CcaPlatformClaimsV2MissingExtensionVCADigest.diag` is byte-identical to `cca/rust-ccatoken/platform-2024/missing-extension-vca-digest.diag`
- `confidential-containers_trustee:deps/verifier/test_data/cca/misc/cpak-pub.json` is byte-identical to `cca/rust-ccatoken/cpak.json`
- `confidential-containers_trustee:deps/verifier/test_data/cca/conf/tastore.json` is byte-identical to `cca/rust-ccatoken/ta-tfa.json`
- `google_go-eventlog:testdata/legacydata/ubuntu_2104_shielded_vm_no_secure_boot_eventlog` is byte-identical to `tpm/go-eventlog/ubuntu-2104-no-secure-boot.bin`
- `google_go-tdx-guest:testing/testdata/ccel/ccel_data.dat` is byte-identical to `tdx/go-eventlog-ccel/cos-113-intel-tdx.bin`
- `google_go-tdx-guest:testing/testdata/ccel/ccel_table.dat` is byte-identical to `tdx/go-eventlog-ccel/cos-113-intel-tdx.table.bin`
- `confidential-containers_trustee:deps/verifier/test_data/nvidia/hopperAttestationReport.txt` is byte-identical to `nvidia/nvtrust/hopperAttestationReport.txt`
- `confidential-containers_trustee:deps/verifier/test_data/nvidia/hopper_cert_chain_case1.txt` is byte-identical to `nvidia/nvtrust/hopperCertChain.txt`
- `veraison_corim:coev/testcases/ce-coswid.cbor` is byte-identical to `coswid/veraison-corim/ce-coswid.cbor`
- `veraison_corim:coev/testcases/src/ce-coswid.diag` is byte-identical to `coswid/veraison-corim/ce-coswid.diag`
- `google_go-sev-guest:verify/trust/ask_ark_milan_vlek.pem` is byte-identical to `snp/go-sev-guest/milanvlek.testcer`

## Skipped

| Source | Item | Reason |
|---|---|---|
| virtee/nitro-enclaves | `tests/test_data/hello.eif` | 15.4 MB (> 5 MB); an enclave image, not an attestation document. |
| virtee/tdx | `tests/data/OVMF.inteltdx.fd` | 2 MB firmware image; measurement input, not evidence. |
| virtee/sev-snp-measure | `tests/fixtures/*` (OVMF/SVSM images, up to 3.6 MB) | Launch-measurement inputs, outside the library's offline appraisal scope. |
| virtee/tdx-measure | `tests/fixtures/*` (ACPI tables, expected RTMRs) | Reference-value generation inputs, outside scope. |
| virtee/sev | `tests/naples`, `tests/rome`, `src/certs/sev/builtin/*` | Legacy SEV (pre-SNP) certificate formats. |
| virtee/sev | `tests/measurement/*` | ID/auth block test material with private test keys. |
| virtee/snpguest, snphost, cca | (none) | No test data in the repository. |
| google/go-sev-guest | `testing/data/keys/*` | Synthetic private keys for fake reports. |
| google/go-tpm-tools | `internal/test/eventlogs/*` | Same files as google/go-eventlog (copied from there). |
| google/go-tpm-tools, go-eventlog | `secure-boot/*`, `wellknown/*` | Well-known UEFI certificates and dbx updates, not attestation fixtures. |
| confidential-containers/trustee | `csv_evidence.json`, `occlum_quote.dat` | Hygon CSV and SGX: out of scope. |
| confidential-containers/trustee | `cca/misc/*-priv.json`, `kbs/test_data/jwk/*` | Private test keys or KBS-specific. |
| veraison/ccatoken, rust-ccatoken, corim, rust-ear, ear, corim-rs, services | `*.key`, private JWKs and PEMs (`cca_platform.pem`, `ec256.json`, `ec384.json`, `ec-p256.jwk`, `skey.*`, `ec_key.*`) | Private signing keys; only public halves were copied. |
| veraison/ccatoken | `*/testvectors/json/*` | JSON claim fixtures for Go APIs (the CBOR/diag vectors were copied). |
| veraison/psatoken | all | PSA is not a target platform. |
| veraison/swid | all | CoSWID vectors exist only inside Go test source. |
| veraison/eat | RFC 9711 examples | EAT is not a target format (EAR is). |
| veraison/python-ear | `src/example/jwt_output.json` | No LICENSE file in the repository (license unclear). |
| veraison/corim | `coserv/testvectors/*` | CoSERV is not in scope. |
| ietf-rats-wg/draft-ietf-rats-corim | `cddl/examples/*` | License unclear (`LICENSE.md` only points to IETF contribution guidelines). |
| sacmwg/draft-ietf-sacm-coswid | (none) | CDDL only, no example tags. |
| Azure/confidential-computing-cvm-guest-attestation | `sampleAttestationToken.json`, `*.zip`, `*.mp4` | No HCL report samples: an MAA token, binaries and a video (> 5 MB). |
| Azure/azure-cvm-tooling | (repo not found) | Lives at kinvolk/azure-cvm-tooling, which was used instead. |
| aws/aws-nitro-enclaves-nsm-api, aws-nitro-enclaves-sdk-c | (none) | No sample attestation documents. |
| hf/nitrite | (none) | No test data at HEAD; the blocky/nitrite fork was used. |
| blocky/nitrite | `selfsigned_attestation.b64`, `AWS_NitroEnclaves_Root-G1.zip` | Synthetic self-signed document; the root is already in roots/aws. |
| evervault/attestation-doc-validation | `*cert-containing-attestation-doc*` | Evervault-specific TLS certificates with an embedded document. |
| NVIDIA/nvtrust | 24 other `*_PROD.swidtag`, attestation_sdk policies and claims, NVSwitch root copies | Two representative production RIMs were kept; the rest are redundant. |
