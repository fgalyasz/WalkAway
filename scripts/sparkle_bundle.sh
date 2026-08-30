#!/usr/bin/env bash
set -euo pipefail

find_sparkle_framework() {
  local search_root="$1"
  local found
  found="$(find -L "${search_root}" -name 'Sparkle.framework' -type d | awk 'length < min || NR==1 { min=length; best=$0 } END { print best }')"
  if [[ -z "${found}" ]]; then
    echo "ERROR: Sparkle.framework not found under ${search_root}" >&2
    return 1
  fi
  printf '%s\n' "${found}"
}

find_sparkle_bin() {
  local project_root="$1"
  if [[ -n "${SPARKLE_BIN:-}" && -x "${SPARKLE_BIN}/sign_update" ]]; then
    printf '%s\n' "${SPARKLE_BIN}"
    return 0
  fi
  local found
  found="$(find "${project_root}/.build" -path '*/artifacts/*/Sparkle/bin/sign_update' -type f 2>/dev/null | head -n 1)"
  if [[ -n "${found}" ]]; then
    dirname "${found}"
    return 0
  fi
  echo "ERROR: Sparkle sign_update not found. Set SPARKLE_BIN." >&2
  return 1
}

embed_sparkle_framework() {
  local framework_src="$1"
  local app_dir="$2"
  local executable_path="$3"
  local frameworks_dir="${app_dir}/Contents/Frameworks"
  mkdir -p "${frameworks_dir}"
  rm -rf "${frameworks_dir}/Sparkle.framework"
  ditto "${framework_src}" "${frameworks_dir}/Sparkle.framework"
  if otool -l "${executable_path}" | grep -q '@executable_path/../Frameworks'; then
    return 0
  fi
  install_name_tool -add_rpath '@executable_path/../Frameworks' "${executable_path}"
}
