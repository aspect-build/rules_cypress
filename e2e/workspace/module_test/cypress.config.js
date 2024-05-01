const { defineConfig } = require("cypress");

module.exports = defineConfig({
  e2e: {
    specPattern: ["*.cy.js"],
    supportFile: false,
    setupNodeEvents(on, _config) {
      on("before:browser:launch", (_browser, launchOptions) => {
        launchOptions.args.push("--disable-gpu-shader-disk-cache");
      });
    },
  },
});
