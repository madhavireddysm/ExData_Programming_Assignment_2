# Download and unzip data file.

setwd("/Users/MadhaviReddy/ExploratoryDataAnalysis/Programming_Assignment_2")

downloadURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
downloadFile <- "NEI_data.zip"

if(!(file.exists("summarySCC_PM25.rds") && file.exists("Source_Classification_Code.rds")))
{  
  if(!file.exists(downloadFile)) 
  {
    download.file(downloadURL, downloadFile)
  }  
  unzip(downloadFile, overwrite = T)
}  

# Read data from the input file where missing values are coded as "?"

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Load libraries of ggplot2 and plyr

library(ggplot2)
library(plyr)

# Converting "year", "type", "Pollutant", "SCC", "fips" to factor

colToFactor <- c("year", "type", "Pollutant","SCC","fips")
NEI[,colToFactor] <- lapply(NEI[,colToFactor], factor)

# Handling NA's

levels(NEI$fips)[1] = NA
NEIdata <- NEI[complete.cases(NEI),]
colSums(is.na(NEIdata))

# 2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland
# (𝚏𝚒𝚙𝚜 == "𝟸𝟺𝟻𝟷𝟶") from 1999 to 2008? Use the base plotting system to make a plot answering this question.

NEIdataBaltimore <- subset(NEIdata, fips == "24510")
totalEmissionBaltimore <- aggregate(Emissions ~ year, NEIdataBaltimore, sum)
totalEmissionBaltimore

barplot(
  (totalEmissionBaltimore$Emissions)/10^6,
  names.arg=totalEmissionBaltimore$year,
  xlab="Year",
  ylab="PM2.5 Emissions In Tons",
  main="Total PM2.5 Emissions From All Baltimore City Sources"
)

dev.copy(png,"./plot2.png", width=480, height=480, units='px') 
dev.off()

# The total PM2.5 have not continously decreased. 