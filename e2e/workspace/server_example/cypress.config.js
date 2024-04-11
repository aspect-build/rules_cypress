const { defineConfig } = require("cypress");
const { spawn } = require("node:child_process");
const { join } = require("path");

module.exports = defineConfig({
  e2e: {
    specPattern: ["server_example_test.cy.js"],
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
        const serverProcess = spawn(join(__dirname, "server.sh"), [port], {
          // js_binary expects to be run at execroot, but cypress rule has changed pwd to where our test target was defined.
          cwd: `${process.env.TEST_SRCDIR}/${process.env.TEST_WORKSPACE}`,
        });

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
