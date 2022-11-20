const cypress = require('cypress')

cypress.run({
  headless: true,
}).then(result => {
  if (result.status === 'failed') {
    process.exit(1);
  }
})