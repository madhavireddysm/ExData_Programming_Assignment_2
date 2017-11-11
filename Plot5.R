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

# 5. How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?

vehicles <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE)
vehiclesSCC <- SCC[vehicles,]$SCC
vehiclesNEI <- NEI[NEI$SCC %in% vehiclesSCC,]

baltimoreVehiclesNEI <- vehiclesNEI[vehiclesNEI$fips==24510,]

ggplot(baltimoreVehiclesNEI,aes(factor(year),Emissions)) +
  geom_bar(stat="identity",fill="grey",width=0.75) +
  theme_bw() +  guides(fill=FALSE) +
  labs(x="year", y=expression("Total PM2.5 Emission In Tons")) + 
  labs(title=expression("PM2.5 Motor Vehicle Source Emissions in Baltimore from 1999-2008"))

dev.copy(png,"./plot5.png", width=480, height=480, units='px') 
dev.off()

# Emissions from motor vehicle sources have dropped from 1999-2008 in Baltimore City.
