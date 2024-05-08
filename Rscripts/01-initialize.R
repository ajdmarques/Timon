## INITIALIZE DIRECTORIES
home_dir <- "./"
raw_dir <- "./raw/"
int_dir <- "./intermediate/"
#Delete and create a new directory for Trimmomatic output.
trim_dir <- paste0(int_dir,"trimmomatic/")
unlink(trim_dir, force = TRUE, recursive = TRUE)
dir.create(trim_dir, showWarnings = FALSE, recursive = TRUE)
#Delete and create a new directory for process_radtags output.
radtag_dir <- paste0(int_dir,"process_radtags/")
unlink(radtag_dir, force = TRUE, recursive = TRUE)
dir.create(radtag_dir, showWarnings = FALSE, recursive = TRUE)
#Delete and create a new directory for denovomap output.
denovo_dir <- paste0(int_dir,"denovomap/")
unlink(denovo_dir, force = TRUE, recursive = TRUE)
dir.create(denovo_dir, showWarnings = FALSE, recursive = TRUE)
#Delete and create a new directory for populations output.
populations_dir <- paste0(int_dir,"populations/")
unlink(populations_dir, force = TRUE, recursive = TRUE)
dir.create(populations_dir, showWarnings = FALSE, recursive = TRUE)
#Names of your base working directories.
print(c(home_dir,raw_dir,int_dir))
# cleanup
rm(list=ls())
