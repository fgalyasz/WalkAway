#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
COMPANY_ROOT="${TENPRINT_ROOT:-$(cd "${ROOT}/../TenPrintSoftware" && pwd)}"
DEST="${COMPANY_ROOT}/public/downloads/walkaway"
DOWNLOADS="${ROOT}/docs/downloads"

mkdir -p "${DEST}"
if [[ -f "${ROOT}/docs/appcast.xml" ]]; then
  cp -f "${ROOT}/docs/appcast.xml" "${DEST}/appcast.xml"
fi
shopt -s nullglob
for artifact in "${DOWNLOADS}"/WalkAway-*.zip "${DOWNLOADS}"/WalkAway-*.dmg; do
  cp -f "${artifact}" "${DEST}/"
done

if [[ ! -f "${COMPANY_ROOT}/package.json" ]]; then
  echo "WARN: company site not found at ${COMPANY_ROOT}; skip tenprintsoftware.com" >&2
  exit 0
fi

(
  cd "${COMPANY_ROOT}"
  npm run sync:versions
  npm run build
  npm run deploy
)
echo "OK: company site synced and deployed"
