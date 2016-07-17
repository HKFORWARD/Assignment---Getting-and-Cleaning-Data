
#Set work dirrectory
setwd("/home/kun/Dropbox/Study/Coursera - Data Science/03 - Getting and Cleaning Data/Week4")

#Download and unzip Data
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, file.path(getwd(), "Dataset.zip"))

unzip(zipfile="./Dataset.zip",exdir="./data")

#Check file folder
path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
files

#Read the Activity files
dataActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)
dataActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
dim(dataActivityTest)
dim(dataActivityTrain)

#Read the Subject files
dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)
dim(dataSubjectTrain)
dim(dataSubjectTest)

#Read Fearures files
dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)
dataFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dim(dataFeaturesTrain)
dim(dataFeaturesTest)

#Combine files together (vertically)
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

dim(dataSubject)
dim(dataActivity3)
dim(dataFeatures)

#Adding labels
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")

dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2
names(dataFeatures)

#Combine files together (horizontally)
Data <- cbind(dataFeatures, dataSubject, dataActivity)
dim(Data)
names(Data)

#Select only mean and std for each measurement (and subject & activity)
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
dataFeaturesNames$V2
subdataFeaturesNames[70]

as.character(subdataFeaturesNames)
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
selectedNames

Data2<-subset(Data,select=selectedNames)
dim(Data2)
names(Data2)

table(Data2$activity, Data2$subject)

#Change abbriviations of labels to full descriptions to make them more meaningful
names(Data2)<-gsub("^t", "time", names(Data2))
names(Data2)<-gsub("^f", "frequency", names(Data2))
names(Data2)<-gsub("Acc", "Accelerometer", names(Data2))
names(Data2)<-gsub("Gyro", "Gyroscope", names(Data2))
names(Data2)<-gsub("Mag", "Magnitude", names(Data2))
names(Data2)<-gsub("BodyBody", "Body", names(Data2))

names(Data2)

library(plyr);
Data3<-aggregate(. ~subject + activity, Data2, mean)
Data3<-Data3[order(Data3$subject,Data3$activity),]
names(Data3)

#Change ID of activity and subject to descriptions
activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)
names(Data3)[names(Data3)=="activity"] <- "V1"
names(activityLabels)[names(activityLabels)=="V2"] <- "activity"
activityLabels
Data4 <- merge(Data3, activityLabels,by="V1")
Data5 <- subset(Data4, select=-V1)
Data6 <-aggregate(. ~subject + activity, Data5, mean)

#table(Data6$subject, Data6$activity)

write.table(Data6, file = "tidydata - Getting and Cleaning Data Assignment.txt",row.name=FALSE)

install.packages("memisc")
library(memisc)

Data6 <- within(Data6,{
  description(subject) <- "ID of the test subject"
  description(activity) <- "The type of activity performed"
#  measurement(subject) <- "norminal"
  })

codebook(Data6)
Write(codebook(Data6),
      file="Codebook.md")

#library(knitr)
#knit2html("codebook.Rmd")

