# Based on Makefile by Facundo Muñoz (2018)
# Modified by Dogukan Cagatay <dcagatay@gmail.com>
# Originally from : http://tex.stackexchange.com/a/40759
# Modified for compilation of Markdown files with ideas from
# http://plain-text.co/pull-it-together.html
# Modified to build MD from MDS files
# Modified to build tar
# Modified to spellcheck
# Modified to lint
# Modified to build docs via DITA-OT
# Modified to build docs via DITA-OT

ifdef RPM_BUILD_ROOT
RPM_BUILD_ROOT := $(RPM_BUILD_ROOT)
else
RPM_BUILD_ROOT := `pwd`
endif

## Build dir
BUILDDIR = build
VERSIONDIR = hpc-sshot-slingshot-version

SOURCEDIR = .
TMPDIR = ./tmp

HPESCBUILDDIR = $(BUILDDIR)/hpesc
PDFBUILDDIR = $(BUILDDIR)/pdf
PDFDRAFTSBUILDDIR = $(BUILDDIR)/drafts/pdf
HTMLBUILDDIR = $(BUILDDIR)/html
HTMLDRAFTSBUILDDIR = $(BUILDDIR)/drafts/html
MDSBUILDDIR = $(SOURCEDIR)
MDBUILDDIR = $(BUILDDIR)/md

# IMAGESDIR = images
CSSDIR = css
WORKSPACE = "/workspace"


## Target file names with extensions (use substitution references)
## https://www.gnu.org/software/make/manual/make.html#Substitution-Refs

