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
## SAMPLE PREP
##############################
# sample indices and barcodes
read.csv(paste0(raw_dir,"Timon_indices.csv")) -> 
  df_indices
# index key
read.table(paste0(raw_dir,"index_key")) -> key
# Seq library
read.csv(paste0(raw_dir,"ddRAD_GVA1.csv"),skip = 13) -> 
  df_seq
# list of sequence directories
fq <- list()
list.files(path = raw_dir, pattern = "MK1", include.dirs = T) -> fq
# save barcode to each sequence directory
for (i in seq_along(fq)){
  # identify sample corresponding to seq directory
  df_seq[df_seq$Description == fq[i],]$Sample_ID -> x
  # match name to corresponding code
  df_indices[df_indices$SampleName==x,
             c("P1.Adapter","P2.Adapter","SampleName")] -> y
  data.frame(v1=key[match(y$P1.Adapter, key$V1), 2], 
             v2=key[match(y$P2.Adapter, key$V1), 2],
             v3=y$SampleName) -> y
  # write barcode file for seq directory
  write.table(y,
              paste0(raw_dir,fq[i],"/barcodes_",fq[i]),
              col.names = F, row.names = F, quote = F, sep = "\t")
}
# match and repalces name with sequence
data.frame(v1=key[match(df_indices$P1.Adapter, key$V1), 2], 
           v2=key[match(df_indices$P2.Adapter, key$V1), 2],
           v3=df_indices$SampleName) -> barcodes

# save data as barcode file
write.table(barcodes,paste0(raw_dir,"barcodes"),
            col.names = F, row.names = F, quote = F, sep = "\t")
x <- list()
# collect list of barcode files
list.files(path = raw_dir, pattern = "barcodes_", recursive = T) -> barcodes
for (i in seq_along(barcodes)){
  read.table(paste0(raw_dir,barcodes[i]))[3] -> x[i]
}
# write limited popmap to input
write.table(cbind.data.frame(unlist(x),rep("Timon",length(x))), # assign all samples as generic Timon
            paste0(raw_dir,"popmap"),
            col.names = F, row.names = F, quote = F, sep = "\t")
# cleanup
rm(df_indices,key,barcodes,df_seq,fq,i,x,y)
##############################
## Trimmomatic
##############################
pattern <- c("1.fq.gz","2.fq.gz")
s = 1 # start character
f = 6 # ending character
# fastp filter options
qualified_quality_phred = 15 
length_required = 50
low_complexity_filter = 30 # Minimum complexity
## list fo files to run
# list of sequence directories
fq <- list()
list.files(path = raw_dir, pattern = "MK1", include.dirs = T) -> fq
# single end
p1 <- list()
list.files(path = raw_dir, pattern = pattern[1], 
           recursive = T) -> p1
# paired end
p2 <- list()
list.files(path = raw_dir, pattern = pattern[2], 
           recursive = T) -> p2
# generate output directory for trimmed results
for (i in seq_along(fq)){
  dir.create(paste0(trim_dir,fq[i]), 
             showWarnings = FALSE, recursive = TRUE)
}
# execute Trimmomatic for all reads
for (i in seq_along(p1)){
  system(
    paste0(
      # Call the function
      "java -jar ","./Trimmomatic-0.39/trimmomatic-0.39.jar",
      # Paired end
      " PE ",
      # Inputs
      raw_dir,p1[i]," ",
      raw_dir,p2[i]," ",
      # Outputs
      trim_dir,fq[i],"/",fq[i],"_Trim1.fq ",
      trim_dir,fq[i],"/",fq[i],"_Unpair1.fq ",
      trim_dir,fq[i],"/",fq[i],"_Trim2.fq ",
      trim_dir,fq[i],"/",fq[i],"_Unpair2.fq ",
      # Select adapters 
      "ILLUMINACLIP:",
      home_dir,"./Trimmomatic-0.39/adapters/NexteraPE-PE.fa:2:30:10 ",
      "SLIDINGWINDOW:4:20 ",
      "MINLEN:150 "
    ),
    intern = TRUE)
  # compress files
  system(paste0(
    "gzip ",trim_dir,fq[i],"/*.fq" 
  ),
  intern = TRUE)
}
# cleanup
rm(list=ls())