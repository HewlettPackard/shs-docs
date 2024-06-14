#!/usr/bin/env bash
#
# MIT License
#
# (C) Copyright 2022 Hewlett Packard Enterprise Development LP
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

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

function usage() {
  echo "$0 builds the HPESC HTML, PDF, and Markdown versions of the SHS docs"
  echo "Installation and Administration Guides."
  echo ""
  echo "The output files will be in $THIS_DIR/build."
  echo ""
  echo "Usage: $0 [-h]"
  echo ""
  echo "options:"
  echo "h        Print this help"
  echo "c        DITA-OT container image name"
  echo ""
  exit 0

}

while getopts "hc:" arg; do
  case $arg in
    h)
      usage
      ;;
    c)
      DITA_CONTAINER=$OPTARG
      ;;
  esac
done

cd $THIS_DIR
rm -rf build/
mkdir -m777 -p build/PDF
mkdir -m777 -p build/install
mkdir -m777 -p build/release_notes
mkdir -m777 -p build/admin
mkdir -m777 -p build/Markdown

# call the script that flattens the dir structure used to build the HPESC bundle
./flatten.sh

echo "Building SHS Install Guide";

# This line builds the HPESC HTML bundle for the install guide
dita -i tmp/shs_install_guide.ditamap -o build/install -f HPEscHtml5 && cp shs_install_publication.json build/install/publication.json && cd build/install/ && zip -r crs9009en_us.zip ./
cd $THIS_DIR
# This builds the PDF using DITA-OT's default PDF transform
echo "Building PDF"
dita -i shs_install_guide.ditamap -o build/PDF/install -f pdf
# This builds the single file Markdown version of the guide. This leverages DITA's "chunking"
echo "Building Combined Markdown File"
dita -i shs_install_guide.ditamap --root-chunk-override=to-content -o build/Markdown -f markdown_github

echo "Building SHS Release Notes";

# This line builds the HPESC HTML bundle for the release notes
dita -i tmp/HPE_Slingshot_Host_Software_Release_Notes.ditamap -o build/release_notes -f HPEscHtml5 && cp HPE_Slingshot_Host_Software_Release_Notes.json build/release_notes/publication.json && cd build/release_notes/ && zip -r crs9010en_us.zip ./
cd $THIS_DIR
# This builds the PDF using DITA-OT's default PDF transform
echo "Building PDF"
dita -i HPE_Slingshot_Host_Software_Release_Notes.ditamap -o build/PDF/release_notes -f pdf
# This builds the single file Markdown version of the guide. This leverages DITA's "chunking"
echo "Building Combined Markdown File"
dita -i HPE_Slingshot_Host_Software_Release_Notes.ditamap --root-chunk-override=to-content -o build/Markdown -f markdown_github

# delete the tmp dir created by the flatten script. The bundle is still in the build subdir
rm -rf tmp/

# DITA-OT spits out the individual Markdown files (which we don't want) in addition to the unified Md files (that we do want). These lines get rid of the extra files 
mv build/Markdown/shs_*_guide.md build/
mv build/Markdown/HPE_Slingshot_Host_Software_Release_Notes.md build/
rm -rf build/Markdown/*
mv build/shs_*_guide.md build/Markdown/
mv build/HPE_Slingshot_Host_Software_Release_Notes.md build/Markdown/
