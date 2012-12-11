library("foreign") # activate the foreign library, which allows you to read in a .dbf (the data for a shapefile)
dat <- read.dbf('data/man_pluto/MNMapPLUTO.dbf') # read in pluto data
dat <- dat[, "BBL"] # select BBL id column
rat <- read.csv('data/BBLAndScaledRatiness.csv', stringsAsFactors=F) # read in rat data
rat <- rat[rat$Scaled.Ratiness!="",] # remove missing data
rat$Ratiness[rat$Ratiness=='#DIV/0!'] <- 0 # excel errors to 0
rat <- rat[,2:3] # we just want two columns
names(rat) <- c("Ratiness", "BBL") # rename columns

library("plyr") # activate the plyr library which allows includes a  "join" fx to combine tables by common id's
out <- join(rat, dat, by="BBL", type="right") # join tables

write.dbf(d,'/Users/brian/Dropbox/towmapathon2012/data/man_pluto/MNMapPLUTO.dbf') # write dbf to file