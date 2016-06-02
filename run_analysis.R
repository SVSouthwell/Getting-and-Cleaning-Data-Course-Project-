setwd('/Users/Shay/Documents/R/UCI HAR dataset')

#Read in labels
feat = read.table("./features.txt")
act = read.table("./activity_labels.txt", header = FALSE)

#Read in training data
trainSub = read.table("./train/subject_train.txt", header = FALSE)
trainAct = read.table("./train/y_train.txt", header = FALSE)
trainFeat = read.table("./train/X_train.txt", header = FALSE)

#Read test data
testSub = read.table("./test/subject_test.txt", header = FALSE)
testAct = read.table("./test/y_test.txt", header = FALSE)
testFeat = read.table("./test/X_test.txt", header = FALSE)

#Merge train and test datasets
subject = rbind(trainSub, testSub)
activity = rbind(trainAct, testAct)
features = rbind(trainFeat, testFeat)

#Give colnames
colnames(subject) = "Subject"
colnames(activity) = "Activity"
colnames(features) = feat[,2]


data = cbind(features,activity,subject)
names(data)

#Extract mean and std
extractColumns1 = grep(".*Mean.*|.*Std.*", names(data), ignore.case=TRUE)
which(colnames(data) == "Activity")
extractColumns2 = c(extractColumns1, 562, 563)
dataExtract = data[,extractColumns2]
dim(dataExtract)


#clean up the colnames
names(dataExtract) = gsub("^t", "Time", names(dataExtract))
names(dataExtract) = gsub("^f", "Frequency", names(dataExtract))
names(dataExtract) = gsub("Freq", "Frequency", names(dataExtract), ignore.case = TRUE)
names(dataExtract) = gsub("Acc", "Accelerometer", names(dataExtract))
names(dataExtract) = gsub("tBody", "TimeBody", names(dataExtract))
names(dataExtract) = gsub("BodyBody", "Body", names(dataExtract))
names(dataExtract) = gsub("mean", "Mean", names(dataExtract), ignore.case = TRUE)
names(dataExtract) = gsub("std", "STD", names(dataExtract), ignore.case = TRUE)
names(dataExtract) = gsub("()", "", names(dataExtract))
names(dataExtract) = gsub("mag", "Magnitude", names(dataExtract), ignore.case = TRUE)
names(dataExtract) = gsub("gravity", "Gravity", names(dataExtract))
names(dataExtract) = gsub("\\()","", names(dataExtract))
names(dataExtract) = gsub("angle", "Angle", names(dataExtract))
names(dataExtract)

#Create Tidy Data Set
dataExtract$Subject = as.factor(dataExtract$Subject)
dataExtract = data.table(dataExtract)
dataTidy = aggregate(. ~Subject + Activity, dataExtract, mean)
dataTidy = dataTidy[order(dataTidy$Subject, dataTidy$Activity),]
write.table(dataTidy, file = "TidyData.txt", row.names = FALSE)
