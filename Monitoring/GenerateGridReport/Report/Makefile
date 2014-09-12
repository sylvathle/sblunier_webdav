LATEX=latex
.PHONY: all report.pdf clean

report.pdf : report.tex
	${LATEX} report.tex
	${LATEX} report.tex
	dvipdf report.dvi

clean::
	rm -rf *.600pk *.tfm* *.600gf* *.bbl* *.log* *.blg* *.aux* *.dvi* *.pdf* *.t1 report
