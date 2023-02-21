library(dplyr)

features <- read.table("features.txt", col.names = c("n","Functions"))
activities <- read.table("activity_labels.txt", col.names = c("code", "Activity"))
subject_test <- read.table("test/subject_test.txt", col.names = "Subject")
x_test <- read.table("test/X_test.txt", col.names = features$Functions)
y_test <- read.table("test/y_test.txt", col.names = "code")
subject_train <- read.table("train/subject_train.txt", col.names = "Subject")
x_train <- read.table("train/X_train.txt", col.names = features$Functions)
y_train <- read.table("train/y_train.txt", col.names = "code")

X <- rbind(x_train,x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)

colnames(Merged_Data)
TidyData <- Merged_Data %>% select(Subject, code, contains("mean"), contains("std"))
TidyData$code <- activities[TidyData$code,2]

names(TidyData)[2]="activity"
names(TidyData)<-gsub("Acc","Accelerometer",names(TidyData))
names(TidyData)<-gsub("Gyro","Gyroscope",names(TidyData))
names(TidyData)<-gsub("BodyBody","Body",names(TidyData))
names(TidyData)<-gsub("Mag","Magnitude",names(TidyData))
names(TidyData)<-gsub("^t","Time",names(TidyData))
names(TidyData)<-gsub("^f","Frequency",names(TidyData))
names(TidyData)<-gsub("tbody","TimeBody",names(TidyData))
names(TidyData)<-gsub("-mean()","Mean",names(TidyData),ignore.case = TRUE)
names(TidyData)<-gsub("-std()","STD",names(TidyData),ignore.case = TRUE)
names(TidyData)<-gsub("-freq()","Frequency",names(TidyData),ignore.case = TRUE)

Data<-TidyData %>% group_by(Subject,Activity) %>% summarise_all(list(mean=mean,median=median))
write.table(Data,"Data.txt",row.name = FALSE)
str(Data)
