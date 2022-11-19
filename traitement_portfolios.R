####  Traitement des données de portfolios  ####

## Liste des fichiers

setwd("data/portfolios")

## Premier traitement : enlever espaces inutiles
# Entre chaque cellule, il y a 2 ou 3 espaces inutiles (selon si suivi par un '-')
list_files <- list.files("rawdata")
for(f in list_files){
  data<-readLines(paste0("rawdata/", f))
  #data<-gsub(",", " ", data)
  data<-gsub(",  ", ",", data)
  data<-gsub(", ", ",", data) # on enleve les espaces inutiles entre cellules
  data<-c(paste(1:26, collapse = ","),"\n", data)
  write.table(data,paste0("first_treatment/", f), row.names = F,col.names=F, quote=F)
  # quote = F pour éviter de mettre des guillemets partout!
  #data <- read.csv(paste0("rawdata/", f), sep = ",\t")
}

## Importation et traitement
list_files <- list.files("first_treatment")
for(f in list_files){
  data <- read.csv(paste0("first_treatment/", f), sep=",", header=F)
  index <- which(data[,1]=="")
  i1<-index[[1]]
  i2<-index[[2]]
  data<-data[i1:(i2-2),]
  colnames(data)<-c("date", data[1,-1])
  data<-data[-1,]
  data$date<-as.character(data$date)
  data$date<-paste0(data$date, "01")
  data$date<-as.Date(data$date, format = "%Y%m%d")
  saveRDS(data,paste0("second_treatment/", f, ".rds"))
  View(data)
}
