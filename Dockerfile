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
RUN curl -sSL https://sdk.cloud.google.com > /tmp/gcl && \
    bash /tmp/gcl --install-dir=/usr/local/gcloud --disable-prompts
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin
USER jenkins
RUN java -jar /usr/share/jenkins/jenkins.war --version && \
    python --version && \
    python3 --version && \
    gcloud --version && \
    gcloud compute zones list --filter="name~'europe-west'"
