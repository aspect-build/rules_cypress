<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Public API re-exports

<a id="cypress_test"></a>

## cypress_test

<pre>
cypress_test(<a href="#cypress_test-name">name</a>, <a href="#cypress_test-runner">runner</a>, <a href="#cypress_test-kwargs">kwargs</a>)
</pre>

cypress_test creates a node environment which is hooked up to the cypress toolchain.

The environment is bootstrapped by first setting the environment variable `CYPRESS_RUN_BINARY` to the binary downloaded by the cypress toolchain. See https://docs.cypress.io/guides/references/advanced-installation#Run-binary

After the setting up environment variables, the node program then calls `require` on the `.js` test runner you provide as an attribute. That test runner is expected to call into cypress's module API to bootstrap testing.

Example `runner.js`:
```
const cypress = require('cypress')

async function main() {
    try {
        const result = await cypress.run({
            headless: true,
        })

        // If any tests have failed, results.failures is non-zero, some tests have failed
        if (result.failures) {
            console.error('One or more cypress tests have failed')
            console.error(result.message)
            process.exit(1)
        }

        if (result.status !== 'finished') {
            console.error('Cypress tests failed with status', result.status)
            process.exit(2)
        }
    } catch (e) {
        console.error("Cypress encountered unexpected exception. Exiting.", e)
        process.exit(3)
    }
}

main();
```


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="cypress_test-name"></a>name |  The name used for this rule and output files   |  none |
| <a id="cypress_test-runner"></a>runner |  JS file to call into the cypress module api See https://docs.cypress.io/guides/guides/module-api   |  none |
| <a id="cypress_test-kwargs"></a>kwargs |  All other args from <code>js_test</code>. See https://github.com/aspect-build/rules_js/blob/main/docs/js_binary.md#js_test   |  none |


