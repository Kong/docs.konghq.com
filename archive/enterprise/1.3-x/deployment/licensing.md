---
title: Kong Enterprise Licensing
---

## Overview
Kong Enterprise enforces the presence and validity of a license file. 

License files must be deployed to each node running Kong Enterprise. License file checking is done independently by each node as the Kong process starts; no network connectivity is necessary to execute the license validation process.

## Deploying the License File
There are three possible ways to configure a license file on a Kong node. These are defined below, in the order in which they are checked by Kong:

1. If present, the contents of the environmental variable `KONG_LICENSE_DATA` are used.
2. Kong will search in the default location `/etc/kong/license.json`
3. If present, the contents of the file defined by the environment variable `KONG_LICENSE_PATH` is used.

In this manner, the license file can be deployed either as a file on the node filesystem, or as an environmental variable. 

Note that unlike most other `KONG_*` environmental variables, the `KONG_LICENSE_DATA` and `KONG_LICENSE_PATH` cannot be defined in-line as part of any `kong` CLI commands. The reason for this is that the `kong` CLI tool is a wrapper script to generate an Nginx config and launch the Nginx process using the existing shell. That is, the Nginx process that accepts proxy traffic is spawned as a child of the shell in which the `kong` CLI process is run, not as a child of the `kong` CLI process itself, and thus in-line environmental variables are not made available to the Nginx process. Thus, license file environmental variables must be exported to the shell in which the Nginx process will run, ahead of the `kong` CLI tool.

## Examining the License Data on a Kong Node
License data is displayed as part of the root (`"/"`) Admin API endpoint, under the `license` JSON key. It is also visible in the Admin GUI.

## Troubleshooting
When a valid license file is properly deployed, license file validation is a transparent operation; no additional output or logging data is written or provided. If an error occurs when attempting to validate the license, or the license data is not valid, an error message will be written to the console and logged to the Kong error log, followed by the process quitting. Below are possible error messages and troubleshooting steps to take:

- "license path environment variable not set" 
  - Neither the `KONG_LICENSE_DATA` nor the `KONG_LICENSE_PATH` environmental variables were defined, and no license file could be opened at the default license location (`/etc/kong/license.json`)
- "internal error"
  - An internal error has occurred while attempting to validate the license. Such cases are extremely unlikely; contact Kong support to further troubleshoot.
- "error opening license file"
  - The license file defined either in the default location, or using the `KONG_LICENSE_PATH` env variable, could not be opened. Check that the user executing the Nginx process (e.g., the user executing the Kong CLI utility) has permissions to read this file.
- "error reading license file"
  - The license file defined either in the default location, or using the `KONG_LICENSE_PATH` env variable, could be opened, but an error occurred while reading. Confirm that the file is not corrupt, that there are no kernel error messages reported (e.g., out of memory conditions, etc). This is a generic error and is extremely unlikely to occur if the file could be opened.
- "could not decode license json"
  - The license file data could not be decoded as valid JSON. Confirm that the file is not corrupt and has not been altered since you received it from Kong Inc. Try re-downloading and installing your license file from Kong Inc. 
    - if you still receive this error, contact Kong support.
- "invalid license format"
  - The license file data is missing one or more key/value pairs. Confirm that the file is not corrupt and has not been altered since you received it from Kong Inc. Try re-downloading and installing your license file from Kong Inc. 
    - if you still receive this error, contact Kong support.
- "validation failed"
  - The attempt to verify the payload of the license with the license's signature failed. Confirm that the file is not corrupt and has not been altered since you received it from Kong Inc. Try re-downloading and installing your license file from Kong Inc. 
    - if you still receive this error, contact Kong support.
- "license expired"
  - The system time is past the license's license_expiration_date. Note that Kong Enterprise provides 1-2 days worth of slack time past the license expiration date before failing to validate with this error, to account for timezone discrepancies, human error, etc.
- "invalid license expiration date"
  - The data in the license_expiration_date field is incorrectly formatted. Try re-downloading and installing your license file from Kong Inc. 
    - if you still receive this error, contact Kong support.
- License expiration logs: Kong will start logging the license  expiration date once a day—with a WARN log—90 days before the expiry; 30 days before, the log severity increases to ERR, and after expiration, it to CRIT.
