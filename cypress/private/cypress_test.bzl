"cypress_test rule."

load("@aspect_rules_js//js:libs.bzl", "js_binary_lib", "js_lib_helpers")
load("@bazel_skylib//lib:dicts.bzl", "dicts")

_attrs = dicts.add(js_binary_lib.attrs, {
    "allow_sandbox": attr.bool(
        default = False,
    ),
    "browsers": attr.label_list(
        allow_files = True,
    ),
})

# Do the opposite of _to_manifest_path in
# https://github.com/bazelbuild/rules_nodejs/blob/8b5d27400db51e7027fe95ae413eeabea4856f8e/nodejs/toolchain.bzl#L50
# to get back to the short_path.
# TODO: fix toolchain so we don't have to do this
def _target_tool_short_path(path):
    return ("../" + path[len("external/"):]) if path.startswith("external/") else path

def _impl(ctx):
    cypress_bin = _target_tool_short_path(ctx.toolchains["@aspect_rules_cypress//cypress:toolchain_type"].cypressinfo.target_tool_path)
    cypress_files = ctx.toolchains["@aspect_rules_cypress//cypress:toolchain_type"].cypressinfo.tool_files

    files = ctx.files.data[:] + cypress_files + ctx.files.browsers

    if ctx.attr.chdir:
        cypress_bin = "/".join([".." for _ in ctx.attr.chdir.split("/")] + [cypress_bin])

    launcher = js_binary_lib.create_launcher(
        ctx,
        log_prefix_rule_set = "aspect_rules_cypess",
        log_prefix_rule = "cypress_node_test",
        fixed_args = ctx.attr.fixed_args,
        fixed_env = {
            "CYPRESS_RUN_BINARY": cypress_bin,
            "HOME": "$$TEST_TMPDIR",
            "XDG_CONFIG_HOME": "$$TEST_TMPDIR",
        },
    )

    runfiles = ctx.runfiles(
        files = files,
        transitive_files = js_lib_helpers.gather_files_from_js_providers(
            targets = ctx.attr.data,
            include_transitive_sources = ctx.attr.include_transitive_sources,
            include_declarations = ctx.attr.include_declarations,
            include_npm_linked_packages = ctx.attr.include_npm_linked_packages,
        ),
    ).merge(launcher.runfiles).merge_all([
        target[DefaultInfo].default_runfiles
        for target in ctx.attr.data
    ])

    return [
        DefaultInfo(
            executable = launcher.executable,
            runfiles = runfiles,
        ),
    ]

cypress_test_lib = struct(
    attrs = _attrs,
    implementation = _impl,
)
