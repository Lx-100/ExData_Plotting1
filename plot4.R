#This is the code for creating the 4th plot in Week 1's assignment 
#of Exploratory Data Analysis with R on Coursera
#This code loads Individual household electric power consumption Data Set
#and plot plot1, plot2, plot3 together with
# a scatter plot with lines  illustrating the 
#relationship between Global active power and the time
#between 2007-02-01 and 2007-02-02 in a 2 by 2 format

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

#convert the col.s to numeric values
sub$Global_active_power <- as.numeric(sub$Global_active_power)
sub$Voltage <- as.numeric(sub$Voltage)
sub$Global_reactive_power <- as.numeric(sub$Global_reactive_power)

#add a dt col to sub
sub <- mutate (sub, dt = ymd_hms(paste (sub$Date, sub$Time, sep = " ")))

#set up the graphic device
png ("plot4.png")

par (mfrow = c(2,2))
with (sub, {
      plot (dt, Global_active_power, 
                 type = "l", xlab = "",
                 ylab = "Global Active Power (kilowatts)")
      
      plot(dt, Voltage,
           type = "l", xlab = "datetime", ylab = "Voltage")
      
      plot (dt, Sub_metering_1,  
            type = "l", ylab = "Energy sub metering",
            xlab = "")
      points (dt, Sub_metering_2,  type = "l", col = "red")
      points (dt, Sub_metering_3,  type = "l", col = "blue")
      legend ("topright", lty =1, 
              col = c ("black", "red", "blue"),
              legend = c ("Sub_metering_1", "Sub_metering_2",
                          "Sub_metering_3"))
      
      plot (dt, Global_reactive_power, type = "l",
            xlab = "datetime", ylab = "Global_reactive_power")
      })

dev.off()