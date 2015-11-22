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

# read subject test data as train data
    subject_test = read.table("UCI HAR Dataset/test/subject_test.txt", col.names=c("subject_id"))
    subject_test$ID <- as.numeric(rownames(subject_test))
    X_test = read.table("UCI HAR Dataset/test/X_test.txt")
    X_test$ID <- as.numeric(rownames(X_test))
    y_test = read.table("UCI HAR Dataset/test/y_test.txt", col.names=c("activity_id")) 
    y_test$ID <- as.numeric(rownames(y_test))
    
# merge subject_test and y_test to test
    test <- merge(subject_test, y_test, all=TRUE)
# merge test and X_test
    test <- merge(test, X_test, all=TRUE)

#combine train and test
    data1 <- rbind(train, test)

#clear temp var
    rm(list=c("train","subject_train","X_train","y_train"))
    rm(list=c("test","subject_test","X_test","y_test"))

############
# Step 2
# Extracts only the measurements on the mean and standard deviation for each measurement. 
############
# read features from featrues.txt
    features = read.table("UCI HAR Dataset/features.txt", col.names=c("feature_id", "feature_label")) 
# chose mean() and std() measurements by grepl()
    s_features <- features[grepl("mean\\(|std\\(", features$feature_label), ]
# result    
    data2 <- data1[, c(c(1:3),s_features$feature_id + 3)]

#clear temp var
    rm(s_features)
    

############
# Step 3
# Uses descriptive activity names to name the activities in the data set
############
# read from activity_labels.txt
    activity_labels = read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("activity_id", "activity_label"))
# merge
    data3 <- merge(data2,activity_labels)


############
# Step 4
# Appropriately labels the data set with descriptive variable names. 
############
#copy a tmp var for operate
    tdata <- data3
#use regx pattern search the label need to be renamed
    coln <- colnames(tdata)
    for (i in 1:length(coln)) {
        if  (grepl("V\\d",coln[i])) {
            num <- as.integer(substring(coln[i],2))
            colnames(tdata)[i] <- as.character(features$feature_label[num])
        }
    }
#save the result    
    data4 <- tdata

# clear temp var
  rm(list=c("tdata","i","coln","num"))
  

############
# Step 5
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
############
#remove the ID, activity_label Col
    tdata <- data4[,!(names(data4) %in% c("ID", "activity_label"))]
    data5 <-aggregate(tdata, by=list(subject = tdata$subject_id, activity = tdata$activity_id), FUN=mean, na.rm=TRUE)

# remove the "subject","activity" Col
    data5 <- data5[,!(names(data5) %in% c("subject","activity"))]

    data5 = merge(data5, activity_labels)
    
    write.table(file="submit.txt", x=data5, row.name=FALSE)
    print("you can check the result for the step1 to step5 by")
    print("data1  --> Step 1;         data2  --> Step 2;")
    print("data3  --> Step 3          data4  --> Step 4;")
    print("data5  --> Step 5")

##clear tmp var
    rm(list=c("activity_labels","features","tdata"))
#END
