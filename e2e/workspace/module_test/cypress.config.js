const { defineConfig } = require("cypress");

// Set XVFB_DISPLAY_NUM to instruct cypress what port to use during CI and prevent port collision.
process.env.XVFB_DISPLAY_NUM = Math.floor(Math.random() * 99999).toString();

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
