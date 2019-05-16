##Download Data

fileurl = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
if (!file.exists('./UCI HAR Dataset.zip')){
  download.file(fileurl,'./UCI HAR Dataset.zip', mode = 'wb')
  unzip("UCI HAR Dataset.zip", exdir = getwd())
}

##Reading the features and labels
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels2[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

##Extracting the mean and standarad deviation data

featurewanted<-grep(".*mean.*|.*std.*",feature2)
featurewanted_names<-feature[featurewanted,2]
fetaurewanted_names=gsub('-mean','Mean',featurewanted_names)
fetaurewanted_names=gsub('-std','Std',featurewanted_names)
featurewanted_names<-gsub('[-()]','',featurewanted_names)

##load datasets

train<-read.table("UCI HAR Dataset/train/X_train.txt")[featurewanted]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

test<-read.table("UCI HAR Dataset/test/X_test.txt")[featurewanted]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

##merging the train and test dataset

allData<-rbind(train,test)
colnames(allData)<-c("subject","activity",featurewanted_names)

##turn activity and subjects
library(reshape2)
allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

##write the tidied data into tidy.txt
write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)