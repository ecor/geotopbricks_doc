
# render_print: true
#
#

file <- "erum2018_poster_cordano_et_al"
file_rmd <- paste0(file,".Rmd")

### A0: 

f <- 2.7
width <- 841*f
height <- 1189*f

rmarkdown::render(file_rmd)

file_png <- paste0(file,".png")
file_url <- paste0(file,".html")
file_pdf <- paste0(file,".jpg")

webshot::webshot(url=file_url,file=file_png,vwidth = width,vheight = height)

