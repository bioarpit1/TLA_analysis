#############################################
# make a plot with all chromosomes#
#############################################

# usage GenomePlot.R file.txt chr1:123-456

# The first argument is a .txt file with the coverage depth bins of fixed sizes


##### Defining functions

# Function: removes the chromosomes with too few data points
removeSmall <- function( a ){
	# build a vector with frequencies for each chromosome	
	cnt <- table(a[,1])
	# select only chromosomes with more that 100 data point
	n <- names(cnt[cnt > 100])
	# filter the data for the selected chromosome
	a[a[,1] %in% n,]
}

# Function: makes running median on data
runMedChrom <- function(z, window=5){
	# making a list of chr
	chr <- unique(z[,1])
	# making running median
	for( c in chr ){
		z[,3] <- runmed(z[,3], k=window)
	}
	z
}

# Function: Sort by chromosome
sortOnChrom <- function( input ){
	#remove 'chr' string
	x <- sub("chr","",as.character(input[,1]))
	# change from lower to upper case
	x <- toupper(x)
	#save number of chromosomes
	len <- length(unique(x))
	# replace the X with the total number of chromosomes
	x[x=='X'] <- len
	# replace the Y with the total number of chromosomes+1
	x[x=='Y'] <- len+1
	# chanage x to numeric
	x <- as.numeric(x)
	# change the order in input
	input[order(x),]
}	

# Function: plotting coverage data (exclude should be chr:start-end, 0-based system)
# Exlude parameter allows to specify a genomic regions that will not be considered when setting the Y-axes
translocationPlot <- function( td, cutoff){
	# cutoff value is set base on specified quantile 
	abs.cut <- quantile(td[,3],cutoff, na.rm=T)

	#replace all the values above the cutoff with the cutoff value
	td[td[,3] > abs.cut,3] <- abs.cut
	# normalize on the cutoff value
	td[,3] <- td[,3]/abs.cut

	#remove 'chr' string
	td[,1] <- sub("chr","",as.character(td[,1]))
	# change from lower to upper case
	td[,1] <- toupper(td[,1])
	# save chr names as character
	td[,1] <- as.character(td[,1])
	# remove chr names that do not contain number or X/Y
	td <- td[grep("[0-9XY]",td[,1]),]
	# remove chr names that contain "_"
	td <- td[grep("_",td[,1], invert=T),]

	#saving chromosomes labels (adding chr back)
	chroms <- paste("chr", unique(td[,1]), sep="")

	# check if chrY exists
	if(sum(chroms == 'chrY')){
		# Replace Y and Y with numbers
		td[td[,1]=='X',1] <- length(chroms)-1
		td[td[,1]=='Y',1] <- length(chroms)
	}else{
		print("No_chrY")
		# Replace only X with numbers
		td[td[,1]=='X',1] <- length(chroms)
		#add and empty values to the list of chroms (this way the y-axis has the same scale in both sexes)
		chroms<-append(chroms, "")
	}
	# save data as numeric (at this stage all the chr are called using numbers	
	td[,1] <- as.numeric(td[,1])

	#plotting area using min and max values(but not graphic is added with the type='n' option)
	plot(c(0,max(td[,2])), c(0,length(chroms)), type='n', axes=F, xlab="Chromosomal position (Mb)", ylab="", ylim=(c(0,length(chroms))) )

	#connecting data points with lines (coverage values are added to the chr numbers)
	segments(td[,2],td[,1],td[,2],td[,1]+td[,3])
	# making labels for genomic positions
	lab <- seq(0,ceiling(max(td[,2])/10e6)*10, by=10)
	axis(1, at = lab*1e6, label=lab)
	# making labels for chromosomes
	axis(2, at= 1:length(chroms)+0.5, lab=chroms, lwd=0, las=2, hadj=0 )

}	


#################
# Start Program #
#################
args <- commandArgs(trailingOnly = TRUE)
f<-args[1]
# Saving input to a matrix
d <- read.delim(f, h=F, stringsAsFactors=F)

#skip if not enough is mapped
#if(nrow(d) < 30e3)
#	next

# Remove chr with too few data points
#d <- removeSmall(d)
# Make running median on data
d <- runMedChrom(d)
# Sort by chromosome
d <- sortOnChrom(d)
# removing NA
d <- d[!is.na(d[,3]),]

# saving a name for the output file (use input name and replace .txt with png)
out.file <- sub(".txt",".png", f)

#open a png file with specified size
png(out.file, wid=1200, hei=600)
	# setting margins
	par(mar=c(5, 4, 4, 2))
	# plotting data 
	translocationPlot(d, cutoff=0.999)
invisible(dev.off())
