#!/usr/bin/env bash
# bump-formula.sh — bump a Homebrew formula to a new upstream release.
#
# Usage: scripts/bump-formula.sh <formula-file> <new-version>
#
# Generic: works for any formula whose upstream GitHub repo publishes a
# release tagged vX.Y.Z with a checksums.txt asset in `sha256sum` format
# covering every file the formula's `url`s reference. If a URL's basename is
# missing from checksums.txt, the asset is downloaded and hashed directly
# (fallback for repos that haven't adopted the contract yet — see README).
#
# The script derives everything from the formula file itself:
#   - current version: first semver in the first `url` line
#   - upstream repo:   the `homepage` line (github.com/<owner>/<repo>)

set -euo pipefail

if [[ "$#" -ne 2 ]]
then
  echo "usage: $0 <formula-file> <new-version>" >&2
  exit 64
fi

formula_file="$1"
new_version="${2#v}"

[[ -f "${formula_file}" ]] || {
  echo "error: no such file: ${formula_file}" >&2
  exit 66
}

sha256_of() {
  if command -v sha256sum >/dev/null 2>&1
  then
    sha256sum "$1" | awk '{print $1}'
  else
    shasum -a 256 "$1" | awk '{print $1}'
  fi
}

first_url_line=$(grep -m1 -E '^[[:space:]]*url "' "${formula_file}") ||
  {
    echo "error: no url line found in ${formula_file}" >&2
    exit 65
  }

current_version=$(echo "${first_url_line}" | grep -oE 'v?[0-9]+\.[0-9]+\.[0-9]+' | head -1)
current_version="${current_version#v}"
[[ -n "${current_version}" ]] || {
  echo "error: could not parse version from: ${first_url_line}" >&2
  exit 65
}

if [[ "${current_version}" = "${new_version}" ]]
then
  echo "${formula_file} is already at ${new_version} — nothing to do."
  exit 0
fi

repo=$(grep -m1 -E 'homepage "https://github\.com/' "${formula_file}" |
  sed -E 's|.*github\.com/([^"/]+/[^"/]+).*|\1|')
[[ -n "${repo}" ]] || {
  echo "error: could not parse github repo from homepage in ${formula_file}" >&2
  exit 65
}

echo "bumping ${formula_file}: ${current_version} -> ${new_version} (repo: ${repo})"

# checksums.txt is allowed to be missing/incomplete; misses fall back to
# downloading and hashing the asset directly.
checksums=$(curl -fsSL "https://github.com/${repo}/releases/download/v${new_version}/checksums.txt" 2>/dev/null || true)

lookup_sha() {
  # $1: asset basename; sha256sum format is "<sha>  <filename>" (or " *<file>")
  awk -v f="$1" '$2 == f { print $1; exit }' <<<"${checksums}"
}

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

# Line numbers never shift: every edit is a same-line replacement.
while read -r url_lineno
do
  old_url=$(sed -n "${url_lineno}s/.*url \"\(.*\)\".*/\1/p" "${formula_file}")
  new_url=${old_url//${current_version}/${new_version}}
  [[ "${new_url}" != "${old_url}" ]] || {
    echo "error: version ${current_version} not found in ${old_url}" >&2
    exit 65
  }

  filename=${new_url##*/}
  sha=$(lookup_sha "${filename}")
  if [[ -z "${sha}" ]]
  then
    echo "  ${filename}: not in checksums.txt, downloading to hash"
    curl -fsSL "${new_url}" -o "${tmpdir}/asset" || {
      echo "error: download failed: ${new_url}" >&2
      exit 65
    }
    sha=$(sha256_of "${tmpdir}/asset")
    rm -f "${tmpdir}/asset"
  else
    echo "  ${filename}: sha256 from checksums.txt"
  fi
  [[ -n "${sha}" ]] || {
    echo "error: could not determine sha256 for ${new_url}" >&2
    exit 65
  }

  # The sha256 line paired with this url: the next sha256 line below it,
  # which must come before the next url line.
  sha_lineno=$(awk -v start="${url_lineno}" 'NR > start && /sha256 "/ { print NR; exit }' "${formula_file}")
  [[ -n "${sha_lineno}" ]] || {
    echo "error: no sha256 line after url at line ${url_lineno}" >&2
    exit 65
  }
  next_url_lineno=$(awk -v start="${url_lineno}" 'NR > start && /url "/ { print NR; exit }' "${formula_file}")
  if [[ -n "${next_url_lineno}" ]] && [[ "${sha_lineno}" -gt "${next_url_lineno}" ]]
  then
    echo "error: url at line ${url_lineno} has no paired sha256 line" >&2
    exit 65
  fi

  sed -i.bak "${url_lineno}s|url \".*\"|url \"${new_url}\"|" "${formula_file}"
  sed -i.bak "${sha_lineno}s|sha256 \".*\"|sha256 \"${sha}\"|" "${formula_file}"
done < <(grep -n -E '^[[:space:]]*url "' "${formula_file}" | cut -d: -f1)
rm -f "${formula_file}.bak"

echo "done: ${formula_file} bumped to ${new_version}"
