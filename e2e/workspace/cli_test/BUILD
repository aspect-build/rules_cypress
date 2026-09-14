load("@aspect_rules_cypress//cypress:defs.bzl", "cypress_test")
load("//:cypress13.bzl", "cypress13_data", "cypress13_env")

cypress_test(
    name = "cli_test",
    timeout = "short",
    args = [
        "run",
        "--config-file=cli_test/cypress.config.ts",
    ],
    data = [
        "cli_test.cy.ts",
        "cypress.config.ts",
        "tsconfig.json",
        "//:node_modules",
    ],
)

cypress_test(
    name = "cli_test13",
    timeout = "short",
    args = [
        "run",
        "--config-file=cli_test/cypress.config.ts",
    ],
    cypress = "//:node_modules/cypress13",
    data = [
        "cli_test.cy.ts",
        "cypress.config.ts",
        "tsconfig.json",
        "//:node_modules",
    ] + cypress13_data(),
    env = cypress13_env(),
    no_copy_to_bin = cypress13_data(),
)
