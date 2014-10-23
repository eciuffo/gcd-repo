Getting And Cleaning Data Peer reviewed Project
========================================================

This is a Markdown document geared toward the Coursera Project for the "Getting and Cleaning Data" which is part of the "Data Science specialization program"" established between John Hopkins University and Coursera as a MOOC (Massive Open On-line Course).

The code was authored by Ewerton Ciuffo as part of the "Getting and Cleaning Data"" class Summer 2014.

The R code will proceed as follows:
1) Initialize the environment, load packages, set the root directory where all the actions will happen. This step is commented as it should be set according to the desired location on your desktop.
2) Download the zip file and unzip it. The file should come from the following URL: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
3) load the datafiles into data frames for both test and training data. Notice that the activity code and subject values are separate in distinct files.
4) Assemble the full data set (train Union test). 
5) perform transformations to cleanup feature names
6) Add feature names a headers for the columns. This step is based on the cleaned data from step 4. The vector name used is featureVector and it contains names for all columns.
7) Join the activity_labesl data set with the main measurses data. Use the arrange function for that.
8) Use select function to filter only the subject, activity and measures containing the word "-mean" or "-std". The same step uses gather function to group all measures in a tallskinny intermediary  data set.
9) write intermediary data file "tallskinny.txt" using write.table function.
10) Create second data set using dcast to compute the average.
11) Finally write the tidy data set (wide version) computing the average per subject/activity name.
