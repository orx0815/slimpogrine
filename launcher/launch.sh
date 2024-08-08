#!/bin/sh -eu
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

echo '-------------------------------------------------------------------------------------------'
echo '[NOTE] Launching application, this will fail if you did not build the project at least once'
echo '[NOTE] Remove the launcher folder to throw away local changes'
echo '-------------------------------------------------------------------------------------------'

# Feature slimpogrine_composite_runtime after setup_composite_seed_local.sh fails to start composum-pages.commons package
# (because of oak:indexes in there?)

feature_name="slimpogrine_oak_tar"  
feature=$(find ./target/artifacts -name "*${feature_name}*.slingosgifeature")

if [[ ! -f "${feature}" ]]; then
    echo "[ERROR] Did not find any feature file matching name ${feature_name}. Aborting"
    exit 1
fi

docker_feature=$(find ./target/artifacts -name "*docker.slingosgifeature")
feature="${feature},${docker_feature}"

# remove add-opens after SLING-10831 is fixed
JAVA_OPTS="--add-opens java.base/java.lang=ALL-UNNAMED"

export JAVA_OPTS
echo "[INFO] JAVA_OPTS=${JAVA_OPTS}"

exec ./target/dependency/org.apache.sling.feature.launcher/bin/launcher \
    -c ./target/artifacts \
    -CC "org.apache.sling.commons.log.LogManager=MERGE_LATEST" \
    -f ${feature}

#./target/dependency/org.apache.sling.feature.launcher/bin/launcher -f target/slingfeature-tmp/feature-slimpogrine_composite_runtime.json
#./target/dependency/org.apache.sling.feature.launcher/bin/launcher -f target/slingfeature-tmp/feature-slimpogrine_composite_seed.json
#./target/dependency/org.apache.sling.feature.launcher/bin/launcher -f target/slingfeature-tmp/feature-slimpogrine_oak_tar.json

