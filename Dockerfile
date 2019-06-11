FROM golang:alpine
MAINTAINER "Daniel Prado <danazkari@gmail.com>"

ARG BUILD_TERRAFORM_VERSION=0.11.13

# Configure the Terraform version here
ENV TERRAFORM_VERSION=$BUILD_TERRAFORM_VERSION

RUN apk add git bash openssh py-pip make --no-cache --virtual=.terraform-build-deps

# install azure cli
RUN apk add --virtual=.build-deps --no-cache \
  gcc \
  libffi-dev \
  musl-dev \
  openssl-dev \
  python-dev \
  && pip install --no-cache-dir azure-cli \
  && apk del --purge .build-deps

ENV TF_DEV=true
ENV TF_RELEASE=true

WORKDIR $GOPATH/src/github.com/hashicorp/terraform
RUN git clone https://github.com/hashicorp/terraform.git ./ && \
  git checkout v${TERRAFORM_VERSION} && \
  /bin/bash scripts/build.sh && \
  apk del --purge .terraform-build-deps

# Start in root's home
WORKDIR /root
