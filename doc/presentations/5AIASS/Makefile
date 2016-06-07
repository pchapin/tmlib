#
# Makefile for 5AIASS talk.
#

main.ps:	main.dvi
	dvips -t landscape main.dvi
	chmod 700 main.ps

main.dvi:	main.tex ces_macros.tex \
	rt0example.tex cycle.tex rtrexample.tex \
	search01.tex search02.tex search03.tex search04.tex search05.tex
	latex main.tex

rt0example.tex:	rt0example.pic
	pic -t rt0example.pic > rt0example.tex

cycle.tex:	cycle.pic
	pic -t cycle.pic > cycle.tex

rtrexample.tex:	rtrexample.pic
	pic -t rtrexample.pic > rtrexample.tex

search01.tex:	search01.pic
	pic -t search01.pic > search01.tex

search02.tex:	search02.pic
	pic -t search02.pic > search02.tex

search03.tex:	search03.pic
	pic -t search03.pic > search03.tex

search04.tex:	search04.pic
	pic -t search04.pic > search04.tex

search05.tex:	search05.pic
	pic -t search05.pic > search05.tex
