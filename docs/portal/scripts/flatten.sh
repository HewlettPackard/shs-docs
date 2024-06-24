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
sed -i 's/overview\///' tmp/HPE_Slingshot_Host_Software_Installation_and_Configuration_Guide.ditamap
sed -i 's/install\///' tmp/HPE_Slingshot_Host_Software_Installation_and_Configuration_Guide.ditamap
sed -i 's/operations\///' tmp/HPE_Slingshot_Host_Software_Installation_and_Configuration_Guide.ditamap
sed -i 's/troubleshoot\///' tmp/HPE_Slingshot_Host_Software_Troubleshooting_Guide.ditamap
sed -i 's/operations\///' tmp/HPE_Slingshot_Host_Software_Administration_Guide.ditamap
sed -i 's/performance\///' tmp/HPE_Slingshot_Host_Software_Administration_Guide.ditamap
sed -i 's/release_notes\///' tmp/HPE_Slingshot_Host_Software_Release_Notes.ditamap


# convert all links in all Markdown files. 
declare -a prefixes=("\.\.\/install" "\.\.\/operations" "\.\.\/overview" "\.\.\/release_notes" "\.\.\/performance" "\.\.\/troubleshoot")
for file in $(ls tmp/*.md);do for prefix in ${prefixes[@]}; do sed -i "s/$prefix\///g" $file;done;done