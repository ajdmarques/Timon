##############################
## INITIALIZE DIRECTORIES
##############################
# Define directories
home_dir <- "./"
raw_dir <- "./raw/"
int_dir <- "./intermediate/"
# results directories
trim_dir <- paste0(int_dir,"trimmomatic/")
radtag_dir <- paste0(int_dir,"process_radtags/")
denovo_dir <- paste0(int_dir,"denovomap/")
populations_dir <- paste0(int_dir,"populations/")
##############################
## PARAMETERS
##############################
### load parameters
# load population map
pop_map = paste0(raw_dir,"popmap")
M = 4       # max mismatches allowed between stacks within individuals
Thread = 10 # the number of threads/CPUs to use (default: 1).
msp = 0.75  # min number of samples per population
maf = 0.05  # minimum minor allele frequency 
moh = 0.5   # maximum observed heterozygosity
# new list of directories to save results
denovo_M_dir <- paste0(denovo_dir,"denovo_M",M,"/")
## Run populations
# run denovo_map
system(paste0("populations",
              " -P ", denovo_M_dir, 
              " -O ", populations_dir,
              " -M ", pop_map,
              " --genepop --structure --fasta-loci",
              " -t ",Thread,
              " --min-samples-per-pop ", 0.75,
              " --min-maf ",0.05,
              "--max-obs-het",0.5), 
       intern = TRUE)
# cleanup
rm(list=ls())
