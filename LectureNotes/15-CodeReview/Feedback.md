# Group Feedback for Project 1 
## Niko

This code runs fine for me. There are no error returns. It is also readable. It also set
 each parameter as variable. It’s no needs to refactor the code. I didn’t check the memory
usage, because this code run very fast.
Some suggestions:
Please add more comments
 - Line 53, pls explain this for loop
 - line 83, pls add some ending comments of this project the graphs may need
   - vertical axis label
   - legend labeling the functions
   - check -- do they taper off to 1 or 0 (past day 15)?*
 - In addition, It would be better if we put the four plots in one picture, because they 
 have a same x and y axis.

## Ryan 
reads fine
the graphs may need
 - vertical axis label
 - legend labeling the functions
 - check -- do they taper off to 1 or 0 (past day 15)?
 - didn't check memory or speed, however both look ok for the scope of the code (edited) 
 
+ Great comments
-- A legend on the graphs would help a lot because i'm unsure which lines are which
-- The y axis being labeled would also help because I was unsure about what the units are

# Group 2 Feedback
## Krupa and Jeremy
The script's concept is fascinating, and various stocks being analyzed across industries 
provide an excellent high-level overview.

 1.	Provided a thoughtful readme explaining the logic behind the script
 2.	The script utilizes good naming convention
 3.	The script is well organized and spaced out for readability
 4.	The script ran successfully and provided the expected results in an organized fashion.

Suggestions:
 1.	We suggest documenting the stocks in the examples for further clarity. AMZN for Amazon
  may be common knowledge, but it may cause some confusion for a reader who is not as aware
   of the stock market.
 2.	Consider documenting the definitions for terminology and variable names such as line 21
  the colnames
 3.	Increased documentation would help the reader understand the type of calculations and 
 metrics being applied.
 4.	Consider explaining what the results mean, such as null values, and what is considered
  high/low or good/bad for better context.
 5.	The GOOD_PERCENT resulted in 1 for all stocks. We are not sure if this was the intended
  result of the metric.
 6.	We would suggest utilizing spelling and grammar software to resolve any small mistakes 
 that may have been missed. For example, the word stuck appears to be misspelled for the word 
 stock in the readme.

## Roberto and Louis
The program itself is nicely written, variables represent what they're supposed to do. 
However, more comments would have been useful for people that may have a different background.
I like the fact that the author created a function instead of repeating the prediction for 
each variable as well but some comments would have helped with some of the operations.
Lastly the binding of all the predictions into a table took a lot of time. I am not sure 
if it's because of the copying issue we discussed in class or the fact that it is extracting 
the data dynamically maybe. Also, refactoring this part may be helpful since all the author
 is using the same ata frame and adding each variable as the only argument changing.


# Group Feedback for Project 3
## Hesam Safri and Joshua Anderson

Comments to the Author of Project 3:

The documentation is very detailed and well put together. This helps a lot with 
understanding the goal of the project and what problem is trying to be solved. Although It
 is not clear whether the 510draft.r or the completed model.r file is the correct one to be
  reviewed.

Looking into the 510draft.r the header comments are well put together and are informative.

line 51 - Before each regression, adding a comment to specify which model is being used to
 clarify the goal of a specific code chunk.

line 144-157 - there is a lot of repetition in some of these models like in this section. 
Using a for loop or a function to clean up the computation would be useful.

In general the project structure is organized, but could also be improved. Using an R 
project and subdirectories is good practice but could also add a folder for data/ Also 
avoiding setting the working directory in the R file would make it cleaner. The project 
definitely had effort put into organization but has room for improvement as well.

## Yibo and Raha
Point of improvement:
Update read.me to include packages to open and how to navigate through the folders.
Includes lines on packages to install.
At the beginning of the script, maybe it’s a good idea to put a short description of the
 dataset used and the plot as well as project itself.
Install and preload the packages at the beginning of the script
Clean up the sub-title in the plot.
Maybe add documentation to explain the variables in the dataset

Highlights:
Good commends to explain what codes below does
Good looking plot (titles, great labeling, great use of colors)


# Group Feedback for Project 4 
## Daniel Briseno, Hanna Lu

 1. We like that each block of code has comments explaining its function
 2. Code needs additional data to run that is not provided, we get an error on line 48 
 since we don't have `stock_volumes/VZ.csv`
 3. Some comments are unclear. As an example, we're having some trouble understanding what
  `# ticker symbols used maybe need` means on line 37. 
 4. We like the use of descriptive variable names. As an example, `ticker_symbols` and
  `dividend_table` are very descriptive.







