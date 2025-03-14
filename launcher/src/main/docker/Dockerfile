FROM docker.io/eclipse-temurin:21

LABEL org.opencontainers.image.authors="orx0815@users.noreply.github.com"

ARG ADDITIONAL_FEATURE_COORDINATE=
ARG FM_SEED_CLASSIFIER=slimpogrine_composite_seed
ARG RUNMODE=standalone
ARG FM_RUNTIME_CLASSIFIER=slimpogrine_composite_runtime

ENV ADDITIONAL_FEATURE_COORDINATE=${ADDITIONAL_FEATURE_COORDINATE}
ENV RUNMODE=${RUNMODE}
ENV FM_RUNTIME_CLASSIFIER=${FM_RUNTIME_CLASSIFIER}

EXPOSE 8080

RUN groupadd --system sling && \
    useradd --no-log-init --system --gid sling sling && \
    mkdir /opt/sling && \
    mkdir /opt/sling/org.apache.sling.feature.launcher && \
    mkdir /opt/sling/launcher && \
    mkdir /opt/sling/artifacts && \
    mkdir /opt/sling/agents && \
    chown -R sling:sling /opt/sling/launcher

VOLUME /opt/sling/launcher

# contextDir is the slimpogrine/laucher
COPY src/main/docker/bin /opt/sling/bin
COPY src/main/docker/setup /opt/sling/setup
COPY target/dependency/org.apache.sling.feature.launcher /opt/sling/org.apache.sling.feature.launcher
COPY target/artifacts /opt/sling/artifacts

# ensure all files are readable by the sling user
# for some reason some jar files are 0600 while most are 0644
RUN find /opt/sling/artifacts -type f -perm 0600 | xargs --no-run-if-empty chmod 0644

USER sling:sling

WORKDIR /opt/sling
#ENTRYPOINT [ "/opt/sling/bin/launch.sh" ]
#CMD ["slimpogrine_composite_seed"]

# Setup Slimpogrine
#RUN /bin/bash /opt/sling/bin/setup-composite.sh

#RUN cp /opt/sling/setup/config-${RUNMODE}.json /opt/sling/features
ENTRYPOINT [ "/opt/sling/bin/launch.sh" ]
#CMD ["slimpogrine_composite_runtime"]
CMD ["slimpogrine_oak_tar"]
