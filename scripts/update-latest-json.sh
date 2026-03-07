#!/usr/bin/env bash
set -euo pipefail

REPO="${GITHUB_REPOSITORY:-ProjectYaru/Yaru-release}"
API_URL="https://api.github.com/repos/${REPO}/releases/latest"

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required but not installed." >&2
  exit 1
fi

response="$(curl -fsSL "${API_URL}")"

if [[ "$(jq -r '.message // empty' <<<"${response}")" == "Not Found" ]]; then
  echo "Latest release not found for ${REPO}" >&2
  exit 1
fi

tag="$(jq -r '.tag_name' <<<"${response}")"
published_at="$(jq -r '.published_at' <<<"${response}")"
release_html_url="$(jq -r '.html_url // empty' <<<"${response}")"

if [[ -z "${tag}" || "${tag}" == "null" ]]; then
  echo "Invalid release tag from API response." >&2
  exit 1
fi

build_number="$(grep -oE '[0-9]+' <<<"${tag}" | tail -n 1 || true)"
if [[ -z "${build_number}" ]]; then
  build_number="0"
fi

pick_asset() {
  local pattern
  local asset

  for pattern in "$@"; do
    asset="$(jq -rc --arg pattern "${pattern}" '
      [
        .assets[]
        | select(
            ((.name // "") | ascii_downcase) as $name
            | ($name | test($pattern))
          )
      ][0] // empty
    ' <<<"${response}")"

    if [[ -n "${asset}" && "${asset}" != "null" ]]; then
      printf '%s' "${asset}"
      return 0
    fi
  done

  return 1
}

windows_asset="$(pick_asset '(^|[^a-z])windows([^a-z]|$)' '\.(exe|msix)$' || true)"
android_asset="$(pick_asset '(^|[^a-z])android([^a-z]|$)' '\.apk$' || true)"
linux_asset="$(pick_asset '(^|[^a-z])linux([^a-z]|$)' '\.(appimage|tar|tar\.gz|deb|rpm)$' || true)"

win_name="$(jq -r '.name // empty' <<<"${windows_asset}")"
win_url="$(jq -r '.browser_download_url // empty' <<<"${windows_asset}")"
win_sha="$(jq -r '(.digest // "") | sub("^sha256:"; "")' <<<"${windows_asset}")"
win_size="$(jq -r '.size // empty' <<<"${windows_asset}")"

android_name="$(jq -r '.name // empty' <<<"${android_asset}")"
android_url="$(jq -r '.browser_download_url // empty' <<<"${android_asset}")"
android_sha="$(jq -r '(.digest // "") | sub("^sha256:"; "")' <<<"${android_asset}")"
android_size="$(jq -r '.size // empty' <<<"${android_asset}")"

linux_name="$(jq -r '.name // empty' <<<"${linux_asset}")"
linux_url="$(jq -r '.browser_download_url // empty' <<<"${linux_asset}")"
linux_sha="$(jq -r '(.digest // "") | sub("^sha256:"; "")' <<<"${linux_asset}")"
linux_size="$(jq -r '.size // empty' <<<"${linux_asset}")"

if [[ -z "${win_url}" || -z "${android_url}" || -z "${linux_url}" ]]; then
  echo "One or more required assets were not found in latest release." >&2
  echo "Available assets:" >&2
  jq -r '.assets[]?.name' <<<"${response}" >&2
  exit 1
fi

echo "Matched assets:"
echo "  windows: ${win_name}"
echo "  android: ${android_name}"
echo "  linux:   ${linux_name}"

tmp_file="$(mktemp)"

jq \
  --arg version "${tag}" \
  --argjson build_number "${build_number}" \
  --arg release_date "${published_at}" \
  --arg win_url "${win_url}" \
  --arg win_sha "${win_sha}" \
  --argjson win_size "${win_size}" \
  --arg android_url "${android_url}" \
  --arg android_sha "${android_sha}" \
  --argjson android_size "${android_size}" \
  --arg linux_url "${linux_url}" \
  --arg linux_sha "${linux_sha}" \
  --argjson linux_size "${linux_size}" \
  --arg notes_url "${release_html_url:-https://github.com/${REPO}/releases/tag/${tag}}" \
  '
  .version = $version |
  .build_number = $build_number |
  .release_date = $release_date |
  .platforms.windows.installer_url = $win_url |
  .platforms.windows.installer_sha256 = $win_sha |
  .platforms.windows.installer_size = $win_size |
  .platforms.android.installer_url = $android_url |
  .platforms.android.installer_sha256 = $android_sha |
  .platforms.android.installer_size = $android_size |
  .platforms.linux.portable_url = $linux_url |
  .platforms.linux.portable_sha256 = $linux_sha |
  .platforms.linux.portable_size = $linux_size |
  .release_notes_url = $notes_url
  ' latest.json > "${tmp_file}"

mv "${tmp_file}" latest.json

echo "Updated latest.json to ${tag}"
