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

# 4.Across the United States, how have emissions from coal combustion-related sources 
# changed from 1999-2008?

names(SCC)<-gsub("\\.","", names(SCC))

SCCcombustion<-grepl(pattern = "comb", SCC$SCCLevelOne, ignore.case = TRUE)
SCCCoal<-grepl(pattern = "coal", SCC$SCCLevelFour, ignore.case = TRUE)

SCCCoalCombustionSCC<-SCC[SCCcombustion & SCCCoal,]$SCC
NIECoalCombustionValues<-NEIdata[NEIdata$SCC %in% SCCCoalCombustionSCC,]
NIECoalCombustionTotalEm<-aggregate(Emissions~year, NIECoalCombustionValues, sum)

g<-ggplot(aes(year, Emissions/10^5), data=NIECoalCombustionTotalEm)
g+geom_bar(stat="identity",fill="grey",width=0.75) +
  guides(fill=FALSE) +
  labs(x="year", y=expression("Total PM2.5 Emission In Tons")) + 
  labs(title=expression("PM2.5 Coal Combustion Source Emissions Across US from 1999-2008"))

dev.copy(png,"./plot4.png", width=480, height=480, units='px') 
dev.off()

# Coal cumbustion is showing a decreasing trend with a slight increase from 2002-2005, and then a decrease after.

