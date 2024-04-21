// https://docs.cypress.io/guides/references/configuration
const { defineConfig } = require("cypress");
const { spawn } = require("node:child_process");
const { join } = require("path");

// Set XVFB_DISPLAY_NUM to instruct cypress what port to use during CI and prevent port collision.
process.env.XVFB_DISPLAY_NUM = Math.floor(Math.random() * 99999).toString();

module.exports = defineConfig({
  e2e: {
    specPattern: ["server_example/server_example_test.cy.js"],
    supportFile: false,
    setupNodeEvents(on, config) {
      // Use "before:browser:launch" to edit config values.
      // "before:run" does not propagate config value changes.
      on("before:browser:launch", (browser, launchOptions) => {
        launchOptions.args.push("--disable-gpu-shader-disk-cache");
      });

      const port = "3000";
      return new Promise((resolve, reject) => {
        // Launch the server
        const workspaceRoot = join(
          process.env.RUNFILES_DIR,
          process.env.TEST_WORKSPACE,
        );
        const serverProcess = spawn(
          join(workspaceRoot, "server_example/server_/server"),
          [port],
          {
            // js_binary expects to be run at execroot, but cypress rule has changed pwd to where our test target was defined.
            cwd: workspaceRoot,
          },
        );

        serverProcess.stdout.on("data", (data) => {
          data = data.toString();
          console.log(data);
          if (data.includes(`Example app listening on port ${port}`)) {
            // Tell cypress where server is running
            resolve({ ...config, baseUrl: `http://localhost:${port}` });
          }
        });
        serverProcess.stderr.on("data", (data) => {
          data = data.toString();
          console.error(data);
          reject(data);
        });
        serverProcess.on("error", (code) => {
          console.error(`server exited with code: ${code}`);
          reject(`server exited with code: ${code}`);
        });
      });
    },
  },
});
