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
# number of mismatches allowed between stacks within individuals (for ustacks).
M = 4
# the number of threads/CPUs to use (default: 1).
Thread = 10
# new list of directories to save results
denovo_M_dir <- list()
## Iterate for variable values of M
for (i in seq_along(M)){
  denovo_M_dir[[i]] <- paste0(denovo_dir,"denovo_M",M[i],"/")
  # empty directory to save FastQ files
  unlink(denovo_M_dir[[i]], recursive = TRUE, force = TRUE)
  dir.create(denovo_M_dir[[i]], showWarnings = FALSE,
             recursive = TRUE)
  system(paste0("denovo_map.pl",
                " -T ", Thread,
                " -M ", M[i],
                " -o ", denovo_M_dir[[i]],
                " --samples ", radtag_dir,
                " --popmap ", pop_map,
                " --paired"
  ), 
  intern = TRUE)
}
# cleanup
rm(list=ls())
