
Slimpogrine = [SLIng][sli] + [coMPOsum][mpo] + [pereGRINE][grine]
====

[sli]: https://sling.apache.org
[mpo]: https://www.composum.com
[grine]: https://github.com/headwirecom/peregrine-cms

This repo builds a Sling™ application-server with the [OSGi Feature Model][fm].
It serves 3 example applications, a very basic one about templates plus two open-source CMS's. It comes as single micro-service (docker-image). 

[fm]: https://github.com/apache/sling-org-apache-sling-feature/blob/master/readme.md


# Run
## Docker
If docker is installed, easiest is to run the [slimpogrine image from dockerhub][1].

[1]: https://hub.docker.com/r/orx0815dockerhub/slimpogrine

```
docker run -p 8080:8080 -v slimpogrine-volume:/opt/sling/launcher orx0815dockerhub/slimpogrine
```

The admin's user:password is admin:admin. Some links on localhost:

[Peregrine-CMS start][peregrinecms] / [Peregrine sample-content][peregrinesample]   
[Composum start][composumtools] / [Composum_pages sample-content][composumsample]  
silly [reverse-css-zengarden][www]  
[OSGi Config-Manager][config] ...

[www]: http://localhost:8080/slimpogrine/home.html
[peregrinecms]: http://localhost:8080/admin/pages/index.html
[peregrinesample]: http://localhost:8080/content/admin/pages/pages/edit.html/path:/content/sligrine/pages/index
[composumtools]: http://localhost:8080/bin/browser.html
[composumsample]: http://localhost:8080/bin/pages.html/content/sites/slimpo/home  
[config]: http://localhost:8080/system/console/configMgr


### Gitpod
With a github account you can build and run the whole thing at gitpod.io. Just click here -> [![Try SliMpoGrine on Gitpod](https://img.shields.io/badge/Gitpod-Try%20SliMpoGrine%20CMS%20Online-0a4d2c?logo=gitpod)](https://gitpod.io/#https://github.com/orx0815/slimpogrine) and it will start a developer environment in the browser.  
Builds the project in the cloud somewhere and starts the server. Good way to confirm it not only "works on my machine".



# Build and run
## Requirements
Maven, Java 11 and 21

### Build peregine fork with Java 11
You need [this peregrine-cms fork](https://github.com/orx0815/peregrine-cms/tree/feature/bake_into_far).
(Only that has one content-package migrated to [Jackrabbit FileVault Package Maven Plugin](https://jackrabbit.apache.org/filevault-package-maven-plugin/) to make it work)
  
**In the peregrine-cms folder** run
```
    mvn clean install
```
__with Java 11__ to have the required artefacts in your local .m2 repo.  

**In this directory here run**  
```
    mvn clean install -Ddocker.skip=false
```  

There is an [example start-script](launcher/launch.sh)

## Content packages

In the folder content-packages there are two sample-content packages:
- slimpo (for the Composum part)
- sligrine (for the Peregrine part)

They are both part of the initial content of the application server, meaning changes in content will be overriden when deployed again. So both have a content-download.sh to sync changes back into sources. Long term goal is to have more documentation here.

## WebCache

In the docker/webcache directory is the setup to launch an apache2 webserver for anonymous access of published web-content.  
For testing on a local environment, add the following entries into your /etc/hosts file:

    127.0.0.1 slimpo.motorbrot.local  
    127.0.0.1 sligrine.motorbrot.local  
    127.0.0.1 www.motorbrot.local  
    127.0.0.1 editor.motorbrot.local  
 
There is an [docker build_run script](launcher/webcache_docker_build_run.sh) for that. When started, it should serve the silly reverse-css-zengarden here: http://www.motorbrot.local/

The current setup is for a single instance to provide an editor for logged-in users and also three websites served for everyone. The concept behind that is quite different though:
- The silly example just allows read-access for everyone.
- Composum's InPlace replication copies from /content path to /public when publishing.
- Peregrine is an SPA, it's publishing by writing json into local file-system.  
  ${sling.home}/staticreplication is set in OSGi config LocalFileSystemReplicationService  
  In this case apache is not proxy'ing to Sling but serves json-files directly. Therefore, when starting slimpogrine the first time, it's necessary to click 'replicate Home' [on this page](http://editor.motorbrot.local/content/admin/pages/pages.html/path:/content/sligrine/pages) in order to see it on [sligrine.local](http://sligrine.motorbrot.local/). Also Sling and webcache have to run on the same docker-volume, so files written by Sling can be read by the webserver.

It should be possible to use Sling-Distribution to replicate content between author/publish instances in a cluster though.

## The launcher

Most of the magic is happening inside launcher/src/main/features.  
That is where the [sling-feature-model-plugin](https://github.com/apache/sling-slingfeature-maven-plugin/blob/master/README.md) picks up the features to include.  
At first I started off by forking the [sling-starter](https://github.com/apache/sling-org-apache-sling-starter) in order to add an open-source CMS. Only later I found out about the new maven artefact-**type** 'slingosgifeature', which is basically json with maven-coordinates inside. It's published to maven-central by the sling-starter. We can use that in here to have something that actually boots and has a repository and so on. We can focus on our features to add on top.  

Another different approach would have been to use a layered docker-image.
Begin with the official apache-sling-starter image as base-layer and then install bundles and packages on top in our Dockerfile.


## ToDo's 

- Avoid hardcoded domains [CONGA Sling Plugin](https://devops.wcm.io/conga/plugins/sling/) maybe?
- How to deploy secrets like the openai/deepseek api-key ?
- SSL in front of the WebCache
- URL shortening [reverse-outgoing-mapping](https://sling.apache.org/documentation/the-sling-engine/mappings-for-resource-resolution.html#reverse-outgoing-mapping) not working yet for the domains
- GitOps, deploy with github actions
- [why-use-a-composite-nodestore](https://sling.apache.org/documentation/feature-model/howtos/create-sling-composite.html#why-use-a-composite-nodestore-1)? Unsure, blue/green deployments maybe? 


### This project was initially generated from [sling-project-archetype][sling-project-archetype]

[sling-project-archetype]:https://github.com/apache/sling-project-archetype