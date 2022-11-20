load("@aspect_rules_js//js:libs.bzl", "js_binary_lib", "js_lib_helpers")

_attrs = js_binary_lib.attrs

def _impl(ctx):
    cypress_bin = ctx.toolchains["@aspect_rules_cypress//cypress:toolchain_type"].cypressinfo.target_tool_path
    cypress_files = ctx.toolchains["@aspect_rules_cypress//cypress:toolchain_type"].cypressinfo.tool_files

    files = ctx.files.data[:] + cypress_files

    if ctx.attr.chdir:
        cypress_bin = "/".join([".." for _ in ctx.attr.chdir.split("/")] + [cypress_bin])

    launcher = js_binary_lib.create_launcher(
        ctx,
        log_prefix_rule_set = "aspect_rules_cypess",
        log_prefix_rule = "cypress_node_test",
        fixed_env = {
            "CYPRESS_RUN_BINARY": cypress_bin,
            "HOME": "$$TEST_TMPDIR",
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

lib = struct(
    attrs = _attrs,
    implementation = _impl,
)
