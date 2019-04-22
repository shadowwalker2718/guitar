#!/bin/sh

#bookdown::render_book('index.Rmd', 'bookdown::gitbook')
#bookdown::render_book('index.Rmd', 'bookdown::pdf_book')
#bookdown::render_book('index.Rmd', 'bookdown::tufte_html_book')
#bookdown::render_book('index.Rmd', 'bookdown::html_chapters')
#bookdown::render_book('index.Rmd', 'bookdown::epub_book')
#serve_book(dir='.',output_dir = '_book',preview = TRUE,
#  in_session = TRUE, daemon = FALSE, host='0.0.0.0')

cat > sde.R <<RSCRIPT_CONTENT
library(bookdown);
library(rmarkdown);

Sys.setenv(RSTUDIO_PANDOC="/usr/lib/rstudio/bin/pandoc")

bookdown::render_book('index.Rmd', 'bookdown::gitbook')
bookdown::render_book('index.Rmd', 'bookdown::pdf_book')
RSCRIPT_CONTENT

if [ -f sde.R ]; then
  Rscript sde.R && rm -f sde.R
else
  echo "ERROR: Cannot find sde.R"
fi

if [ -f sde.tex ]; then
  pdflatex sde
  #pdflatex sde && makeindex sde.idx && pdflatex sde && mv sde.pdf "vol_paper.pdf"
  if [ "$?" -eq "0" ]; then
    rm -f sde.aux sde.idx sde.ilg sde.ind sde.log sde.md sde.out sde.tex sde.toc
  fi
else
  echo "ERROR: Cannot find sde.tex"
fi


bookdown::render_book('index.Rmd',
bookdown::gitbook(fig_caption = TRUE,
number_sections = TRUE,
  self_contained = FALSE,
  lib_dir = "libs",
  split_by = c("chapter", "chapter+number", "section", "section+number", "rmd", "none"),
  split_bib = TRUE,
  config = list()
)

bookdown::render_book('index.Rmd', output_format=gitbook(fig_caption = TRUE, number_sections = TRUE,
split_by = c("chapter", "chapter+number", "section", "section+number", "rmd", "none"),
split_bib = TRUE, config = list(css='style.css',highlight='tango')))


gf=gitbook(fig_caption = TRUE, number_sections = TRUE, self_contained = FALSE, lib_dir = "libs",
split_by = c('section+number', 'section', 'chapter+number', 'chapter', 'rmd', 'none'),
split_bib = TRUE, config = list(highlight='tango'),css='style.css')


gf2=html_chapters(fig_caption = TRUE, number_sections = TRUE, self_contained = FALSE, lib_dir = "libs",
split_by = c("chapter", "chapter+number", "section", "section+number", "rmd", "none"),
split_bib = TRUE, config = list(highlight='tango'),css='style.css')


bookdown::render_book('index.Rmd', 'bookdown::html_chapters')


hc = html_chapters(toc = TRUE, number_sections = TRUE, fig_caption = TRUE,
  lib_dir = "libs", template = "templates.html",  base_format = rmarkdown::html_document, split_bib = TRUE,
  page_builder = build_chapter, split_by = c("section+number",  "section", "chapter+number", "chapter", "rmd", "none"))


hc = html_chapters(toc = TRUE, number_sections = TRUE, fig_caption = TRUE,
  lib_dir = "libs", template = bookdown:::bookdown_file("templates/default.html"),
  base_format = rmarkdown::html_document, split_bib = TRUE,
  page_builder = build_chapter, split_by = c("section+number",  "section", "chapter+number", "chapter", "rmd", "none"), css='style.css')

## Generate Code and upload to quant365
library(bookdown)
hc = html_chapters(toc =FALSE, number_sections = TRUE, fig_caption = FALSE,
  lib_dir = "libs", template = "/mnt/hgfs/book/sde/templates/template.html",
  base_format = rmarkdown::html_document, split_bib = TRUE,
  page_builder = build_chapter, split_by = c("section+number",  "section", "chapter+number", "chapter", "rmd", "none"), css='style.css')

bookdown::render_book('index.Rmd',hc)

####

library(bookdown)
button_link = function(target, text, align) {
  if (length(target) == 0) return()
  if(align==0)
    sprintf(
      '<div class="col-sm-6"><a href="%s"><button class="btn btn-xs btn-info">%s</button></a></div>',
      target, text)
  else
    sprintf(
      '<div class="col-sm-6 text-right"><a href="%s"><button class="btn btn-xs btn-info">%s</button></a></div>',
      target, text)
}

my_build_chapter = function(
  head, toc, chapter, link_prev, link_next, rmd_cur, html_cur, foot
) {
  # add a has-sub class to the <li> items that has sub lists
  toc = gsub('^(<li>)(.+<ul>)$', '<li class="has-sub">\\2', toc)
  paste(c(
    head,
    '<div class="row">',
    '<div class="col-sm-3">',
    toc,
    '</div>',
    '',
    '',
    '<div class="col-sm-9 text-bottom" id="my_body">
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- quant365 -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-9054627452897134"
     data-ad-slot="4792440779"
     data-ad-format="auto"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
<hr>',
    chapter,
    '<p style="text-align: center;">',
    button_link(link_prev, '<< Prev',0),
    #edit_link(rmd_cur),
    '',
    button_link(link_next, 'Next >>',1),
    '</p>',
    '</div>',
    '</div>',
    foot
  ), collapse = '\n')
}

hc = html_chapters(
  toc =TRUE, toc_depth=2, number_sections = TRUE, fig_caption = FALSE,
  lib_dir = "libs", template = "/Users/henry.wu/guitar/templates/template.html",
  base_format = rmarkdown::html_document, split_bib = TRUE,
  page_builder = my_build_chapter,
  split_by = c("section+number",  "section", "chapter+number", "chapter", "rmd", "none"),
  css='style.css')

bookdown::render_book('index.Rmd',hc)

export SRC_BOOK=/root/guitar/_book/
rsync -a $SRC_BOOK root@www.quant365.com:/quant365.com/music

bookdown::render_book('00-chinese.Rmd',hc)

bookdown::render_book('41-heap.Rmd',hc,preview = TRUE)

## Rebuild a single html page
bookdown::render_book('41-heap.Rmd', 'bookdown::gitbook',preview = TRUE)


