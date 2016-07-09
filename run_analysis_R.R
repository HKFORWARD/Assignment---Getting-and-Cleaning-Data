

setwd("C:/Users/HK/Dropbox/Study/Coursera - Data Science/03 - Getting and Cleaning Data/Week4")

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, file.path(getwd(), "Dataset.zip"))

unzip(zipfile="./Dataset.zip",exdir="./data")

path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
files

#Read the Activity files

dataActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)

#Read the Subject files

dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)

#Read Fearures files

dataFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)


str(dataActivityTest)
table(dataActivityTest)

str(dataActivityTrain)
table(dataActivityTrain)

str(dataSubjectTrain)
table(dataSubjectTrain)

str(dataSubjectTest)
table(dataSubjectTest)

str(dataFeaturesTest)
dim(dataFeaturesTest)

str(dataFeaturesTrain)
dim(dataFeaturesTrain)

dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)


names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

dataFeaturesNames

table(dataSubject)

table(dataActivity)

str(dataFeatures)
names(dataFeatures)

dim(dataFeatures)
dim(dataFeaturesTest)
dim(dataFeaturesTrain)


dim(dataSubject)
dim(dataActivity)

dataCombine <- cbind(dataSubject, dataActivity)
dim(dataCombine)

Data <- cbind(dataFeatures, dataSubject, dataActivity)

dim(Data)

subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
subdataFeaturesNames

as.character(subdataFeaturesNames)
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
selectedNames

as.character(subdataFeaturesNames)
Data<-subset(Data,select=selectedNames)
str(Data)

activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)
activityLabels
head(Data$activity,30)


names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

names(Data)

library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata - Getting and Cleaning Data Assignment.txt",row.name=FALSE)




