## Douglas R Briggs
## Getting & Cleaning Data (Getdata-006)
## Course Project

## load libraries needed
library(plyr) ## for joins
library(stringr) ## for string manipulation

## Step 1:  Merge the training and the test sets to create one data set
## read the data sets into data frames
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

## merge the various data frames
merged_x <- rbind(x_train, x_test)
rm(x_train, x_test)
merged_activity <- rbind(y_train, y_test)
rm(y_train, y_test)
merged_subject <- rbind(subject_train, subject_test)
rm(subject_test, subject_train)

## now apply the labels
## first need to swap rows/columns of features to merge it more easily
features_t <- t(features)
## remove index row
features_t <- features_t[2,]
## recast as a dataframe
## features_f <- as.data.frame(features_t)  NOT NEEDED
## Now apply the labels to the columns of the merged DF
colnames(merged_x) <- features_t
## Do the same for the other DF's
colnames(merged_subject) <- "Subject"
colnames(merged_activity) <- "Activity"

## while we could easily combine the three datasets now with this command:
## merged_all <- data.frame(merged_x, merged_subject, merged_activity)
## instead, we will subset the desired columns in merged_x first,
## then append the other two DF's

## Step 2:  Extract only the measurements on the mean and 
##  standard deviation for each measurement
## This means eliminate all columns that are not mean() or std() calculations

## first get list of desired columns
colswant_1 <- grep("std()", names(merged_x))
colswant_2 <- grep("mean()", names(merged_x))
colswant <- sort(c(colswant_1, colswant_2))
wanted_x <- merged_x[,colswant]

## now we append the other two columns
merged_all <- data.frame(wanted_x, merged_subject, merged_activity)

## clean up unneeded DF's
rm(wanted_x, merged_x, features, features_t)

## Step 3: Uses descriptive activity names to name the activities
##  in the data set

## rename columns in activity_labels so we can join on "Activity"
colnames(activity_labels) <- c("Activity", "ActivityName")
## now join with the larger merged DF
activity_matched <- join(merged_all,
                         activity_labels,
                         by=c("Activity"))
## cleanup unneeded DF's to save memory
rm(merged_all,merged_activity, merged_subject)


## Step 4:  Appropriately labels the data set with descriptive
##  variable names.
## I've decided to use UpperCamelCase (individual words capitalized)

## If column name starts with "tBody", change to "TimeBody",
colnames(activity_matched) <- gsub("tBody", "TimeBody",colnames(activity_matched))
## if "tGravity" change to "TimeGravity"
colnames(activity_matched) <- gsub("tGravity", "TimeGravity",colnames(activity_matched))
## if "fBody", change to "FrequencyBody"
colnames(activity_matched) <- gsub("fBody", "FrequencyBody",colnames(activity_matched))
## if "fGravity" change to "FrequencyGravity"
colnames(activity_matched) <- gsub("fGravity", "FrequencyGravity",colnames(activity_matched))
## Next, change "Acc" to "Acceleration" and "Gyro" to "Gyroscope"
colnames(activity_matched) <- gsub("Acc", "Acceleration",colnames(activity_matched))
colnames(activity_matched) <- gsub("Gyro", "Gryoscope",colnames(activity_matched))
## Change "Mag" to "Magnitude"
colnames(activity_matched) <- gsub("Mag", "Magnitude",colnames(activity_matched))
## Change ".std." to "StandardDeviation" and ".mean." to "Mean"
colnames(activity_matched) <- gsub(".std..", "StandardDeviation",colnames(activity_matched))
## Change ".mean." to "Mean"
colnames(activity_matched) <- gsub(".mean..", "Mean",colnames(activity_matched))
## change ".meanFreq." and other mis-matches to "MeanFrequency"
colnames(activity_matched) <- gsub(".meanFreq.", "MeanFrequency",colnames(activity_matched))
colnames(activity_matched) <- gsub("Meanreq.", "MeanFrequency",colnames(activity_matched))
colnames(activity_matched) <- gsub("Meaneq..", "MeanFrequency",colnames(activity_matched))
## change .X, .Y, and .Z to just X, Y, Z
colnames(activity_matched) <- gsub(".X", "X",colnames(activity_matched))
colnames(activity_matched) <- gsub(".Y", "Y",colnames(activity_matched))
colnames(activity_matched) <- gsub(".Z", "Z",colnames(activity_matched))
## fix doubles
colnames(activity_matched) <- gsub("BodyBody", "Body",colnames(activity_matched))


## Part 5:  Create a second, independent tidy data set with the
##  average of each variable for each activity and each subject. 

## reorder dataframe columns
penultimate <- activity_matched[,c(80,82,1:79)]
final_df <- aggregate(penultimate[,3:81],
                   by=list(penultimate$Subject,
                           penultimate$ActivityName),
                   FUN=mean)
## fix column names
colnames(final_df)[1] <- "Subject"
colnames(final_df)[2] <- "Activity"

## remove unneeded DF's
rm(activity_matched, penultimate)

## now ready to write out the DF to a file
write.table(final_df, file = "samsung_tidy.txt", row.name=FALSE)
write.table(colnames(final_df), file = "samsung_tidy_columns.txt")






