const cypress = require("cypress");

async function main() {
  const result = await cypress.run({
    headless: true,
  });

  // If any tests have failed, results.failures is non-zero, some tests have failed
  if (result.failures) {
    console.error("One or more cypress tests have failed");
    console.error(result.message);
    return 1;
  }

  if (result.status !== "finished") {
    console.error("Cypress tests failed with status", result.status);
    return 2;
  }

  return 0;
}

main()
  .then((code) => (process.exitCode = code))
  .catch((e) => {
    console.error("Cypress encountered unexpected exception. Exiting.", e);
    process.exitCode = 3;
  });
