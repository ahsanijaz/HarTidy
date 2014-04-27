trainingFeature <- read.table("UCI HAR Dataset\\train\\X_train.txt")
testingFeature <- read.table("UCI HAR Dataset\\test\\x_test.txt")
featuresName <- read.table("UCI HAR Dataset\\features.txt")
trainSubject <- read.table("UCI HAR Dataset\\train\\subject_train.txt")
testSubject <- read.table("UCI HAR Dataset\\test\\subject_test.txt")
colnames(trainingFeature) <- featuresName$V2
colnames(testingFeature) <- featuresName$V2
trainingFeature<-cbind(trainSubject,trainingFeature)
testingFeature<-cbind(testSubject,testingFeature)
trainingOutput <- read.table("UCI HAR Dataset\\train\\y_train.txt")
testingOutput <- read.table("UCI HAR Dataset\\test\\y_test.txt")
activityLabels <- read.table("UCI HAR Dataset\\activity_labels.txt")
for(j in 1:length(activityLabels$V1))
{
  indextr<-which(trainingOutput$V1 %in% activityLabels$V1[j])
  trainingOutput$V1[indextr] <- as.character(activityLabels$V2[j])
  indexte<-which(testingOutput$V1 %in% activityLabels$V1[j])
  testingOutput$V1[indexte] <- as.character(activityLabels$V2[j])
}
trainingData <- cbind(trainingFeature,trainingOutput)
testingData <- cbind(testingFeature,testingOutput)
combinedData <- rbind(trainingData,testingData)  
colnames(combinedData)[563]<-"Activity_Label"
colnames(combinedData)[1]<-"Subjects"
featnames <- names(combinedData)
indexmean <- grep("mean()",featnames)
indexstd <- grep("std()",featnames)
finalData <- combinedData[,c(1,indexstd,indexmean,563)]

write.csv(finalData,file="tidy data.csv",row.names=FALSE)

subjectMeans <- data.frame(do.call("rbind",by(finalData[,c(2:(dim(finalData)[2]-1))],finalData$Subjects,colMeans
)))
ActivityMeans <- data.frame(do.call("rbind",by(finalData[,c(2:(dim(finalData)[2]-1))],finalData$Activity_Label,colMeans
)))
write.csv(cbind(Subjects=rownames(subjectMeans),subjectMeans),file="subject means.csv",row.names=FALSE)

write.csv(cbind(Activity=rownames(ActivityMeans),ActivityMeans),file="activity means.csv",row.names=FALSE)

