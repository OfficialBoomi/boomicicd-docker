FROM openjdk:11-jdk-stretch
ENV DEBIAN_FRONTEND noninteractive

# Install git lfs on Debian stretch per https://github.com/git-lfs/git-lfs/wiki/Installation#debian-and-ubuntu
# Avoid JENKINS-59569 - git LFS 2.7.1 fails clone with reference repository
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y git curl jq  tidy unzip libxml2-utils \
    && curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && apt-get install -y git-lfs && git lfs install \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
    && unzip awscliv2.zip \
    && ./aws/install
  
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG http_port=8080
ARG agent_port=50000
ARG JENKINS_HOME=/var/jenkins_home
ARG REF=/usr/share/jenkins/ref

ENV JENKINS_HOME $JENKINS_HOME
ENV JENKINS_SLAVE_AGENT_PORT ${agent_port}
ENV REF $REF
ENV KEY ""

# Jenkins is run with user `jenkins`, uid = 1000
# If you bind mount a volume from the host or a data container,
# ensure you use the same uid
RUN mkdir -p $JENKINS_HOME \
  && chown ${uid}:${gid} $JENKINS_HOME \
  && groupadd -g ${gid} ${group} \
  && useradd -d "$JENKINS_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

# Jenkins home directory is a volume, so configuration and build history
# can be persisted and survive image upgrades
VOLUME $JENKINS_HOME

# $REF (defaults to `/usr/share/jenkins/ref/`) contains all reference configuration we want
# to set on a fresh new installation. Use it to bundle additional plugins
# or config file with your custom jenkins Docker image.
RUN mkdir -p ${REF}/init.groovy.d

# Use tini as subreaper in Docker container to adopt zombie processes
ARG TINI_VERSION=v0.16.1
COPY tini_pub.gpg ${JENKINS_HOME}/tini_pub.gpg
RUN curl -fsSL https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static-$(dpkg --print-architecture) -o /sbin/tini \
  && curl -fsSL https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static-$(dpkg --print-architecture).asc -o /sbin/tini.asc \
  && gpg --no-tty --import ${JENKINS_HOME}/tini_pub.gpg \
  && gpg --verify /sbin/tini.asc \
  && rm -rf /sbin/tini.asc /root/.gnupg \
  && chmod +x /sbin/tini

# jenkins version being bundled in this docker image
ARG JENKINS_VERSION
# jenkins.war checksum, download will be validated using it
ARG JENKINS_SHA=9663A14158588EB470A024AD941F6780945C6383B5A82DDA4EF2D15DAC4F7214
ENV JENKINS_VERSION ${JENKINS_VERSION:-2.299}
ENV JENKINS_SHA ${JENKINS_SHA}

# Can be used to customize where jenkins.war get downloaded from
ARG JENKINS_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war

# could use ADD but this one does not check Last-Modified header neither does it allow to control checksum
# see https://github.com/docker/docker/issues/8331
RUN curl -fsSL ${JENKINS_URL} -o /usr/share/jenkins/jenkins.war \
  && echo "${JENKINS_SHA}  /usr/share/jenkins/jenkins.war" | sha256sum -c -

# install latest atom runtime installer
RUN mkdir -p ${REF}/cli \	
  && curl -fsSL https://platform.boomi.com/atom/atom_install64.sh -o ${REF}/cli/atom_install64.sh \
	&& chmod +x "${REF}/cli/atom_install64.sh"

ENV JENKINS_UC https://updates.jenkins.io
ENV JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental
ENV JENKINS_INCREMENTALS_REPO_MIRROR=https://repo.jenkins-ci.org/incrementals
RUN chown -R ${user}:${group} "$JENKINS_HOME" "$REF" 

ARG PLUGIN_CLI_URL=https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/plugin-management-parent-pom-2.0.0/jenkins-plugin-manager-2.0.0.jar
RUN curl -fsSL ${PLUGIN_CLI_URL} -o /usr/lib/jenkins-plugin-manager.jar

# for main web interface:
EXPOSE ${http_port}

# will be used by attached slave agents:
EXPOSE ${agent_port}

ENV COPY_REFERENCE_FILE_LOG $JENKINS_HOME/copy_reference_file.log
ENV UUID=${uuidgen}
USER ${user}

COPY cli $REF/cli
COPY secret $REF/secret
COPY jenkins_jobs/jobs ${REF}/jobs
COPY hudson.tasks.Shell.xml ${JENKINS_HOME}/hudson.tasks.Shell.xml
COPY jenkins-support /usr/local/bin/jenkins-support
COPY jenkins.sh /usr/local/bin/jenkins.sh
COPY tini-shim.sh /bin/tini
COPY jenkins-plugin-cli.sh /bin/jenkins-plugin-cli.sh 

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY restart.sh ${REF}/restart/sh
COPY updateexecutors.sh ${REF}/updateexecutors.sh
ARG SONAR_HOME=${REF}/sonar-scanner-4.2.0.1873-linux 
RUN mkdir -p ${SONAR_HOME}
COPY sonarqube/* ${REF}/sonar-scanner-4.2.0.1873-linux

#ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/jenkins.sh"]
ENTRYPOINT ["/bin/bash", "/usr/local/bin/entrypoint.sh"]

ENV JENKINS_USER admin
ENV JENKINS_PASS admin
COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/
COPY default-user.groovy /usr/share/jenkins/ref/init.groovy.d/
# Skip initial setup
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
# from a derived Dockerfile, can use `RUN plugins.sh active.txt` to setup ${REF}/plugins from a support bundle
COPY install-plugins.sh /usr/local/bin/install-plugins.sh
RUN /usr/local/bin/install-plugins.sh pipeline-model-extensions build-timeout pipeline-milestone-step github-api workflow-job docker-workflow pipeline-stage-view workflow-multibranch apache-httpcomponents-client-4-api pipeline-model-api git-server resource-disposer jquery-detached workflow-scm-step credentials-binding ant momentjs pipeline-rest-api display-url-api gradle junit structs command-launcher trilead-api token-macro github cloudbees-folder ace-editor plain-credentials workflow-aggregator pipeline-model-definition credentials branch-api script-security workflow-step-api timestamper folder-properties git-client pipeline-github-lib mapdb-api workflow-cps pipeline-stage-tags-metadata bouncycastle-api pipeline-build-step antisamy-markup-formatter jsch pam-auth handlebars workflow-api authentication-tokens pipeline-stage-step lockable-resources workflow-cps-global-lib subversion matrix-project git jdk-tool ws-cleanup workflow-support jackson2-api ssh-credentials pipeline-input-step pipeline-graph-analysis durable-task ldap docker-commons ssh-slaves workflow-durable-task-step scm-api matrix-auth workflow-basic-steps authorize-project purge-job-history google-login uno-choice build-publisher htmlpublisher build-user-vars-plugin secure-requester-whitelist postbuildscript
