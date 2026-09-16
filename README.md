# Bazel rules for Cypress

Runs [Cypress](https://www.cypress.io/) tests under Bazel with a hermetically fetched Cypress binary.

## Requirements

- Bazel 8.5 or newer, bzlmod only
- [rules_js](https://github.com/aspect-build/rules_js) 3.x, with the `cypress` npm package in your lockfile
- Linux or macOS on x86_64 or arm64. There is no Windows toolchain.

## Installation

Follow the instructions from the release you wish to use:
<https://github.com/aspect-build/rules_cypress/releases>

In short, add to `MODULE.bazel`:

```starlark
bazel_dep(name = "aspect_rules_cypress", version = "<VERSION>", dev_dependency = True)

cypress = use_extension("@aspect_rules_cypress//cypress:extensions.bzl", "cypress", dev_dependency = True)
cypress.toolchain(cypress_version = "16.0.0")
use_repo(cypress, "cypress_toolchains")

register_toolchains("@cypress_toolchains//:all")
```

The toolchain downloads the Cypress binary, so the npm package's postinstall download is not needed.
Skip it with `lifecycle_hooks_exclude = ["cypress"]` on `npm_translate_lock`.

### Cypress versions

`cypress_version` must be one of the versions mirrored in
[`cypress/private/versions.bzl`](cypress/private/versions.bzl), or you must supply
`cypress_integrity` with a sha256 for every platform:

```starlark
cypress.toolchain(
    cypress_version = "16.1.0",
    cypress_integrity = {
        "darwin-x64": "...",
        "darwin-arm64": "...",
        "linux-x64": "...",
        "linux-arm64": "...",
    },
)
```

`bazel run @aspect_rules_cypress//scripts:mirror_releases -- <VERSION>` prints the hashes for a release.

## Usage

`cypress_test` runs the Cypress CLI. It accepts all `js_test` attributes.

```starlark
load("@aspect_rules_cypress//cypress:defs.bzl", "cypress_test")

cypress_test(
    name = "e2e",
    args = [
        "run",
        "--config-file=$(rootpath cypress.config.ts)",
    ],
    data = [
        "cypress.config.ts",
        "e2e.cy.ts",
        "//:node_modules",
    ],
)
```

`cypress_module_test` runs a JS file of your own that calls the
[Cypress module API](https://docs.cypress.io/guides/guides/module-api).

```starlark
load("@aspect_rules_cypress//cypress:defs.bzl", "cypress_module_test")

cypress_module_test(
    name = "e2e",
    chdir = package_name(),
    data = [
        "cypress.config.js",
        "e2e.cy.js",
    ],
    runner = "runner.js",
)
```

Both macros default `cypress` to `//:node_modules/cypress` and add the `no-sandbox` tag,
because Electron writes outside the sandbox. See the docstrings in
[`cypress/defs.bzl`](cypress/defs.bzl) for details.

Working examples live in [`e2e/workspace`](e2e/workspace).
