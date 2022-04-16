#!/bin/bash
# Copyright © 2022 Dimitri Prosper <dimitri_prosper@us.ibm.com>

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -euo pipefail
set -o errexit

set +o errexit
ibmcloud code-engine project create --name "$CE_PROJECT_NAME" --no-select
[ $? -ne 0 ] && echo "Error during project create" \
&& ibmcloud code-engine project delete --name "$CE_PROJECT_NAME" --force --hard \
&& exit 1

ibmcloud code-engine project select --name "$CE_PROJECT_NAME"
[ $? -ne 0 ] && echo "Error during project select" && exit 1
set -o errexit

p_registry_secret=""
if [ ! -z "${REGISTRY_USER}" ] && [ ! -z "${REGISTRY_PASSWORD}" ] ; then
  set +o errexit
  ibmcloud code-engine registry create \
  --name "$CE_REGISTRY_SECRET" \
  --server "$REGISTRY" \
  --username "$REGISTRY_USER" \
  --password "$REGISTRY_PASSWORD"
  [ $? -ne 0 ] && echo "Error during registry secret create" && exit 1
  set -o errexit

  p_registry_secret="--registry-secret $CE_REGISTRY_SECRET"
fi

# Reads and write configmaps to Code Engine from icce-project-config.json, skips if empty.
p_mount_configmap=""
if [ -f .github/workflows/icce-project-config.json ]; then
  if jq -e . .github/workflows/icce-project-config.json >/dev/null 2>&1; then
    configmaps=$(jq -c '.configmapsfromfile[]?' .github/workflows/icce-project-config.json)
    for configmap in $configmaps; do
      name=$(echo ${configmap} | jq -r '.name | select (.!=null)')
      file=$(echo ${configmap} | jq -r '.file | select (.!=null)')
      path=$(echo ${configmap} | jq -r '.path | select (.!=null)')

      set +o errexit
      ibmcloud code-engine configmap create --name "$name" --from-file "$file"
      [ $? -ne 0 ] && echo "Error during configmap create" && exit 1
      set -o errexit

     p_mount_configmap="--mount-configmap $path=$name"
    done
  else
    echo "Failed to create configmap from icce-project-config.json, either the file failed json parsing or something else went wrong." && exit 1
  fi
fi

set +o errexit
ibmcloud code-engine app create \
--name "$CE_APP_NAME" \
--image "$IMAGE" \
--port "$APP_PORT" \
${p_registry_secret} \
${p_mount_configmap} \
--wait \
--wait-timeout 120
[ $? -ne 0 ] && echo "Error encountered during app create, printing events and logs from deployment." \
&& events=$(ibmcloud ce application events -n "$CE_APP_NAME") \
&& echo "::set-output name=events::$events" \
&& logs=$(ibmcloud ce application logs -n "$CE_APP_NAME") \
&& echo "::set-output name=logs::$logs" \
&& ibmcloud code-engine project delete --name "$CE_PROJECT_NAME" --force --hard \
&& exit 1

app_url=$(ibmcloud code-engine app get --name "$CE_APP_NAME" --output json | jq -r '.status.url')
[ $? -ne 0 ] && echo "Error obtaining app url" && exit 1
set -o errexit

echo "::set-output name=url::$app_url"

exit 0