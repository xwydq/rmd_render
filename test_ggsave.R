library(nycflights13)
library(data.table)


data <- data.table(flights)
data <- data[sample(1:nrow(data), 1000), ]
var_xs = c("dest", "origin", "tailnum", "carrier")
var_y = "arr_time"

plt_data <- melt.data.table(data, id.vars=var_y, measure.vars=var_xs)

var_plot <- ggplot(plt_data, aes_string(x="value", y=var_y, group="value")) +
  geom_boxplot() +
  geom_jitter(alpha=0.5, width = 0.2) +
  facet_wrap(~variable, scales = "free") +
  xlab(NULL)

system.time({
  ggsave("testsave.png", var_plot)
})
