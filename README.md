# shs-docs

## Overview

The shs-docs repository holds the documentation and documentation publication tooling
for the HPE Slingshot Host Software (SHS) product.

## Documentation Source

The SHS documentation source is located under the `docs/portal/developer-portal` directory
of this repository.  All documentation must be in Markdown format supported by DITA-OT. 
Aside from script-generated content like the Release Notes, all content must conform to the 
Markdown-based [MDITA authoring language of the proposed LwDITA standard](https://dita-lang.org/lwdita/authoring-formats/mdita/mdita-introduction). 
The table of contents for the SHS documentation, including each topic/chapter subdirectories, 
is generated from the ditamap files. The official HPE SHS guides are maintained as DITA 1.3 ditamaps.

## How We Generate the Official HPE Slingshot Host Software (SHS) Documentation

For each public release, an information developer builds docs with `make` commands script which:

1. Builds the HTML5 output for all guides using a DITA-OT running in a container.
1. Bundles the HTML5 output of each guide with an HPESC-required metadata JSON file.
1. Zips the HTML5 and metadata files for each guide into its own archive for uploading, reviewing, and publishing.

## Benefits of This Hybrid Markdown and DITA Approach

- Ease of Markdown authoring for software developers
- Ability to use Markdown tooling for authoring content
- We can use all the map-level DITA content reuse and conditionalization features
- The ditamaps support the map-level metadata required by our custom DITA-OT plugin
- The ditamaps can include topic files written in other formats supported by DITA-OT ("full" DITA, rST, etc.)
- Since the content is already in Markdown, this allows us to use the MDITA authoring format of the proposed
Lightweight DITA (LwDITA) standard.

## Content Creation Tips

- All Markdown files must begin with a level one header (#).
- There cannot be any content above the topmost header. DITA-OT will throw a fatal error.
- Cross-reference links within the same MDITA file **must** include a `./` between the `#` symbol and the header
id (slug). For example, to link to the "Example" section in the same file, use [LINK_TEXT](#./example).
- Currently, cross-reference links to other files must include the target file. You can optionally add the target header if you need to point to a specific section in the target file. The benefit is that DITA-OT will keep track of all cross-references no matter how the content is transformed (by assigning unique hashes to the source and target). Another benefit is that if the xref works in the Markdown source, it'll work in the output.
- Generic, frequently used headings such as "Examples", "Overview", "Prerequisites", etc. **must not** be the top level (`#`) header. They can be level-two (`##`) headers. The top-level header becomes the topic id and duplicate topic ids within the same publication (map) cause errors during processing.

## Build docs locally with DITA-OT

Different Makefile targets produce different outputs:

- `hpesc_build`: builds a `.zip` file for HPESC Direct Publishing for each publication
- `dita_ot_md`: builds a single file GitHub Flavored Markdown (GFM) output for each publication
- `dita_ot_html`: builds an HPE-styled single file HTML5 output for each publication
- `dita_ot_pdf`: builds an HPE-styled PDF output for each publication
- `dita_ot_tar`: builds the Markdown, HTML5, and PDF outputs and combines them into a tarball

## Build docs automatically with DITA-OT

Same Jenkinsfile configuration as with the mds-file-and-Pandoc build process, except that you must replace the current Makefile target(s) with one or more of the above for automated Hummingbird builds.