## Expands to a list of all markdown files in the working directory
MD_SRC = $(wildcard $(SOURCEDIR)/*.md)
MDS_SRC = $(wildcard $(SOURCEDIR)/*.mds)


## Expands to list of .html, .pdf, .md objects to build based on .md and .mds
## x.pdf depends on x.md, x.html depends on x.md, x.md depends on x.mds, etc
## pdfs can be built from all md and tex files



## Expands to list of .html, .pdf, .md objects to build based on .md and .mds
## x.pdf depends on x.md, x.html depends on x.md, x.md depends on x.mds, etc
## pdfs can be built from all md and tex files

MDOBJECTS = $(patsubst %.mds,%.md,$(MDS_SRC))


CHKOBJECTS = $(patsubst %.mds,%.md,$(MDS_DOCS))


HTMLDOCS = $(patsubst $(SOURCEDIR)/%.md,$(HTMLBUILDDIR)/%.html,$(MD_DOCS))
HTMLDOCS2 = $(patsubst $(SOURCEDIR)/%.mds,$(HTMLBUILDDIR)/%.html,$(MDS_DOCS))
PDFDOCS = $(patsubst $(SOURCEDIR)/%.md,$(PDFBUILDDIR)/%.pdf,$(MD_DOCS))
PDFDOCS2 = $(patsubst $(SOURCEDIR)/%.mds,$(PDFBUILDDIR)/%.pdf,$(MDS_DOCS))
TROFFDOCS = $(patsubst $(MANPAGE_SOURCEDIR)/%.8.md,$(MANBUILDDIR)/%.8,$(MANPAGE_DOCS))
HTMLMANPAGES = $(patsubst $(MANPAGE_SOURCEDIR)/%.8.md,$(HTMLBUILDDIR)/man/%.8.html,$(MANPAGE_DOCS))
MDDOCS = $(patsubst $(SOURCEDIR)/%.md,$(MDBUILDDIR)/%.md,$(MD_DOCS))


## Expands to a list of all publication-level ditamaps in the working directory
DITAMAPS = $(wildcard $(SOURCEDIR)/*.ditamap)

# MAIN LATEXMK RULE
# -pdf tells latexmk to generate PDF directly (instead of DVI).
# -pdflatex="" tells latexmk to call a specific backend with specific options.
# -use-make tells latexmk to call make for generating missing files.
# -interactive=nonstopmode keeps the pdflatex backend from stopping at a
# missing file reference and interactively asking you for an alternative.
# Left for reference:
# LATEXMK = latexmk -use-make -pdf -pdflatex="pdflatex -interactive=nonstopmode"

# Convert .mds to .md file
COMPILEMDS = ../scripts/compileMDS.py
MKVERSION = ../../../setup_versioning.sh

PANDOC_OPTS = --toc --pdf-engine=xelatex -H ./pdf-templates/fancy.tex -V urlcolor:blue -V linkcolor:blue -V monofontoptions:"Scale=0.4" -V geometry:"top=2cm, bottom=1.5cm, left=1.5cm, right=1.5cm" -H pdf-templates/headings.tex -H pdf-templates/tables.tex --listings -H pdf-templates/code.tex -M subtitle="Version: ${VER}" --number-sections

# Helpful info:  https://www.pragmaticlinux.com/2021/01/create-a-man-page-for-your-own-program-or-script-with-pandoc/
MANPAGE_OPTS = --standalone --to man -M section="8" -M header="Slingshot Fabric Commands ${VER}" -M title="${NAME}" -M footer="Slingshot ${VER}"
MANPAGE_OPTS_HTML = --standalone -M title="${NAME}(8)" -M subtitle="Slingshot Fabric Commands, Version ${VER}" 
HTML_PANDOC_OPTS = -c $(CSSDIR)/H.css -s --toc -V urlcolor:blue -V linkcolor:blue --to html5 -M subtitle="Version: ${VER}" --toc --number-sections

PANDOC = docker run --volume "`pwd`:/data" --user `id -u`:`id -g` arti.hpc.amslabs.hpecorp.net/third-party-docker-stable-local/pandoc/latex:latest ${PANDOC_OPTS}
MAN_PANDOC = docker run --volume "`pwd`:/data" --user `id -u`:`id -g` arti.hpc.amslabs.hpecorp.net/third-party-docker-stable-local/pandoc/latex:latest ${MANPAGE_OPTS} 
MAN_PANDOC_HTML = docker run --volume "`pwd`:/data" --user `id -u`:`id -g` arti.hpc.amslabs.hpecorp.net/third-party-docker-stable-local/pandoc/latex:latest ${MANPAGE_OPTS_HTML} 

# Used when env NODOCKER is set
PANDOC-N = pandoc ${PANDOC_OPTS}
MAN_PANDOC-N = pandoc ${MANPAGE_OPTS} 
MAN_PANDOC_HTML-N = pandoc ${MANPAGE_OPTS_HTML}
HTML_PANDOC-N = pandoc ${HTML_PANDOC_OPTS}


HTML_PANDOC = docker run --rm --volume "`pwd`:/data" --user `id -u`:`id -g` arti.hpc.amslabs.hpecorp.net/third-party-docker-stable-local/pandoc/latex:latest ${HTML_PANDOC_OPTS}


REDOC = docker run -v "`pwd`/..:/data" arti.hpc.amslabs.hpecorp.net/third-party-docker-stable-local/broothie/redoc-cli:0.9.8 bundle
MDL =	docker run --rm -v `pwd`:/workspace -v `pwd`/lint/.mdlrc:/mdl/.mdlrc arti.hpc.amslabs.hpecorp.net/third-party-docker-stable-local/wpengine/mdl:latest
MDL-N = mdl

# Also, include non-file targets in .PHONY so they are run regardless of any
# file of the given name existing.
.PHONY: all

# Rules -- make all, make pdf, make html. The `clean` rule is below.
# The first rule in a Makefile is the one executed by default ("make"). It
# should always be the "all" rule, so that "make" and "make all" are identical.
#

md:    dir $(MDOBJECTS) $(MDDOCS)

pdf:    $(PDFDOCS) $(PDFDOCS2)

html:   $(HTMLDOCS) $(HTMLDOC2S)

# manpages: dir md $(TROFFDOCS) $(HTMLMANPAGES)  

set-permissions:
	chmod +x ../scripts/dita_build_prep.sh
	chmod +x ../scripts/dita_build.sh


dita_build: $(TMPDIR)/VeRsIoN.md
	bash ../scripts/dita_build.sh


## https://www.gnu.org/software/make/manual/html_node/Using-Implicit.html#Using-Implicit
## Each implicit rule has a arget pattern and prerequisite patterns.
## There may be many implicit rules with the same target pattern
## The rule that actually applies is the one whose prerequisites exist or can be made

## '$@' is a variable holding the name of the target,
## and '$<' is a variable holding the (first) dependency of a rule.

# Setup Version/Copyright for Doc section
$(TMPDIR)/VeRsIoN.md:
	mkdir -p $(TMPDIR)
	cd ../../.. && sh setup_versioning.sh -d > docs/portal/developer-portal/$(TMPDIR)/VeRsIoN.md

dir: $(TMPDIR)/VeRsIoN.md
	mkdir -p $(PDFBUILDDIR)
	mkdir -p $(PDFDRAFTSBUILDDIR)
#	mkdir -p $(HTMLBUILDDIR)/man
	mkdir -p $(HTMLDRAFTSBUILDDIR)
	mkdir -p $(HPESCBUILDDIR)
	mkdir -p $(MDBUILDDIR)
#	cp -r $(IMAGESDIR) $(HTMLBUILDDIR)
	cp -r $(CSSDIR) $(HTMLBUILDDIR)

# Some build environments may not have docker installed
# In this case, specify make NODOCKER='y', and
# Pandoc must be installed locally

ifdef NODOCKER
$(HTMLBUILDDIR)/%.html: $(SOURCEDIR)/%.md dir
	$(eval VER := $(shell cat ${VERSIONDIR}/shs-build-version))
	$(HTML_PANDOC-N) -o $@ $(TMPDIR)/VeRsIoN.md $<

$(PDFBUILDDIR)/%.pdf: $(SOURCEDIR)/%.md dir
	$(eval VER := $(shell cat ${VERSIONDIR}/shs-build-version))
	$(PANDOC-N) -o $@ $(TMPDIR)/VeRsIoN.md $<

$(MANBUILDDIR)/%.8: $(MANPAGE_SOURCEDIR)/%.8.md dir
	$(eval VER := $(shell cat ${VERSIONDIR}/shs-build-version))
	$(eval NAME := $(shell basename $(patsubst %.8.md,%,$<)))
	$(MAN_PANDOC-N) -o $@  $<

$(HTMLBUILDDIR)/man/%.8.html: $(MANPAGE_SOURCEDIR)/%.8.md dir
	$(eval VER := $(shell cat ${VERSIONDIR}/shs-build-version))
	$(eval NAME := $(shell basename $(patsubst %.8.md,%,$<)))
	$(MAN_PANDOC_HTML-N) -o $@  $<

$(MDBUILDDIR)/%.md: $(SOURCEDIR)/%.md dir
	cp $< $@ 

else

$(HTMLBUILDDIR)/%.html: $(SOURCEDIR)/%.md dir
	$(eval VER := $(shell cat ${VERSIONDIR}/shs-build-version))
	$(HTML_PANDOC) -o $@ $(TMPDIR)/VeRsIoN.md $<

$(PDFBUILDDIR)/%.pdf: $(SOURCEDIR)/%.md dir
	$(eval VER := $(shell cat ${VERSIONDIR}/shs-build-version))
	$(PANDOC) -o $@ $(TMPDIR)/VeRsIoN.md $<

$(MANBUILDDIR)/%.8: $(MANPAGE_SOURCEDIR)/%.8.md dir
	$(eval VER := $(shell cat hpc-sshot-slingshot-version/shs-build-version))
	$(eval NAME := $(shell basename $(patsubst %.8.md,%,$<)))
	$(MAN_PANDOC) -o $@  $<

$(HTMLBUILDDIR)/man/%.8.html: $(MANPAGE_SOURCEDIR)/%.8.md dir
	$(eval VER := $(shell cat hpc-shs-version/shs-build-version))
	$(eval NAME := $(shell basename $(patsubst %.8.md,%,$<)))
	$(MAN_PANDOC_HTML) -o $@ $<

$(MDBUILDDIR)/%.md: $(SOURCEDIR)/%.md dir
	cp $< $@ 

endif

$(SOURCEDIR)/%.md: $(SOURCEDIR)/%.mds dir
ifdef NOEDITLINKS
	$(COMPILEMDS) $<
else
	$(COMPILEMDS) -e $<
endif


clean:
	rm -fr $(BUILDDIR) $(TMPDIR) $(VERSIONDIR)
	rm -f $(MDOBJECTS)
	rm -f install*.md admin*.md hw*.md telemetry.md
	rm -fr $(HPESCBUILDDIR)
	rm -f pdf-templates/fancy.tex
	rm -fr ./dita_build/


ifdef NODOCKER
lint: ./**/*.md 
	$(MDL-N) $(MD_DOCS)
else
lint: ./**/*.md 
	$(MDL) $(patsubst %,$(WORKSPACE)/%,$(^))
endif


test:
	echo 'src'
	echo $(MD_SRC)
	echo 'mds'
	echo $(MDS_SRC)
	echo 'mddocs'
	echo $(MD_DOCS)
	echo 'html'
	echo $(HTMLOBJECTS)
	echo 'html2'
	echo $(HTMLOBJECTS2)
	echo 'pdf'
	echo $(PDFOBJECTS)
	echo 'pdf2'
	echo $(PDFOBJECTS2)
	echo 'md'
	echo $(MDOBJECTS)
	echo 'troff docs'
	echo $(TROFFDOCS)
	echo $(HTMLMANPAGES)


tar: $(BUILDDIR)/pdfhtml.tar

$(BUILDDIR)/pdfhtml.tar: html pdf md
	rm -f $(BUILDDIR)/*/apis* \
		$(BUILDDIR)/*/admin* \
		$(BUILDDIR)/*/overview* \
		$(BUILDDIR)/*/install* \
		$(BUILDDIR)/*/shasta* \
		$(BUILDDIR)/*/cassini* \
		$(BUILDDIR)/*/taxonomy* \
        $(BUILDDIR)/*/hw*
	tar cf $@ $(BUILDDIR)/*

shs-docs-$(VERSION).tar.bz2:
	mkdir -p shs-docs-$(VERSION)
	cp -ar md html pdf shs-docs-$(VERSION)
	tar cjf $@ shs-docs-$(VERSION)

install: shs-docs-$(VERSION).tar.bz2
	cp -r $< $(RPM_BUILD_ROOT)/rpmbuild/SOURCES/

$(RPM_BUILD_ROOT)/rpmbuild:
	mkdir -p $@/BUILD
	mkdir -p $@/BUILDROOT
	mkdir -p $@/RPMS
	mkdir -p $@/SOURCES
	mkdir -p $@/SPECS
	mkdir -p $@/SRPMS

package: $(RPM_BUILD_ROOT)/rpmbuild install
	rpmbuild -ba shs-docs.spec --define "_topdir $(RPM_BUILD_ROOT)/rpmbuild"

dita_ot_dir: dir
	../scripts/dita_build_prep.sh

dita_container_prep:
	docker image build -t test-dita-ot-image:1.0 docker/

hpesc_build: dita_ot_dir dita_container_prep
	../scripts/dita_build.sh -b

dita_ot_pdf: dita_ot_dir dita_container_prep
	../scripts/dita_build.sh -p

dita_ot_md: dita_ot_dir dita_container_prep
	../scripts/dita_build.sh -m

dita_ot_html: dita_ot_dir dita_container_prep
	../scripts/dita_build.sh -w

dita_ot_tar: dita_ot_md dita_ot_html dita_ot_pdf
	cp $(TMPDIR)/VeRsIoN.md $(BUILDDIR)/md

# Delete the empty HPESC bundle build dir
	rm -fr $(HPESCBUILDDIR)
	tar cf pdfhtml.tar $(BUILDDIR)
	mv pdfhtml.tar $(BUILDDIR)