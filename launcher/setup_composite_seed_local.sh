#!/bin/bash -e
echo '-------------------------------------------------------------------------------------------'
echo '[SETUP] slimpogrine_composite_seed'
echo '-------------------------------------------------------------------------------------------'

SLING_USERNAME=admin
SLING_PASSWORD=admin

mvn clean package -Ddocker.skip=false

feature_name="slimpogrine_composite_seed"
feature=$(find ./target/artifacts -name "*${feature_name}*.slingosgifeature")

if [[ ! -f "${feature}" ]]; then
    echo "[ERROR] Did not find any feature file matching name ${feature_name}. Aborting"
    exit 1
fi

docker_feature=$(find ./target/artifacts -name "*docker.slingosgifeature")

echo "[INFO] Selected ${feature} for launching"
echo "[INFO] Automatically appended ${docker_feature}"

feature="${feature},${docker_feature}"

if [ ! -z "${JAVA_DEBUG_PORT}" ]; then
    JAVA_DEBUG_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:${JAVA_DEBUG_PORT}"
fi
# remove add-opens after SLING-10831 is fixed
JAVA_OPTS="--add-opens java.base/java.lang=ALL-UNNAMED ${JAVA_DEBUG_OPTS} ${EXTRA_JAVA_OPTS}"

export JAVA_OPTS
echo "[INFO] JAVA_OPTS=${JAVA_OPTS}"

exec ./target/dependency/org.apache.sling.feature.launcher/bin/launcher \
    -c ./target/artifacts \
    -CC "org.apache.sling.commons.log.LogManager=MERGE_LATEST" \
    -f ${feature} \
    & SLING_PID=$!

echo "Sling PID: ${SLING_PID}"

sleep 30s
STARTED=1
for i in {1..20}; do
    echo "[${i}/20]: Checking to see if started with username: ${SLING_USERNAME}..."
    STATUS=$(curl -4 -s -o /dev/null -w "%{http_code}" -u${SLING_USERNAME}:${SLING_PASSWORD} "http://localhost:8080/system/health.txt?tags=systemalive")
    echo "Retrieved status: ${STATUS}"
    if [ $STATUS -eq 200 ]; then
        STARTED=0
        break
    fi
    sleep 30s
done
sleep 30s
kill $SLING_PID
echo "Waiting for instance to stop..."

sleep 30s

if [ $STARTED -eq 1 ]; then
    echo "Failed to seed sling repository!"
    exit 2
else
    echo "Cleaning up seeding..."
    rm -rf ./launcher/framework ./launcher/logs \
        ./launcher/repository ./launcher/resources
    ln -s `pwd`/launcher/composite/repository-libs/segmentstore `pwd`/launcher/composite/repository-libs/segmentstore-composite-mount-libs
fi
echo "Repository seeded successfully!"

exit 0


#docker volume create slimpogrine-launcher
#docker run -p 8080:8080 -v slimpogrine-launcher:/opt/sling/launcher ghcr.io/orx0815/slimpogrine:snapshot
