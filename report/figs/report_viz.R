
# packages ----------------------------------------------------------------

library(ggplot2)
library(ggthemes)
library(lattice)
library(tidyr)
library(plyr)
library(reshape2)
library(microbenchmark)
library(readxl)


# import data -------------------------------------------------------------
## GA - KGA
data <- read.csv2("..../genomic/finalResults/finalResults.txt", sep = ",")
data_clean <- data[,c("dataset",
                      "X.meanDist_GA",
                      "X.meanDist_KGA",
                      "X.bestDist_GA",
                      "X.bestDist_KGA")]

colnames(data_clean) <- c("Dataset", "MeanDist_GA", "MeanDist_KGA", "BestDist_GA", "BestDist_KGA")
data_bar_GA_KGA <- melt(data_clean, id.vars = "Dataset")
data_bar_GA_KGA$value <- as.numeric(data_bar_GA_KGA$value)

## ACO-Ant Q



# grouped bar chart -------------------------------------------------------

## GA-KGA

png("GA_KGA_avg_best.png", width = 12, height = 6, units = 'in', res = 300)
ggplot(data_bar_GA_KGA,
       aes(fill = variable,
           x = Dataset,
           y = value)) +
  geom_bar(position = "dodge",
           stat = "identity",
           alpha = .8,
           width = .5) + 
  theme_classic() +
  scale_x_discrete(limits = c("dj38",
                              "berlin52",
                              "ch130",
                              "d198",
                              "pr1002")) +
  scale_fill_manual(values = c("#333333",
                               "#b3b3b3",
                               "#990000",
                               "#ff4d4d"),
                    labels = c("  GA_Avg  ",
                               "  KGA_Avg ",
                               "  GA_Best ",
                               " KGA_Best"),
                    guide = guide_legend(override.aes = list(size = 15))) +
  labs(x = "Dataset",
       y = "Displacement%") +
  theme(legend.title = element_blank(),
        legend.position = "top") +
  coord_cartesian(ylim = c(0, 100)) + 
  annotate(geom="text",
           x=4.8,
           y=75,
           label="more than 1500%",
           color="white",
           angle = 90,
           size = 4) +
  annotate(geom="text",
           x=5.055,
           y=75,
           label="more than 1500%",
           color="white",
           angle = 90,
           size = 4)
dev.off()

## ACO - Ant-Q





