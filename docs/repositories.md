<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Declare runtime dependencies

These are needed for local dev, and users must install them as well.
See https://docs.bazel.build/versions/main/skylark/deploying.html#dependencies

<a id="cypress_register_toolchains"></a>

## cypress_register_toolchains

<pre>
cypress_register_toolchains(<a href="#cypress_register_toolchains-name">name</a>, <a href="#cypress_register_toolchains-cypress_version">cypress_version</a>, <a href="#cypress_register_toolchains-cypress_integrity">cypress_integrity</a>, <a href="#cypress_register_toolchains-register">register</a>)
</pre>

Convenience macro for setting up cypress toolchain for all supported platforms.

- create a repository for each built-in platform like "cypress_linux-x64" -
  this repository is lazily fetched when node is needed for that platform.


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="cypress_register_toolchains-name"></a>name |  base name for all created repos, like `cypress` or `cypress_10_1`   |  none |
| <a id="cypress_register_toolchains-cypress_version"></a>cypress_version |  Cypress version   |  `None` |
| <a id="cypress_register_toolchains-cypress_integrity"></a>cypress_integrity |  Mapping from platform to integrity file hash.<br><br>Valid platform values are: darwin-x64, darwin-arm64, linux-x64, linux-arm64, win32-x64. See @aspect_rules_cypress//cypress/private:versions.bzl<br><br>We have provided a helper script to help generate these integrity hashes.<br><br>`bazel run @aspect_rules_cypress//scripts:mirror_releases <VERSION_NUMBER>`<br><br>Alternatively, download a binary manually to compute its integrity hash, see https://docs.cypress.io/guides/references/advanced-installation#Download-URLs<br><br>Once downloaded, run `shasum -a 256` to get the integrity hash   |  `None` |
| <a id="cypress_register_toolchains-register"></a>register |  Whether to call Bazel register_toolchains on the created toolchains. Should be True when used from a WORKSPACE file, and False used from bzlmod which has its own toolchain registration syntax.   |  `True` |


<a id="cypress_repositories"></a>

## cypress_repositories

<pre>
cypress_repositories(<a href="#cypress_repositories-name">name</a>, <a href="#cypress_repositories-platform">platform</a>, <a href="#cypress_repositories-repo_mapping">repo_mapping</a>, <a href="#cypress_repositories-sha256">sha256</a>, <a href="#cypress_repositories-version">version</a>)
</pre>

Fetch external tools needed for cypress toolchain

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="cypress_repositories-name"></a>name |  A unique name for this repository.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="cypress_repositories-platform"></a>platform |  -   | String | required |  |
| <a id="cypress_repositories-repo_mapping"></a>repo_mapping |  In `WORKSPACE` context only: a dictionary from local repository name to global repository name. This allows controls over workspace dependency resolution for dependencies of this repository.<br><br>For example, an entry `"@foo": "@bar"` declares that, for any time this repository depends on `@foo` (such as a dependency on `@foo//some:target`, it should actually resolve that dependency within globally-declared `@bar` (`@bar//some:target`).<br><br>This attribute is _not_ supported in `MODULE.bazel` context (when invoking a repository rule inside a module extension's implementation function).   | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional |  |
| <a id="cypress_repositories-sha256"></a>sha256 |  -   | String | optional |  `""`  |
| <a id="cypress_repositories-version"></a>version |  -   | String | required |  |


