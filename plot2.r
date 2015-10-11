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


### - Plot 2 - Time Series of Global Active Power 

# Change Global_active_power to numeric from factor
data$Global_active_power <- as.numeric(as.character(data$Global_active_power))

# combining
data$DateTime <- as.POSIXct(paste(data$MyDate, as.character(data$Time)))

# Create plot
plot(x= data$DateTime, y= data$Global_active_power,type="n", ylab="Global Active Power (kilowatts)", xlab="")
lines(x= data$DateTime, y= data$Global_active_power, type="l")

# Write to file and close connection
dev.copy(png, file="plot2.png")
dev.off()
