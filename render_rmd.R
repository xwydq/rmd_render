rmarkdown::render("test_rmd/rmd_outputtest.Rmd")

# output 重命名
system.time({
  rmarkdown::render("test_rmd/rmd_outputtest.Rmd",
                    quiet = TRUE, # suppress printing no message
                    output_dir = file.path("test_rmd", uuid::UUIDgenerate()),
                    output_file = "demo01.html")
})

# reset output_format 
system.time({
  rmarkdown::render("test_rmd/rmd_outputtest.Rmd", 
                    output_format = "md_document", 
                    output_dir = file.path("test_rmd", uuid::UUIDgenerate()),
                    quiet = TRUE,
                    output_file = "demo02.md")
})

# render md to html
rmarkdown::render("test_rmd/demo02.md", 
                  output_format = "html_document", 
                  output_file = "demo002.html")


## 取消 分离的HTML文件，生成速度快
# self_contained: false
# lib_dir: libs
system.time({
  dir_name = uuid::UUIDgenerate()
  rmarkdown::render("test_rmd/rmd_outputtest.Rmd",
                    quiet = TRUE, # suppress printing no message
                    output_dir = file.path("test_rmd", dir_name),
                    output_options = list(self_contained=FALSE,
                                          lib_dir=file.path(dir_name, "libs")),
                    output_file = "demo01.html")
})


# output: html_fragment
system.time({
  dir_name = uuid::UUIDgenerate()
  rmarkdown::render("test_rmd/rmd_outputtest.Rmd",
                    quiet = TRUE, # suppress printing no message
                    output_format = "html_fragment",
                    output_dir = file.path("test_rmd", dir_name),
                    output_options = list(self_contained=FALSE,
                                          lib_dir=file.path(dir_name, "libs")),
                    output_file = "demo01.html")
})

## 指定CDN 拼接
# header.html(libs) + demo01.html(html_fragment) + footer.html
# 问题不含样式




##############
# flexdashboard
# rmarkdown::draft("test_rmd/rmd_outputtest1.Rmd", template = "flex_dashboard", package = "flexdashboard")
system.time({
  dir_name = uuid::UUIDgenerate()
  rmarkdown::render("test_rmd/demo_flexdashboard.Rmd",
                    quiet = TRUE, # suppress printing no message
                    output_format = "flexdashboard::flex_dashboard",
                    output_dir = file.path("test_rmd", dir_name),
                    output_options = list(self_contained=FALSE,
                                          lib_dir=file.path(dir_name, "libs"),
                                          orientation="columns",
                                          vertical_layout="fill"),
                    output_file = "demo_flexdashboard.html")
})



############
## test plotly render
# render 速度比 ggplot2 快很多
library(plotly)
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
  p1=p1,
  p2=p2,
  p3=p3,
  p4=p4,
  p5=p5,
  p6=p6,
  p7=p7,
  p8=p8,
  p9=p9,
  # p7=p10, #替换后正常显示
  # p8=p11,
  # p9=p12,
  p10=p10,
  p11=p11,
  p12=p12
)

# output_format = "html_document" 多个TAB可以正常显示
# output_format = "flex_dashboard" 多个TAB时存在部分不能正常显示
# 测试比对因某个不能正常显示的图表（如上的P9）导致后续的TAB显示失败（估计flex 与 plotlyjs部分冲突导致）
dir_name = uuid::UUIDgenerate()
system.time({
  rmarkdown::render("test_rmd/renderplotly-test.Rmd",
                    quiet = TRUE, # suppress printing no message
                    # output_format = "flexdashboard::flex_dashboard",
                    output_format = "html_document",
                    output_dir = file.path("test_rmd", dir_name),
                    # output_options = list(self_contained=FALSE,
                    #                       lib_dir=file.path(dir_name, "libs"),
                    #                       orientation="columns",
                    #                       vertical_layout="fill"),
                    output_file = "renderplotly-test.html",
                    params = list(
                      plots = plt_list
                    ))
})
