#!/bin/sh

# Copyright 2019-2022 Kong Inc.
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

curl -L https://kuma.io/installer.sh | \
  PRODUCT_NAME="Kong Mesh" \
  REPO="kong/kong-mesh" \
  LATEST_VERSION="https://docs.konghq.com/mesh/latest_version/" \
  sh -s - "$@"
