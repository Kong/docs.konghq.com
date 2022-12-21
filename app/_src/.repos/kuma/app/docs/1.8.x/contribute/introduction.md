---
title: Contribute
---

There are multiple ways to make an impact in Kuma

## Community

You can join the slack channel or the community meetings as shown in the [community section](/community).

## Documentation

You can edit this documentation. To do so checkout [the getting started doc](https://github.com/kumahq/kuma-website/blob/master/CONTRIBUTING.md).

## Core Code

Most of Kuma is in Go. Checkout the [contributing](https://github.com/kumahq/kuma/blob/master/CONTRIBUTING.md) documentation on how to get started.

## GUI Code

The UI is in Vuejs and Checkout the [repo](https://github.com/kumahq/kuma-gui/blob/master/DEVELOPER.md) to see how to contribute.

## Testing unreleased versions

Kuma publishes new binaries for every commit.
There's a small script to download the latest version:

```shell
curl https://kuma.io/preview.sh | sh -
```

{% tip %}
If you already know the version you can use the installer:

```shell
curl https://kuma.io/installer.sh | VERSION=kuma-0.0.0-preview.4d3a9fd03 sh -
```

{% endtip %}

It outputs:

```shell
Getting release

INFO	Welcome to the Kuma automated download!
INFO	Kuma version: 0.0.0-preview.4d3a9fd03
INFO	Kuma architecture: amd64
INFO	Operating system: Darwin
INFO	Downloading Kuma from: https://download.konghq.com/mesh-alpine/kuma-0.0.0-preview.4d3a9fd03-darwin-amd64.tar.gz
```

You then run kumactl with:

```shell
./kuma-0.0.0-preview.4d3a9fd03/bin/kumactl
```

Note that the version contains the commit short-hash which is useful if you open issues.
