# How to use overlays to transform an API spec

The function of overlays is to apply a transformation to an API spec. The files in this directory are used to transform the Kong Gateway EE and OSS API specs. We are using overlays to decouple docs changes from the auto-generated API spec. 


## Installation

We are using this [project](https://github.com/lornajane/openapi-overlays-js) for generation:

* Clone [this](https://github.com/lornajane/openapi-overlays-js) repo, `cd` into the directory where you cloned it. 
* Run `npm install` to get the dependencies
* Run `npm install -g` to get `overlayjs` as a command


## Apply a transformation

To apply an overlay to a spec use the following command: 

`overlayjs --openapi openapi.yml --overlay overlay.yaml`

This will output the changed version to the console, then you can pipe it to a new file like:

` overlayjs --openapi openapi.yml --overlay overlay.yaml >> newfile.yaml `

That new file will be a complete and transformed API spec. Ideally this output is what is uploaded to the dev portal. 