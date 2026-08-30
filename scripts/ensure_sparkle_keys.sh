#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=scripts/sparkle_bundle.sh
source "${ROOT}/scripts/sparkle_bundle.sh"
SPARKLE_BIN="$(find_sparkle_bin "${ROOT}")"
PUBLIC_KEY_FILE="${ROOT}/scripts/sparkle_public_ed_key.txt"
KEY_FILE="${SPARKLE_ED_KEY_FILE:-${HOME}/.config/walkaway/sparkle_eddsa}"
ACCOUNT="${SPARKLE_ACCOUNT:-walkaway}"

if [[ -f "${PUBLIC_KEY_FILE}" && -s "${PUBLIC_KEY_FILE}" ]]; then
  echo "Public key present: ${PUBLIC_KEY_FILE}"
  exit 0
fi

mkdir -p "$(dirname "${KEY_FILE}")"
if [[ -f "${KEY_FILE}" ]]; then
  "${SPARKLE_BIN}/generate_keys" --account "${ACCOUNT}" -f "${KEY_FILE}"
else
  "${SPARKLE_BIN}/generate_keys" --account "${ACCOUNT}"
  "${SPARKLE_BIN}/generate_keys" --account "${ACCOUNT}" -x "${KEY_FILE}"
fi
"${SPARKLE_BIN}/generate_keys" --account "${ACCOUNT}" -p | tr -d ' \t\n\r' > "${PUBLIC_KEY_FILE}"
if [[ ! -s "${PUBLIC_KEY_FILE}" ]]; then
  echo "ERROR: failed to write Sparkle public key" >&2
  exit 1
fi
echo "Wrote ${PUBLIC_KEY_FILE}"
