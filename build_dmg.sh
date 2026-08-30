#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
package_name="WalkAway"
executable_name="WalkAway"
bundle_id="com.tenprintsoftware.WalkAway"
bump_level=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --major) bump_level="major"; shift ;;
    --minor) bump_level="minor"; shift ;;
    --patch) bump_level="patch"; shift ;;
    --help|-h)
      echo "Usage: $(basename "$0") [--major|--minor|--patch]"
      echo "  With no bump flag, builds the VERSION file as-is."
      exit 0
      ;;
    *) echo "ERROR: Unknown option: $1" >&2; exit 1 ;;
  esac
done

version_file="${project_root}/VERSION"
current_version="$(tr -d ' \t\n\r' < "${version_file}")"
if [[ ! "${current_version}" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
  echo "ERROR: VERSION must be MAJOR.MINOR.PATCH, got: ${current_version}" >&2
  exit 1
fi

major="${BASH_REMATCH[1]}"
minor="${BASH_REMATCH[2]}"
patch="${BASH_REMATCH[3]}"
case "${bump_level}" in
  major) major=$((major + 1)); minor=0; patch=0 ;;
  minor) minor=$((minor + 1)); patch=0 ;;
  patch) patch=$((patch + 1)) ;;
esac
app_version="${major}.${minor}.${patch}"
echo "${app_version}" > "${version_file}"
printf '%s' "${app_version}" > "${project_root}/docs/version.txt"
echo "[build_dmg] Version ${current_version} -> ${app_version}" >&2

build_number="$(git -C "${project_root}" rev-list --count HEAD 2>/dev/null || echo 1)"
build_dir="${project_root}/.build"
dist_dir="${project_root}/dist"
staging_dir="${dist_dir}/staging"
dmg_path="${dist_dir}/${package_name}-${app_version}.dmg"
app_name="${package_name}.app"
app_dir="${staging_dir}/${app_name}"
contents_dir="${app_dir}/Contents"
macos_dir="${contents_dir}/MacOS"
resources_dir="${contents_dir}/Resources"

rm -rf "${staging_dir}"
mkdir -p "${macos_dir}" "${resources_dir}"
swift build -c release --package-path "${project_root}"
binary_path="${build_dir}/release/${executable_name}"
cp "${binary_path}" "${macos_dir}/${executable_name}"
chmod +x "${macos_dir}/${executable_name}"
cp "${version_file}" "${resources_dir}/VERSION"
if [[ -f "${project_root}/Assets/AppIcon.icns" ]]; then
  cp "${project_root}/Assets/AppIcon.icns" "${resources_dir}/AppIcon.icns"
fi

cat > "${contents_dir}/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleDevelopmentRegion</key>
  <string>en</string>
  <key>CFBundleExecutable</key>
  <string>${executable_name}</string>
  <key>CFBundleIconFile</key>
  <string>AppIcon</string>
  <key>CFBundleIdentifier</key>
  <string>${bundle_id}</string>
  <key>CFBundleInfoDictionaryVersion</key>
  <string>6.0</string>
  <key>CFBundleName</key>
  <string>${package_name}</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>CFBundleShortVersionString</key>
  <string>${app_version}</string>
  <key>CFBundleVersion</key>
  <string>${build_number}</string>
  <key>LSMinimumSystemVersion</key>
  <string>13.0</string>
  <key>LSUIElement</key>
  <true/>
  <key>NSHighResolutionCapable</key>
  <true/>
  <key>NSSupportsAutomaticTermination</key>
  <false/>
  <key>NSSupportsSuddenTermination</key>
  <false/>
  <key>NSBluetoothAlwaysUsageDescription</key>
  <string>WalkAway uses Bluetooth to measure the signal of your Apple Watch or iPhone so it can lock the screen when you walk away.</string>
  <key>NSBluetoothPeripheralUsageDescription</key>
  <string>WalkAway uses Bluetooth to measure the signal of your Apple Watch or iPhone so it can lock the screen when you walk away.</string>
  <key>NSAppleEventsUsageDescription</key>
  <string>WalkAway locks the screen through System Events. It does not sleep the Mac.</string>
</dict>
</plist>
EOF
echo -n "APPL????" > "${contents_dir}/PkgInfo"

# shellcheck source=scripts/ensure_local_signing_identity.sh
source "${project_root}/scripts/ensure_local_signing_identity.sh"
ensure_local_signing_identity
codesign --force --deep \
  --sign "${LOCAL_SIGNING_IDENTITY_NAME}" \
  --keychain "${LOCAL_SIGNING_KEYCHAIN_PATH}" \
  "${app_dir}"

ln -s "/Applications" "${staging_dir}/Applications"
rm -f "${dmg_path}"
tmp_rw_dmg="${dist_dir}/${package_name}.rw.dmg"
disk_device=""
cleanup() {
  if [[ -n "${disk_device}" ]]; then
    hdiutil detach "${disk_device}" -quiet >/dev/null 2>&1 || true
  fi
  rm -f "${tmp_rw_dmg}" >/dev/null 2>&1 || true
}
trap cleanup EXIT
hdiutil create -volname "${package_name}" -srcfolder "${staging_dir}" -ov -format UDRW "${tmp_rw_dmg}" >/dev/null
attach_output="$(hdiutil attach -readwrite -noverify -noautoopen "${tmp_rw_dmg}")"
disk_device="$(echo "${attach_output}" | awk '/^\/dev\// {print $1; exit}')"
mount_point="$(echo "${attach_output}" | awk 'BEGIN{mp=""} /\/Volumes\// {mp=$NF} END{print mp}')"
osascript <<EOF
tell application "Finder"
  tell disk "${package_name}"
    open
    set current view of container window to icon view
    set toolbar visible of container window to false
    set statusbar visible of container window to false
    set bounds of container window to {200, 200, 940, 640}
    set viewOptions to icon view options of container window
    set arrangement of viewOptions to not arranged
    set icon size of viewOptions to 96
    try
      set position of item "${app_name}" of container window to {180, 160}
    end try
    try
      set position of item "Applications" of container window to {540, 160}
    end try
    close
    open
    update without registering applications
    delay 1
  end tell
end tell
EOF
sync
hdiutil detach "${disk_device}" -quiet
disk_device=""
hdiutil convert "${tmp_rw_dmg}" -format UDZO -ov -o "${dmg_path}" >/dev/null
rm -f "${tmp_rw_dmg}"

downloads_dir="${project_root}/docs/downloads"
mkdir -p "${downloads_dir}"
cp -f "${dmg_path}" "${downloads_dir}/$(basename "${dmg_path}")"
echo "OK: DMG created at ${dmg_path}"
