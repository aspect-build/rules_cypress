import { defineConfig } from "cypress";

// Set XVFB_DISPLAY_NUM to instruct cypress what port to use during CI and prevent port collision.
process.env.XVFB_DISPLAY_NUM = Math.floor(Math.random() * 99999).toString();

export default defineConfig({
  e2e: {
    specPattern: ["cli_test.cy.ts"],
    supportFile: false,
    setupNodeEvents(on, config) {
      on("before:browser:launch", (browser, launchOptions) => {
        launchOptions.args.push("--disable-gpu-shader-disk-cache");
      });
    },
  },
});
