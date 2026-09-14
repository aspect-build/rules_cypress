#!/usr/bin/env bash
# Print the versions.bzl entry for a cypress release (default: latest on npm).
set -o errexit -o nounset -o pipefail

version="${1:-$(curl --fail --silent https://registry.npmjs.org/cypress/latest | jq --raw-output .version)}"

seen=""
echo "    \"$version\": {"
for platform in darwin-x64 darwin-arm64 linux-x64 linux-arm64; do
	url="https://cdn.cypress.io/desktop/$version/$platform/cypress.zip"
	sha256=$(curl --fail --silent --location "$url" | shasum -a 256 | cut -d ' ' -f 1)
	case "$seen" in
	*"$sha256"*)
		echo "error: $platform hash matches another platform; download of $url is suspect" >&2
		exit 1
		;;
	esac
	seen="$seen $sha256"
	echo "        \"$platform\": \"$sha256\","
done
echo "    },"
