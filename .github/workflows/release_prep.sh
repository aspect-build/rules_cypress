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
\`\`\`

[Bzlmod]: https://bazel.build/build/bzlmod
EOF
