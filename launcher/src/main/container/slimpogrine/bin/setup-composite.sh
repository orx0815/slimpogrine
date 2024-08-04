#!/bin/bash

SLING_USERNAME="${SLING_USERNAME:-admin}"
SLING_PASSWORD="${SLING_PASSWORD:-admin}"

echo "Creating composite seed..."

/opt/sling/bin/launch.sh slimpogrine_composite_seed & SLING_PID=$!

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
    rm -rf /opt/sling/launcher/framework /opt/sling/launcher/logs \
        /opt/sling/launcher/repository /opt/sling/launcher/resources \
        /opt/sling/setup
    ln -s /opt/sling/launcher/composite/repository-libs/segmentstore \
        /opt/sling/launcher/composite/repository-libs/segmentstore-composite-mount-libs
fi
echo "Repository seeded successfully!"