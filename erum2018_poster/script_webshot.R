
# render_print: true
#
#

filez <<- "erum2018_poster_cordano_et_al"
filez_rmd <- paste0(filez,".Rmd")

### A0: 

f <- 2.7
width <- 841*f
height <- 1189*f

postr::render(filez_rmd)

#file_png <- paste0(filez,".png")
#file_url <- paste0(filez,".html")
#file_pdf <- paste0(filez,".jpg")

#webshot::webshot(url=file_url,file=file_png,vwidth = width,vheight = height)

