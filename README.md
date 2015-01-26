#SRT Utility#

> Parses and plays subtitle (SRT) files

##Setup##
Install the required node packages for both development and testing:

    npm install
   
##Development##
This package uses **gulp** to build a simple web interface for loading and playing SRT files. Sample SRT files can be found under `tests/fixtures`. **gulp** builds to a folder called `web-player`, which contains an `index.html` file that can be opened locally on any modern browser.

	gulp build

Run `gulp` for a continous watch task.

##Testing##
The test suite is built on Mocha & Chai, and uses Karma as a test runner, therefore you need to install the Karma CLI to run the tests.

	npm install -g karma-cli

Once the Karma CLI is installted, run the test suite with

	npm test
