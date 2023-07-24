"""Declare runtime dependencies

These are needed for local dev, and users must install them as well.
See https://docs.bazel.build/versions/main/skylark/deploying.html#dependencies
"""

load("//cypress/private:toolchains_repo.bzl", "PLATFORMS", "toolchains_repo")
load("//cypress/private:versions.bzl", "TOOL_VERSIONS")

LATEST_CYPRESS_VERSION = TOOL_VERSIONS.keys()[0]

########
# Remaining content of the file is only used to support toolchains.
########
_DOC = "Fetch external tools needed for cypress toolchain"
_ATTRS = {
    "version": attr.string(mandatory = True),
    "platform": attr.string(mandatory = True, values = PLATFORMS.keys()),
    "sha256": attr.string(),
}

def _cypress_repo_impl(repository_ctx):
    url = "https://cdn.cypress.io/desktop/{0}/{1}/cypress.zip".format(
        repository_ctx.attr.version,
        repository_ctx.attr.platform,
    )

    repository_ctx.download_and_extract(
        url = url,
        sha256 = repository_ctx.attr.sha256,
    )
    binary_state_json_contents = '{"verified": true}'
    repository_ctx.file("binary_state_temp.json", binary_state_json_contents)

    # Base BUILD file for this repository
    repository_ctx.template("BUILD.bazel", Label("//cypress:BUILD.cypress"))

cypress_repositories = repository_rule(
    _cypress_repo_impl,
    doc = _DOC,
    attrs = _ATTRS,
)

# Wrapper macro around everything above, this is the primary API
def cypress_register_toolchains(name, cypress_version = None, cypress_integrity = None):
    """
    Convenience macro for setting up cypress toolchain for all supported platforms.

    - create a repository for each built-in platform like "cypress_linux-x64" -
      this repository is lazily fetched when node is needed for that platform.

    Args:
        name: base name for all created repos, like `cypress` or `cypress_10_1`

        cypress_version: Cypress version

        cypress_integrity: Mapping from platform to integrity file hash.

            Valid platform values are: darwin-x64, darwin-arm64, linux-x64, linux-arm64, win32-x64. See @aspect_rules_cypress//cypress/private:versions.bzl

            We have provided a helper script to help generate these integrity hashes.

            `bazel run @aspect_rules_cypress//scripts:mirror_releases <VERSION_NUMBER>`

            Alternatively, download a binary manually to compute its integrity hash, see https://docs.cypress.io/guides/references/advanced-installation#Download-URLs

            Once downloaded, run `shasum -a 256` to get the integrity hash
    """
    if not cypress_integrity:
        if cypress_version not in TOOL_VERSIONS.keys():
            fail("""\
cypress version {} is not currently mirrored into rules_cypress.
Please instead choose one of these available versions: {}
Or, make a PR to the repo running /scripts/mirror_release.sh to add the newest version.
Alternately, you may manually specify platform integrity hashes with cypress_integrity.""".format(cypress_version, TOOL_VERSIONS.keys()))
        cypress_integrity = TOOL_VERSIONS[cypress_version]

    for platform in PLATFORMS.keys():
        cypress_repositories(
            name = name + "_" + platform,
            version = cypress_version,
            platform = platform,
            sha256 = cypress_integrity.get(platform, None),
        )
        native.register_toolchains("@%s_toolchains//:%s_toolchain" % (name, platform))

    toolchains_repo(
        name = name + "_toolchains",
        user_repository_name = name,
    )
