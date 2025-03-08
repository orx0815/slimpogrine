#!/bin/bash

if [[ $0 == *":\\"* ]]; then
  DISPLAY_PAUSE_MESSAGE=true
fi

# https://github.com/wcm-io/io.wcm.maven.plugins.wcmio-content-package-maven-plugin/blob/develop/src/it/sling-composum-upload-download/pom.xml#L192
# echo "Download not support for Composum yet with wcmio-content-package:download. Using curl. You need to manually rebuild package in http://localhost:8080/bin/packages.html/motorbrot-samples/slimpogrine-sample-content-sligrine-1.0-SNAPSHOT.zip"
# curl -u admin:admin 'http://localhost:8080/bin/cpm/package.download.zip/motorbrot-samples/slimpogrine-sample-content-sligrine-1.0-SNAPSHOT.zip' --output slimpogrine-sample-content-sligrine-1.0-SNAPSHOT.zip
# unzip -o slimpogrine-sample-content-sligrine-1.0-SNAPSHOT.zip
# rm slimpogrine-sample-content-sligrine-1.0-SNAPSHOT.zip

mvn package -Dvault.unpack=true wcmio-content-package:download

if [ "$DISPLAY_PAUSE_MESSAGE" = true ]; then
  echo ""
  read -n1 -r -p "Press any key to continue..."
fi
