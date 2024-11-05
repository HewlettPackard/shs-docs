#!/bin/bash

# use basenames to avoid hard-coding specific dirs and files 
# in the build code 
for MAP in $(ls ${PWD}/*.ditamap);do
	STEM=$(basename $MAP | cut -d "." -f1)
	PUB_STEMS+=($STEM);done

# create a subdir for each publication
for STEM in ${PUB_STEMS[@]};do
	mkdir -p build/hpesc/$STEM;
	mkdir -p build/pdf/$STEM;
    mkdir -p build/html/$STEM;
    mkdir -p build/md/$STEM;
	# create an images subdir for each pub
    # the DITA-OT container isn't allowed to
    # create them during Jenkins builds
	mkdir -p build/hpesc/$STEM/images;
    mkdir -p build/html/$STEM/images;
    mkdir -p build/md/$STEM/images;
	done

# remove inline LaTeX
sed -i'' -e "s/\\\pagebreak//g" ${PWD}/tmp/VeRsIoN.md

# Use the version file generated by Makefile
PRODUCT_VERSION=`cat ../../../hpc-shs-version/shs-version`
echo "VERSION PASSED TO DITA BUILD IS $PRODUCT_VERSION"
DOCS_GIT_HASH=`grep -C 1 "Doc git hash" ${PWD}/tmp/VeRsIoN.md | tail -n 1`
echo "GIT HASH PASSED TO DITA BUILD IS $DOCS_GIT_HASH"
for file in $(find ./tmp -name "*.json");do	
	sed -i'' -e "s/@product_version@/$PRODUCT_VERSION/g" $file
	sed -i'' -e "s/@docs_git_hash@/$DOCS_GIT_HASH/g" $file 
	done
for file in $(find ./tmp -name "*.ditamap");do	
	sed -i'' -e "s/@product_version@/$PRODUCT_VERSION/g" $file
	sed -i'' -e "s/@docs_git_hash@/$DOCS_GIT_HASH/g" $file
	done

# replace variables in the XML header files used for the single file HTML5 output
for file in $(find ./tmp -name "*.xml");do
	sed -i'' -e "s/@product_version@/$PRODUCT_VERSION/g" $file
	sed -i'' -e "s/@docs_git_hash@/$DOCS_GIT_HASH/g" $file 
	done
