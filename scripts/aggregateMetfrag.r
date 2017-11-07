#!/usr/bin/env Rscript

options(stringAsfactors = FALSE, useFancyQuotes = FALSE)

# Taking the command line arguments
args <- commandArgs(trailingOnly = TRUE)

if(length(args)==0)stop("No files have been specified!")

output<-NA
appendTo<-NA
appendToName<-"realNames"
cleanFileName=T
filetype="txt"
for(arg in args)
{
  argCase<-strsplit(x = arg,split = "=")[[1]][1]
  value<-strsplit(x = arg,split = "=")[[1]][2]
  
  if(argCase=="realNames")
  {
    realNames=as.character(value)
  }
  if(argCase=="inputs")
  {
    inputs=as.character(value)
  }
  if(argCase=="filetype")
  {
    filetype=as.character(value)
  }
  if(argCase=="output")
  {
    output=as.character(value)
  }
  
}


inputs<-gsub(pattern = " ",replacement = "",strsplit(x = inputs,split = ",",fixed=T)[[1]],fixed=T)
realNamesTMP<-gsub(pattern = " ",replacement = "",strsplit(x = realNames,split = ",",fixed=T)[[1]],fixed=T)
inputs<-inputs[inputs!=""]
realNamesTMP<-realNamesTMP[realNamesTMP!=""]
if(cleanFileName)
  realNamesTMP<-gsub(pattern = "Galaxy.*-\\[|\\].*",replacement = "",x = realNamesTMP)

##### if it is a zip file
if(filetype=="zip")
{

dir.create("metfragTMPRes", showWarnings = FALSE)
unzip(inputs,exdir = "metfragTMPRes", junkpaths = T)
files<-list.files("metfragTMPRes",full.names = TRUE)
inputs<-files
realNamesTMP<-files

}

inputs<-inputs[inputs!=""]
realNamesTMP<-realNamesTMP[realNamesTMP!=""]



allMS2IDs<-c()
for(i in 1:length(inputs))
{
  # check if the file is empty
  info = file.info(inputs[i])
  if(info$size!=0 & !is.na(info$size))
  {
    tmpFile<-read.csv(inputs[i])
    if(nrow(tmpFile)>0)
      {
    # Extract mz and rt from the real file names
    rt<-as.numeric(strsplit(x = realNamesTMP[i],split = "_",fixed = T)[[1]][2])
    mz<-as.numeric(strsplit(x = realNamesTMP[i],split = "_",fixed = T)[[1]][3])

    allMS2IDs<-rbind(allMS2IDs,data.frame(parentMZ=mz,parentRT=rt,tmpFile))
      }
  }

}


write.table(x = allMS2IDs,file = output,
            row.names = F,quote = F,sep = "\t")



