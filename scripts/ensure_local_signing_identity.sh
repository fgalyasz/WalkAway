#!/usr/bin/env bash
set -euo pipefail

LOCAL_SIGNING_IDENTITY_NAME="WalkAway Local"
LOCAL_SIGNING_KEYCHAIN_PATH="${HOME}/Library/Keychains/walkaway-signing.keychain-db"
LOCAL_SIGNING_KEYCHAIN_PASSWORD="walkaway-local-signing"
PKCS12_EXPORT_PASSWORD="walkaway-p12-export"
SYSTEM_OPENSSL="/usr/bin/openssl"

identity_is_present() {
  if [[ ! -f "${LOCAL_SIGNING_KEYCHAIN_PATH}" ]]; then
    return 1
  fi
  security find-identity -v -p codesigning "${LOCAL_SIGNING_KEYCHAIN_PATH}" 2>/dev/null \
    | grep -F "\"${LOCAL_SIGNING_IDENTITY_NAME}\"" >/dev/null
}

create_keychain_if_needed() {
  if [[ -f "${LOCAL_SIGNING_KEYCHAIN_PATH}" ]]; then
    return 0
  fi
  security create-keychain -p "${LOCAL_SIGNING_KEYCHAIN_PASSWORD}" "${LOCAL_SIGNING_KEYCHAIN_PATH}"
  security set-keychain-settings -lut 21600 "${LOCAL_SIGNING_KEYCHAIN_PATH}"
}

unlock_signing_keychain() {
  security unlock-keychain -p "${LOCAL_SIGNING_KEYCHAIN_PASSWORD}" "${LOCAL_SIGNING_KEYCHAIN_PATH}"
}

keychain_search_list() {
  security list-keychains -d user | sed 's/^[[:space:]]*"//; s/"$//'
}

is_signing_keychain_on_search_list() {
  keychain_search_list | grep -F -x "${LOCAL_SIGNING_KEYCHAIN_PATH}" >/dev/null
}

add_signing_keychain_to_search_list() {
  if is_signing_keychain_on_search_list; then
    return 0
  fi
  local -a chains=()
  while IFS= read -r line; do
    [[ -n "${line}" ]] && chains+=("${line}")
  done < <(keychain_search_list)
  security list-keychains -d user -s "${LOCAL_SIGNING_KEYCHAIN_PATH}" "${chains[@]}"
}

write_openssl_config() {
  cat > "$1" <<'EOF'
[ req ]
default_bits = 2048
prompt = no
distinguished_name = dn
x509_extensions = codesign_ext

[ dn ]
CN = WalkAway Local

[ codesign_ext ]
basicConstraints = critical,CA:FALSE
keyUsage = critical,digitalSignature
extendedKeyUsage = critical,codeSigning
EOF
}

export_pkcs12() {
  local work_dir="$1"
  "${SYSTEM_OPENSSL}" pkcs12 -export \
    -inkey "${work_dir}/key.pem" \
    -in "${work_dir}/cert.pem" \
    -out "${work_dir}/identity.p12" \
    -passout "pass:${PKCS12_EXPORT_PASSWORD}" \
    -name "${LOCAL_SIGNING_IDENTITY_NAME}"
}

import_pkcs12() {
  security import "$1" \
    -k "${LOCAL_SIGNING_KEYCHAIN_PATH}" \
    -P "${PKCS12_EXPORT_PASSWORD}" \
    -T /usr/bin/codesign \
    -T /usr/bin/security
  security set-key-partition-list \
    -S apple-tool:,apple:,codesign: \
    -s \
    -k "${LOCAL_SIGNING_KEYCHAIN_PASSWORD}" \
    "${LOCAL_SIGNING_KEYCHAIN_PATH}" >/dev/null
}

make_self_signed_cert() {
  local work_dir="$1"
  "${SYSTEM_OPENSSL}" req -new -x509 -days 3650 -nodes \
    -config "${work_dir}/codesign.cnf" \
    -keyout "${work_dir}/key.pem" \
    -out "${work_dir}/cert.pem"
}

trust_codesign_certificate() {
  security add-trusted-cert -r trustRoot -p codeSign \
    -k "${LOCAL_SIGNING_KEYCHAIN_PATH}" \
    "$1"
}

create_codesign_certificate() {
  local work_dir
  work_dir="$(mktemp -d)"
  write_openssl_config "${work_dir}/codesign.cnf"
  make_self_signed_cert "${work_dir}"
  export_pkcs12 "${work_dir}"
  import_pkcs12 "${work_dir}/identity.p12"
  trust_codesign_certificate "${work_dir}/cert.pem"
  rm -rf "${work_dir}"
}

create_codesign_certificate_if_needed() {
  if identity_is_present; then
    return 0
  fi
  create_codesign_certificate
  if identity_is_present; then
    return 0
  fi
  echo "ERROR: Failed to create signing identity ${LOCAL_SIGNING_IDENTITY_NAME}" >&2
  exit 1
}

ensure_local_signing_identity() {
  create_keychain_if_needed
  unlock_signing_keychain
  add_signing_keychain_to_search_list
  create_codesign_certificate_if_needed
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  ensure_local_signing_identity
  echo "[local_signing] identity=${LOCAL_SIGNING_IDENTITY_NAME}"
  echo "[local_signing] keychain=${LOCAL_SIGNING_KEYCHAIN_PATH}"
fi
