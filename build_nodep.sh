#!/bin/bash

PROJECT=rancher-letsencrypt
PLATFORMS=linux
ARCH=amd64

VERSION=$(cat VERSION)
SHA=$(git rev-parse --short HEAD)

# remove old symbolic links if exists
rm -rf ${PWD}/vendor/github.com/vxcontrol
rm -rf ${PWD}/vendor/src

make clean

# link code
mkdir -p ${PWD}/vendor/github.com/vxcontrol/rancher-letsencrypt/
ln -s ${PWD}/letsencrypt vendor/github.com/vxcontrol/rancher-letsencrypt
ln -s ${PWD}/rancher vendor/github.com/vxcontrol/rancher-letsencrypt

# link /src/vendor to /vendor
ln -s ${PWD}/vendor ${PWD}/vendor/src

GOPATH=${PWD}/vendor CGO_ENABLED=0 GOOS=${PLATFORMS} GOARCH=${ARCH} go build -ldflags "-X main.Version=${VERSION} -X main.Git=${SHA} -w -s" -a -o build/${PROJECT}-${PLATFORMS}-${ARCH}/${PROJECT}

# remove symbolic links
rm -rf ${PWD}/vendor/github.com/vxcontrol
rm -rf ${PWD}/vendor/src