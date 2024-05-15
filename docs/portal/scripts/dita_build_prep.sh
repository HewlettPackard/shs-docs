#!/bin/bash

# use basenames to avoid hard-coding specific dirs and files 
# in the build code 
for MAP in $(ls ${PWD}/*.ditamap);do
	STEM=$(basename $MAP | cut -d "." -f1)
	PUB_STEMS+=($STEM);done

# create a subdir for each publication
for STEM in ${PUB_STEMS[@]};do
	mkdir build/hpesc/$STEM;
	mkdir build/pdf/$STEM;
    mkdir build/html/$STEM;
    mkdir build/md/$STEM;
	done

# Use the version file generated by Makefile
DOCS_VERSION=`cat ../../dac-assets/product_version`
echo "VERSION PASSED TO DITA BUILD IS $DOCS_VERSION"
DOCS_GIT_HASH=`grep -C 1 "Doc git hash" ${PWD}/tmp/VeRsIoN.md | tail -n 1`
echo "GIT HASH PASSED TO DITA BUILD IS $DOCS_GIT_HASH"
for file in $(find . -name "*.json");do	
	sed -i "s/@version@/$DOCS_VERSION/g" $file
	sed -i "s/@docs_git_hash@/$DOCS_GIT_HASH/g" $file 
	done
for file in $(ls *.ditamap);do	
	sed -i "s/@version@/$DOCS_VERSION/g" $file
	sed -i "s/@docs_git_hash@/$DOCS_GIT_HASH/g" $file
	done

