library(data.table)

# Creates a large .csv file with 1M rows
set.seed(100)
m <- data.frame(matrix(runif(10000000), nrow=1000000))
write.csv(m, 'm2.csv', row.names = F)

# Time taken by read.csv to import
system.time({m_df <- read.csv('m2.csv')})

# Time taken by fread to import
system.time({m_dt <- fread('m2.csv')})

##############################################################################

#creating a dummy data table
DT <- data.table( ID = 1:50,
                  Capacity = sample(100:1000, size = 50, replace = F),
                  Code = sample(LETTERS[1:4], 50, replace = T),
                  State = rep(c("Alabama","Indiana","Texas","Nevada"), 50))
head(DT)

#simple data.table command
DT[Code == "C", mean(Capacity), State]

# You don't need to utilize every aspect of the command
DT[Code == "D"]
DT[, mean(Capacity), by = State]
DT[Code == "A", mean(Capacity)]

##############################################################################

library(data.table)

mydata = fread("https://github.com/arunsrinivasan/satrdays-workshop/raw/master/flights_2014.csv")

# 1) selecting / keeping columns based on name - here keeping only the "origin" column
dat1 = mydata[ , .(origin)] # returns a data.table, note the preceding "." prior to (origin)

# 2) selecting columns based on position - here keeping 2nd column ="month" 
dat2 = mydata[, 2]

# 3) keeping multiple columns 
dat3 = mydata[, .(origin, year, month, hour)]

# 4) dropping multiple columns using the "!" sign
dat4 = mydata[, !c("origin", "year", "month"), with=FALSE]

# 5) using logical operator "%like%" to find pattern (here "dep") and keep columns
dat5 = mydata[,names(mydata) %like% "dep", with=FALSE]

# 6) subsetting rows/ filtering based on one variable
dat6 = mydata[origin == "JFK"]

# 7) subsetting rows/ filtering using '%in%' -- Filter all the flights whose origin is either 'JFK' or 'LGA'
dat7 = mydata[origin %in% c("JFK", "LGA")]

# 8) rename multiple variables with the setnames() function
setnames(mydata, c("dest","origin"), c("Destination", "origin.of.flight"))

#9) sort data using setorder() function, By default, it sorts data on ascending order
mydata01 = setorder(mydata, origin)



