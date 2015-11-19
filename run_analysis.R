############
# Step 1
# Merges the training and the test sets to create one data set.
############

# read subject training data  and Add ID Col by row number
    subject_train = read.table("UCI HAR Dataset/train/subject_train.txt", col.names=c("subject_id"))
    subject_train$ID <- as.numeric(rownames(subject_train))
# read training data and add ID Col by row number
    X_train = read.table("UCI HAR Dataset/train/X_train.txt")
    X_train$ID <- as.numeric(rownames(X_train))
# read activity training data and add ID Col by row number
    y_train = read.table("UCI HAR Dataset/train/y_train.txt", col.names=c("activity_id")) 
    y_train$ID <- as.numeric(rownames(y_train))
# merge subject_train and y_train to train
    train <- merge(subject_train, y_train, all=TRUE)
# merge train and X_train
    train <- merge(train, X_train, all=TRUE)

# read subject test data  and Add ID Col by row number
    subject_test = read.table("UCI HAR Dataset/test/subject_test.txt", col.names=c("subject_id"))
    subject_test$ID <- as.numeric(rownames(subject_test))
# read test data and add ID Col by row number
    X_test = read.table("UCI HAR Dataset/test/X_test.txt")
    X_test$ID <- as.numeric(rownames(X_test))
# read activity test data and add ID Col by row number
    y_test = read.table("UCI HAR Dataset/test/y_test.txt", col.names=c("activity_id")) 
    y_test$ID <- as.numeric(rownames(y_test))
# merge subject_test and y_test to test
    test <- merge(subject_test, y_test, all=TRUE)
# merge test and X_test
    test <- merge(test, X_test, all=TRUE)

#combine train and test
    data1 <- rbind(train, test)


############
# Step 2
# Extracts only the measurements on the mean and standard deviation for each measurement. 
############
# read features from featrues.txt
    features = read.table("UCI HAR Dataset/features.txt", col.names=c("feature_id", "feature_label"),) 
# chose mean() and std() measurements by grepl()
    s_features <- features[grepl("mean\\(|std\\(", features$feature_label), ]
    data2 <- data1[, c(c(1:3),s_features$feature_id + 3)]

############
# Step 3
# Uses descriptive activity names to name the activities in the data set
############
# read from activity_labels.txt
    activity_labels = read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("activity_id", "activity_label"),)
# merge
    data3 <- merge(data2,activity_labels)


############
# Step 4
# Appropriately labels the data set with descriptive variable names. 
############
tdata <- data3
coln <- colnames(tdata)
for (i in 1:length(coln)) {
    if  (grepl("V\\d",coln[i])) {
        num <- as.integer(substring(coln[i],2))
        colnames(tdata)[i] <- as.character(features$feature_label[num])
    }
}
data4 <- tdata

############
# Step 5
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
############
# remove the ID, activity_label Col
    data5 <- data4[,!(names(data4) %in% c("ID","activity_label"))]
    aggdata <-aggregate(data5, by=list(subject = data5$subject_id, activity = data5$activity_id), FUN=mean, na.rm=TRUE)
# remove the "subject","activity" Col
    aggdata <- aggdata[,!(names(aggdata) %in% c("subject","activity"))]

    aggdata = merge(aggdata, activity_labels)
    write.table(file="submit.txt", x=aggdata, row.name=FALSE)
