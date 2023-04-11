## Installation
The installation of ArecaBay's Kong Plugin and the corresponding ArecaBay components is extremely simple and easy. It involves the following two steps:
1. Install and setup ArecaBay's Kong Plugin
2. Access ArecaBay Cloud Webconsole and configure ArecaBay Kong Plugin as a MicroSensor

### Install and setup ArecaBay's Kong Plugin
Install the ArecaBay's Kong plugin (ab-microsensor) on each node in your Kong cluster via luarocks. As this plugin source is already hosted in Luarocks.org, please run the below command:

```
luarocks install kong-plugin-ab-microsensor
```

Add to the custom_plugins list in your Kong configuration (on each Kong node):

```
custom_plugins = ab-microsensor
```

### Access ArecaBay Cloud Webconsole and setup LocalBay
Please visit the [Partners page](https://www.arecabay.com/partners/kong) and request your ArecaBay Cloud Webconsole account. Follow the quickstart guide within the Webconsole to configure your Kong Plugin as a MicroSensor. This involves providing details for the Kong Plugin MicroSensor and downloading the setup script. Run the setup script which internally uses the Kong Admin API to configure & run the Kong Plugin as a global plugin.  

