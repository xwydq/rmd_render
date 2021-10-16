library(htmltools)
render_tabplots <- function(plots, label_nms = names(plots)){
  tagsid <- sapply(1:length(plots), FUN = function(x) {paste0(sample(LETTERS, 10, replace = TRUE), collapse = "")})
  # create our top-level div for our tabs
  tags$div(
    # create the tabs with titles as a ul with li/a
    tags$ul(
      class="nav nav-tabs",
      role="tablist",
      lapply(
        seq_along(tagsid),
        function(p){
          tags$li(
            tags$a(
              "data-toggle"="tab",
              href=paste0("#tab-",tagsid[p]),
              label_nms[p]
            )
          )
        }
      )
    ),
    # fill the tabs with our plotly plots
    tags$div(
      class="tab-content",
      lapply(
        seq_along(plots),
        # names(plots),
        function(p){
          tags$div(style="height: 80vh;",
            #  make the first tabpane active
            class=ifelse(tagsid[p]==tagsid[1],"tab-pane active","tab-pane"),
            #  id will need to match the id provided to the a href above
            id=paste0("tab-",tagsid[p]),
            as_widget(plots[[p]])
          )
        }
      )
    )
  )
}


render_orderplots <- function(plots, label_nms = names(plots), tagh3=TRUE){
  # create our top-level div for our tabs
  tags$div(
    # fill the tabs with our plotly plots
    tags$div(
      lapply(
        seq_along(plots),
        function(p){
          if(tagh3){
            res <- tags$div(
              tags$h3(label_nms[p]),
              as_widget(plots[[p]])
            )
          }else{
            res <- tags$div(
              as_widget(plots[[p]])
            )
          }
          return(res)
        }
      )
    )
  )
  # %>%
  #   attachDependencies(
  #     list(
  #       rmarkdown::html_dependency_jquery(),
  #       shiny::bootstrapLib()
  #     )
  #   )
}