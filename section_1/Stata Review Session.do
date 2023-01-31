/*

Section 1: Stata Review
Date: January 2023

*/

* Clears any stored data, matrices, etc. in the current session
clear all

* Closes any log files that you may be open 
	*capture prefix suppresses output and lets the do file continue in spite of 
	*errors (e.g. no log being open)
capture log close

* Changes the working directory for both saving and opening files.  
* You will need to change this!
cd "/Users/benjaminzeisberg/university/Econ1123/section_1"

* Creates a log file of all Stata output.
log using statareview, replace

* Loads in  dataset.  This dataset should be stored in the working directory.
use nlsw88

* View the data in spreadsheet form
browse

/* How to read in your data 
Stata converts data to .dta files, which isn't a very common data type, so you will occasionally
need to convert a .csv, .xls, or similar filetype to a .dta, which Stata has tools to handle in 
its tool bar under file -> import

To find the working directory you need to specify a 'path' for Stata to follow to a given folder

Tip:
	- here is how to find the path of a file on mac: https://setapp.com/how-to/how-to-find-the-path-of-a-file-in-mac
	- here is how to find the path of a file on PC: https://www.sony.com/electronics/support/articles/00015251
	- the path must lead to a folder, NOT a specific file
*/

/*
Summarize and desribe the data: 
	- How many observations are there?  
	- How many variables?  
	- What types of variables?  
	- Produce a few summary statistics.
*/

display _N

* Variable Type
desc age
desc race

* Notice that race is saved as a numeric variable--each category has a numeric 
* value and a string label.
tab race
tab race, nolabel
count if race == 2 
count if race == .

* You might also find data where variables are saved as strings.  You must always 
* use quotation marks when working with strings.
desc racestr
count if racestr == "black"
count if racestr == ""

* You can also make a two-way tabulation table!
tab race married

* Basic Summary Stats
sum wage
sum wage, detail
sum wage if collgrad == 1
sum wage if collgrad == 0


* Histograms
hist wage
hist wage if race == 2 
hist wage, by(race) name(plot1)

* If you would like to make a frequency table instead of a density one, add 
* "freq" to your hist command.
hist wage, freq by(race) name(plot2)

* Scatterplot
scatter wage age, name(plot3)


* Creating new variables

* Take the log of a variable
gen lwage = log(wage)

* This creates a binary (0 or 1) variable indicating if the person worked more
* than 30 hours per week.
* Stata interprets missing values of numeric values as infinity, so be careful
* when you are coding "greater than" statements!
gen full_time = hours > 30 if hours!=.

* Use an existing variable to generate new information
gen birthyear = .
replace birthyear = 1988 - age


* Estimate a regression of log hourly wage on highest grade completed
reg lwage grade

* Use robust standard errors
reg lwage grade, robust

* Use HC2 standard errors
reg lwage grade, hc2

* Estimate conditional and multivariate regressions
reg lwage grade if full_time == 0, robust
reg lwage grade union race, robust

* Other helpful commands

* Compute the correlation coefficient between hours and wage.
corr grade wage

* View Stata's help file on a command
help scatter

* Sort the data by a variable
sort age
* or by two variables!
sort idcode age

* Close your log file
log close 
