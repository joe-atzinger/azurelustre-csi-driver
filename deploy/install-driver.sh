#!/bin/bash

# Copyright 2020 The Kubernetes Authors.
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
set -o xtrace
set -euo pipefail

echo "Installing Azure Lustre CSI driver"
kubectl apply -f deploy/csi-azurelustre-driver.yaml
kubectl create -f docs/examples/storageclass_existing_lustre.yaml
kubectl create -f docs/examples/pvc_storageclass.yaml

kubectl apply -f deploy/rbac-csi-azurelustre-controller.yaml
kubectl apply -f deploy/rbac-csi-azurelustre-node.yaml
kubectl apply -f deploy/csi-azurelustre-controller.yaml
kubectl apply -f deploy/csi-azurelustre-node.yaml

kubectl rollout status deployment csi-azurelustre-controller -nkube-system --timeout=300s
kubectl rollout status daemonset csi-azurelustre-node -nkube-system --timeout=1800s
echo 'Azure Lustre CSI driver installed successfully.'

kubectl apply -f deploy/example/echodate/echo.yml
