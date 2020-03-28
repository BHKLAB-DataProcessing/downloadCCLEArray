library(readr)
library(tximport)
library(rhdf5)
library(gdata)
library(readxl)
library(openxlsx)
library(CoreGx)
library(affy)



require(downloader)
arraydownload <- download("https://data.broadinstitute.org/ccle_legacy_data/mRNA_expression/CCLE_Expression.Arrays_2013-03-18.tar.gz",  destfile="/pfs/out/CCLE_Expression.Arrays_2013-03-18.tar.gz")
res <- untar(tarfile="/pfs/out/CCLE_Expression.Arrays_2013-03-18.tar.gz", exdir = "/pfs/out")
fff <- affy::list.celfiles(file.path("/pfs/out/CCLE_Expression.Arrays_2013-03-18"))
res <- apply(cbind("from"=file.path("/pfs/out", "CCLE_Expression.Arrays_2013-03-18", fff), "to"=file.path("/pfs/out", fff)), 1, function(x) { return(file.rename(from=x[1], to=x[2])) })
unlink(file.path("/pfs/out/CCLE_Expression.Arrays_2013-03-18"), recursive=TRUE)

celfile.timestamp <- as.character(file.info(file.path("/pfs/out", fff))[ , "mtime"])
celfile.timestamp <- t(sapply(strsplit(celfile.timestamp, split=" "), function(x) { return(x) }))
dimnames(celfile.timestamp) <- list(fff, c("file.day", "file.hour"))

## compress each CEL file individually using gzip
rr <- sapply(file.path("/pfs/out", fff), R.utils::gzip, overwrite=TRUE)

# unlink(file.path(path.ge, "dwl"), recursive=TRUE)
write.csv(celfile.timestamp, file=("/pfs/out/celfile_timestamp.csv")) 
save(list=c("celfile.timestamp"), compress=TRUE, file="/pfs/out/celfile.timestamp.RData")
