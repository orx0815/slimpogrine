
Slimpogrine = SLIng + coMPOsum + pereGRINE
=====

[![Try SliMpoGrine on Gitpod](https://img.shields.io/badge/Gitpod-Try%20SliMpoGrine%20CMS%20Online-0a4d2c?logo=gitpod)](https://gitpod.io/#https://github.com/orx0815/slimpogrine) 


Here we bake two open-source WYSIWYG website editors into the same [![Apache Sling](https://sling.apache.org/res/logos/sling.png)](https://sling.apache.org) app-server.
Because we can.

1)  
[Peregrine](https://www.peregrine-cms.com) with a VueJs-SPA approach from [headwire](https://www.headwire.com).
(see [github](https://github.com/headwirecom/peregrine-cms), [adapt.to talk](https://adapt.to/2019/en/schedule/current-state-of-peregrine-cms.html) )  
   
2)  
[Composum-Pages](https://www.composum.com/home.html) with a normal html-page approach from [ist-software](https://www.ist-software.com).
Composum is friends with Sling standalone-apps anyway. They provide a node-browser, a content-package- and a user-manager for open-source Sling. 
So that is already used by the plain sling-starter and peregrine-cms, so adding the pages feature seems quite natural.

---
There is also the official [Apache Sling - CMS Reference App](https://github.com/apache/sling-org-apache-sling-app-cms) that comes also with a WYSIWYG editor. [adapt.to talk](https://adapt.to/2021/en/schedule/sling-cms-building-a-simple-cms-on-apache-sling.html)  
It's not used here but it's still worth looking into it to get some general concepts about Sling.

---


# Build and run
You need [this peregrine-cms fork](https://github.com/orx0815/peregrine-cms).
(Only that has ONE content-package migrated to [Jackrabbit FileVault Package Maven Plugin](https://jackrabbit.apache.org/filevault-package-maven-plugin/) to make it work)
  
**In the peregrine-cms fork** run

    mvn clean install
to have the required artefacts in your local .m2 repo.  

**In here**

    mvn clean install
(Integration-tests need a look at).

There is an [example start-skipt](launcher/launch.sh)

Access it on port 8080: http://localhost:8080  
It starts with the Peregrine Loging screen. (user:passwd is admin:admin)  
Over the Tools section you can get into composum or via this link:
http://localhost:8080/bin/pages.html
    

In launcher/src/main/container/webcache
    docker build --tag 'ghcr.io/orx0815/slimpogrine_webcache:latest' . && docker run -t -i -p 80:80 --env RENDERER_URL=172.17.0.1 --env AUTHOR_URL=172.17.0.1 ghcr.io/orx0815/slimpogrine_webcache:latest


### Maven Project generated from Maven Archetype

#### License

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.

#### Introduction

This project was created by the Full Project Sling Maven Archetype which created
four modules:

1. **core**: OSGi Bundle which is deployed as OSGi Bundle to Sling which includes your
             Servlets, Filters, Sling Models and much more. This module is **not intended**
             to contain Sling Content.
2. **ui.apps**: JCR Content Module which is used to install a JCR Package into Sling
                by using **Composum**. For that it must be installed and the Composum
                Package Manager must be whitelisted.
3. **launcher**: Feature model module which assembles a full application from the project
                 which can then be launched using the included `./launch.sh` script
4. **all**: This is another JCR Content Module but it is only used to install the
            other two modules. 

There are also two more modules that provide some examples with the same name plus
the **.example** extension. This modules should not be deployed as is but rather
examples that you want to use should be copied to the core or ui.apps module.
The structure of both modules are the same and so copying them over just be
quite simple.

#### Why the All Package

Most real projects have many different OSGi bundles, Content Packages, Configuration
Modules and many more. Deploying them one by one is cumbersome and can lead to
inconsitency and to a lot of overhead in a Continious Integration system.
The **All** package allows you to deploy all theses artifacts in one swoop or it allows
you to deploy them to multiple targets by just repeating the **All** deployment.

##### Adding a new Module

If you create a new Maven module then you need to add them to the **All** POM as
well to include them into the All deployment. These are the steps:

1. Add the dependency to the new module in the All POM
2. Add the module to the **maven-vault-plugin** definition
    1. If this is a content package then into the **subPackages**
    2. If this is an OSGi Bundle then into the **embeddeds**

##### Package Filter

In any multi-content-package environment the developer needs to pay close attention
to the **content filtering** in the **META-INF/vault/filter.xml** as this can lead
to hard to detect issues. Please make sure that:

1. Exclude **/apps/&lt;apps-folder-name>/install** from any of your content package
   as in that folder the **All** package is installing the bundles into
2. Make sure that content packages are not removing each other contents. The rule is
   that each content package has their own sub folder inside **/apps/&lt;apps-folder-name>**
   and avoid overlap.
3. Any shared folders like **overlays** need to be separated from each other.
   It is a good idea to limit your filter to smallest subset possible to avoid
   future issues if another package needs to place their overlays into the
   same folder. 

The package filter is a **mask** that tells Sling which part of the JCR tree
your package maintains and after the deployment that part of the JCR tree will
be the same as in your package. All missing ndoes in Sling will be created, all
existing nodes will be updated and all missing nodes in your package will be
deleted in Sling.


#### Why a JCR Package instead of a Content Bundle

There a several reasons to use a JCR Package instead of a Content Bundle
but for the most important reason is that a JCR Package allows the **Sling
Tooling** to update a single file rather than an entire Bundle and also
to import a Node from Sling into the project.


#### Attention:

Due to the way Apache Maven Archetypes work both **example** modules are added
to the parent POM's module list. Please **remove** them after you created them
to avoid the installation of these modules into Sling.
At the end of the parent POM you will find the lines below. Remove the lines
with **core.example** and **ui.apps.example**.

    <modules>
        <module>core</module>
        <module>core.example</module>
        <module>ui.apps</module>
        <module>ui.apps.example</module>
        <module>launcher</module>
        <module>all</module>
    </modules>

#### Build and Installation

The project is built quite simple:

    mvn clean install
    
To install the project **autoInstallAll**:

    mvn clean install -P autoInstallAll

##### ATTENTION

It is not a good idea to deploy code with both approaches.
Choose one and stick with it as you can either loose a bundle
or the bundle is not updated during installation.

In case of a mishape the package and bundles needs to deinstalled
manullay:

1. Remove /apps/${appsFolderName}/install folder
2. Uninstall the package using the package manager
3. Remove the package from /etc/packages including the snapshots if they are still there
4. Remove the Bundle using the OSGi Console (/system/console/bundles)

