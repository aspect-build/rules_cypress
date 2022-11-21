const { defineConfig } = require('cypress')

module.exports = defineConfig({
  e2e: {
    specPattern: ["cli_test.cy.js"],
    supportFile: false,
    setupNodeEvents(on, config) {
      on('before:browser:launch', (browser = {}, launchOptions) => {
        launchOptions.args.push("--disable-gpu-shader-disk-cache")
      })
    }
  },
})