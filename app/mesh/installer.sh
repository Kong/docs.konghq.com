#!/bin/sh

# Copyright 2019-2020 Kong Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# You can customize the version of Kuma (or Kuma-based products) to
# download by setting the VERSION environment variable, and you can change
# the default 64bit architecture by setting the ARCH variable.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

: "${VERSION:=}"
: "${ARCH:=amd64}"

PRODUCT_NAME="Kong Mesh"
LATEST_VERSION=https://docs.konghq.com/mesh/latest_version/
REPO_PREFIX="kong-mesh"

printf "\n"
printf "INFO\tWelcome to the $PRODUCT_NAME automated download!\n"

if ! type "grep" > /dev/null 2>&1; then
  printf "ERROR\tgrep cannot be found\n"
  exit 1;
fi
if ! type "curl" > /dev/null 2>&1; then
  printf "ERROR\tcurl cannot be found\n"
  exit 1;
fi
if ! type "tar" > /dev/null 2>&1; then
  printf "ERROR\ttar cannot be found\n"
  exit 1;
fi
if ! type "gzip" > /dev/null 2>&1; then
  printf "ERROR\tgzip cannot be found\n"
  exit 1;
fi

DISTRO=""
OS=`uname -s`
if [ "$OS" = "Linux" ]; then
  DISTRO=$(grep -oP '(?<=^ID=).+' /etc/os-release | tr -d '"')
  if [ "$DISTRO" = "amzn" ]; then
    DISTRO="centos"
  fi
elif [ "$OS" = "Darwin" ]; then
  DISTRO="darwin"
else
  printf "ERROR\tOperating system %s not supported by $PRODUCT_NAME\n" "$OS"
  exit 1
fi

if [ -z "$DISTRO" ]; then
  printf "ERROR\tUnable to detect the operating system\n"
  exit 1
fi

if [ -z "$VERSION" ]; then
  # Fetching latest version
  printf "INFO\tFetching latest $PRODUCT_NAME version..\n"
  VERSION=`curl -s $LATEST_VERSION`
  if [ $? -ne 0 ]; then
    printf "ERROR\tUnable to fetch latest $PRODUCT_NAME version.\n"
    exit 1
  fi
  if [ -z "$VERSION" ]; then
    printf "ERROR\tUnable to fetch latest $PRODUCT_NAME version because of a problem with $PRODUCT_NAME.\n"
    exit 1
  fi
fi

printf "INFO\t$PRODUCT_NAME version: %s\n" "$VERSION"
printf "INFO\t$PRODUCT_NAME architecture: %s\n" "$ARCH"
printf "INFO\tOperating system: %s\n" "$DISTRO"

URL="https://kong.bintray.com/$REPO_PREFIX/$REPO_PREFIX-$VERSION-$DISTRO-$ARCH.tar.gz"

if ! curl -s --head $URL | head -n 1 | grep "HTTP/1.[01] [23].." > /dev/null; then
  printf "ERROR\tUnable to download $PRODUCT_NAME at the following URL: %s\n" "$URL"
  exit 1
fi

printf "INFO\tDownloading $PRODUCT_NAME from: %s" "$URL"
printf "\n\n"

if curl -L "$URL" | tar xz; then
  printf "\n"
  printf "INFO\t$PRODUCT_NAME %s has been downloaded!\n" "$VERSION"
  printf "\n"
  printf "%s" "$(<$DIR/$REPO_PREFIX-$VERSION/README)"
  printf "\n"
else
  printf "\n"
  printf "ERROR\tUnable to download $PRODUCT_NAME\n"
  exit 1
fi
