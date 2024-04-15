# Copyright 2021-2022 Hewlett Packard Enterprise Development LP
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
# (MIT License)

BUILD_DATE ?= $(shell date +'%Y%m%d%H%M%S')
RELEASE_VERSION ?= $(shell ./version.sh)-local
GIT_TAG ?= $(shell git rev-parse --short HEAD)
NAME_BUILD_DOC_TOOLS_IMAGE ?= hpe-dita-ot
DOCKERFILE_BUILD_DOC_TOOLS ?= Dockerfile.build_docs
BUILD_DOC_TOOLS_VERSION ?= 1.0-local

all : check_env build_docs generate_release

check_env:
ifndef ARTIFACTORY_USER
        $(error ARTIFACTORY_USER is undefined)
endif
ifndef ARTIFACTORY_TOKEN
        $(error ARTIFACTORY_TOKEN is undefined)
endif

build_docs:
	docker build --pull ${DOCKER_ARGS} -f ${DOCKERFILE_BUILD_DOC_TOOLS} --tag '${NAME_BUILD_DOC_TOOLS_IMAGE}:${BUILD_DOC_TOOLS_VERSION}' .
	./docs/portal/developer-portal/build_iuf_docs.sh -c '${NAME_BUILD_DOC_TOOLS_IMAGE}:${BUILD_DOC_TOOLS_VERSION}' 

generate_release:
	./release.sh