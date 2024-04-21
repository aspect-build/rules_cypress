"""Starlark helper to fetch rules_cypress dependencies.

Should be replaced by bzlmod for users of Bazel 6.0 and above.
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", _http_archive = "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def http_archive(name, **kwargs):
    maybe(_http_archive, name = name, **kwargs)

def rules_cypress_dependencies():
    http_archive(
        name = "bazel_skylib",
        sha256 = "b8a1527901774180afc798aeb28c4634bdccf19c4d98e7bdd1ce79d1fe9aaad7",
        urls = ["https://github.com/bazelbuild/bazel-skylib/releases/download/1.4.1/bazel-skylib-1.4.1.tar.gz"],
    )

    http_archive(
        name = "aspect_bazel_lib",
        sha256 = "d0529773764ac61184eb3ad3c687fb835df5bee01afedf07f0cf1a45515c96bc",
        strip_prefix = "bazel-lib-1.42.3",
        url = "https://github.com/aspect-build/bazel-lib/releases/download/v1.42.3/bazel-lib-v1.42.3.tar.gz",
    )

    http_archive(
        name = "aspect_rules_js",
        sha256 = "bc9b4a01ef8eb050d8a7a050eedde8ffb1e45a56b0e4094e26f06c17d5fcf1d5",
        strip_prefix = "rules_js-1.41.2",
        url = "https://github.com/aspect-build/rules_js/releases/download/v1.41.2/rules_js-v1.41.2.tar.gz",
    )

    http_archive(
        name = "rules_nodejs",
        sha256 = "764a3b3757bb8c3c6a02ba3344731a3d71e558220adcb0cf7e43c9bba2c37ba8",
        urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/5.8.2/rules_nodejs-core-5.8.2.tar.gz"],
    )
