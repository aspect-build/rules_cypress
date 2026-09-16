#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

# Set by GH actions, see
# https://docs.github.com/en/actions/learn-github-actions/environment-variables#default-environment-variables
TAG=${GITHUB_REF_NAME}
# The prefix is chosen to match what GitHub generates for source archives
PREFIX="rules_cypress-${TAG:1}"
ARCHIVE="rules_cypress-$TAG.tar.gz"
git archive --format=tar --prefix=${PREFIX}/ ${TAG} | gzip >$ARCHIVE

cat <<EOF
## Using [Bzlmod]:

Add to your \`MODULE.bazel\` file:

\`\`\`starlark
bazel_dep(name = "aspect_rules_cypress", version = "${TAG:1}", dev_dependency = True)

cypress = use_extension("@aspect_rules_cypress//cypress:extensions.bzl", "cypress", dev_dependency = True)
cypress.toolchain(cypress_version = "16.0.0")
use_repo(cypress, "cypress_toolchains")

register_toolchains("@cypress_toolchains//:all")
\`\`\`

Requires Bazel 8.5+ and rules_js 3.x. See the [README](https://github.com/aspect-build/rules_cypress#readme) for usage.

[Bzlmod]: https://bazel.build/build/bzlmod
EOF
