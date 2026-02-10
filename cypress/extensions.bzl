"extensions for bzlmod"

load("//cypress:repositories.bzl", "cypress_register_toolchains")
load("@aspect_tools_telemetry_report//:defs.bzl", "TELEMETRY")  # buildifier: disable=load

def _toolchain_extension(module_ctx):
    for mod in module_ctx.modules:
        for toolchain in mod.tags.toolchain:
            cypress_register_toolchains(
                name = toolchain.name,
                cypress_version = toolchain.cypress_version,
                cypress_integrity = toolchain.cypress_integrity,
                register = False,
            )

cypress = module_extension(
    implementation = _toolchain_extension,
    tag_classes = {
        "toolchain": tag_class(attrs = {
            "name": attr.string(
                doc = "Base name for generated repositories",
                default = "cypress",
            ),
            "cypress_version": attr.string(
                doc = "Version of cypress to download",
            ),
            "cypress_integrity": attr.string_dict(
                doc = "Mapping from platform to integrity file hash. See cypress_register_toolchains",
            ),
        }),
    },
)
