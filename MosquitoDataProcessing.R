## This script creates a new Master Data sheet that includes more granular information about the mosquito community
## This includes mosquito richness, counts of individual species, and metrics related to mosquito predators -- richness and abundance

library(dplyr)

mosqdata <- read.csv("mosqsumdata.csv")
masterdata <- read.csv("MasterDataSummed.csv")

# Appends the mosquito summary data to the master sheet
new.df <- masterdata[1:125,]
new.df$Pool_ID <- as.character(new.df$Pool_ID)
mosqdata$Pool_ID <- as.character(mosqdata$Pool_ID)
new.df <- left_join(new.df, mosqdata, by = "Pool_ID")

# Replaces the empty mosquito counts with zeroes for the Highlands data only (i.e., no Belle, for which IDs weren't done anyway)
new.df[21:125,59:64][is.na(new.df[21:125,59:64])] <- 0


# Calculates mosquito richness, predator richness, and predator abundance for mosquito predators only
new.df$Mosq_Richness <- apply( new.df[,59:64], 1, function( df ) length( which( df > 0 ) ) )
new.df$Pred_Richness <- apply( new.df[c( "Flatworm", "Predacious_Diving_Beetle", "Backswimmer",	"Water_Strider",	"Skimmer_Dragonfly", "Darner_Dragonfly",	"Damselfly",	"Fish")], 1, function( df ) length( which( df > 0 ) ) )
new.df$Pred_Abundance <- apply( new.df[c( "Flatworm", "Predacious_Diving_Beetle", "Backswimmer",	"Water_Strider",	"Skimmer_Dragonfly", "Darner_Dragonfly",	"Damselfly",	"Fish")], 1, FUN = sum )

# Writes the resulting df to a new, separate master data sheet for analysis
write.csv(new.df, "MasterData_MosquitoAnalysis.csv")
