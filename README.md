Douglas R Briggs
Coursera: Getting and Cleaning Data
August 2014


## Files
* README.md: this markdown file
* run_analysis.R: the R script that will conduct the data cleansing operation on the Samsung  movement files.
* samsung_tidy.txt: the resulting tidy data file, with the mean of all variables grouped by subject number and activity
* Samsung Movement Summary Codebook.csv: the codebook describing fields in the tidy data set: column number, name, data type, length, and content description

## Assumptions
The R script runs successfully when sourced in the same directory as the unpacked Samsung data (i.e. the UCI HAR Dataset directory).  It depends on the libraries:
* plyr
* stringr

## Script Behavior
The R script runs in five parts:
* Part 1:
	* reads in data files (subject_test, x_test, y_test, subject_train, x_train, y_train)
	* merges them into a consolidated dataframe 
	* labels the columns with the features.txt entries
* Part 2:
	* finds the list of desired columns: only mean() and std() of each measurement.
	* subsets the dataframe into a new dataframe with the desired columns
* Part 3:
	* Renames activities to use the descriptive character labels instead of numbers
* Part 4:
	* Cleans up all column names to use UpperCamelCase and conform to tidy standards, removing extraneous spaces and punctuation marks
* Part 5:
	* Reorders the dataframe to put the Subject and Activity columns first
	* Aggregates the dataframe by taking the mean of all variables, grouped by Subject and Activity
	* Writes the resulting dataframe to the file "samsung_tidy.txt"
	* Writes the column names to the file "samsung_tidy_columns.txt"