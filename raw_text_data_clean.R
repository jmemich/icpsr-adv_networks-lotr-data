## cleaning raw Luke Hilliman network data from :http://www.lukehillman.net/2011/06/social-network-analysis/
## for ICPSR adv. network analysis class

# get text file with raw data
raw_data <- readLines("C:/Users/Jamie/Documents/GitHub/icpsr-adv_networks-lotr-data/luke_hilliman-raw_lotr_data.txt") 

# unique names
unique_names <- unlist(unique(lapply(strsplit(grep("^[^0-9]", raw_data, value = TRUE), " and "), function(X) unique(X[[1]]))))

# create edgelist
edgelist <- data.frame(expand.grid(unique_names, unique_names), stringsAsFactors = FALSE)[, 2:1] ## reverse col order (prettier!)
edgelist$edge <- 0
	
# iterate over each pair of characters
# add edge if any one meeting across all three books!
for(i in unique_names)  {

	for(ii in unique_names) {

		line_number <- grep(paste(i, "and", ii), raw_data)

		# if any of the next 3 lines (1 line for each book) ends in '1' then the two character meet
		if(any(grepl("[1-9]$", raw_data[c(line_number + 1, line_number + 2, line_number + 3)]))) {

			edgelist$edge[edgelist[, 1] == i & edgelist[, 2] == ii] <- 1
			
		}

	}

}

# write data
write.csv(edgelist, "C:/Users/Jamie/Documents/GitHub/icpsr-adv_networks-lotr-data/edgelist.csv", row.names = FALSE)