
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
data <- read.csv2("../finalResults_dario.txt", sep = ",")
data

colnames(data) <- c("Dataset", "MeanDist_ACO", "MeanDist_Ant-Q", "BestDist_ACO", "BestDist_Ant-Q")
data_bar_ACO_Ant.Q <- melt(data, id.vars = "Dataset")
data_bar_ACO_Ant.Q$value <- as.numeric(data_bar_ACO_Ant.Q$value)


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

png("ACO_Ant-Q_avg_best.png", width = 12, height = 6, units = 'in', res = 300)
ggplot(data_bar_ACO_Ant.Q,
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
                    labels = c("  ACO_Avg  ",
                               "  Ant-Q_Avg ",
                               "  ACO_Best ",
                               " Ant-Q_Best"),
                    guide = guide_legend(override.aes = list(size = 15))) +
  labs(x = "Dataset",
       y = "Displacement%") +
  theme(legend.title = element_blank(),
        legend.position = "top")
dev.off()
