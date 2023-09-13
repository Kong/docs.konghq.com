## Konnect OAS data

In order to render the OAS definitions in the docs, the products Ids in Konnect
and their versions need to be available at build time so that the Vue.js
application can make the corresponding API calls to Konnect Portal.

This script writes the data into `app/_data/konnect_oas_data.json`.

### Install dependencies

From the root of the repo run, open a terminal and run

```bash
cd tools/konnect-oas-data-generator
npm ci
```

### Running the script

From the tool folder, run:

```bash
node run.js --url <konnect_portal_url>
```
