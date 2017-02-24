# Tuukka Lehtiniemi
# 24.2.2017
# IODS course, Ch. 5 data wrangling script
# Data source: http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt

#access necessary libraries
library(dplyr)
#library(ggplot2)
library(tidyr)
library(stringr)

#read data into a table
human = read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt",sep=",",header=TRUE)

#transform the Gross National Income (GNI) variable to numeric 
new_GNI <- str_replace(human$GNI, pattern=",", replace ="") 
new_GNI <- as.numeric(new_GNI)
human$GNI <- new_GNI

#keep only the columns matching the provided variable names 
keep_columns <- c("Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")
human <- select(human, one_of(keep_columns))

#Remove all rows with missing values
complete <- complete.cases(human)
human <- filter(human, complete)

#Remove the observations which relate to regions instead of countries.
last = nrow(human)-7
human <- human[1:last, ]

#Define the row names of the data by the country names and remove the country name column 
#from the data.

rownames(human) <- human$Country
human <- subset(human, select = -c(Country))

#The data now ahs 155 observations and 8 variables. 

#store data locally
write.table(human, "/Users/lehtint9/IODS-project/data/human.csv", sep = ",")
