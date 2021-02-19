FROM node:14-buster
MAINTAINER pepion@gmail.com

ARG REFRESHED_AT
ENV REFRESHED_AT $REFRESHED_AT
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

#JDK
RUN apt-get update
RUN apt-get install software-properties-common
RUN apt-add-repository 'deb http://security.debian.org/debian-security stretch/updates main'
RUN apt-get update
RUN apt-get install -y openjdk-8-jdk openjdk-8-jre
RUN java -version

#
RUN apt-get install -y build-essential

# DOCKER
#RUN apt-get update
RUN apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88

RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

RUN apt-get update
RUN apt-get install -y docker-ce docker-ce-cli containerd.io
RUN service docker start

# autoreconf
RUN apt-get install -y automake autoconf libtool pkg-config nasm build-essential dh-autoreconf

# chromium
# https://hub.docker.com/r/weboaks/node-karma-protractor-chrome
#RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" \
    apt-get install -y --no-install-recommends \
    chromium \
    chromium-driver \
    libatk-bridge2.0-0 \
    libgconf-2-4 \
    libxss1

RUN npm install -g gulp

RUN apt-get install -y --no-install-recommends mc

# VOLUME
WORKDIR /setbuilder

# start it with: docker build -t tru . && docker run -v /var/run/docker.sock:/var/run/docker.sock -ti tru
