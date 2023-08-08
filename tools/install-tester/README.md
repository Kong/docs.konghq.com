# Install Tester

This is a tool that scrapes our installation documentation and uses `docker` to ensure that the packages install as expected.

## Why does it exist?

Our install docs should always work. That's where everyone starts on the docs.

Why now? I needed to test the following matrix of combinations whilst moving to a new package hosting platform:

(2.6, 2.7, 2.8, 3.0, 3.1, 3.2, 3.3) x (Ubuntu, Debian, RHEL, Amazon Linux, CentOS[2.x only]) x (OSS, EE) x (Package, Repository) = 140 combinations

## How it works

1. Read `kong_versions.yml` to build a list of versions to test
2. Use `ce-version` and `ee-version` to set expected output (the test runs `kong version` to ensure the package installed correctly)
3. For each version, loop through each OS
4. Fetch the docs URL for that OS. Extract the codeblocks for (OSS, EE) x (Package, Repository)
5. Create a docker container for each OS
6. Set up the initial environment (install `sudo`, create a non-root user etc)
7. Run the commands that were fetched earlier
8. Run `kong version`
9. Assert that the message matches the expected version from `kong_versions.yml`

## How to run it

Run `make run` in another terminal.

In the current directory:

> This will run a LOT of tests (all 140, in fact). There is a way to run fewer tests that which will be shown later

```bash
npm ci
node index.js
```

You can run a specific `DISTRO`, `METHOD`, `VERSION` or `PACKAGE` e.g.:

* `DISTRO=ubuntu,rhel METHOD=package VERSION=2.8.x,3.3.x PACKAGE=enterprise node index.js` runs a specific set of tests
* `DISTRO=amazon-linux node index.js` runs all versions, both EE and OSS, via package and repository install

You may also want to add `IGNORE_SKIPS=1 CONTINUE_ON_ERROR=1` if running multiple tests.

## Debugging

When a test runs, it writes a file in `./output` in the format `version-distro-package-method.txt`. This contains the exact command run at the top, plus any output. You can run the command then attach to the running docker image to explore the environment

If you see a failure, you can run that specific combination using the `ONLY` parameter:

```bash
ONLY=2.8.x/ubuntu/oss/package node index.js
```

## False positives

Some of the failures are due to external hosting issues and not the docs site. The `expected-failures.yaml` file allows you to mark specific tests as expected to fail. 

By default expected failures do not fail the build. Set `EXPECTED_FAILURES_EXIT_CODE=1` to make it a failure.