#!/usr/bin/env bash
#
# MIT License
#
# (C) Copyright [2020-2022] Hewlett Packard Enterprise Development LP
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
set -Eeuox pipefail

# Function to log errors for simpler debugging
function notify {
        FAILED_COMMAND="$(caller): ${BASH_COMMAND}"
        echo "ERROR: ${FAILED_COMMAND}"
}
trap notify ERR

function copy_manifests {
    rsync -aq "${ROOTDIR}/manifests/" "${BUILDDIR}/manifests/"
    sed -e "s/@name@/${NAME}/g
               s/@product_version@/${VERSION}/g
               s/@doc_product_manifest_version@/${DOC_PRODUCT_MANIFEST_VERSION}/g" "${BUILDDIR}/manifests/docs-product-manifest.yaml" > "${BUILDDIR}/docs-product-manifest.yaml"
}

function copy_docs {
    DATE="`date`"
    rsync -aq --exclude="hugo" "${ROOTDIR}/docs/" "${BUILDDIR}/docs/"
    # Set any dynamic variables in the SHS docs
    for docfile in `find "${BUILDDIR}/docs/" -name "*.md" -o -name "*.ditamap" -o -name "*publication.json" -type f`;
    do
        sed -i.bak -e "s/@product_version@/${VERSION}/g" "$docfile"
        sed -i.bak -e "s/@product_version_short@/${MAJOR}.${MINOR}/g" "$docfile"
        sed -i.bak -e "s/@name@/${NAME}/g" "$docfile"
        sed -i.bak -e "s/@date@/${DATE}/g" "$docfile"
    done
    for bundle_file in `find "${BUILDDIR}/docs/" -name "build*sh" -o -name "direct_publish*sh" -o -name "*publication.json" -type f`;
    do
	sed -i.bak -e "s/@docid_suffix@/${DOCID_SUFFIX}/g" "$bundle_file"
    done
    for bakfile in `find "${BUILDDIR}/docs/" -name "*.bak" -type f`;
    do
        rm $bakfile
    done
}

function package_distribution {
    PACKAGE_NAME=${NAME}-${VERSION}
    tar -C $(realpath -m "${ROOTDIR}/dist") -zcvf $(dirname "$BUILDDIR")/${PACKAGE_NAME}.tar.gz $(basename $BUILDDIR)
}

# Definitions and sourced variables
ROOTDIR="$(dirname "${BASH_SOURCE[0]}")"

source "${ROOTDIR}/vars.sh"
BUILDDIR="$(realpath -m "$ROOTDIR/dist/${NAME}-${VERSION}")"

# initialize build directory
[[ -d "$BUILDDIR" ]] && rm -fr "$BUILDDIR"
mkdir -p "$BUILDDIR"
mkdir -p "${BUILDDIR}/lib"

# Create the Release Distribution
copy_manifests
copy_docs

# Package the distribution into an archive
package_distribution