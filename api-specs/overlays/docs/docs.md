# How to use overlays to transform an API spec

The function of overlays is to apply a transformation to an API spec. The files in this directory are used to transform the Kong Gateway EE and OSS API specs. We are using overlays to decouple docs changes from the auto-generated API spec. 


## Installation

We are using this [project](https://github.com/lornajane/openapi-overlays-js) for generation:

1. Clone the [openapi-overlays-js](https://github.com/lornajane/openapi-overlays-js) repo, `cd` into the directory where you cloned it. 
2. Run `npm install` to get the dependencies
3. Run `npm install -g` to get `overlayjs` as a command


## Apply a transformation

To apply an overlay to a spec use the following command. It will output the changed version to the console, then pipe it to a new file:

`overlayjs --openapi openapi.yml --overlay overlay.yaml >> newfile.yaml`

For example:

`overlayjs --openapi api-specs/Gateway-EE/3.4/kong-ee-3.4.yaml --overlay api-specs/overlays/ee/tag-descriptions.yaml >> api-specs/Gateway-EE/newspec.yaml`


The command will pipe the output to a new file that will become the new API spec with the changes from the overlay applied. The new spec should be uploaded to the Dev Portal for consumption.