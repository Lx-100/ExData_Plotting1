#This is the code for creating the second plot in Week 1's assignment 
#of Exploratory Data Analysis with R on Coursera
#This code loads Individual household electric power consumption Data Set
#and plot a scatter plot with lines illustrating the 
#relationship between Global Active Power and the time
#between 2007-02-01 and 2007-02-02

library (dplyr)
library (lubridate)

fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

#download and unzip the dataset
if (!file.exists("./data")) {
  dir.create ("./data")
  download.file(fileUrl, destfile = "./data/household_power.zip", method = "curl")
  unzip ("./data/household_power.zip", exdir = getwd())
}

#read in the data set
data <- read.table ("household_power_consumption.txt", 
                    header = TRUE, sep = ";",                     
                    colClasses ="character")

#convert the Date column into dates using lubridate
data$Date <- dmy (data$Date)

#subset data between 2007-02-01~2007-02-02
sub <- filter (data,  Date == "2007-02-01" | Date == "2007-02-02")
rm (data)

#add a dt col to sub
sub <- mutate (sub, dt = ymd_hms(paste (sub$Date, sub$Time, sep = " ")))

#convert the Global Active Power col. to numeric values
sub$Global_active_power <- as.numeric(sub$Global_active_power)

#set up the graphic device
png ("plot2.png")

#create a scatter plot with lines demonstrating the
#relationship between Global Active Power and week day

plot (sub$dt, sub$Global_active_power, 
      type = "l", xlab = "",
      ylab = "Global Active Power (kilowatts)")

dev.off()

