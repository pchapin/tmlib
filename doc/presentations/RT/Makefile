#
# Makefile for Figures document.
#

RT.ps:	RT.dvi
	dvips -t landscape RT.dvi
	chmod 700 RT.ps

RT.dvi:	RT.tex request.tex
	latex RT.tex

request.tex:	request.pic
	pic -t request.pic > request.tex
