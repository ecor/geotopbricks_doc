
# render_print: true
#
#

file <- "erum_poster_2"
file_rmd <- paste0(file,".Rmd")
file_png <- paste0(file,".png")
file_url <- paste0(file,".html")
file_pdf <- paste0(file,".jpg")

### A0: 

f <- 2.7
width <- 841*f
height <- 1189*f

rmarkdown::render(file_rmd)
webshot::webshot(url=file_url,file=file_pdf,vwidth = width,vheight = height)

