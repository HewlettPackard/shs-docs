#!/usr/bin/env bash
#
# MIT License
#
# (C) Copyright [2021] Hewlett Packard Enterprise Development LP
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
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
# Version script required by the build pipeline. This script should output
# the version of the release distribution as defined by the tag of this commit.

# Tags should be of the format v[semver-compatible version]

# If the tag is v1.2.3:
#   and the pipeline runs this, then the version will be 1.2.3
#   and this is run locally, then the version will be 1.2.3
#   and this is run locally with committed changes, then the version will be 1.2.3-{commits}-{git hash}
#   and this is run locally with uncommitted changes, then the version will be appended with '-dirty'
set -eo pipefail

version=$(git describe --tags --match 'v*' | sed -e 's/^v//')
if [[ ! -z $(git status -s) ]]; then
    if [[ ! -n ${BUILD_NUMBER} ]]; then
        echo ${version}'-dirty'
    else  # don't attach -dirty to pipeline builds
        echo ${version}
    fi
else
    echo ${version}
fi