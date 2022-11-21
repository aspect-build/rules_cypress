<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Public API re-exports

<a id="cypress_cli_test"></a>

## cypress_cli_test

<pre>
cypress_cli_test(<a href="#cypress_cli_test-name">name</a>, <a href="#cypress_cli_test-cypress">cypress</a>, <a href="#cypress_cli_test-kwargs">kwargs</a>)
</pre>

cypress_cli_test runs the cypress CLI with the cypress toolchain.

The environment is bootstrapped by first setting the environment variable `CYPRESS_RUN_BINARY` to the binary downloaded by the cypress toolchain. See https://docs.cypress.io/guides/references/advanced-installation#Run-binary

See documentation on what arguments the cypress CLI supports:
https://docs.cypress.io/guides/guides/command-line#What-you-ll-learn



**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="cypress_cli_test-name"></a>name |  The name used for this rule and output files   |  none |
| <a id="cypress_cli_test-cypress"></a>cypress |  The cypress npm package which was already linked using an API like npm_link_all_packages.   |  <code>"//:node_modules/cypress"</code> |
| <a id="cypress_cli_test-kwargs"></a>kwargs |  All other args from <code>js_test</code>. See https://github.com/aspect-build/rules_js/blob/main/docs/js_binary.md#js_test   |  none |


<a id="cypress_module_test"></a>

## cypress_module_test

<pre>
cypress_module_test(<a href="#cypress_module_test-name">name</a>, <a href="#cypress_module_test-runner">runner</a>, <a href="#cypress_module_test-cypress">cypress</a>, <a href="#cypress_module_test-kwargs">kwargs</a>)
</pre>

cypress_module_test creates a node environment which is hooked up to the cypress toolchain.

The environment is bootstrapped by first setting the environment variable `CYPRESS_RUN_BINARY` to the binary downloaded by the cypress toolchain. See https://docs.cypress.io/guides/references/advanced-installation#Run-binary

You will provide a test runner, via the runner attribute, which is expected to call into cypress's module API to bootstrap testing.

Example `runner.js`:
```
const cypress = require('cypress')

cypress.run({
headless: true,
}).then(result =&gt; {
if (result.status === 'failed') {
    process.exit(1);
}
})
```

In most scenarios, it is easier to use cypress_cli_test. But in some scenarios, you may need more flexibility:
  - Accessing to the test results directly after the run and do something with them.
  - Reruning a failing spec file
  - Kicking off other builds or scripts


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="cypress_module_test-name"></a>name |  The name used for this rule and output files   |  none |
| <a id="cypress_module_test-runner"></a>runner |  JS file to call into the cypress module api See https://docs.cypress.io/guides/guides/module-api   |  none |
| <a id="cypress_module_test-cypress"></a>cypress |  The cypress npm package which was already linked using an API like npm_link_all_packages.   |  <code>"//:node_modules/cypress"</code> |
| <a id="cypress_module_test-kwargs"></a>kwargs |  All other args from <code>js_test</code>. See https://github.com/aspect-build/rules_js/blob/main/docs/js_binary.md#js_test   |  none |


