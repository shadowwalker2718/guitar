#!/bin/bash

#set -x
#Rscript --no-save --no-restore -e "print ('Hello')"

rm -f sde.*

cat > sde.R <<RSCRIPT_CONTENT
library(bookdown);
library(rmarkdown);

#Sys.setenv(RSTUDIO_PANDOC="/root/.local/bin/pandoc")
Sys.setenv(RSTUDIO_PANDOC="/usr/lib/rstudio/bin/pandoc")

bookdown::render_book('index.Rmd', 'bookdown::gitbook')
#bookdown::render_book('index.Rmd', 'bookdown::pdf_book')
RSCRIPT_CONTENT

SRC_BOOK=/root/sde_web/_book/

if [ -f sde.R ]; then
  cat sde.R && Rscript sde.R && rm -f sde.Rmd sde.R
  if [ "$?" == "0" ]; then
    echo "Starting to run rsync..."
    if [ -d $SRC_BOOK ]; then
      rsync -a $SRC_BOOK root@www.quant365.com:/quant365.com/sde
    else
      echo "Folder $SRC_BOOK doesn't exist."
    fi
  fi
else
  echo "ERROR: Cannot find sde.R"
fi

if [ -f sde.tex ]; then
  pdflatex sde
  #pdflatex sde && makeindex sde.idx && pdflatex sde && mv sde.pdf "vol_paper.pdf"
  if [ "$?" -eq "0" ]; then
    rm -f sde.aux sde.idx sde.ilg sde.ind sde.log sde.md sde.out sde.toc
    if [ -f sde.tex ]; then rm -f sde.tex; fi
  fi
else
  echo "Cannot find sde.tex so no pdf generated..."
fi


# How many leetcode problems?
# gp "leetcode.com/problems/" *Rmd |awk -F"leetcode.com/problems/" '{print $2}'|awk -F"/" '{print $1}'|sort|uniq|wc -l
# gp "www.lintcode.com/en/problem/" *Rmd |awk -F"lintcode.com/en/problem/" '{print $2}'|awk -F"/" '{print $1}'|sort|uniq|wc -l


