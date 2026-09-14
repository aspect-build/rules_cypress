"""Run the e2e tests against the oldest cypress version the ruleset mirrors.

Only one cypress toolchain can be registered per platform, so the second
version is wired up by pointing CYPRESS_RUN_BINARY at the cypress13_* repos.
cypress_test sets that variable from the toolchain first and applies the
`env` attribute after it.
"""

_PLATFORMS = {
    "darwin-arm64": struct(
        constraints = ["@platforms//os:macos", "@platforms//cpu:aarch64"],
        binary = "Cypress.app",
        binary_path = "Contents/MacOS/Cypress",
    ),
    "darwin-x64": struct(
        constraints = ["@platforms//os:macos", "@platforms//cpu:x86_64"],
        binary = "Cypress.app",
        binary_path = "Contents/MacOS/Cypress",
    ),
    "linux-arm64": struct(
        constraints = ["@platforms//os:linux", "@platforms//cpu:aarch64"],
        binary = "cypress_binary",
        binary_path = "Cypress",
    ),
    "linux-x64": struct(
        constraints = ["@platforms//os:linux", "@platforms//cpu:x86_64"],
        binary = "cypress_binary",
        binary_path = "Cypress",
    ),
}

def cypress13_config_settings(name):
    for platform, meta in _PLATFORMS.items():
        native.config_setting(
            name = name + "_" + platform,
            constraint_values = meta.constraints,
            visibility = ["//visibility:public"],
        )

def cypress13_data():
    return select({
        "//:cypress13_" + platform: [
            "@cypress13_{}//:files".format(platform),
            "@cypress13_{}//:{}".format(platform, meta.binary),
        ]
        for platform, meta in _PLATFORMS.items()
    })

def cypress13_env(chdir = None):
    prefix = "../" * len(chdir.split("/")) if chdir else ""
    return select({
        "//:cypress13_" + platform: {
            "CYPRESS_PACKAGE": "cypress13",
            "CYPRESS_RUN_BINARY": "{}$(rootpath @cypress13_{}//:{})/{}".format(prefix, platform, meta.binary, meta.binary_path),
        }
        for platform, meta in _PLATFORMS.items()
    })
