.separateYMD <- function(d){
    ## valueDate format valueDate = "2008-02-01"
    dateYear <- as.numeric(format(as.Date(d), "%Y"))
    dateMonth <- as.numeric(format(as.Date(d), "%m"))
    dateDay <- as.numeric(format(as.Date(d), "%d"))
    return(c(dateYear, dateMonth, dateDay))
}


## download the rates zip file from a given URL. Unzip and parse the
## XML
.downloadRates <- function(URL, verbose = FALSE){ 
    tf <- tempfile()
    td <- tempdir()
    download.file(URL, tf , method = "curl", quiet = 1-verbose, mode = 'wb')
    files <- unzip(tf , exdir = td)
    
    ## the 2nd file of the unzipped directory contains the rates info
    doc <- xmlTreeParse(files[2], getDTD = F)
    r <- xmlRoot(doc)
    return(r)
}


