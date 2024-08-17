"Public API re-exports"

load("@aspect_bazel_lib//lib:directory_path.bzl", "directory_path")
load("@aspect_rules_cypress//cypress/private:cypress_test.bzl", "cypress_test_lib")
load("@aspect_rules_js//js:defs.bzl", "js_run_devserver")
load("@aspect_rules_js//js:libs.bzl", "js_binary_lib")

_cypress_test = rule(
    doc = """Identical to js_test with the addition of the cypress toolchain made available.""",
    attrs = cypress_test_lib.attrs,
    implementation = cypress_test_lib.implementation,
    test = True,
    toolchains = js_binary_lib.toolchains + ["@aspect_rules_cypress//cypress:toolchain_type"],
)

def _cypress_test_macro(name, entry_point, cypress, disable_sandbox, **kwargs):
    tags = kwargs.pop("tags", [])
    if disable_sandbox:
        tags.append("no-sandbox")
    _cypress_test(
        name = name,
        entry_point = entry_point,
        data = kwargs.pop("data", []) + [
            cypress,
        ],
        enable_runfiles = select({
            Label("@aspect_bazel_lib//lib:enable_runfiles"): True,
            "//conditions:default": False,
        }),
        tags = tags,
        **kwargs
    )

def cypress_test(
        name,
        cypress = "//:node_modules/cypress",
        disable_sandbox = True,
        browsers = [],
        **kwargs):
    """cypress_test runs the cypress CLI with the cypress toolchain.

    The environment is bootstrapped by first setting the environment variable `CYPRESS_RUN_BINARY` to the binary downloaded by the cypress toolchain. See https://docs.cypress.io/guides/references/advanced-installation#Run-binary

    See documentation on what arguments the cypress CLI supports:
    https://docs.cypress.io/guides/guides/command-line#What-you-ll-learn

    Macro produces two targets:
      - `[name]`: Test target which will invoke `cypress run`
      - `[name].open`: Runnable target which will invoke `cypress open`. Meant to be used in conjunction with ibazel

    Args:
        name: The name used for this rule and output files
        cypress: The cypress npm package which was already linked using an API like npm_link_all_packages.
        disable_sandbox: Turn off sandboxing by default to allow electron to perform write operations.
            Cypress does not expose the underlying electron apis so we
            cannot alter the user app data directory to be within the bazel
            sandbox.

            From https://www.electronjs.org/docs/latest/api/app
            appData Per-user application data directory, which by default points to:
                %APPDATA% on Windows
                $XDG_CONFIG_HOME or ~/.config on Linux
                ~/Library/Application Support on macOS

            Cypress may fail to connect on macos with errors like:
                Timed out waiting for the browser to connect. Retrying...
                Timed out waiting for the browser to connect. Retrying again...
                The browser never connected. Something is wrong. The tests cannot run. Aborting...
        browsers: A sequence of labels specifying the browsers to include.
            Usually, any dependency that you wish to be included in the runfiles tree should
            be included within the data attribute. However, data dependencies, by default,
            are copied to the Bazel output tree before being passed as inputs to runfiles.

            This is not a good default behavior for browser since these typically come from
            external workspaces which cannot be symlinked into bazel-bin. Instead, we
            place them at the root of the runfiles tree. Use relative paths to construct
            account for this placement

            e.g. ../../../BROWSER_WORKSPACE_NAME
        **kwargs: All other args from `js_test`. See https://github.com/aspect-build/rules_js/blob/main/docs/js_binary.md#js_test
    """
    entry_point = "%s__entry_point" % name
    directory_path(
        name = entry_point,
        directory = cypress + "/dir",
        path = "bin/cypress",
        tags = ["manual"],
    )

    args = kwargs.pop("args", [])
    data = kwargs.pop("data", [])
    _cypress_test_macro(
        name = name,
        entry_point = entry_point,
        cypress = cypress,
        disable_sandbox = disable_sandbox,
        browsers = browsers,
        args = ["run"] + args,
        data = data,
        **kwargs
    )

    js_run_devserver(
        name = name + ".open",
        tool = name,
        args = ["open"] + args,
        # Allow using _cypress_test_macro as the tool. It is testonly so this target also needs to be testonly.
        testonly = True,
        data = data,
        grant_sandbox_write_permissions = True,
    )

def cypress_module_test(
        name,
        runner,
        cypress = "//:node_modules/cypress",
        disable_sandbox = True,
        browsers = [],
        **kwargs):
    """cypress_module_test creates a node environment which is hooked up to the cypress toolchain.

    The environment is bootstrapped by first setting the environment variable `CYPRESS_RUN_BINARY` to the binary downloaded by the cypress toolchain. See https://docs.cypress.io/guides/references/advanced-installation#Run-binary

    You will provide a test runner, via the runner attribute, which is expected to call into cypress's module API to bootstrap testing.

    Example `runner.js`:
    ```
    async function main() {
    const result = await cypress.run({
        headless: true,
    });

    // If any tests have failed, results.failures is non-zero, some tests have failed
    if (result.failures) {
        console.error("One or more cypress tests have failed");
        console.error(result.message);
        return 1;
    }

    if (result.status === "failed") {
        console.log("Cypress exited with a failure status");
        return 2;
    }

    return 0;
    }
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
        disable_sandbox: Turn off sandboxing by default to allow electron to perform write operations.
            Cypress does not expose the underlying electron apis so we
            cannot alter the user app data directory to be within the bazel
            sandbox.

            From https://www.electronjs.org/docs/latest/api/app
            appData Per-user application data directory, which by default points to:
                %APPDATA% on Windows
                $XDG_CONFIG_HOME or ~/.config on Linux
                ~/Library/Application Support on macOS

            Cypress may fail to connect on macos with errors like:
                Timed out waiting for the browser to connect. Retrying...
                Timed out waiting for the browser to connect. Retrying again...
                The browser never connected. Something is wrong. The tests cannot run. Aborting...
        browsers: A sequence of labels specifying the browsers to include.
            Usually, any dependency that you wish to be included in the runfiles tree should
            be included within the data attribute. However, data dependencies, by default,
            are copied to the Bazel output tree before being passed as inputs to runfiles.

            This is not a good default behavior for browser since these typically come from
            external workspaces which cannot be symlinked into bazel-bin. Instead, we
            place them at the root of the runfiles tree. Use relative paths to construct
            account for this placement

            e.g. ../../../BROWSER_WORKSPACE_NAME
        **kwargs: All other args from `js_test`. See https://github.com/aspect-build/rules_js/blob/main/docs/js_binary.md#js_test
    """
    _cypress_test_macro(
        name = name,
        entry_point = runner,
        cypress = cypress,
        disable_sandbox = disable_sandbox,
        browsers = browsers,
        **kwargs
    )
