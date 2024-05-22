#!/bin/sh -x
set -ex
# Automated versioning changes are done here.
# Do not change versions in any other place

CHANGE_LOG=changelog$$

CURRENT_BRANCH=$GIT_BRANCH

# RELEASE_BRANCH is used to checkout the correct slingshot-version!
# Update RELEASE_BRANCH when a new release branch is created.
# For example:
# RELEASE_BRANCH=release/shs-11.0

RELEASE_BRANCH=main

if [ -d hpc-shs-version ]; then
    rm -rf hpc-shs-version
fi
if [ ! -z "$HPE_GITHUB_TOKEN_USR" -a ! -z "$HPE_GITHUB_TOKEN_PSW" ]; then
   git clone https://${HPE_GITHUB_TOKEN_USR}:${HPE_GITHUB_TOKEN_PSW}@github.hpe.com/hpe/hpc-shs-version.git -b $RELEASE_BRANCH
else
   git clone https://github.hpe.com/hpe/hpc-shs-version.git -b $RELEASE_BRANCH
fi

cd hpc-shs-version
if ! git checkout $CURRENT_BRANCH > /dev/null ; then
    echo "INFO: Branch ${CURRENT_BRANCH} is not an official SHS branch, using version string from ${RELEASE_BRANCH}" >&2
fi
cd - > /dev/null

PRODUCT_VERSION=$(cat hpc-shs-version/shs-version)
date=`date '+%a %b %d %Y'`
git_hash=`git rev-parse HEAD`
if [ -z "${BUILD_NUMBER}" ]; then
  RELEASE="LocalBuild"
else
  RELEASE=${BUILD_NUMBER}
fi
echo "${PRODUCT_VERSION}-${RELEASE}" > hpc-shs-version/shs-build-version


create_changelog() {
    # Usage:
    #    create_changelog <output file name> <release_version>
    outfile=$1
    package_version=$2


    rm -f $1
    echo '* '`date '+%a %b %d %Y'`" $USER <$USER@hpe.com> $package_version" >> $1
    echo "- Built from git hash ${git_hash}" >> $1
}

if [ "-d" = "${1}" ]; then
   cat << EOF

# Copyright and Version
&copy; 2024 Hewlett Packard Enterprise Development LP

Slingshot:
${PRODUCT_VERSION}-${RELEASE}

Doc git hash:
${git_hash}

Generated:
${date}

EOF
   # Modify Latex Footer to contain version
    cat ./pdf-templates/fancy.tex.template | sed \
        -e "s/VERSIONFOOTER/Version: ${PRODUCT_VERSION}-${RELEASE}/g" > ./pdf-templates/fancy.tex
   exit 0
fi

if [ ! -z "${BUILD_NUMBER}" ]; then
    if [ -z "${PRODUCT_VERSION}" ]; then
        echo "Version: ${PRODUCT_VERSION} is Empty"
        exit 1
    fi
    create_changelog $CHANGE_LOG ${PRODUCT_VERSION}

    # Modify .version files
    sed -i s/999.999.999/${PRODUCT_VERSION}-${BUILD_NUMBER}/g .version
    sed -i s/999.999.999/${PRODUCT_VERSION}/g .version_rpm

    # Modify rpm spec
    cat portal/developer-portal/slingshot-docs.spec.template | sed \
        -e "s/999.999.999/$PRODUCT_VERSION/g" \
        -e "/__CHANGELOG_SECTION__/r $CHANGE_LOG" \
        -e "/__CHANGELOG_SECTION__/d" > portal/developer-portal/slingshot-docs.spec
fi
rm -f ${CHANGE_LOG}
