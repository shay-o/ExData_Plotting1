# read sample to get header info
sample <- read.table("./household_power_consumption.txt",nrows=10,sep=";",header=TRUE)

# read data. start only after coming to "1/1/2007"
data <- read.table("./household_power_consumption.txt",skip=grep("1/1/2007",readLines("household_power_consumption.txt")),sep=";")

# assign correct column names
names(data) <- names(sample)

#### --- Subset to dates needed

# Create new column with $Date reformatted as a date
data$MyDate <- as.Date(as.character(data$Date),"%d/%m/%Y")

min_date <- as.Date("2007-02-01")
max_date <- as.Date("2007-02-02")

data <- data[data$MyDate>=min_date & data$MyDate<=max_date,]

# Change Global_active_power to numeric from factor
data$Global_active_power <- as.numeric(as.character(data$Global_active_power))
data$Global_reactive_power <- as.numeric(as.character(data$Global_reactive_power))
data$Voltage2 <- as.numeric(as.character(data$Voltage))

# combining
data$DateTime <- as.POSIXct(paste(data$MyDate, as.character(data$Time)))


# Plot
par(mfrow = c(2,2))
with(data, {
  
  #  plot 1
  plot(x= data$DateTime, y= data$Global_active_power,type="n", ylab="Global Active Power", xlab="")
  lines(x= data$DateTime, y= data$Global_active_power, type="l")
  
  # Plot 2
  plot(x= data$DateTime, y= data$Voltage,type="n", ylab="Voltage", xlab="datetime")
  lines(x= data$DateTime, y= data$Voltage, type="l")
  
  #  plot 3
  plot(x=data$DateTime, y= data$Sub_metering_1,type="n", xlab="",ylab="Energy sub metering")
  lines(x=data$DateTime, y=data$Sub_metering_1,type="l")
  lines(x=data$DateTime, y=data$Sub_metering_2,type="l",col="red")
  lines(x=data$DateTime, y=data$Sub_metering_3,type="l",col="blue")
  legend("topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),col=c("black","red","blue"),lwd=c(2.5,2.5,2.5))
  
    #  plot 4
  plot(x= data$DateTime, y= data$Global_reactive_power,type="n", ylab="Global_reactive_power", xlab="datetime")
  lines(x= data$DateTime, y= data$Global_reactive_power, type="l")
  
})

# Write to file and close connection
dev.copy(png, file="plot4.png")
dev.off()
dev.off()
#NEXT get plots square then post.