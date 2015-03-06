library(data.table)

## Plot date_time Vs Globa Active Power (Kilowatts)

## read first few line to get the column names
dat <- read.table("./household_power_consumption.txt", nrows=1, sep=";", header=T)
colnames <- names(dat)        


## Now read the data for 01/02/2007 and 02/02/2007 
## So for each day there are 60 *24 = 1440 rows.
## First entry is for 16/12/2006, and we are interested in data of 01-02-2006 and 02-02-2006
## so we can skip number of entriesrows = 1440 * (days fr7/12/2006 to 31/01/2006 = 46 days) + 420 (for 16/12/2006) = ~66636 rows
## and then reading only  1440 *2 (days) + entries for 16/12/2006 (60) + some for 03/02/2006 (100) = ~3100 rows
data <- as.data.table(read.table("./household_power_consumption.txt", skip=66636, nrows=2882, sep=";", header=T))
setnames(data, names(data), colnames)
date_time_list <- c()
rows <- nrow(data)

## combine the Date and Time columns and then convert to date with as.POSIXct
for (row in 1:rows) {
        date_time <- paste(as.character(as.Date(data$Date[row], "%d/%m/%Y")), data$Time[row], collapse=" ")
        date_time_list <- c(date_time_list, as.POSIXct(date_time))
}

## Plot the graph with labels and type as line,  
plot(date_time_list, data$Global_active_power, type="l", ylab = "Global Active Power (kilowatts)", xlab = "", xaxt = "n")

## create the start and end tick positions
start_time = as.POSIXct(paste(as.character(as.Date(data$Date[1], "%d/%m/%Y")), data$Time[1], collapse=" "))
end_time = as.POSIXct(paste(as.character(as.Date(data$Date[rows], "%d/%m/%Y")), data$Time[rows], collapse=" "))
tickpos <- seq(start_time,
               end_time,
               by="day")

## label x axis with at tickpos
axis.POSIXct(side=1, at=tickpos)

##Copy the graph to a plot2.png file and close the device
dev.copy(png, file="./plot2.png")
dev.off()
