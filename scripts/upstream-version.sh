#!/usr/bin/env bash
set -euo pipefail

# Derive the CRS version pinned in the Containerfile, e.g. "4.30.0" from
# "FROM ghcr.io/coreruleset/modsecurity-crs:4.30.0-apache-...@sha256:..."
repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
containerfile="${repo}/Containerfile"

if [ ! -f "${containerfile}" ]; then
  echo "error: ${containerfile} not found (run from a modsecurity-docker checkout)" >&2
  exit 1
fi

if ! version="$(grep -Eom1 'ghcr\.io/coreruleset/modsecurity-crs:[0-9]+\.[0-9]+\.[0-9]+' "${containerfile}" \
  | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+')"; then
  echo "error: no ghcr.io/coreruleset/modsecurity-crs:<x.y.z> FROM line found in Containerfile" >&2
  exit 1
fi

if ! printf '%s' "${version}" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$'; then
  echo "error: derived version '${version}' does not match X.Y.Z" >&2
  exit 1
fi

printf '%s\n' "${version}"
