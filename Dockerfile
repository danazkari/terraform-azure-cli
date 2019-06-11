FROM alpine
MAINTAINER "Daniel Prado <danazkari@gmail.com>"

ARG BUILD_TERRAFORM_VERSION=0.11.13

# Configure the Terraform version here
ENV TERRAFORM_VERSION=$BUILD_TERRAFORM_VERSION

# install azure cli
RUN apk update \
  && apk add --virtual=.build-deps --no-cache \
  gcc \
  make \
  py-pip \
  libffi-dev \
  musl-dev \
  openssl-dev \
  python-dev \
  && pip install --no-cache-dir azure-cli \
  && apk del --purge .build-deps

ENV TF_DEV=true
ENV TF_RELEASE=true

WORKDIR /

ADD https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip /terraform.zip

RUN unzip /terraform.zip -d /usr/bin/ \
  && chmod +x /usr/bin/terraform \
  && rm /terraform.zip

# Start in root's home
WORKDIR /root
