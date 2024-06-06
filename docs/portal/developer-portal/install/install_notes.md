
# Notes

Perform these steps to build compute and UAN/UAI images prior to boot with the updated HPE Slingshot components.

1. Build a new COS image from recipe and then customize it with CFS-based image customization. See the _HPE Cray Operating System Administration Guide_.

   After building the new image, update the BOS session template to point to the newly created image.
   See "BOS Session Templates" section of the CSM documentation for general steps.

2. Build a new UAN image from recipe and then customize it with CFS-based image customization

   See subsection "Build a New UAN Image Using the Default Recipe" under the "Image Management" section of the CSM documentation for general steps.

   After building the new image, update the BOS session template to point to the newly created image. See the section mentioned above for examples.

3. Assemble an updated UAI image and configure the User Access Service (UAS) to use this image.

   See "Customize End-User UAI Images" under the "UAS user and admin topics" section of the CSM documentation for instructions.

At this point, the SHS product has been installed.

If you are installing multiple products, return to the Install and Upgrade Framework (IUF) section of the [Cray System Management (CSM) Documentation](https://cray-hpe.github.io/docs-csm/en-14/operations/iuf/iuf/) for next steps.

