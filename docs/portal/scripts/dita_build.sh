#!/usr/bin/env bash

function usage() {
  echo "Wrapper script for building docs with DITA-OT"
  echo ""
  echo "Usage: dita_build.sh [-chbpwm]"
  echo ""
  echo "options:"
  echo ""
  echo "-h                      Print this help"
  echo ""
  echo "-b  HPESC *B*undle:     Build an HPESC managed bundle for each publication"
  echo ""
  echo "-p  *P*DF:              Build a PDF of each publication using HPE fonts and custom formatting"
  echo ""
  echo "-w  *W*eb output:       Build a single HTML5 file for each publication"
  echo ""
  echo "-m  *M*arkdown output:  Build a single GFM file for each publication"
  echo ""
  echo "WRITTEN FOR, AND TESTED ON, BASH"
}

THIS_DIR=$PWD

# get basenames of all ditamaps
for MAP in $(ls ${PWD}/*.ditamap);do
	STEM=$(basename $MAP | cut -d "." -f1)
	PUB_STEMS+=($STEM);done

function build_bundle(){
    for STEM in ${PUB_STEMS[@]};do
        podman run \
        --mount type=bind,src=`pwd`,dst=/src \
        --userns=keep-id:uid=1000,gid=1000 \
        test-dita-ot-image:1.0 -v \
        -i /src/tmp/$STEM.ditamap \
        -o /src/build/hpesc/$STEM/ \
        -f HPEscHtml5 \
        && cp tmp/$STEM.json build/hpesc/$STEM/publication.json \
        && cd build/hpesc/$STEM/ && zip -r $STEM.zip ./
        cd $THIS_DIR;
	    done
}

function build_pdf(){
    for STEM in ${PUB_STEMS[@]};do
        podman run \
        --mount type=bind,src=`pwd`,dst=/src \
        --userns=keep-id:uid=1000,gid=1000 \
        test-dita-ot-image:1.0 -v \
        -i /src/tmp/$STEM.ditamap \
        -o /src/build/pdf/$STEM/ \
        --theme=/src/pdf-formatting/hpe-basic-pdf-theme.yaml \
        --args.fo.userconfig=/src/pdf-formatting/fop.xconf \
        -f pdf;
	    done
}

function build_html5(){
    for STEM in ${PUB_STEMS[@]};do
        podman run \
        --mount type=bind,src=`pwd`,dst=/src \
        --userns=keep-id:uid=1000,gid=1000 \
        test-dita-ot-image:1.0 -v \
        -i /src/tmp/$STEM.ditamap \
        --root-chunk-override=to-content \
	      --nav-toc=full \
        --args.hdr=/src/tmp/dita_ot_jumbo_html5_files/$STEM.xml \
        -o /src/build/html/$STEM/ \
        -f HPEscHtml5;
        cp /$THIS_DIR/css/style.css build/html/$STEM/css;
	    done
}

function build_gfm(){
    for STEM in ${PUB_STEMS[@]};do
        podman run \
        --mount type=bind,src=`pwd`,dst=/src \
        --userns=keep-id:uid=1000,gid=1000 \
        test-dita-ot-image:1.0 -v \
        -i /src/tmp/$STEM.ditamap \
        --root-chunk-override=to-content \
        -o /src/build/md/$STEM/ \
        -f markdown_github;
	    done
}

while getopts "hbpwm" arg; do
  case $arg in
    h)
      usage
      ;;
    b)
      build_bundle
      ;;
    p)
      build_pdf
      ;;
    w)
      build_html5
      ;;
    m)
      build_gfm
      ;;
  esac
done