# data
# data_bar_GA <- data[,c("dataset", "X.meanDist_GA", "X.bestDist_GA")]
# data_bar_GA <- melt(data_bar_GA, id.vars = "dataset")
# data_bar_KGA <- data[,c("dataset", "X.meanDist_KGA", "X.bestDist_KGA")]
# data_bar_KGA <- melt(data_bar_KGA, id.vars = "dataset")
# data_bar_ACO <- data1[,c("Dataset", "X.AvgDist_ACO", "X.BestDist_ACO")]
# data_bar_ACO <- melt(data_bar_ACO, id.vars = "Dataset")
# data_bar_Ant.Q <- data1[,c("Dataset", "X.AvgDist_Ant.Q", "X.BestDist_Ant.Q")]
# data_bar_Ant.Q <- melt(data_bar_Ant.Q, id.vars = "Dataset")
# 
# ## GA
# ggplot(data_bar_GA, aes(fill = variable, x = dataset, y = value)) +
#   geom_bar(position = "dodge", stat = "identity", alpha = .7) + theme_classic() +
#  scale_x_discrete(limits = c("dj38", "berlin52", "ch130", "d198", "pr1002")) +
#  scale_fill_manual(values = c("#333333","#b3b3b3"), labels = c("  meanDist_GA  ", "  bestDist_GA  "),
#                    guide = guide_legend(override.aes = list(size = 10))) +
#   labs(x = "Dataset", y = "Error%") +
#   theme(legend.title = element_blank(), legend.position = "top")
# 
# ##KGA
# ggplot(data_bar_KGA, aes(fill = variable, x = dataset, y = value)) +
#   geom_bar(position = "dodge", stat = "identity", alpha = .8, width = .5) + theme_classic() +
#   scale_x_discrete(limits = c("dj38", "berlin52", "ch130", "d198", "pr1002")) +
#   scale_fill_manual(values = c("#333333","#b3b3b3"), labels = c("  meanDist_KGA  ", "  bestDist_KGA"),
#                     guide = guide_legend(override.aes = list(size = 10))) +
#   labs(x = "Dataset", y = "Error%") +
#   theme(legend.title = element_blank(), legend.position = "top")
# 
# ##ACO
# ggplot(data_bar_ACO, aes(fill = variable, x = Dataset, y = value)) +
#   geom_bar(position = "dodge", stat = "identity", alpha = .8, width = .5) + theme_classic() +
#   scale_x_discrete(limits = c("Dj38", "Berlin52", "Ch130", "D198", "Pr1002")) +
#   scale_fill_manual(values = c("#333333","#b3b3b3"), labels = c("  AvgDist_ACO  ", "  BestDist_ACO"),
#                     guide = guide_legend(override.aes = list(size = 10))) +
#   labs(x = "Dataset", y = "Error%") +
#   theme(legend.title = element_blank(), legend.position = "top")
# 
# ##Ant-Q
# ggplot(data_bar_Ant.Q, aes(fill = variable, x = Dataset, y = value)) +
#   geom_bar(position = "dodge", stat = "identity", alpha = .8, width = .5) + theme_classic() +
#   scale_x_discrete(limits = c("Dj38", "Berlin52", "Ch130", "D198", "Pr1002")) +
#   scale_fill_manual(values = c("#333333","#b3b3b3"), labels = c("  AvgDist_Ant-Q  ", "  BestDist_Ant-Q"),
#                     guide = guide_legend(override.aes = list(size = 10))) +
#   labs(x = "Dataset", y = "Error%") +
#   theme(legend.title = element_blank(), legend.position = "top")
# 
# ## AVGDist ACO
# ggplot(data_bar, aes(fill = variable, x = Dataset, y = value)) +
#   geom_bar(position = "dodge", stat = "identity", alpha = .8, width = .5) + theme_classic() +
#   scale_x_discrete(limits = c("Dj38", "Berlin52", "Ch130", "D198", "Pr1002")) +
#   scale_fill_manual(values = c("#333333","#b3b3b3", "darkred", "red"), labels = c("  ACO_avg  ", "  Ant-Q_avg ", "  ACO_best ", " Ant-Q_best"),
#                     guide = guide_legend(override.aes = list(size = 10))) +
#   labs(x = "Dataset", y = "Displacement%") +
#   theme(legend.title = element_blank(), legend.position = "top")
# 
# # error bar chart ---------------------------------------------------------
# 
# data_err_GA <- data[,c("dataset", "mean_GA", "sd_GA")]
# data_err_GA$upper <- data_err_GA$mean_GA + 1.96*(data_err_GA$sd_GA/sqrt(5))
# data_err_GA$lower <- data_err_GA$mean_GA - 1.96*(data_err_GA$sd_GA/sqrt(5))
# data_err_GA$error <- data_err_GA$upper - data_err_GA$lower
# 
# data_err_KGA <- data[,c("dataset", "mean_KGA", "sd_KGA")]
# data_err_KGA$upper <- data_err_KGA$mean_KGA + 1.96*(data_err_KGA$sd_KGA/sqrt(5))
# data_err_KGA$lower <- data_err_KGA$mean_KGA - 1.96*(data_err_KGA$sd_KGA/sqrt(5))
# data_err_KGA$error <- data_err_KGA$upper - data_err_KGA$lower
# 
# data_err_ACO <- data1[,c("Dataset", "Mean_ACO", "SD_ACO")]
# data_err_ACO$upper <- data_err_ACO$Mean_ACO + 1.96*(data_err_ACO$SD_ACO/sqrt(5))
# data_err_ACO$lower <- data_err_ACO$Mean_ACO - 1.96*(data_err_ACO$SD_ACO/sqrt(5))
# data_err_ACO$error <- data_err_ACO$upper - data_err_ACO$lower
# 
# data_err_Ant.Q <- data1[,c("Dataset", "Mean_Ant.Q", "SD_Ant.Q")]
# data_err_Ant.Q$upper <- data_err_Ant.Q$Mean_Ant.Q + 1.96*(data_err_Ant.Q$SD_Ant.Q/sqrt(5))
# data_err_Ant.Q$lower <- data_err_Ant.Q$Mean_Ant.Q - 1.96*(data_err_Ant.Q$SD_Ant.Q/sqrt(5))
# data_err_Ant.Q$error <- data_err_Ant.Q$upper - data_err_Ant.Q$lower
# 
# ggplot(data_err_GA, aes(x = dataset, y = mean_GA)) +
#   geom_errorbar(data = data_err_GA, aes(ymin = lower, ymax = upper),
#                 width = .10) + theme_bw() +
#   labs(x = "Dataset", y = "meanDistance")
# 
# ggplot(data_err_KGA, aes(x = dataset, y = mean_KGA)) +
#   geom_errorbar(data = data_err_KGA, aes(ymin = lower, ymax = upper),
#                 width = .10) + theme_bw() +
#   labs(x = "Dataset", y = "meanDistance")
# 
# ggplot(data_err_ACO, aes(x = Dataset, y = Mean_ACO)) +
#   geom_errorbar(data = data_err_ACO, aes(ymin = lower, ymax = upper),
#                 width = .10) + theme_bw() +
#   labs(x = "Dataset", y = "meanDistance")
# 
# ggplot(data_err_Ant.Q, aes(x = Dataset, y = Mean_Ant.Q)) +
#   geom_errorbar(data = data_err_Ant.Q, aes(ymin = lower, ymax = upper),
#                 width = .10) + theme_bw() +
#   labs(x = "Dataset", y = "meanDistance")
