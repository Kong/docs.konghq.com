<!-- Version compatibility and download instructions for Brain and Immunity
which is located in the install-configure.md file in the immuntiy folder -->

{% if include.version == "1.5-2.1" %}
## Version Compatibility
Kong Brain and Kong Immunity follow a different versioning scheme from Kong Enterprise. See the table for version compatibility. Note the following:
* The Brain and Immunity version reflects the `kong/immunity` package available on Docker Hub.
* For Kong Enterprise 1.3.x, 1.5.x, and 2.1.x, use Brain and Immunity 3.0.0.
* Do not use Brain and Immunity 2.x.x, as it is end-of-life (EOL).

| Brain and Immunity Version       | Kong Enterprise Version |
|:---------------------------------|:------------------------|
| 3.0.0                            | 1.5.x, 2.1.x            |
| 2.x.x is EOL. Use 3.0.0 instead. | 1.5.x, 1.3.x                   |

## Install Brain and Immunity on Kubernetes
Set up the Collector App via Helm. Use the public helm chart for setting up the Collector App and all its dependencies on Kubernetes. Instructions for setup can be found on the public repo at: [https://github.com/Kong/kong-collector-helm/blob/master/README.md](https://github.com/Kong/kong-collector-helm/blob/master/README.md).

## Install Brain and Immunity on Docker
Install Brain and Immunity by downloading, installing and starting the Collector App on Docker, as defined in this section. After installing the Collector App, you will enable the Collector Plugin to access Brain and Immunity on Kong Enterprise.

### Prerequisites
To complete this installation you will need:

* A Docker-enabled system with proper Docker access.

* Kong Enterprise 1.5.x or later is installed on Docker.

* A valid [Kong Enterprise License](/enterprise/{{page.kong_version}}/deployment/access-license/) JSON file, including a license for Immunity.

### Step 1. Pull the Kong Brain and Kong Immunity Docker Image

1. Pull the Kong Brain and Kong Immunity Docker image.
```bash
$ docker pull kong/immunity:3.0.0
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
Immunity follows a different versioning scheme from Kong Enterprise, as defined in the version compatibility table below. The Immunity version reflects the `kong/immunity` package available on Docker Hub.

| Immunity Version                 | Kong Enterprise Version |
|:---------------------------------|:------------------------|
| 4.0.0                            | 2.2.x, 2.3.x, 2.4.x     |
| 3.0.0                            | 1.3.x, 1.5.x, 2.1.x            |

## Install Immunity on Kubernetes
Set up the Collector App via Helm. Use the public helm chart for setting up the Collector App and all its dependencies on Kubernetes. Setup instructions can be found on the public repo at: [https://github.com/Kong/kong-collector-helm/blob/master/README.md](https://github.com/Kong/kong-collector-helm/blob/master/README.md).

## Install Immunity on Docker
Install Immunity by downloading, installing and starting the Collector App on Docker, as defined in this section. After installing the Collector App, you will enable the Collector Plugin to access Immunity on Kong Enterprise.

### Prerequisites
To complete this installation you will need:

* A Docker-enabled system with proper Docker access.

* Kong Enterprise 2.2.x or later is installed on Docker.

* A valid [Kong Enterprise License](/enterprise/{{page.kong_version}}/deployment/access-license/) JSON file, including a license for Immunity.

### Step 1. Pull the Immunity Docker image

1. In a terminal window, pull the Kong Immunity Docker image.
```bash
$ docker pull kong/immunity:4.0.0
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
