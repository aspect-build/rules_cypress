<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Public API re-exports

<a id="cypress_module_test"></a>

## cypress_module_test

<pre>
cypress_module_test(<a href="#cypress_module_test-name">name</a>, <a href="#cypress_module_test-runner">runner</a>, <a href="#cypress_module_test-cypress">cypress</a>, <a href="#cypress_module_test-disable_sandbox">disable_sandbox</a>, <a href="#cypress_module_test-browsers">browsers</a>, <a href="#cypress_module_test-kwargs">kwargs</a>)
</pre>

cypress_module_test creates a node environment which is hooked up to the cypress toolchain.

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


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="cypress_module_test-name"></a>name |  The name used for this rule and output files   |  none |
| <a id="cypress_module_test-runner"></a>runner |  JS file to call into the cypress module api See https://docs.cypress.io/guides/guides/module-api   |  none |
| <a id="cypress_module_test-cypress"></a>cypress |  The cypress npm package which was already linked using an API like npm_link_all_packages.   |  `"//:node_modules/cypress"` |
| <a id="cypress_module_test-disable_sandbox"></a>disable_sandbox |  Turn off sandboxing by default to allow electron to perform write operations. Cypress does not expose the underlying electron apis so we cannot alter the user app data directory to be within the bazel sandbox.<br><br>From https://www.electronjs.org/docs/latest/api/app appData Per-user application data directory, which by default points to:     %APPDATA% on Windows     $XDG_CONFIG_HOME or ~/.config on Linux     ~/Library/Application Support on macOS<br><br>Cypress may fail to connect on macos with errors like:     Timed out waiting for the browser to connect. Retrying...     Timed out waiting for the browser to connect. Retrying again...     The browser never connected. Something is wrong. The tests cannot run. Aborting...   |  `True` |
| <a id="cypress_module_test-browsers"></a>browsers |  A sequence of labels specifying the browsers to include. Usually, any dependency that you wish to be included in the runfiles tree should be included within the data attribute. However, data dependencies, by default, are copied to the Bazel output tree before being passed as inputs to runfiles.<br><br>This is not a good default behavior for browser since these typically come from external workspaces which cannot be symlinked into bazel-bin. Instead, we place them at the root of the runfiles tree. Use relative paths to construct account for this placement<br><br>e.g. ../../../BROWSER_WORKSPACE_NAME   |  `[]` |
| <a id="cypress_module_test-kwargs"></a>kwargs |  All other args from `js_test`. See https://github.com/aspect-build/rules_js/blob/main/docs/js_binary.md#js_test   |  none |


<a id="cypress_test"></a>

## cypress_test

<pre>
cypress_test(<a href="#cypress_test-name">name</a>, <a href="#cypress_test-cypress">cypress</a>, <a href="#cypress_test-disable_sandbox">disable_sandbox</a>, <a href="#cypress_test-browsers">browsers</a>, <a href="#cypress_test-kwargs">kwargs</a>)
</pre>

cypress_test runs the cypress CLI with the cypress toolchain.

The environment is bootstrapped by first setting the environment variable `CYPRESS_RUN_BINARY` to the binary downloaded by the cypress toolchain. See https://docs.cypress.io/guides/references/advanced-installation#Run-binary

See documentation on what arguments the cypress CLI supports:
https://docs.cypress.io/guides/guides/command-line#What-you-ll-learn



**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="cypress_test-name"></a>name |  The name used for this rule and output files   |  none |
| <a id="cypress_test-cypress"></a>cypress |  The cypress npm package which was already linked using an API like npm_link_all_packages.   |  `"//:node_modules/cypress"` |
| <a id="cypress_test-disable_sandbox"></a>disable_sandbox |  Turn off sandboxing by default to allow electron to perform write operations. Cypress does not expose the underlying electron apis so we cannot alter the user app data directory to be within the bazel sandbox.<br><br>From https://www.electronjs.org/docs/latest/api/app appData Per-user application data directory, which by default points to:     %APPDATA% on Windows     $XDG_CONFIG_HOME or ~/.config on Linux     ~/Library/Application Support on macOS<br><br>Cypress may fail to connect on macos with errors like:     Timed out waiting for the browser to connect. Retrying...     Timed out waiting for the browser to connect. Retrying again...     The browser never connected. Something is wrong. The tests cannot run. Aborting...   |  `True` |
| <a id="cypress_test-browsers"></a>browsers |  A sequence of labels specifying the browsers to include. Usually, any dependency that you wish to be included in the runfiles tree should be included within the data attribute. However, data dependencies, by default, are copied to the Bazel output tree before being passed as inputs to runfiles.<br><br>This is not a good default behavior for browser since these typically come from external workspaces which cannot be symlinked into bazel-bin. Instead, we place them at the root of the runfiles tree. Use relative paths to construct account for this placement<br><br>e.g. ../../../BROWSER_WORKSPACE_NAME   |  `[]` |
| <a id="cypress_test-kwargs"></a>kwargs |  All other args from `js_test`. See https://github.com/aspect-build/rules_js/blob/main/docs/js_binary.md#js_test   |  none |


