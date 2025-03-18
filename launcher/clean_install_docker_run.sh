
echo '-------------------------------------------------------------------------------------------'
echo '[NOTE] Launching Slimpogrine docker conatiner with composite node-store. Persistent volume slimpogrine-launcher for repository-global '
echo '-------------------------------------------------------------------------------------------'

# docker run -p 8080:8080 -v /tmp/sling:/opt/sling/sling apache/sling:12

mvn clean package -Ddocker.skip=false
docker run -p 8080:8080 --rm -v slimpogrine-volume:/opt/sling/launcher ghcr.io/orx0815/slimpogrine:snapshot
