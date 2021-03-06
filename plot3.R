library(data.table)
## Each row in observation at one minute interval


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

#print(colnames)
## combine the Date and Time columns and then convert to date with as.POSIXct
for (row in 1:rows) {
        date_time <- paste(as.character(as.Date(data$Date[row], "%d/%m/%Y")), data$Time[row], collapse=" ")
        date_time_list <- c(date_time_list, as.POSIXct(date_time))
}

## Plot the graph with labels and type as line,  
plot(date_time_list, data$Sub_metering_1, ylab = "Energy sub metering", xlab = "", xaxt = "n", type = "n")

## create the start and end tick positions
start_time = as.POSIXct(paste(as.character(as.Date(data$Date[1], "%d/%m/%Y")), data$Time[1], collapse=" "))
end_time = as.POSIXct(paste(as.character(as.Date(data$Date[rows], "%d/%m/%Y")), data$Time[rows], collapse=" "))
tickpos <- seq(start_time,
                end_time,
                by="day")

## label x axis with at tickpos
axis.POSIXct(side=1, at=tickpos)

## Draw the points for each of the three Sub metering

## Draw sub metering 1
points(date_time_list, data$Sub_metering_1, col = "black", type = "l")

## Draw sub metering 2
points(date_time_list, data$Sub_metering_2, col = "red", type = "l")

## Draw sub metering 3
points(date_time_list, data$Sub_metering_3, col = "blue", type = "l")

## Put legends on top right corner
legend("topright", pch = "_", col = c("black", "red", "blue"),
        legend = c(colnames[[7]], colnames[[8]], colnames[[9]]))

print("strwidth: ")
print(strwidth(colnames[[9]]))

##Copy the graph to a plot3.png file and close the device
dev.copy(png, file="./plot3.png")
dev.off()
