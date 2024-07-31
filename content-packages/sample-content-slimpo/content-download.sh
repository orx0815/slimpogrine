#!/bin/bash

if [[ $0 == *":\\"* ]]; then
  DISPLAY_PAUSE_MESSAGE=true
fi

echo "Not worky on wcmio-content-package:download. Tying curl. Manually rebuild package in /bin/packages.html/motorbrot-samples/slimpogrine-sample-content-slimpo-1.0-SNAPSHOT.zip"

# curl -u admin:admin  --data-raw 'event.job.topic=com%2Fcomposum%2Fsling%2Fcore%2Fpckgmgr%2FPackageJobExecutor&reference=%2Fmotorbrot-samples%2Fslimpogrine-sample-content-1.0-SNAPSHOT.zip&_charset_=UTF-8&operation=assemble&overridePath=%2Fmotorbrot-samples%2Fslimpogrine-sample-content-1.0-SNAPSHOT.zip'

curl -u admin:admin 'http://localhost:8080/bin/cpm/package.download.zip/motorbrot-samples/slimpogrine-sample-content-slimpo-1.0-SNAPSHOT.zip' --output slimpogrine-sample-content-slimpo-1.0-SNAPSHOT.zip
unzip -o slimpogrine-sample-content-slimpo-1.0-SNAPSHOT.zip
rm slimpogrine-sample-content-slimpo-1.0-SNAPSHOT.zip

#mvn package -Dvault.unpack=true wcmio-content-package:download

if [ "$DISPLAY_PAUSE_MESSAGE" = true ]; then
  echo ""
  read -n1 -r -p "Press any key to continue..."
fi
