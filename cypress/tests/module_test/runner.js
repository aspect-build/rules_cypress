const cypress = require('cypress')

async function main() {
    try {
        const result = await cypress.run({
            headless: true,
        })

        // If any tests have failed, results.failures is non-zero, some tests have failed
        if (result.failures) {
            console.error('One or more cypress tests have failed')
            console.error(result.message)
            process.exit(1)
        }

        if (result.status !== 'finished') {
            console.error('Cypress tests failed with status', result.status)
            process.exit(2)
        }
    } catch (e) {
        console.error("Cypress encountered unexpected exception. Exiting.", e)
        process.exit(3)
    }
}

main();
