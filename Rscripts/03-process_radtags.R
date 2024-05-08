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
# general cutside
renz1 = "pstI"
# rare cutsite
renz2 = "aclI"
# adapter sequence
lenth_limit = 150
##############################
## LIST FILES
##############################
# list of sequence directories
fq <- list()
list.files(path = trim_dir, pattern = "MK1", include.dirs = T) -> fq
# trimmed P1 reads
p1 <- list()
list.files(path = trim_dir, pattern = "Trim1.fq.gz", recursive = T) -> p1
# trimmer P2 reads
p2 <- list()
list.files(path = trim_dir, pattern = "Trim2.fq.gz", recursive = T) -> p2
##############################
## PROCESS_RADTAGS
##############################
### Run process_radtags to parse the Combined data by individual
for (i in seq_along(fq)){
  system(
    paste0("process_radtags",
           " -1 ",trim_dir,p1[i],
           " -2 ",trim_dir,p2[i],
           " -b ",raw_dir,fq[i],"/barcodes_",fq[i],
           " --paired ",
           " -c ",
           " -r ",
           " -o ",radtag_dir,
           " -q ",
           " --inline-inline ",
           " --renz-1 ",renz1,
           " --renz-2 ",renz2
    ),
    intern = TRUE)
}
# cleanup
rm(list=ls())
