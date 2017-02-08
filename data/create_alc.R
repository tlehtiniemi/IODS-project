# Tuukka Lehtiniemi
# 8.2.2017
# IODS course Ch 3 data wrangling script

#access necessary libraries
library(dplyr)
library(ggplot2)

# read both csv data files into R
d_mat = read.table("/Users/lehtint9/IODS-project/data/student-mat.csv",sep=";",header=TRUE)
d_por = read.table("/Users/lehtint9/IODS-project/data/student-por.csv",sep=";",header=TRUE)

dim(d_mat) #[1] 395  33
dim(d_por) #[1] 649  33
# d_mat has 395 students, d_por has 649 students
# both have 33 columns

colnames(d_mat) == colnames (d_por)
# column names are identical

#join by the specifiec columns. inner join --> only students present in both datasets are kept
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")
d_mat_por <- inner_join(d_mat, d_por, by = join_by, suffix = c(".math", ".por"))

dim(d_mat_por) #[1] 382  53
colnames(d_mat_por) # columns from d_mat and d_por not used for joining are kept with .mat and .por suffixes 

# create a new data frame with only the columns used for joining
alc <- select(d_mat_por, one_of(join_by))

# the columns in the datasets which were not used for joining the data
# these columns are in d_mat_por with .mat and .por suffixes 
notjoined_columns <- colnames(d_mat)[!colnames(d_mat) %in% join_by]

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select the (two) columns from 'd_mat_por' with the same original name
  two_columns <- select(d_mat_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- two_columns[[1]] #select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

# the ugly way to add a new column
# not sure if alc_use should be rounded or not
# decided not to round
alc["alc_use"] <- rowMeans(select(alc, contains("alc")))

# the nicer way this time
alc <- mutate(alc, high_use = alc_use > 2)


# glimpse at the new data frame
glimpse(alc)
#The joined data now has 382 observations of 35 variables as expected

# write data to file
write.table(alc, "/Users/lehtint9/IODS-project/data/Ch3_alc.csv", sep = ";")
