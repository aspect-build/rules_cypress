"cypress_test rule."

load("@aspect_rules_js//js:libs.bzl", "js_binary_lib", "js_lib_helpers")
load("@bazel_skylib//lib:dicts.bzl", "dicts")

_attrs = dicts.add(js_binary_lib.attrs, {
    "browsers": attr.label_list(
        allow_files = True,
    ),
})

def _impl(ctx):
    cypressinfo = ctx.toolchains["@aspect_rules_cypress//cypress:toolchain_type"].cypressinfo
    cypress_bin = cypressinfo.target_tool.short_path

    files = ctx.files.data[:] + cypressinfo.tool_files + ctx.files.browsers

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
            # Unique Xvfb display per test process so parallel tests don't race for :99
            "XVFB_DISPLAY_NUM": "$$$$",
        },
    )

    runfiles = ctx.runfiles(
        files = files,
        transitive_files = js_lib_helpers.gather_files_from_js_infos(
            targets = ctx.attr.data,
            include_sources = ctx.attr.include_sources,
            include_types = ctx.attr.include_types,
            include_transitive_sources = ctx.attr.include_transitive_sources,
            include_transitive_types = ctx.attr.include_transitive_types,
            include_npm_sources = ctx.attr.include_npm_sources,
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
