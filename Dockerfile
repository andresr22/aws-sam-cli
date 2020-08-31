FROM ubuntu:18.04

ARG SONAR_SCANNER_HOME=/opt/sonar-scanner
ARG NODEJS_HOME=/opt/nodejs
ENV SONAR_SCANNER_HOME=${SONAR_SCANNER_HOME} \
    SONAR_SCANNER_VERSION=4.3.0.2102 \
    NODEJS_HOME=${NODEJS_HOME} \
    NODEJS_VERSION=v10.19.0 \
    PATH=${SONAR_SCANNER_HOME}/bin:${NODEJS_HOME}/bin:${PATH} \
    NODE_PATH=${NODEJS_HOME}/lib/node_modules

# Installing packages
RUN apt-get update -qq > /dev/null \
 && apt-get install -qq --no-install-recommends \
        ca-certificates \
        unzip \
        xz-utils \
        pylint \
        python3.7 \
        python3-pip \
        python3-setuptools \
        wget > /dev/null \
 && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/python3.7 /usr/local/bin/python

WORKDIR /tmp

RUN wget -U "scannercli" --quiet --output-document=sonar-scanner-cli.zip \
        "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip" \
 && unzip -q sonar-scanner-cli.zip \
 && mv sonar-scanner-${SONAR_SCANNER_VERSION}-linux ${SONAR_SCANNER_HOME} \
 && wget -U "nodejs" --quiet --output-document=nodejs.tar.xz \
        "https://nodejs.org/dist/${NODEJS_VERSION}/node-${NODEJS_VERSION}-linux-x64.tar.xz" \
 && tar Jxf nodejs.tar.xz \
 && mv node-${NODEJS_VERSION}-linux-x64 ${NODEJS_HOME} \
 && npm install -g typescript@3.6.3

RUN pip3 install -U \
        aws-sam-cli \
        pytest \
        virtualenv

ENV LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

WORKDIR /usr/src

RUN virtualenv -p /usr/bin/python3.7 venv

LABEL maintainer="Andres Rios"