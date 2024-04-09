# Declare the local Bazel workspace.
workspace(name = "aspect_rules_cypress")

load(":internal_deps.bzl", "rules_cypress_internal_deps")

# Fetch deps needed only locally for development
rules_cypress_internal_deps()

load("@aspect_rules_cypress//cypress:dependencies.bzl", "rules_cypress_dependencies")

# Fetch dependencies which users need as well
rules_cypress_dependencies()

load("@aspect_bazel_lib//lib:repositories.bzl", "aspect_bazel_lib_dependencies")

aspect_bazel_lib_dependencies(override_local_config_platform = True)

load("@rules_nodejs//nodejs:repositories.bzl", "DEFAULT_NODE_VERSION", "nodejs_register_toolchains")

nodejs_register_toolchains(
    name = "nodejs",
    node_version = DEFAULT_NODE_VERSION,
)

load("@aspect_rules_cypress//cypress:repositories.bzl", "cypress_register_toolchains")

cypress_register_toolchains(
    name = "cypress",
    cypress_version = "12.3.0",
)

# For running our own unit tests
load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

# Buildifier
load("@buildifier_prebuilt//:deps.bzl", "buildifier_prebuilt_deps")

buildifier_prebuilt_deps()

load("@buildifier_prebuilt//:defs.bzl", "buildifier_prebuilt_register_toolchains")

buildifier_prebuilt_register_toolchains()
