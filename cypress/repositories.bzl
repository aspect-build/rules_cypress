"""Declare runtime dependencies

These are needed for local dev, and users must install them as well.
See https://docs.bazel.build/versions/main/skylark/deploying.html#dependencies
"""

load("//cypress/private:toolchains_repo.bzl", "PLATFORMS", "toolchains_repo")

########
# Remaining content of the file is only used to support toolchains.
########
_DOC = "Fetch external tools needed for cypress toolchain"
_ATTRS = {
    "cypress_version": attr.string(mandatory = True),
    "platform": attr.string(mandatory = True, values = PLATFORMS.keys()),
    "sha256": attr.string(),
}

def _cypress_repo_impl(repository_ctx):
    url = "https://cdn.cypress.io/desktop/{0}/{1}/cypress.zip".format(
        repository_ctx.attr.cypress_version,
        repository_ctx.attr.platform,
    )
    repository_ctx.download_and_extract(
        url = url,
        sha256 = repository_ctx.attr.sha256,
    )
    binary_state_json_contents = '{"verified": true}'
    repository_ctx.file("binary_state.json", binary_state_json_contents)

    # Base BUILD file for this repository
    repository_ctx.template("BUILD.bazel", Label("//cypress:BUILD.cypress"))

cypress_repositories = repository_rule(
    _cypress_repo_impl,
    doc = _DOC,
    attrs = _ATTRS,
)

# Wrapper macro around everything above, this is the primary API
def cypress_register_toolchains(name, platform_to_integrity_hash = {}, **kwargs):
    """
    Convenience macro for setting up cypress toolchain for all supported platforms.

    - create a repository for each built-in platform like "cypress_linux-x64" -
      this repository is lazily fetched when node is needed for that platform.

    Args:
        name: base name for all created repos, like `cypress` or `cypress_10_1`
        platform_to_integrity_hash: Mapping from platform to integrity file hash

            Valid platform values are: darwin-x64, darwin-arm64, linux-x64 and linux-arm64. See @aspect_rules_cypress//cypress/private:toolchains_repo.bzl

            We have provided a helper script to help generate these integrity hashes.

            `bazel run @aspect_rules_cypress//scripts:gen_platform_to_integrity_hash VERSION_NUMBER`

            Alternatively, download a binary manually to compute its integrity hash, see https://docs.cypress.io/guides/references/advanced-installation#Download-URLs

            Once downloaded, run `shasum -a 256` to get the integrity hash
        **kwargs: passed to each node_repositories call
    """
    for platform in PLATFORMS.keys():
        cypress_repositories(
            name = name + "_" + platform,
            platform = platform,
            sha256 = platform_to_integrity_hash.get(platform, None),
            **kwargs
        )
        native.register_toolchains("@%s_toolchains//:%s_toolchain" % (name, platform))

    toolchains_repo(
        name = name + "_toolchains",
        user_repository_name = name,
    )
