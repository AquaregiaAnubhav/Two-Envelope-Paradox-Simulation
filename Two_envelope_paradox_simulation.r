#!/usr/bin/env Rscript

library(optparse)
library(ggplot2)
library(reshape2)
library(gridExtra)

sim_2envpar = function(n, k) {
  result = data.frame(
    choice = numeric(n),
    switch_choice = numeric(n),
    switch_payoff = numeric(n),
    benefit_bool = integer(n),
    choice_mean = numeric(n),
    switch_mean = numeric(n)
  )
  
  net_ben_bool = 0
  choice_mean = 0
  switch_mean = 0
  
  for (i in 1:n) {
    x = rgeom(1, 0.5)
    amounts = c(k^(x-1), k^x)
    choice = sample(amounts, 1)
    switch_choice = setdiff(amounts, choice)
    switch_payoff = switch_choice - choice
    benefit_bool = ifelse(switch_payoff > 0, 1, -1)
    
    net_ben_bool = net_ben_bool + benefit_bool
    choice_mean = (choice_mean * (i - 1) + choice) / i
    switch_mean = (switch_mean * (i - 1) + switch_choice) / i
    
    # Fill the i-th row
    result[i, ] = c(choice, switch_choice, switch_payoff, benefit_bool, choice_mean, switch_mean)
  }
  
  return(list(result, net_ben_bool, choice_mean, switch_mean))
}


if (!interactive()){
  options_list=list(
    make_option(c("-n","--num_sim"), type="integer", help="Number of iterations in simulation", metavar="NUMBER OF SIMULATIONS"),
    make_option(c("-m","--multiplier"), type="integer", help="Multiplier value in between the amounts in the envelopes", metavar="MULTIPLIER VAULE")
    )
  Parser=OptionParser(option_list= options_list)
  opt=parse_args(Parser)

  start_time=Sys.time()
  res=sim_2envpar(opt$num_sim, opt$multiplier)
  end_time=Sys.time()

  df=res[[1]]
  net_ben_bool=res[[2]]
  choice_mean=res[[3]]
  switch_mean=res[[4]]
  mean_benefit=choice_mean-switch_mean

  elapsed_time=end_time-start_time
  cat("-----------------------------------------------------\n")
  cat("Mean payoff per choice            :     ", choice_mean,
      "\nMean payoff per switched choice   :     ", switch_mean,
      "\nMean benefit on switching         :     ", mean_benefit,
      "\nNet amount of times when in profit:     ", net_ben_bool, "\n")
  cat("-----------------------------------------------------\n")
  
  cat("Time taken for", opt$num_sim, "simulations     :     ", elapsed_time, "seconds\n")
  cat("-----------------------------------------------------\n")

  df$diff= df$switch_mean-df$choice_mean
  df$iteration= 1:nrow(df)
  
  
  plot_df= melt(df[, c("iteration", "choice_mean", "switch_mean", "diff")], id.vars = "iteration")
  
  
  plot_main = ggplot(plot_df[plot_df$variable %in% c("choice_mean", "switch_mean"), ],
                     aes(x = iteration, y = value, color = variable)) +
    geom_line(linewidth=1) +
    labs(title = "Rolling Mean of Payoffs in Two-Envelope Paradox Simulation",
         x = "Iteration",
         y = "Rolling mean of Payoffs",
         color = "Legend") +
    scale_color_manual(
      values = c("choice_mean" = "blue", "switch_mean" = "green"),
      labels = c("choice_mean" = "Rolling mean payoff if I Stick", 
                 "switch_mean" = "Rolling mean payoff if I Switch")
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(hjust = 0.5, face = "bold"),
      panel.border = element_rect(color = "black", fill = NA, linewidth = 1)
    )
  
  plot_diff = ggplot(plot_df[plot_df$variable == "diff", ],
                     aes(x = iteration, y = value, color = variable)) +
    geom_line(linewidth=1) +
    labs(title = "Rolling Mean Benefit of Switching",
         x = "Iteration",
         y = "Rolling mean of Payoffs",
         color = "Legend") +
    scale_color_manual(
      values = c("diff" = "red"),
      labels = c("diff" = "Rolling mean benefit of Switching")
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(hjust = 0.5, face = "bold"),
      panel.border = element_rect(color = "black", fill = NA, linewidth = 1)
    )
  

  
  ggsave("plots/two_envelope_plot.jpg",
         plot = grid.arrange(plot_main, plot_diff, ncol = 1),
         width = 12, height = 12, dpi = 300, create.dir = TRUE)
  
}
