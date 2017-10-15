#--------------------Start creating tidy test data

# load activities related data from test directory
y_test <- read.table("~/UCI HAR Dataset/test/y_test.txt", header = FALSE)

# since the data frame has no label / column names, add appropriate column names
# here since its activity id adding it as a column name
colnames(y_test) <- c("activity_id")

# load volunteers / subject id
subject_text <- read.table("~/UCI HAR Dataset/test/subject_test.txt", header = FALSE)

# since the data frame has no label / column names, add appropriate column names
# here since its volunteer id adding it as a column name
colnames(subject_text) <- c("volunteer_id")

# load all features related data
features <- read.table("~/UCI HAR Dataset/features.txt", header = FALSE)
# since the data frame has no label / column names, add appropriate column names
colnames(features) <- c("id","colname")

# load subject's different measurements data
X_test <- read.table("~/UCI HAR Dataset/test/X_test.txt", header = FALSE)

# add label / column names from features data frame 
colnames(X_test) <- features$colname
# add an additional column just for our reference to know the source whether it is training or test data when we merge into single data frame
test_data["source"]<- "test"

# now merge all these columns into a data frame to get final test data frame
test_data <- cbind(subject_text,y_test,X_test)

#-------------------- creating tidy test data ends here 

#-------------------- Start creating tidy training data

# load activities related data from train directory
y_train <- read.table("~/UCI HAR Dataset/train/y_train.txt", header = FALSE)

# since the data frame has no label / column names, add appropriate column names
# here since its activity id adding it as a column name
colnames(y_train) <- c("activity_id")

# load volunteers / subject id
subject_train <- read.table("~/UCI HAR Dataset/train/subject_train.txt", header = FALSE)

# since the data frame has no label / column names, add appropriate column names
# here since its volunteer id adding it as a column name
colnames(subject_train) <- c("volunteer_id")

# load subject's different measurements data
X_train <- read.table("~/UCI HAR Dataset/train/X_train.txt", header = FALSE)

# add label / column names from features data frame 
colnames(X_train) <- features$colname

# now merge all these columns into a data frame to get final train data frame
train_data <- cbind(subject_train,y_train,X_train)

# add an additional column just for our reference to know the source whether it is training or test data when we merge into single data frame
train_data["source"]<- "train"

#-------------------- tidy train data ends here

# 1. Merges the training and the test sets to create one data set.
train_test_data <- rbind(train_data,test_data)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
train_test_data_subset <- train_test_data[, grepl(paste(c("mean","std","volunteer_id","activity_id","source"), collapse = "|"),names(train_test_data))]

# 3. Uses descriptive activity names to name the activities in the data set
activity_labels <- read.table("~/UCI HAR Dataset/activity_labels.txt", header = FALSE)
colnames(activity_labels) <- c("activity_id","activity")

# 4.Appropriately labels the data set with descriptive variable names.
final_data <- merge.data.frame(activity_labels,train_test_data_subset,by.x = "activity_id",by.y = "activity_id")

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity 
#     and each subject.
agg_data <- aggregate(final_data[, 4:82], list(final_data$activity,final_data$volunteer_id), mean)

# finally name the column / labels back 
names(agg_data)[names(agg_data) == 'Group.2'] <- 'Subject'
names(agg_data)[names(agg_data) == 'Group.1'] <- 'Activity'