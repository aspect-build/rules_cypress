version=$1

echo "cypress_register_toolchains(
    name = \"cypress\",
    cypress_version = \"10.8.0\",
    platform_to_integrity_hash = {"

for pkg in darwin-x64 darwin-arm64 linux-x64 linux-arm64; do
    sha256=($(curl -sL "https://cdn.cypress.io/desktop/${version}/${pkg}/cypress.zip" | shasum -a 256))
    echo "        \"$pkg\": \"$sha256\","
done

echo "    }
)"