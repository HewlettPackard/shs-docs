#!/usr/bin/env bash
set -ex

function usage() {
  echo "Wrapper script for building docs with DITA-OT"
  echo ""
  echo "Usage: dita_build.sh [-ahbpwm]"
  echo ""
  echo "options:"
  echo ""
  echo "-h                      Print this help"
  echo ""
  echo "-p  *P*DF:              Build a PDF of each publication using HPE fonts and custom formatting"
  echo ""
  echo "-w  *W*eb output:       Build a single HTML5 file for each publication"
  echo ""
  echo "-m  *M*arkdown output:  Build a single GFM file for each publication"
  echo ""
  echo "-a  *A*ll formats:      Build all output formats for each publication"
  echo ""
  echo "-b  *B*undle for HPESC  Build an HPESC managed bundle for each publication"
  echo "" 
  echo "WRITTEN FOR, AND TESTED ON, BASH"
}

function build_pdf(){
    PROJECT_FILE="shs_guides_pdf.yaml"
    dita_ot_build
}

function build_html5(){
    PROJECT_FILE="shs_guides_html5.yaml"
    dita_ot_build
    copy_css
    image_fix_html
}

function build_hpesc_bundle(){
    PROJECT_FILE="release_hpesc.yaml"
    dita_ot_build
}

function build_gfm(){
    PROJECT_FILE="shs_guides_md.yaml"
    dita_ot_build
    image_fix_html
    md_stage2
}

function build_all_formats(){
    PROJECT_FILE="release.yaml"
    dita_ot_build
    copy_css
    image_fix_html
    md_stage2
}

function dita_ot_build(){
    # If we're on Linux and the tmpfs is at least 45MB, use 30MB of it for DITA-OT's temp dir
    if [ `uname` = "Linux" ] && [ $(df --output=avail /dev/shm | tail -n 1) -gt 45000 ]; then
        podman run --tmpfs /tmp:size=30m,mode=1777 --mount type=bind,src=`pwd`,dst=/src --userns=keep-id:uid=1000,gid=1000 test-dita-ot-image:1.0 --project=/src/project_files/$PROJECT_FILE -v
    else
        podman run --mount type=bind,src=`pwd`,dst=/src --userns=keep-id:uid=1000,gid=1000 test-dita-ot-image:1.0 --project=/src/project_files/$PROJECT_FILE -v
    fi
}

function copy_css(){
    for PUB_DIR in $(find ${THIS_DIR}/build/ -name "html" -type d);do
        cp $THIS_DIR/css/style.css ${PUB_DIR}/css;done
}

function image_fix_html(){
    # Replace image references to "/src" with ".." in the jumbo HTML file
    for html in $(find ${THIS_DIR}/build/ -name "*.html");do
        sed -i'' -e "s/\/src\/images/images/g" $html;done
}

function md_stage2(){
    for MD_DIR in $(find ${THIS_DIR}/build/ -name "md" -type d);do
        python3 ../scripts/htmlClean.py $MD_DIR;
        MD_DIRS+=($MD_DIR);done
    for MD_DIR in ${MD_DIRS[@]};do
        for HTML in $(find $MD_DIR -name "*html" -type f);do
            STEM=$(basename $HTML | cut -d "." -f1)
            HTML_PATH=$(echo $HTML | rev | cut -d "/" -f2-3 | rev)
            echo "CURRENT HTML PATH: $HTML_PATH";
            podman run --mount type=bind,src=`pwd`,dst=/data \
            --userns=keep-id \
            arti.hpc.amslabs.hpecorp.net/third-party-docker-stable-local/pandoc/latex:3.6.4.0 -s \
            -o /data/build/$HTML_PATH/$STEM.md \
            -f html-native_divs -t gfm-raw_html \
            /data/build/$HTML_PATH/$STEM.html;
            rm $THIS_DIR/build/$HTML_PATH/$STEM.html;
        done 
    rm -rf $MD_DIR/_hpesc;
    rm -rf $MD_DIR/css;
    done

    # Fix the image links in the jumbo Markdown file
    for md in $(find ${THIS_DIR}/build/ -name "*.md");do
        sed -i'' -e "s/file://g" $md;done
}

THIS_DIR=$PWD

while getopts "bahpwm" arg; do
  case $arg in
    h)
      usage
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
    a)
      build_all_formats
      ;;
    b)
      build_hpesc_bundle
      ;;
  esac
done