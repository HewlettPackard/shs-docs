# create tmp subdir
mkdir tmp
#mkdir tmp/images
# copy all markdown files to the tmp subdir
cp ./*/*.md tmp/
# copy all images to the tmp subdir
#cp ./*/*/*.png tmp/images/
# copy ditamap to the tmp subdir 
cp ./*.ditamap tmp/
# convert links in the ditamap
sed -i 's/overview\///' tmp/shs_install_guide.ditamap
sed -i 's/install\///' tmp/shs_install_guide.ditamap

# convert all links in all Markdown files. 
declare -a prefixes=("\.\.\/install" "\.\.\/overview")
for file in $(ls tmp/*.md);do for prefix in ${prefixes[@]}; do sed -i "s/$prefix\///g" $file;done;done