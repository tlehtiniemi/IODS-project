# Tuukka Lehtiniemi
# 30.1.2014 
# Read learning data from the web, wrangle the data and store output into a file 

library(dplyr)

# read data from web
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

# look at the dimensions of the data
dim(lrn14)
# 183 observations of 60 variables

# look at the structure of the data
str(lrn14)
# most are int, only gender is a Factor (F and M)

# create analysis dataset
learning2014[c("gender","Age","Attitude","deep","stra", "surf", "Points")] <- NA

deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D07","D14","D22","D30")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)

# select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(lrn14, one_of(surface_questions))
lrn14$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(lrn14, one_of(strategic_questions))
lrn14$stra <- rowMeans(strategic_columns)

#create new variable learning2014 and store only necessary columns of lrn14
keep_columns <- c("gender","Age","Attitude", "deep", "stra", "surf", "Points")
learning2014 <- select(lrn14, one_of(keep_columns))

#filter based on points>0
learning2014 <- filter(learning2014, Points>0)

# rename columns
colnames(learning2014)[2] <- "age"
colnames(learning2014)[3] <- "attitude"
colnames(learning2014)[7] <- "points"

# write data frame learning2014 into a file
write.table(learning2014, "learning2014.txt")

# check that the output is ok
test_output <- read.table("learning2014.txt")
str(test_output)
head(test_output)