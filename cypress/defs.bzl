"Public API re-exports"

load("@aspect_rules_cypress//cypress/private:cypress_test.bzl", "cypress_test_lib")
load("@aspect_rules_js//js:libs.bzl", "js_binary_lib")
load("@aspect_bazel_lib//lib:directory_path.bzl", "directory_path")

_cypress_test = rule(
    doc = """Identical to js_test with the addition of the cypress toolchain made available.""",
    attrs = cypress_test_lib.attrs,
    implementation = cypress_test_lib.implementation,
    test = True,
    toolchains = js_binary_lib.toolchains + ["@aspect_rules_cypress//cypress:toolchain_type"],
)

def cypress_test(name, cypress = "//:node_modules/cypress", **kwargs):
    """cypress_test runs the cypress CLI with the cypress toolchain.

    The environment is bootstrapped by first setting the environment variable `CYPRESS_RUN_BINARY` to the binary downloaded by the cypress toolchain. See https://docs.cypress.io/guides/references/advanced-installation#Run-binary

    See documentation on what arguments the cypress CLI supports:
    https://docs.cypress.io/guides/guides/command-line#What-you-ll-learn


    Args:
        name: The name used for this rule and output files
        cypress: The cypress npm package which was already linked using an API like npm_link_all_packages.
        **kwargs: All other args from `js_test`. See https://github.com/aspect-build/rules_js/blob/main/docs/js_binary.md#js_test
    """
    entry_point = "%s__entry_point" % name
    directory_path(
        name = entry_point,
        directory = cypress + "/dir",
        path = "bin/cypress",
        tags = ["manual"],
    )

    _cypress_test(
        name = name,
        entry_point = entry_point,
        data = kwargs.pop("data", []) + [
            cypress,
        ],
        chdir = native.package_name(),
        enable_runfiles = select({
            "@aspect_rules_js//js/private:enable_runfiles": True,
            "//conditions:default": False,
        }),
        **kwargs
    )

def cypress_module_test(name, runner, cypress = "//:node_modules/cypress", **kwargs):
    """cypress_module_test creates a node environment which is hooked up to the cypress toolchain.

    The environment is bootstrapped by first setting the environment variable `CYPRESS_RUN_BINARY` to the binary downloaded by the cypress toolchain. See https://docs.cypress.io/guides/references/advanced-installation#Run-binary

    You will provide a test runner, via the runner attribute, which is expected to call into cypress's module API to bootstrap testing.

    Example `runner.js`:
    ```
    const cypress = require('cypress')

    cypress.run({
    headless: true,
    }).then(result => {
    if (result.status === 'failed') {
        process.exit(1);
    }
    })
    ```

    In most scenarios, it is easier to use cypress_test. But in some scenarios, you may need more flexibility:
      - Accessing to the test results directly after the run and do something with them.
      - Reruning a failing spec file
      - Kicking off other builds or scripts

    Args:
        name: The name used for this rule and output files
        runner: JS file to call into the cypress module api
            See https://docs.cypress.io/guides/guides/module-api
        cypress: The cypress npm package which was already linked using an API like npm_link_all_packages.
        **kwargs: All other args from `js_test`. See https://github.com/aspect-build/rules_js/blob/main/docs/js_binary.md#js_test
    """
    _cypress_test(
        name = name,
        enable_runfiles = select({
            "@aspect_rules_js//js/private:enable_runfiles": True,
            "//conditions:default": False,
        }),
        entry_point = runner,
        chdir = native.package_name(),
        data = kwargs.pop("data", []) + [
            cypress,
        ],
        patch_node_fs = kwargs.pop("patch_node_fs", False),
        **kwargs
    )
