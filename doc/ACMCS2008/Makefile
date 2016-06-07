############################################################################
# FILE   : Makefile
# Subject: Controls build of the ACMCS paper
#
# It would be nice to figure out how to get make to invoke latex a
# sufficient number of times in all cases.
############################################################################

# Implicit rule for converting PIC figures into TeX files.
.SUFFIXES:	.pic

.pic.tex:
	pic -t $< > $*.tex

SOURCE = \
	ces_macros.tex   \
	conclusion.tex   \
	features.tex     \
	figures.tex      \
	foundation.tex   \
	frontmatter.tex  \
	introduction.tex \
	macros.tex       \
	main.bbl         \
	main.tex         \
	other.tex        \
	overview.tex     \
	QCM-SD3.tex      \
	review.tex       \
	RT.tex           \
	SPKI-SDSI.tex    \
	summary.tex

FIGURES = \
	tmstruct.fig

# Main paper.
main.ps:	main.dvi
	dvips main.dvi

main.dvi:	$(SOURCE) $(FIGURES)
	latex main.tex

main.bbl:	main.aux survey.bib
	bibtex main

# This rule is used the first time a build is done.
main.aux:
	latex main.tex
