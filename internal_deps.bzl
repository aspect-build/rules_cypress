"""Our "development" dependencies

Users should *not* need to install these. If users see a load()
statement from these, that's a bug in our distribution.
"""

# buildifier: disable=bzl-visibility
load("//cypress/private:maybe.bzl", http_archive = "maybe_http_archive")

def rules_cypress_internal_deps():
    "Fetch deps needed for local development"
    http_archive(
        name = "build_bazel_integration_testing",
        urls = [
            "https://github.com/bazelbuild/bazel-integration-testing/archive/165440b2dbda885f8d1ccb8d0f417e6cf8c54f17.zip",
        ],
        strip_prefix = "bazel-integration-testing-165440b2dbda885f8d1ccb8d0f417e6cf8c54f17",
        sha256 = "2401b1369ef44cc42f91dc94443ef491208dbd06da1e1e10b702d8c189f098e3",
    )

    http_archive(
        name = "io_bazel_stardoc",
        sha256 = "62bd2e60216b7a6fec3ac79341aa201e0956477e7c8f6ccc286f279ad1d96432",
        urls = ["https://github.com/bazelbuild/stardoc/releases/download/0.6.2/stardoc-0.6.2.tar.gz"],
    )

    # To update CHROME_REVISION, use the below script
    #
    # LASTCHANGE_URL="https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2FLAST_CHANGE?alt=media"
    # CHROME_REVISION=$(curl -s -S $LASTCHANGE_URL)
    # echo "latest CHROME_REVISION_LINUX is $CHROME_REVISION"
    CHROME_REVISION_LINUX = "1072361"

    http_archive(
        name = "chrome_linux",
        build_file_content = """filegroup(
    name = "all",
    srcs = glob(["**"]),
    visibility = ["//visibility:public"],
)""",
        sha256 = "0df22f743facd1e090eff9b7f8d8bdc293fb4dc31ce9156d2ef19b515974a72b",
        strip_prefix = "chrome-linux",
        urls = [
            "https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2F" + CHROME_REVISION_LINUX + "%2Fchrome-linux.zip?alt=media",
        ],
    )

    http_archive(
        name = "buildifier_prebuilt",
        sha256 = "8ada9d88e51ebf5a1fdff37d75ed41d51f5e677cdbeafb0a22dda54747d6e07e",
        strip_prefix = "buildifier-prebuilt-6.4.0",
        urls = ["http://github.com/keith/buildifier-prebuilt/archive/6.4.0.tar.gz"],
    )

    http_archive(
        name = "aspect_rules_lint",
        sha256 = "1e679b081750ca9cedad4f79e371ee5e14d9a157de8018661af9fe45879100b2",
        strip_prefix = "rules_lint-0.21.0",
        url = "https://github.com/aspect-build/rules_lint/releases/download/v0.21.0/rules_lint-v0.21.0.tar.gz",
    )
