#!/usr/bin/env bash
# Produce a dictionary for the current cypress release,
# suitable for appending to cypress/private/versions.bzl
set -o errexit -o nounset
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
CYPRESS_VERSION_ARG="${1:-latest}"

version="${1:-$(curl --silent "https://registry.npmjs.org/cypress/$CYPRESS_VERSION_ARG" | jq --raw-output ".version")}"

echo "    \"$version\": {"
for pkg in darwin-{x,arm}64 linux-{x,arm}64 win32-x64; do
	sha256=($(curl -sL "https://cdn.cypress.io/desktop/${version}/${pkg}/cypress.zip" | shasum -a 256))
	echo "        \"$pkg\": \"$sha256\","
done
echo "    },"
echo
echo "Now paste the code block above into /cypress/private/versions.bzl"
