"cypress_test rule."

load("@aspect_rules_js//js:libs.bzl", "js_binary_lib", "js_lib_helpers")
load("@bazel_skylib//lib:dicts.bzl", "dicts")

_attrs = dicts.add(js_binary_lib.attrs, {
    "browsers": attr.label_list(
        allow_files = True,
    ),
})

def _impl(ctx):
    cypress_bin = ctx.toolchains["@aspect_rules_cypress//cypress:toolchain_type"].cypressinfo.target_tool_path
    cypress_files = ctx.toolchains["@aspect_rules_cypress//cypress:toolchain_type"].cypressinfo.tool_files

    files = ctx.files.data[:] + cypress_files + ctx.files.browsers

    # TODO: Augment rules_js to expose JS__EXECROOT before setting fixed_env. Then use that variable.
    execroot = "$$( realpath \"$${BASH_SOURCE[0]}\" | sed -E 's/^(.*\\/execroot\\/[^/]+).*/\\1/')"
    cypress_run_binary = "/".join([execroot, cypress_bin])

    launcher = js_binary_lib.create_launcher(
        ctx,
        log_prefix_rule_set = "aspect_rules_cypess",
        log_prefix_rule = "cypress_node_test",
        fixed_args = ctx.attr.fixed_args,
        fixed_env = {
            "CYPRESS_RUN_BINARY": cypress_run_binary,
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
