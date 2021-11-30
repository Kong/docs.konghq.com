<!-- Version compatibility and download instructions for Brain and Immunity
which is located in the install-configure.md file in the immuntiy folder -->

{% if include.version == "1.5-2.1" %}
## Version Compatibility
Kong Immunity follows a different versioning scheme from Kong Enterprise. Note the following:
* The Immunity version reflects the `kong/immunity` package available on Docker Hub.
* For Kong Enterprise 1.5.x and 2.1.x, use Immunity 4.x.x.
* Do not use Brain and Immunity 2.x.x or 3.x.x as they are end-of-life (EOL).

## Install Brain and Immunity on Kubernetes
Set up the Collector App via Helm. Use the public helm chart for setting up the Collector App and all its dependencies on Kubernetes. Instructions for setup can be found on the public repo at: [https://github.com/Kong/kong-collector-helm/blob/master/README.md](https://github.com/Kong/kong-collector-helm/blob/master/README.md).

## Install Brain and Immunity on Docker
Install Brain and Immunity by downloading, installing and starting the Collector App on Docker, as defined in this section. After installing the Collector App, you will enable the Collector Plugin to access Brain and Immunity on Kong Enterprise.

### Prerequisites
To complete this installation you will need:

* A Docker-enabled system with proper Docker access.

* Kong Enterprise 1.5.x or later is installed on Docker.

* A valid [Kong Enterprise License](/enterprise/{{include.kong_version}}/deployment/access-license/) JSON file, including a license for Immunity.

### Step 1. Pull the Kong Brain and Kong Immunity Docker Image

1. Pull the Kong Brain and Kong Immunity Docker image.
```bash
$ docker pull kong/immunity:4.1.0
```
You should now have your Kong Brain and Kong Immunity image locally.

2. Verify that you have the Docker image. Find the image ID matching your repository:
```bash
$ docker images
```
3. Tag the image ID as `kong-bi` for easier use. Replace `<IMAGE_ID>` with the image ID matching your repository.
```bash
$ docker tag <IMAGE_ID> kong-bi
```
{% endif %}

{% if include.version == ">2.1" %}
## Version Compatibility
Immunity follows a different versioning scheme from {{site.base_gateway}}. The Immunity version reflects the `kong/immunity` package available on Docker Hub.
For {{site.base_gateway}} 2.1.x and above, use Immunity 4.x.x.

{:.warning}
> **Warning:** Kong Immunity is not compatible with {{site.base_gateway}} v2.4.x.

## Install Immunity on Kubernetes
Set up the Collector App via Helm. Use the public helm chart for setting up the Collector App and all its dependencies on Kubernetes. Setup instructions can be found on the public repo at: [https://github.com/Kong/kong-collector-helm/blob/master/README.md](https://github.com/Kong/kong-collector-helm/blob/master/README.md).

## Install Immunity on Docker
Install Immunity by downloading, installing and starting the Collector App on Docker, as defined in this section. After installing the Collector App, you will enable the Collector Plugin to access Immunity on {{site.base_gateway}}.

### Prerequisites
To complete this installation you will need:

* A Docker-enabled system with proper Docker access.

* {{site.base_gateway}} 2.2.x or later is installed on Docker.

* A valid [{{site.base_gateway}} License](/enterprise/{{include.kong_version}}/deployment/access-license/) JSON file, including a license for Immunity.

### Step 1. Pull the Immunity Docker image

1. In a terminal window, pull the Kong Immunity Docker image.
```bash
$ docker pull kong/immunity:4.1.0
```
You should now have your Kong Immunity image locally.

3. Verify that you have the Docker image. Find the image ID matching your repository:
```bash
$ docker images
```
4. Tag the image ID as `kong-immunity`. Replace `<IMAGE_ID>` with the image ID matching your repository.
```bash
$ docker tag <IMAGE_ID> kong-immunity
```
{% endif %}
