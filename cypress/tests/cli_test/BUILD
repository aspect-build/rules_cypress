load("@aspect_rules_cypress//cypress:defs.bzl", "cypress_cli_test")

cypress_cli_test(
    name = "cli_test",
    args = [
        "run",
        "--config-file=cypress.config.js",
    ],
    cypress = "//cypress/tests:node_modules/cypress",
    data = [
        "cli_test.cy.js",
        "cypress.config.js",
        "@aspect_rules_cypress//cypress/tests:node_modules",
    ],
)
