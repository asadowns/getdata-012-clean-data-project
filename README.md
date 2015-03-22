#README

###The code in run_analysis.R does the following:

* Downloads and unzip Human Activity Recognition Using Smartphones Dataset. More information on raw data found here: [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](Human Activity Recognition Using Smartphones)
* Read in data from test and train folder and get labels for activities and variables.
* Merges the test and training dataset to create a single dataset
* Extracts only the measurements on the mean and standard deviation for each measurement.
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive variable names.
* From this data set, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
* Write this data set into tidy\_data\_set.txt
