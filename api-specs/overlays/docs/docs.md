# How to use overlays




## Installation

We are using this [project](https://github.com/lornajane/openapi-overlays-js) for generation:

* Clone [this](https://github.com/lornajane/openapi-overlays-js) repo
* Run `npm install` to get the dependencies
* Run `npm install -g` to get `overlayjs` as a command


## Apply an overlay

To apply an overlay to a spec use the following command: 

`overlayjs --openapi openapi.yml --overlay overlay.yaml`

This will output the changed version to the console, then you can pipe it to a new file like:

` overlayjs --openapi openapi.yml --overlay overlay.yaml >> newfile.yaml `