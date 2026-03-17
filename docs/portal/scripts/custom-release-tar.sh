#!/usr/bin/env bash
set -ex

echo "CUSTOM RELEASE TARBALL AND HPESC BUNDLE SCRIPT"

if [ "$1" != "hpesc_bundle" ]; then
    echo "THIS REPO DOES NOT CURRENT SUPPORT SEPARATE DOCS TARBALLS"
else
    # Build the HPESC managed bundle zip files
    cp HPE_Slingshot_Host_Software_Administration_Guide.json build/HPE_Slingshot_Host_Software_Administration_Guide/hpesc/publication.json
    cd build/HPE_Slingshot_Host_Software_Administration_Guide/hpesc/ && zip -r SHS_AG.zip ./
    cd ../../../
    cp HPE_Slingshot_Host_Software_Installation_and_Configuration_Guide.json build/HPE_Slingshot_Host_Software_Installation_and_Configuration_Guide/hpesc/publication.json
    cd build/HPE_Slingshot_Host_Software_Installation_and_Configuration_Guide/hpesc/ && zip -r SHS_IC_guide.zip ./
    cd ../../../
    cp HPE_Slingshot_Host_Software_Release_Notes.json build/HPE_Slingshot_Host_Software_Release_Notes/hpesc/publication.json
    cd build/HPE_Slingshot_Host_Software_Release_Notes/hpesc/ && zip -r SHS_RN.zip ./
    cd ../../../
    cp HPE_Slingshot_Host_Software_Scale_and_Performance_Validation_Guide.json build/HPE_Slingshot_Host_Software_Scale_and_Performance_Validation_Guide/hpesc/publication.json
    cd build/HPE_Slingshot_Host_Software_Scale_and_Performance_Validation_Guide/hpesc/ && zip -r SHS_SPV_guide.zip ./
    cd ../../../
    cp HPE_Slingshot_Host_Software_Troubleshooting_Guide.json build/HPE_Slingshot_Host_Software_Troubleshooting_Guide/hpesc/publication.json
    cd build/HPE_Slingshot_Host_Software_Troubleshooting_Guide/hpesc/ && zip -r SHS_T_guide.zip ./
    cd ../../../
    cp HPE_Slingshot_Host_Software_User_Guide.json build/HPE_Slingshot_Host_Software_User_Guide/hpesc/publication.json
    cd build/HPE_Slingshot_Host_Software_User_Guide/hpesc/ && zip -r SHS_UG.zip ./
    cd ../../../
fi