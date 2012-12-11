rm(list=ls())
d <- read.csv('/Users/brian/Dropbox/towmapathon2012/data/ReadyForTute.csv', stringsAsFactors=F)
inspections <- d[ ,grep("Result", names(d))]

results2number <- function(v) {
    v = gsub("Passed Inspection", "0", v)
    v = gsub("Problem Conditions", "8", v)
    v = gsub("Active Rat Signs", "10", v)
    v = as.numeric(v)
    return(v)
}

inspections <- apply(inspections, 2, results2number)
summary(inspections)
rattiness = vector("numeric", nrow(inspections))

# scaling function
scale <- function(x, low = 1, high = 100, min, max) {
    scaled <- (low + (x - min)*(high-low) / (max-min))
    return(scaled)
}

# compute rattiness
for (i in 1:nrow(inspections)) {
    property <- inspections[i, ]
    property <- property[!is.na(property)] # remove NAs
    n.inspections <- length(property)

    # define max and mins
    if (n.inspections==0) { 
        rattiness[i] <- NA
    }
    else {
        if (n.inspections==1) { 
            min <- 1
            max <- 10
        }
        if (n.inspections==2) { 
            min <- 2
            max <- 20 
            property[2] <- property[2] * c(0.7)
            property[1] <- property[1] * c(0.3)
        }
        if (n.inspections==3) { 
            min <- 3
            max <- 30
            property[3] <- property[3] * c(0.6)
            property[2] <- property[2] * c(0.25)
            property[1] <- property[1] * c(0.15)
        }
        if (n.inspections==4) { 
            min <- 4
            max <- 40
            property[4] <- property[4] * c(0.55)
            property[3] <- property[3] * c(0.20)
            property[2] <- property[2] * c(0.15)
            property[1] <- property[1] * c(0.1)
        }
        
    # scale 
    x <- sum(property)
    rattiness[i] <- scale(x, min = min, max = max)
    }
}
stem(rattiness)