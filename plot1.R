## Each row in observation at one minute interval


## read first line to get the column names
dat <- read.table("./household_power_consumption.txt", nrows=1, sep=";", header=T)
colnames <- names(dat)        

## Now read the data for 01/02/2007 and 02/02/2007 
## So for each day there are 60 *24 = 1440 rows.
## First entry is for 16/12/2006, and we are interested in data of 01-02-2006 and 02-02-2006
## so we can skip number of entriesrows = 1440 * (days from 17/12/2006 to 31/01/2006 = 46 days) + 420 (for 16/12/2006) = ~66636 rows
## and then reading only  1440 *2 (days) + entries for 16/12/2006 (60) + some for 03/02/2006 (100) = ~3100 rows
data <- read.table("./household_power_consumption.txt", skip=66635, nrows=2882, sep=";", header=T)
names(data) <- colnames

## draw the hist on the screen first, for Global Active Power
hist(data$Global_active_power, col = 10, xlab="Global Active Power (kilowatts)", main = "Global Active Power")

##Copy the graph to a plot1.png file and then close the device 
dev.copy(png, file="./plot1.png")
dev.off()
