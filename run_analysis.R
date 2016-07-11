## run_analysis.R
# this script assumes that the zip file of the data was downloaded and saved in the working directory

## library stuff you need
library(tidyr)
library(dplyr)

## 1. Merges the training and the test sets to create one data set.
# get some of the common labels into memory
features <- read.table("./UCI_HAR_Dataset/features.txt")
activity_labels <- read.table("./UCI_HAR_Dataset/activity_labels.txt")

# get the test data into memory
X_test <- read.table("./UCI_HAR_Dataset/test/X_test.txt")
y_test <- read.table("./UCI_HAR_Dataset/test/y_test.txt")
subject_test <- read.table("./UCI_HAR_Dataset/test/subject_test.txt")

# put variable header labels on columns in table
names(X_test) <- features$V2
names(y_test) <- c("activity")
names(subject_test) <- c("subject")

# combine test data X, y, and subject into one data frame
test_all <- bind_cols(subject_test, y_test, X_test)


# get the train data into memory
X_train <- read.table("./UCI_HAR_Dataset/train/X_train.txt")
y_train <- read.table("./UCI_HAR_Dataset/train/y_train.txt")
subject_train <- read.table("./UCI_HAR_Dataset/train/subject_train.txt")

# put variable header labels on columns in table
names(X_train) <- features$V2
names(y_train) <- c("activity")
names(subject_train) <- c("subject")

# combine test data X, y, and subject into one data frame
train_all <- bind_cols(subject_train, y_train, X_train)

# append train data to test data set
complete_data <- rbind(test_all, train_all)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
mean_cols <- grep("mean", features$V2, value = TRUE)
std_cols <- grep("std", features$V2, value = TRUE)
colstoget <- c("subject", "activity", mean_cols, std_cols)

mnsd_data <- complete_data[,colstoget]

## 3. Uses descriptive activity names to name the activities in the data set
mnsd_data$activity <- factor(mnsd_data$activity)
levels(mnsd_data$activity) <- activity_labels$V2

## 4. Appropriately labels the data set with descriptive variable names.
# done above under:
# put variable header labels on columns in table


## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable 
## for each activity and each subject.

summary_data <- mnsd_data %>% group_by(subject, activity) %>% summarise_each(funs(mean))
write.csv(summary_data, file = "summary_data.csv")
