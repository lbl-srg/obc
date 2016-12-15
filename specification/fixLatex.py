#!/usr/bin/python
import os

newFil = os.path.join("build", "latex", "cdl_specification.tex-new")
oldFil = os.path.join("build", "latex", "cdl_specification.tex")

def replace(old, new):
    with open(newFil, "wt") as out:
        for line in open(oldFil):
            out.write(line.replace(old, new))
    os.remove(oldFil)
    os.rename(newFil, oldFil)

replace('\def\sphinxdocclass{report}',
        '%\def\sphinxdocclass{report}')
replace('\documentclass[letterpaper,11pt, openany]{sphinxmanual}',
        '\documentclass[letterpaper,11pt,english]{report}')
replace('\maketitle',
        '\input{../../source/titlepage.tex}')
replace('\\begin{thebibliography}{1}',
        '''\\chapter{References}
\\begin{thebibliography}{1}''')

replace('\\begin{tabular}', '\\begin{longtable}')
replace('\\end{tabular}', '\\end{longtable}')
