all: Bachelor.tex
	bibtex Bachelor
	pdflatex Bachelor.tex
	#pdflatex Bachelor.tex
clean: 
	rm -f *.o *.toc *.log *.aux *.bbl *.blg
