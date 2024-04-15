# shs-docs

## Overview

The shs-docs repository holds the documentation and documentation publication tooling
for the HPE Slingshot Host Software (SHS) product.

## Documentation Source

The SHS documentation source is located under the `docs/portal/developer-portal` directory
of this repository.  All documentation must be in Markdown format. The table of contents
for the SHS documentation, including each topic/chapter subdirectories, is generated from the
ditamap files. The official HPE SHS guides are maintained as DITA 1.3 ditamaps.

## How We Generate the Official HPE Slingshot Host Software (SHS) Documentation

For each public release, an information developer runs the `build.sh` script which:

1. Builds the HTML5 output for both guides using a local DITA-OT installation.
1. Bundles the HTML5 output of each guide with an HPESC-required metadata JSON file.
1. Zips the HTML5 and metadata files for each guide into its own archive for uploading, reviewing, and publishing.

## Benefits of This Hybrid Markdown and DITA Approach

- Ease of Markdown authoring for software developers
- Ability to use Markdown tooling for authoring content
- We can use all the map-level DITA content reuse and conditionalization features
- The ditamaps support the map-level metadata required by our custom DITA-OT plugin
- The ditamaps can include topic files written in other formats supported by DITA-OT ("full" DITA, rST, etc.)
- Since the content is already in Markdown, this eases possible adoption of the MDITA authoring format of the proposed
Lightweight DITA (LwDITA) standard in the future

## Content Creation Tips

- All Markdown files must begin with a level one header (#). I wrote a header renumbering script to automate this after we add the Markdown files.
- There cannot be any content above the topmost header. DITA-OT will throw a fatal error.
- Cross-reference link targets must include the target file. You can optionally add the target header if you need to point to a specific section in the target file. DITA-OT requires it. The benefit is that DITA-OT will keep track of all cross-references no matter how the content is transformed (by assigning unique ids to the source and target). Another benefit is that if the xref works in the Markdown source, it'll work in the output.

