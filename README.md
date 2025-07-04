# shs-docs

## Overview

The shs-docs repository holds the documentation and documentation publication tooling for the HPE Slingshot Host Software (SHS) product.

## Documentation Source

The SHS documentation source is located under the `docs/portal/developer-portal` directory of this repository. All documentation must be in Markdown format supported by DITA-OT. Aside from script-generated content like the Release Notes, all content must conform to the Markdown-based [MDITA authoring language of the proposed LwDITA standard](https://dita-lang.org/lwdita/authoring-formats/mdita/mdita-introduction). The table of contents for the SHS documentation, including each topic/chapter subdirectories, is generated from the ditamap files. The official HPE SHS guides are maintained as DITA 1.3 ditamaps.

## How We Generate the Official HPE Slingshot Host Software (SHS) Documentation

For each public release, an information developer builds docs with `make` commands script which:

1. Builds the HTML5 output for all guides using a DITA-OT running in a container.
2. Bundles the HTML5 output of each guide with an HPESC-required metadata JSON file.
3. Zips the HTML5 and metadata files for each guide into its own archive for uploading, reviewing, and publishing.

## Benefits of This Hybrid Markdown and DITA Approach

- Ease of Markdown authoring for software developers
- Ability to use Markdown tooling for authoring content
- We can use all the map-level DITA content reuse and conditionalization features
- The ditamaps support the map-level metadata required by our custom DITA-OT plugin
- The ditamaps can include topic files written in other formats supported by DITA-OT ("full" DITA, rST, etc.)
- Since the content is already in Markdown, this allows us to use the MDITA authoring format of the proposed Lightweight DITA (LwDITA) standard.

## Content Creation Tips

- All Markdown files must begin with a level one header (#).
- There cannot be any content above the topmost header. DITA-OT will throw a fatal error.
- Cross-reference links within the same MDITA file **must** include a `./` between the `#` symbol and the header id (slug). For example, to link to the "Example" section in the same file, use the format `[LINK_TEXT](#./example)`.
- Currently, cross-reference links to other files must include the target file. You can optionally add the target header if you need to point to a specific section in the target file. The benefit is that DITA-OT will keep track of all cross-references no matter how the content is transformed (by assigning unique hashes to the source and target). Another benefit is that if the xref works in the Markdown source, it'll work in the output.
- Generic, frequently used headings such as "Examples", "Overview", "Prerequisites", etc. **must not** be the top level (`#`) header. They can be level-two (`##`) headers. The top-level header becomes the topic id and duplicate topic ids within the same publication (map) cause errors during processing.
- Headers **must not** begin with a number. For example, "200Gbps NIC Troubleshooting" is not allowed, but "HPE Slingshot 200Gbps NIC Troubleshooting" is fine.

## Build docs locally with DITA-OT

Different Makefile targets produce different outputs:

- `hpesc_build`: builds a `.zip` file for HPESC Direct Publishing for each publication
- `dita_ot_md`: builds a single file GitHub Flavored Markdown (GFM) output for each publication
- `dita_ot_html`: builds an HPE-styled single file HTML5 output for each publication
- `dita_ot_pdf`: builds an HPE-styled PDF output for each publication
- `dita_ot_tar`: builds the Markdown, HTML5, and PDF outputs and combines them into a tarball

## Build docs automatically with DITA-OT

Same Jenkinsfile configuration as with the mds-file-and-Pandoc build process, except that you must replace the current Makefile target(s) with one or more of the above for automated Hummingbird builds.

## Build and publish the HPESC managed bundles

Follow these steps build and publish SHS documentation to HPESC.

1. Navigate to the hpc-shs-docs repository.

   ```screen
   cd /path/to/hpc-shs-docs
   ```

2. Checkout the desired release branch.

   ```screen
   git checkout release/shs-<version>
   ```

3. (Optional) Install the `zip` command.

   Skip this step if `zip` is install already.

   ```screen
   sudo apt install zip
   ```

4. Navigate to the `/docs/portal/developer-portal` directory.

   ```screen
   cd docs/portal/developer-portal
   ```

5. Build the HPESC bundle.

   ```screen
   make hpesc_build
   ```

   **Troubleshooting:** If this step fails, it is likely because Podman is not installed or running. Ensure Podman is set up correctly.

6. Perform the [direct publishing process](https://rndwiki-pro.its.hpecorp.net/display/HPCTechPubs/Direct+publish+PDFs+to+the+HPESC).

   - When selecting the file type, choose "managed bundle" instead of "PDF".
   - Select the appropriate `.zip` file located in the build directory for the guide.

## Run GitHub Actions locally

The spell, link, and style checks that are setup via GitHub Actions can be run locally.

### Prerequisites

- **Podman installed**: Ensure that Podman is installed on your machine.
- **Repository cloned**: Ensure you have cloned the repository containing your markdown files and the script.

### Instructions

1. Navigate to the following directory in the repository.

   ```screen
   # cd docs/portal/developer-portal
   ```

2. Ensure that the script is executable.

   ```screen
   chmod +x md_checks.sh
   ```

3. Run the script.

   NOTE: Cancel any running check using **ctrl** + **c**.

   There are a couple of options for running the script.

   - Run on a single markdown file:

     ```screen
     ./md_checks.sh path/to/markdownfile1.md
     ```

   - Run on a single directory:

     ```screen
     ./md_checks.sh path/to/directory
     ```

   - Run on a combination of markdown files or directories:

     ```screen
     ./md_checks.sh path/to/markdownfile1.md path/to/markdownfile2.md path/to/directory
     ```

   **Troubleshooting:** If you get the following error: `-bash: ./md_checks.sh /bin/bash^M: bad interpreter: No such file or directory`, run the following command to clean up the line endings:

   ```screen
   sed -i 's/\r$//' md_checks.sh
   ```
