FROM jenkins/jenkins:lts
MAINTAINER Samuel Giffard "samuel.giffard@around.media"
USER root
RUN apt-get update && \
    apt-get install -y python python-pip apt-transport-https ca-certificates curl gnupg2 software-properties-common && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; \
    apt-key add /tmp/dkey && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get -y install docker-ce && \
    usermod -a -G docker jenkins

# [GCLOUD SDK]
RUN curl -sSL https://sdk.cloud.google.com > /tmp/gcl && \
    bash /tmp/gcl --install-dir=/usr/local/gcloud --disable-prompts
RUN chown jenkins /usr/local/gcloud -R
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

# [PYTHON]
WORKDIR /opt/app
RUN apt-get install -y python3-pip && \
    /usr/bin/env python3 -m pip install --upgrade pip && \
    /usr/bin/env python3 -m pip install pipenv
RUN /usr/bin/env python -m pip install --upgrade pip && \
    /usr/bin/env python -m pip install pipenv
RUN chown jenkins /opt/app -R

USER jenkins

# [VERSIONS]
# Python 3
RUN python3 --version && \
    python3 -m pip --version && \
    python3 -m pipenv --version
# Python 2
RUN python --version && \
    python -m pip --version && \
    python -m pipenv --version
# Jenkins
RUN java -jar /usr/share/jenkins/jenkins.war --version
# GCloud
RUN gcloud --version && \
    gcloud compute zones list --filter="name~'europe-west'"
