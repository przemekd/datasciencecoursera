#run_analysis.R
#labels
features <- read.table("./UCI HAR Dataset/features.txt", sep=" ", col.names=c("id","features"))
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", sep=" ", col.names=c("id","activity"))

#Train DF
subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names="subject")
observations <- read.table("./UCI HAR Dataset/train/X_train.txt")
activities <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names="id")
activities$order <- 1:nrow(activities)
activities <- merge(activities,activity_labels, sort=FALSE)
activities <- activities[order(activities$order),]
colnames(observations) <- features$features
stds_means <- grep("mean\\(|std", colnames(observations))
observations <- observations[,stds_means]

train <- cbind(subjects,activity=activities$activity,observations)

#Test DF
subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names="subject")
observations <- read.table("./UCI HAR Dataset/test/X_test.txt")
activities <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names="id")
activities$order <- 1:nrow(activities)
activities <- merge(activities,activity_labels, sort=FALSE)
activities <- activities[order(activities$order),]
colnames(observations) <- features$features
stds_means <- grep("mean\\(|std", colnames(observations))
observations <- observations[,stds_means]

test <- cbind(subjects,activity=activities$activity,observations)

#Combined DF
all <- rbind(train,test)

aggregated <- aggregate(.~subject + activity, all, mean)

#output
write.csv(aggregated, file="tidy_dataset.txt", row.names = FALSE)