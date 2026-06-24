# How to Contribute

## Formatting

Starlark files should be formatted by buildifier.
We suggest using a pre-commit hook to automate this.
First [install pre-commit](https://pre-commit.com/#installation),
then run

```shell
pre-commit install
```

Otherwise later tooling on CI may yell at you about formatting/linting violations.

## Updating BUILD files

Some targets are generated from sources.
Currently this is just the `bzl_library` targets.
Run `aspect configure` to keep them up-to-date.

## Using this as a development dependency of other rules

You'll commonly find that you develop in another module, such as
some other ruleset that depends on rules_cypress, or in the nested
module under `e2e/workspace`.

To tell Bazel to use this directory rather than a release artifact or
a version fetched from the registry, add a `local_path_override` to the
dependent's `MODULE.bazel`:

```starlark
local_path_override(
    module_name = "aspect_rules_cypress",
    path = "/path/to/rules_cypress",
)
```

This means that any usage of `@aspect_rules_cypress` in that module will point to this folder.

## Releasing

1. Determine the next release version, following semver (could automate in the future from changelog)
1. Tag the repo and push it (or create a tag in GH UI)
1. Watch the automation run on GitHub actions
