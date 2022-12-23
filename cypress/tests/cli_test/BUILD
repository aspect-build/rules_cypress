load("@aspect_rules_cypress//cypress:defs.bzl", "cypress_test")

cypress_test(
    name = "cli_test",
    args = [
        "run",
        "--config-file=cypress.config.ts",
    ] + select({
        "@bazel_tools//src/conditions:darwin": [],
        "//conditions:default": ["--browser=../../../../chrome_linux/chrome"],
    }),
    browsers = select({
        # Chrome for mac contains files with spaces which are bazel incompatible.
        # Use built in electron binary browser instead.
        "@bazel_tools//src/conditions:darwin": [],
        "//conditions:default": ["@chrome_linux//:all"],
    }),
    cypress = "//cypress/tests:node_modules/cypress",
    data = [
        "cli_test.cy.ts",
        "cypress.config.ts",
        "tsconfig.json",
        "@aspect_rules_cypress//cypress/tests:node_modules",
    ],
)
