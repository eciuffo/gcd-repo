# If necessary, install packages
#install.packages("tidyr")
#install.packages("reshape")
#install.packages("plyr")
#install.packages("dplyr")

# Install packages
library(tidyr)
library(plyr)
library(dplyr) 
library(reshape)
library(reshape2)

# Set default directory according to your local desktop, if necessary
#setwd("C:\\Users\\eciuffo\\github\\jhopkins\\gcd\\Course Project")
#getwd()

# load URL to a string    
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# Download the file
download.file(fileURL,"UCI_0HAR_Dataset.zip")

# capture download time
dateDownloaded <- date()   
dateDownloaded

# Unzip file
unzip("UCI_0HAR_Dataset.zip")

# load features
features <- read.table(".\\UCI HAR Dataset\\features.txt")

# load activitie labels
activity_labels <- read.table(".\\UCI HAR Dataset\\activity_labels.txt")
colnames(activity_labels) <- c("activity","activity_name")

# load test data
x_test <- read.table(".\\UCI HAR Dataset\\test\\X_test.txt")
y_test <- read.table(".\\UCI HAR Dataset\\test\\y_test.txt")
s_test <- read.table(".\\UCI HAR Dataset\\test\\subject_test.txt")

# load train data
x_train <- read.table(".\\UCI HAR Dataset\\train\\x_train.txt")
y_train <- read.table(".\\UCI HAR Dataset\\train\\y_train.txt")
s_train <- read.table(".\\UCI HAR Dataset\\train\\subject_train.txt")

# create vectors of y(activity) and s(subjects)
trainy <- y_train$V1 # Convert variable "V1" to vector "trainy"
testy <- y_test$V1 # Convert variable "V1" to vector "testy"

trains <- s_train$V1 # Convert variable "V1" to vector "trains"
tests <- s_test$V1 # Convert variable "V1" to vector "tests"

# Merge data and labels
activity <- c(trainy,testy) # Combine train/test activity labels into vector
subject  <- c(trains,tests) # Combine train/test subject labels into vector
labels <- data.frame(cbind(subject,activity)) # Combine subject and activity labels into single data frame

# Create Union Training + test Data               (Rubric 1)
data <- rbind(x_train,x_test)

# Edit features vector to separate Domains by adding  "-" after first character
featureVector <- sub("^f","f-",features$V2,)
featureVector <- sub("^t","t-",featureVector,)

# Creating Domain "at" meaning "angle t", aX, aY and aZ meaning "angle X, Y and Z"
featureVector <- sub("angle\\(t","at-",featureVector,)
featureVector <- sub("angle\\(X","aX-",featureVector,)
featureVector <- sub("angle\\(Y","aY-",featureVector,)
featureVector <- sub("angle\\(Z","aZ-",featureVector,)

# Removing "," character from names
featureVector <- sub("\\,","",featureVector,)

# removing "(", ")" characters from feature names
featureVector <- gsub("\\(","",featureVector,)
featureVector <- gsub("\\)","",featureVector,)

# Separating the word "Mean" from the feature name
featureVector <- sub("[a-z]Mean$","-mean",featureVector,)

# Finaly add header containing cleaned  column names              (Rubric 4)
colnames(data) <- featureVector   
    

# Merge labels to dataset
data <- cbind(labels,data) # use the same name for the data frame "data"  to save memory

# Assign descriptive names to Activity values               (Rubric 3)
data<-arrange(join(activity_labels,data),activity)
data$activity <- data$activity_name

----------------------------------------------------------
# Select only Mean and Std data        (Rubric 2)
# select only features that contains the text "-mean" or "-std"
# Generate tall and skinny data set by the use of gather        
df1<- data %>%
        select (subject,
                activity,
                contains("-mean", "-std")) %>%
        gather(measure,value,-subject, -activity)

# Verify results, if desired               
#names(df1)     

# Write table using Write.table function
file<- "tallskinny.txt"
write.table(df1, file=file, row.names=FALSE, col.names=TRUE, sep="\t", quote=FALSE)

# Create second data frame containing the averages     (Rubric 5)
df2<-dcast(df1,subject+activity ~ variable,mean)

# write file with average results from df2
file<- "average.txt"
write.table(df2, file=file, row.names=FALSE, col.names=TRUE, sep="\t", quote=FALSE)
