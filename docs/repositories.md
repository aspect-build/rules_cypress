<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Declare runtime dependencies

These are needed for local dev, and users must install them as well.
See https://docs.bazel.build/versions/main/skylark/deploying.html#dependencies


<a id="cypress_repositories"></a>

## cypress_repositories

<pre>
cypress_repositories(<a href="#cypress_repositories-name">name</a>, <a href="#cypress_repositories-cypress_version">cypress_version</a>, <a href="#cypress_repositories-platform">platform</a>, <a href="#cypress_repositories-repo_mapping">repo_mapping</a>, <a href="#cypress_repositories-sha256">sha256</a>)
</pre>

Fetch external tools needed for cypress toolchain

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="cypress_repositories-name"></a>name |  A unique name for this repository.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="cypress_repositories-cypress_version"></a>cypress_version |  -   | String | required |  |
| <a id="cypress_repositories-platform"></a>platform |  -   | String | required |  |
| <a id="cypress_repositories-repo_mapping"></a>repo_mapping |  A dictionary from local repository name to global repository name. This allows controls over workspace dependency resolution for dependencies of this repository.&lt;p&gt;For example, an entry <code>"@foo": "@bar"</code> declares that, for any time this repository depends on <code>@foo</code> (such as a dependency on <code>@foo//some:target</code>, it should actually resolve that dependency within globally-declared <code>@bar</code> (<code>@bar//some:target</code>).   | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | required |  |
| <a id="cypress_repositories-sha256"></a>sha256 |  -   | String | optional | <code>""</code> |


<a id="cypress_register_toolchains"></a>

## cypress_register_toolchains

<pre>
cypress_register_toolchains(<a href="#cypress_register_toolchains-name">name</a>, <a href="#cypress_register_toolchains-platform_to_integrity_hash">platform_to_integrity_hash</a>, <a href="#cypress_register_toolchains-kwargs">kwargs</a>)
</pre>

    Convenience macro for setting up cypress toolchain for all supported platforms.

- create a repository for each built-in platform like "cypress_linux-x64" -
  this repository is lazily fetched when node is needed for that platform.


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="cypress_register_toolchains-name"></a>name |  base name for all created repos, like <code>cypress</code> or <code>cypress_10_1</code>   |  none |
| <a id="cypress_register_toolchains-platform_to_integrity_hash"></a>platform_to_integrity_hash |  Mapping from platform to integrity file hash<br><br>Valid platform values are: darwin-x64, darwin-arm64, linux-x64 and linux-arm64. See @aspect_rules_cypress//cypress/private:toolchains_repo.bzl<br><br>We have provided a helper script to help generate these integrity hashes.<br><br><code>bazel run @aspect_rules_cypress//scripts:gen_platform_to_integrity_hash VERSION_NUMBER</code><br><br>Alternatively, download a binary manually to compute its integrity hash, see https://docs.cypress.io/guides/references/advanced-installation#Download-URLs<br><br>Once downloaded, run <code>shasum -a 256</code> to get the integrity hash   |  <code>{}</code> |
| <a id="cypress_register_toolchains-kwargs"></a>kwargs |  passed to each node_repositories call   |  none |


