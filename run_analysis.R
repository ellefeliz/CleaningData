library(dplyr)

features <- read.table("features.txt", col.names = c("n","functions"))
activities <- read.table("activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("test/subject_test.txt", col.names = "subject")
x_test <- read.table("test/X_test.txt", col.names = features$functions)
y_test <- read.table("test/y_test.txt", col.names = "code")
subject_train <- read.table("train/subject_train.txt", col.names = "subject")
x_train <- read.table("train/X_train.txt", col.names = features$functions)
y_train <- read.table("train/y_train.txt", col.names = "code")

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)

subject <- rbind(subject_train, subject_test)

merged <- cbind(subject, Y, X)

tidyData <- merged %>% select(subject, code, contains("mean"), contains("std"))

tidyData$code <- activities[tidyData$code,2]

names(tidyData)[2] = "activity"
names(tidyData) <- gsub("Acc", "Accelerometer", names(tidyData))
names(tidyData) <- gsub("Gyro","Gyroscope", names(tidyData))
names(tidyData) <- gsub("BodyBody", "Body", names(tidyData))
names(tidyData) <- gsub("Mag", "Magnitude", names(tidyData))
names(tidyData) <- gsub("^t", "Time", names(tidyData))
names(tidyData) <- gsub("^f", "Frequency", names(tidyData))
names(tidyData) <- gsub("tBody", "TimeBody", names(tidyData))
names(tidyData) <- gsub("-mean()", "Mean", names(tidyData))
names(tidyData) <- gsub("-std()", "STD", names(tidyData), ignore.case =  TRUE)
names(tidyData) <- gsub("-freq()", "Frequency", names(tidyData), ignore.case = TRUE)
names(tidyData) <- gsub("angle", "Angle", names(tidyData))
names(tidyData) <- gsub("gravity","Gravity", names(tidyData))

finalData <- tidyData %>%
        group_by(subject, activity) %>%
        summarise_all(funs(mean))
write.table(finalData, "finalDataset.txt", row.name = FALSE)