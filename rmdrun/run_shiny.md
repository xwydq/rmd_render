---
title: "A Shiny Document"
output: html_document
runtime: shiny
---

A standard R plot can be made interactive by wrapping
it in the Shiny `renderPlot()` function. The `selectInput()`
function creates the input widget to drive the plot.


```r
library(shiny)
selectInput(
  'breaks', label = 'Number of bins:',
  choices = c(10, 20, 35, 50), selected = 20
)
```

<!--html_preserve--><div class="form-group shiny-input-container">
<label class="control-label" for="breaks">Number of bins:</label>
<div>
<select id="breaks"><option value="10">10</option>
<option value="20" selected>20</option>
<option value="35">35</option>
<option value="50">50</option></select>
<script type="application/json" data-for="breaks" data-nonempty="">{}</script>
</div>
</div><!--/html_preserve-->

```r
renderPlot({
  par(mar = c(4, 4, .1, .5))
  hist(
    faithful$eruptions, as.numeric(input$breaks),
    col = 'gray', border = 'white',
    xlab = 'Duration (minutes)', main = ''
  )
})
```

<!--html_preserve--><div id="out53176c12a11b82a8" class="shiny-plot-output" style="width: 100% ; height: 400px"></div><!--/html_preserve-->
