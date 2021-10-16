### httpserver
options(servr.host = '0.0.0.0', servr.port = 8212)
servr::httd(dir = '~/testpro/edalibs/')
servr::daemon_list()
servr::daemon_stop(1)
## cmd
# Rscript -e "options(servr.host = '0.0.0.0', servr.port = 8212,servr.daemon = TRUE);servr::httd(dir = '~/testpro/edalibs/')"
# http://35.220.217.184:8212

## 生成html
setwd("~/testpro/test_rmd/edalibs")

# lib_dir应该使用随机字符串
LIB_DIR = sprintf("eda4insights_%s_libs", 
                  paste0(sample(LETTERS, 10, replace = TRUE), collapse = ""))
OUTPUTHTML_NAME = "edalibs_test.html"
DEPENDENCY_SERVER = "http://35.220.217.184:8212"

rmarkdown::render("edalibs_demo.Rmd",
                  quiet = TRUE, # suppress printing no message
                  output_format = "flexdashboard::flex_dashboard",
                  # output_dir = file.path("test_rmd", dir_name),
                  output_options = list(self_contained=FALSE,
                                        lib_dir=LIB_DIR
                  ),
                  output_file = OUTPUTHTML_NAME)

htmls = readLines(OUTPUTHTML_NAME)
htmls = gsub(LIB_DIR, DEPENDENCY_SERVER, htmls)
writeLines(htmls, OUTPUTHTML_NAME)
# delete dir
unlink(LIB_DIR, recursive = TRUE, force = TRUE)


## CDN 
# 不稳定需要查询多个免费源


###### test multiplot render speed
system.time({
  LIB_DIR = sprintf("eda4insights_%s_libs", 
                    paste0(sample(LETTERS, 10, replace = TRUE), collapse = ""))
  OUTPUTHTML_NAME = "render_multiplots.html"
  DEPENDENCY_SERVER = "http://35.220.217.184:8212"
  
  rmarkdown::render("render_multiplots.Rmd",
                    quiet = TRUE, # suppress printing no message
                    output_format = "html_document",
                    # output_dir = file.path("test_rmd", dir_name),
                    output_options = list(self_contained=FALSE,
                                          lib_dir=LIB_DIR
                    ),
                    output_file = OUTPUTHTML_NAME)
  
  htmls = readLines(OUTPUTHTML_NAME)
  htmls = gsub(LIB_DIR, DEPENDENCY_SERVER, htmls)
  writeLines(htmls, OUTPUTHTML_NAME)
  
  unlink(LIB_DIR, recursive = TRUE, force = TRUE)
})


###### ggplot2 ggpair to plotly
library(GGally)
library(plotly)
p = ggpairs(mtcars)
p1 = plot_ly(economics, x = ~pop)
p2 = plot_ly(economics, x = ~date, y = ~pop)
p3 = plot_ly(z = ~volcano)
p4 = plot_ly(z = ~volcano, type = "surface")
p5 = add_lines(plot_ly(economics, x = ~date, y = ~unemploy/pop))
p6 = economics %>% plot_ly(x = ~date, y = ~unemploy/pop) %>% add_lines()
p7 = plot_ly(economics, x = ~date, color = I("black")) %>%
  add_lines(y = ~uempmed) %>%
  add_lines(y = ~psavert, color = I("red"))
p8 = plot_ly(iris, x = ~Sepal.Width, y = ~Sepal.Length) 
p9 = add_markers(p8, color = ~Petal.Length, size = ~Petal.Length)
p10 = add_markers(p8, color = ~Species)
p11 = add_markers(p8, color = ~Species, colors = "Set1")
p12 = add_markers(p8, symbol = ~Species)

plt_list = list(
  # p=ggplotly(p), # ggpairs转化费时约10s
  p1=p1,
  p2=p2,
  # p3=p3,
  # p4=p4,
  # p5=p5,
  # p6=p6,
  # p7=p7,
  # p8=p8,
  # p9=p9,
  # p10=p10,
  # p11=p11,
  p12=p12
)


