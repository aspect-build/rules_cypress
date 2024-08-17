load("@aspect_rules_cypress//cypress:defs.bzl", "cypress_test")

cypress_test(
    name = "cli_test",
    timeout = "short",
    args = [
        "--e2e",
        "--browser=electron",
        "--config-file=cli_test/cypress.config.ts",
    ],
    data = [
        "cli_test.cy.ts",
        "cypress.config.ts",
        "tsconfig.json",
        "//:node_modules",
    ],
)
