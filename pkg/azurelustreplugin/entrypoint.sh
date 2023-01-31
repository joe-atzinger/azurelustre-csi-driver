#!/bin/bash

# Copyright 2022 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# Shell script to bootstrap the CSI into the host system.
# We do this because we can have multiple host systems, and Lustre
# needs to escape the host container in order to function properly.
# That means the container environment needs to match the host.
#

set -o xtrace
set -o errexit
set -o pipefail
set -o nounset

HOST_PATH=/host/usr/local/azurelustrecsi

if [[ -d "${HOST_PATH}" ]]; then
  rm -rf "${HOST_PATH}"
fi

mkdir -p "${HOST_PATH}"
cp /app/* "${HOST_PATH}"

echo "Changing root to /host"
chroot /host /bin/bash << EOF
cd "${HOST_PATH}"
./csi_entrypoint.sh ${1-} ${2-} ${3-} ${4-}
EOF
