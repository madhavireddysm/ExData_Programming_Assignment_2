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

# 3. Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) 
# variable, which of these four sources have seen decreases in emissions from 1999-2008 
# for Baltimore City? Which have seen increases in emissions from 1999-2008? 
# Use the ggplot2 plotting system to make a plot answer this question.

g <- ggplot(aes(x = year, y = Emissions, fill=type), data=NEIdataBaltimore)
g+geom_bar(stat="identity")+
  facet_grid(.~type)+
  labs(x="year", y=expression("Total PM2.5 Emissions In Tons")) + 
  labs(title=expression("PM2.5 Emissions, Baltimore City 1999-2008 by Source Type"))+
  guides(fill=FALSE)

dev.copy(png,"./plot3.png", width=480, height=480, units='px') 
dev.off()

# The “NON-ROAD”, “NONPOINT” and “ON-ROAD” type of sources have 
# shown a decrease in the total PM2.5 Emissions. “POINT” type of source, shows the increase 
# in the total PM2.5 emissions from 1999-2005 but again a decrease in 2008.