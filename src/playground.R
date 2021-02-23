####################
#                  #
#   Playground     #
#                  #
####################

## 00. Load libraries ----
library(tidyverse)
library(formattable)



## 01. Import datasets
df <- readxl::read_xlsx("Ερωτηματολόγιο Διπλωματικής Εργασίας (Απαντήσεις) (1).xlsx")

View(df)
dim(df)


## 02. Questions encoding ---

raw_questions = colnames(df)

questions_map = c("time", "terms",                                 # 2
                  "O1", "O2.1", "O2.2.1", "O2.2.2", "O2.2.3",      # 5
                  "N1", "N1.2", "N1.3", "N1.4", "N1.5", "N1.6", "N1.7.1", "N1.7.2", "N1.7.3", "N1.7.4", # 10
                  "N1.8", "N1.9.1", "N1.9.2", "N1.9.3", "N2.1", "N2.2", "N2.2.1", "N2.3", "N2.3.1", # 9
                  "N2.4", "N2.4.1", "N2.5.1", "N2.5.2", "N2.5.3", "N2.5.4", "N2.6", "N2.7", # 8
                  "N3.1", "N3.2", "N3.3", "N3.4", "N3.5", "N3.6", "N3.7", "N3.8.1", "N3.8.2", "N3.8.3", # 10
                  "D1", "D2", "D3", "D4", "D4.1", "D5", "D6", "D7.1", "D7.2", "D7.3", "D7.4", # 11
                  "D8","D9") # 2


questions_map_df = data.frame("question" = raw_questions,
                              "question_code" = questions_map,
                              "type" = c("POSIXct", sapply(df[,setdiff(colnames(df), c("time"))], class)))
View(questions_map_df)

# Rename columns
colnames(df) = questions_map


## // EDA (Visualizations, Tables and Statistics) // ----

str(df)
head(df)



# O1
temp_df = table(df$O1)

temp_df = data.frame(q = names(temp_df), temp_df)
temp_df

ggplot(temp_df) +
  geom_bar(aes(y=Freq))+
  ggtitle("O1")


# D2
table(df$D2)


# - f : frequency - frequency count
# - r : row.pct - proprotion within row
# - c : col.pct - proportion within column
# - j : joint.pct - proportion within final 2 dimensions of table
# - t : total.pct - proportion of entire table


# http://rstudio-pubs-static.s3.amazonaws.com/6975_c4943349b6174f448104a5513fed59a9.html
# Load function
source("http://pcwww.liv.ac.uk/~william/R/crosstab.r")
crosstab(df, row.vars = "D2", col.vars = "D1", type = "f")



?formattable

formattable(df["D2"], 
            align =c("l","c","c","c","c", "c", "c", "c", "r"), 
            list(`D2` = formatter(
              "span", style = ~ style(color = "grey",font.weight = "bold")) 
            ))


formattable(i1, 
            align =c("l","c","c","c","c", "c", "c", "c", "r"), 
            list(`Indicator Name` = formatter(
              "span", style = ~ style(color = "grey",font.weight = "bold")) 
            ))


