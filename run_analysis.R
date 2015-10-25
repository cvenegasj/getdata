library(reshape2)
library(dplyr)

dataTest <- read.table("X_test.txt", stringsAsFactors = FALSE)
dataTrain <- read.table("X_train.txt", stringsAsFactors = FALSE)

total <- rbind(dataTest, dataTrain)

headers <- read.table("features.txt")
headers <- headers$V2

# column names for dataset
colnames(total) <- headers

# adding column for activities
testLabels <- read.table("y_test.txt")
trainLabels <- read.table("y_train.txt")
totalLabels <- rbind(testLabels, trainLabels)
colnames(totalLabels) <- c("activity")

# adding column for subjects
testSubjects <- read.table("subject_test.txt")
trainSubjects <- read.table("subject_train.txt")
totalSubjects <- rbind(testSubjects, trainSubjects)
colnames(totalSubjects) <- c("subject")

# deleting problematic columns
subtotal <- total[c(-303:-344, -382:-423, -461:-502)]

s1 <- select(subtotal, contains("mean()"))
s2 <- select(subtotal, contains("std()"))
subtotal <- cbind(s1, s2)

# add the activity and subject columns to data frame
subtotal$activity <- totalLabels$activity
subtotal$subject <- totalSubjects$subject

# naming activities
subtotal$activity[subtotal$activity == "1"] <- "WALKING"
subtotal$activity[subtotal$activity == "2"] <- "WALKING_UPSTAIRS"
subtotal$activity[subtotal$activity == "3"] <- "WALKING_DOWNSTAIRS"
subtotal$activity[subtotal$activity == "4"] <- "SITTING"
subtotal$activity[subtotal$activity == "5"] <- "STANDING"
subtotal$activity[subtotal$activity == "6"] <- "LAYING"

# Second tidy dataset
# Melting dataset with dplyr
writable <- subtotal %>%
  group_by(subject, activity)%>%
  summarise_each(funs(mean))

write.table(writable, "writable.txt", row.name=FALSE)