system.time({
  LIB_DIR = sprintf("eda4insights_%s_libs", 
                    paste0(sample(LETTERS, 10, replace = TRUE), collapse = ""))
  OUTPUTHTML_NAME = "render_plotsfromParams.html"
  DEPENDENCY_SERVER = "http://35.220.217.184:8212"
  rmarkdown::render("render_plotsfromParams.Rmd",
                    quiet = TRUE, # suppress printing no message
                    output_format = "html_document",
                    # output_dir = file.path("test_rmd", dir_name),
                    output_options = list(
                      self_contained=FALSE,
                      # mathjax="local",
                      lib_dir=LIB_DIR
                    ),
                    output_file = OUTPUTHTML_NAME,
                    params = list(
                      plots = plt_list
                    )
  )
  htmls = readLines(OUTPUTHTML_NAME)
  htmls = gsub(LIB_DIR, DEPENDENCY_SERVER, htmls)
  writeLines(htmls, OUTPUTHTML_NAME)
  
  unlink(LIB_DIR, recursive = TRUE, force = TRUE)
})



#####
# test flexdashboard render with params
# render plots list (lapply tagList tabpanel)
source("render_plots.R")
system.time({
  LIB_DIR = sprintf("eda4insights_%s_libs", 
                    paste0(sample(LETTERS, 10, replace = TRUE), collapse = ""))
  OUTPUTHTML_NAME = "render_plotsfromParams.html"
  DEPENDENCY_SERVER = "http://35.220.217.184:8212"
  rmarkdown::render("render_plotsfromParams.Rmd",
                    quiet = TRUE, # suppress printing no message
                    output_format = "html_document",
                    # output_format = "flexdashboard::flex_dashboard", #该格式部分图表不能正常显示
                    # output_dir = file.path("test_rmd", dir_name),
                    output_options = list(
                      self_contained=FALSE,
                      # mathjax="local",
                      orientation="columns",
                      vertical_layout="fill",
                      lib_dir=LIB_DIR
                    ),
                    output_file = OUTPUTHTML_NAME,
                    params = list(
                      plots = plt_list
                    )
  )
  htmls = readLines(OUTPUTHTML_NAME)
  htmls = gsub(LIB_DIR, DEPENDENCY_SERVER, htmls)
  writeLines(htmls, OUTPUTHTML_NAME)
  
  unlink(LIB_DIR, recursive = TRUE, force = TRUE)
})


#####
# test flexdashboard render with params loop for columns
# 
source("render_plots.R")
plt_list = list(
  # p=ggplotly(p), # ggpairs转化费时约10s
  p1=p1,
  p2=p2,
  p3=p3,
  p4=p4,
  p5=p5,
  p6=p6,
  p7=p7,
  p8=p8,
  p9=p9,
  p10=p10,
  p11=p11,
  p12=p12
)
system.time({
  LIB_DIR = sprintf("eda4insights_%s_libs", 
                    paste0(sample(LETTERS, 10, replace = TRUE), collapse = ""))
  OUTPUTHTML_NAME = "flex_loopcolumn.html"
  DEPENDENCY_SERVER = "http://35.220.217.184:8212"
  rmarkdown::render("flex_loopcolumn.Rmd",
                    quiet = TRUE, # suppress printing no message
                    # output_format = "html_document",
                    output_format = "flexdashboard::flex_dashboard",
                    # output_dir = file.path("test_rmd", dir_name),
                    output_options = list(
                      self_contained=FALSE,
                      # mathjax="local",
                      orientation="columns",
                      vertical_layout="fill",
                      lib_dir=LIB_DIR
                    ),
                    output_file = OUTPUTHTML_NAME,
                    params = list(
                      plots = plt_list
                    )
  )
  htmls = readLines(OUTPUTHTML_NAME)
  htmls = gsub(LIB_DIR, DEPENDENCY_SERVER, htmls)
  writeLines(htmls, OUTPUTHTML_NAME)
  
  unlink(LIB_DIR, recursive = TRUE, force = TRUE)
})
