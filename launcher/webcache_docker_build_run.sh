
echo '-------------------------------------------------------------------------------------------'
echo '[NOTE] Launching Slimpogrine webcache conatiner'
echo '-------------------------------------------------------------------------------------------'

docker build --tag 'ghcr.io/orx0815/slimpogrine_webcache:latest' ../docker/webcache
#docker volume create slimpogrine-volume
docker run -t -i -p 80:80  -v slimpogrine-volume:/opt/sling/launcher --env RENDERER_URL=172.17.0.1 --env AUTHOR_URL=172.17.0.1 ghcr.io/orx0815/slimpogrine_webcache:latest
