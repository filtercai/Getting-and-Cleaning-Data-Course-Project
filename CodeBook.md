# Codebook for Getting and Cleaning Data Course Project

## About
This is the course project for the Getting and Cleaning Data Coursera course. 

Filter Cai
2015-11-22

## Project Description
This is the course project for the Getting and Cleaning Data Coursera course. 
This code book descrip the process step by step and summarizes the resulting data fields in tidy.txt.

##Study design and data processing

###Collection of the raw data
In **getdata.sh**, use wget and unzip to download and unzip the data.

###Step 1 Megre the data
1. Read and merge train data from subject, Xtrain, ytrain file, merge them by ID.
2. Do the same thing on test data.
3. Merge the train and test data.

###Step 2 Extracts the selected measurements
1. Read all the feature items from features.txt
2. Select mean and std measurements by regex.
3. Extracts the selected col from step 2.

###Step 3 Uses descriptive activity names 
1. Read the descriptive names from activity\_labels.txt
2. merge the data set from step2 and the descriptive name by activity id

###Step 4 Appropriately labels set with descriptive variable names. 
1. Use for loop traverse the col-names.
2. set the only Vxxx col's col-name by the feature label which read in step2.1

###Step 5 aggregate the write data set.
1. Remove the redunant col to abide the tidy data rule.
2. Aggregate to ave the var.
3. Write the data set to file.

###Tips
* always do house clean work after ech step, clear the temp var.

##Sources
TBC

##Annex
TBC
