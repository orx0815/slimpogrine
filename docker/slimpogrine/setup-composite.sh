#!/bin/bash

SLING_USERNAME="${SLING_USERNAME:-admin}"
SLING_PASSWORD="${SLING_PASSWORD:-admin}"

echo "Creating composite seed..."
java \
    -Dsling.run.modes=composite-seed,${RUNMODE} \
    -jar org.apache.sling.feature.launcher.jar \
    -f /opt/slingcms/setup/${CMS_ARTIFACT_ID}-${FM_SEED_CLASSIFIER}.slingosgifeature \
    -f /opt/slingcms/features/*.slingosgifeature &
SLING_PID=$!
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
    rm -rf /opt/slingcms/launcher/framework /opt/slingcms/launcher/logs \
        /opt/slingcms/launcher/repository /opt/slingcms/launcher/resources \
        /opt/slingcms/setup
    ln -s /opt/slingcms/launcher/composite/repository-libs/segmentstore \
        /opt/slingcms/launcher/composite/repository-libs/segmentstore-composite-mount-libs
fi
echo "Repository seeded successfully!"