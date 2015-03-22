#run_analysis.R

#Setup
library(dplyr)
library(tidyr)

if (!file.exists('ucihar.zip')) {
  download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip','ucihar.zip',method='curl')
  downloadDate <- date()  
}

if (!dir.exists('UCI HAR Dataset') {
  unzip(ucihar.zip)
}

# Merges the training and the test sets to create one data set.
if (!exists('merged')) {
  trainFiles <- list.files(path="./UCI HAR Dataset/train", pattern="*.txt", full.names=TRUE, recursive=TRUE)
  testFiles <- list.files(path="./UCI HAR Dataset/test", pattern="*.txt", full.names=TRUE, recursive=TRUE)
  headerFiles <- list.files(path="./UCI HAR Dataset", pattern="*.txt", full.names=TRUE, recursive=FALSE)

  train <- lapply(trainFiles, function(filename) tbl_df(read.delim(filename, header=FALSE, sep="", as.is=TRUE)))
  test <- lapply(testFiles, function(filename) tbl_df(read.delim(filename, header=FALSE, sep="", as.is=TRUE)))
  headers <- lapply(headerFiles, function(filename) tbl_df(read.delim(filename, header=FALSE, sep="", as.is=TRUE)))
  trainNames <- gsub('.+[/](\\w+?)(_train)?(_test)?.txt','\\1',trainFiles,perl=TRUE)
  testNames <- gsub('.+[/](\\w+?)(_train)?(_test)?.txt','\\1',testFiles,perl=TRUE)
  headerNames <- gsub('.+[/](\\w+?)(_train)?(_test)?.txt','\\1',headerFiles,perl=TRUE)
  names(train) <- trainNames
  names(test) <- testNames
  names(headers) <- headerNames
  
  merged <- lapply(trainNames, function(key) bind_rows(train[[key]],test[[key]]))
  names(merged) <- trainNames
}

# Extracts only the measurements on the mean and standard deviation for each measurement. 
names(merged[['X']]) <- headers$features$V2
meanSd <- merged[['X']][grep('mean|std',headers$features$V2, perl=TRUE)]

# Uses descriptive activity names to name the activities in the data set
for (x in 1:6) {
  merged[['y']]$V1[merged[['y']]$V1==x] <- headers$activity_labels$V2[x]
}

# Appropriately labels the data set with descriptive variable names.
names(merged[['y']]) <- 'activity'
names(merged[['subject']]) <- 'subject'

# Full data set
tidy1 <- tbl_df(bind_cols(merged[['subject']],merged[['y']],meanSd))

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy2 <- tidy1 %>% 
  group_by(activity,subject) %>% 
  summarise_each(funs(mean),3:81)
