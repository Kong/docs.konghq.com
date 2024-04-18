---
title: Installation
tag: how-to
---

decK is entirely written in Go. The build process builds a single static binary,
which makes it easy and convenient to install decK.

## Prerequisites
You have installed {{site.ce_product_name}} >= 1.x or
{{site.ee_product_name}} >= 0.35.

You can follow along installation instructions based on your
Operating System (OS):

## macOS

If you are on macOS, install decK using brew:

1. Tap the `kong/deck` cask:
    ```shell
    brew tap kong/deck
    ```

2. Install decK:
    ```sh
    brew install deck
    ```

To update decK to the latest version:

```sh
brew upgrade deck
```

## Linux

If you are Linux, you can either use the Debian or RPM archive from
the Github [release page](https://github.com/kong/deck/releases)
or install by downloading a compressed archive, which contains the binary:

```shell
$ curl -sL https://github.com/kong/deck/releases/download/v{{page.version}}/deck_{{page.version}}_linux_amd64.tar.gz -o deck.tar.gz
$ tar -xf deck.tar.gz -C /tmp
$ sudo cp /tmp/deck /usr/local/bin/
```

## Windows

If you are on Windows, you can either use the compressed archive from
the Github [release page](https://github.com/kong/deck/releases)
or install using **CMD** by entering the target installation folder and downloading a compressed archive, which contains the binary:

```shell
curl -sL https://github.com/kong/deck/releases/download/v{{page.version}}/deck_{{page.version}}_windows_amd64.tar.gz -o deck.tar.gz
mkdir deck
tar -xf deck.tar.gz -C deck
powershell -command "[Environment]::SetEnvironmentVariable('Path', [Environment]::GetEnvironmentVariable('Path', 'User') + [IO.Path]::PathSeparator + [System.IO.Directory]::GetCurrentDirectory() + '\deck', 'User')"
```

## Docker image

If your workflow requires a Docker image, then you can use `kong/deck` Docker
image from the official Docker hub:

```
docker pull kong/deck
```

You will have to mount the state files into the container as volumes so that
decK can read the files during diff/sync procedures.

If you're integrating decK into your CI system, you can either install decK
into the system itself, use the Docker based environment, or pull the binaries
from [Github](https://github.com/Kong/deck/releases) for each job.

## See also
For more information about how to manage decK using the Docker image, see [Run decK with Docker](/deck/{{page.release}}/guides/run-with-docker/).

