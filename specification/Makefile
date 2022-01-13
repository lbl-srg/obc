# Makefile for Sphinx documentation
#

# You can set these variables from the command line.
#SPHINXOPTS    = -W
SPHINXBUILD   = sphinx-build
PAPER         =
BUILDDIR      = build
TMP          := $(shell mktemp -u /tmp/sphinx.XXXXXX)
# Bitbucket user name
BITUSR        = $(USER)

TEMPDIR := $(shell mktemp -d)

found=${shell java -jar source/plantuml.jar -testdot | grep -c 'Installation seems OK. File generation OK'}

#PYTHONPATH=`pwd`/..

# Internal variables.
PAPEROPT_a4     = -D latex_paper_size=a4
PAPEROPT_letter = -D latex_paper_size=letter
ALLSPHINXOPTS   = -d $(BUILDDIR)/doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) source

.PHONY: help clean html dirhtml pickle json htmlhelp qthelp latex changes linkcheck doctest

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  html      to make standalone HTML files"
	@echo "  dirhtml   to make HTML files named index.html in directories"
	@echo "  pickle    to make pickle files"
	@echo "  json      to make JSON files"
	@echo "  htmlhelp  to make HTML files and a HTML help project"
	@echo "  qthelp    to make HTML files and a qthelp project"
	@echo "  latex     to make LaTeX files, you can set PAPER=a4 or PAPER=letter"
	@echo "  changes   to make an overview of all changed/added/deprecated items"
	@echo "  linkcheck to check all external links for integrity"
	@echo "  doctest   to run all doctests embedded in the documentation (if enabled)"

cleanModels:
	-rm -f source/models/*.fmu
	-rm -f source/models/*.mat
	-rm -f source/models/*.h
	-rm -f source/models/*.c
	-rm -f source/models/*.o
	-rm -f source/models/*.txt
	-rm -f source/models/modelDescription.xml
	-rm -f source/models/dymosim
	-rm -f source/models/fmu.map
	-rm -f source/models/request.
	-rm -f source/models/status.
	-rm -f source/models/success.
	-rm -rf source/models/Resources
	-rm -rf source/models/binaries
clean:
	-rm -rf $(BUILDDIR)/*

generate_cdl_from_modelica:
	./generate_cdl_from_modelica.py
#	rm -r $(TEMPDIR)

copy_case_study1_results:
	cp ../examples/case_study_1/img/* source/img/case_study1/results/

html:
	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html
	./fixHtml.py
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/html"



latex:	test_installation
	$(SPHINXBUILD) -b latex $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	@echo
	@echo "Build finished; the LaTeX files are in $(BUILDDIR)/latex."
	@echo "Run \`make all-pdf' or \`make all-ps' in that directory to" \
	      "run these through (pdf)latex."
	./fixLatex.py
	(cd $(BUILDDIR)/latex; make all-pdf)

test_installation:
ifneq "$(found)" "1"
	@echo "*** Error: plantuml does not pass configuration test. Run 'java -jar source/plantuml.jar -testdot'"
	exit 1
endif

linkcheck:
	$(SPHINXBUILD) -b linkcheck $(ALLSPHINXOPTS) $(BUILDDIR)/linkcheck
	@echo
	@echo "Link check complete; look for any errors in the above output " \
	      "or in $(BUILDDIR)/linkcheck/output.txt."

copytowww:
	ls build/latex/obc_report.pdf
	(cd build && \
	rsync --delete --links --archive \
		--recursive --backup --update \
		--rsh=ssh --compress --times --checksum --verbose \
		--exclude ".DS_Store" \
		--exclude "*~" \
	    html/* \
	    mwetter@simulationresearch.lbl.gov:/usr/local/www/obc/specification/ \
	)
	(cd build && \
	rsync --checksum --verbose \
	    latex/obc_report.pdf \
	    mwetter@simulationresearch.lbl.gov:/usr/local/www/obc/download/obc_report.pdf \
	)


dist:	html, latex, linkcheck
