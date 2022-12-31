####  Traitement des données de portfolios  ####

## Liste des fichiers
library(dplyr)

setwd("data/portfolios")

## Premier traitement : enlever espaces inutiles
# Entre chaque cellule, il y a 2 ou 3 espaces inutiles (selon si suivi par un '-')
list_files <- list.files("rawdata")
for(f in list_files){
  data<-readLines(paste0("rawdata/", f))
  data<-gsub(",  ", ",", data)
  data<-gsub(", ", ",", data) # on enleve les espaces inutiles entre cellules
  data<-c(paste(1:40, collapse = ","),"\n", data) # on a au maximum 30 portfolios

  write.table(data,paste0("first_treatment/", f), row.names = F,col.names=F, quote=F)
  # quote = F pour éviter de mettre des guillemets partout!
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

  #on laisse tomber les colonnes NA
  data<-data[,colnames(data)!="NA"]

  data<-data[-1,]
  data$date<-as.character(data$date)
  data$date<-paste0(data$date, "01")
  data$date<-as.Date(data$date, format = "%Y%m%d")
  # on enleve ".csv" du nom
  f<-gsub(".csv", "", f)
  f<-gsub(".CSV", "", f)
  saveRDS(data,paste0("second_treatment/", f, ".rds"))

}

####  Traitement des données de portfolios  ####

## Liste des fichiers
library(dplyr)

setwd("data/portfolios")

## Premier traitement : enlever espaces inutiles
# Entre chaque cellule, il y a 2 ou 3 espaces inutiles (selon si suivi par un '-')
list_files <- list.files("rawdata")
for(f in list_files){
  data<-readLines(paste0("rawdata/", f))
  data<-gsub(",  ", ",", data)
  data<-gsub(", ", ",", data) # on enleve les espaces inutiles entre cellules
  data<-c(paste(1:31, collapse = ","),"\n", data) # on a au maximum 30 portfolios

  write.table(data,paste0("first_treatment/", f), row.names = F,col.names=F, quote=F)
  # quote = F pour éviter de mettre des guillemets partout!
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

  #on laisse tomber les colonnes NA
  data<-data[,colnames(data)!="NA"]

  data<-data[-1,]
  data$date<-as.character(data$date)
  data$date<-paste0(data$date, "01")
  data$date<-as.Date(data$date, format = "%Y%m%d")
  # on enleve ".csv" du nom
  f<-gsub(".csv", "", f)
  f<-gsub(".CSV", "", f)
  saveRDS(data,paste0("second_treatment/", f, ".rds"))

}
# ensuite on copie tout à la main dans le dossier "portfolios_treated"

############### regrouper les portfolios sur un même fichier
list_files <- list.files("data/portfolios/second_treatment")
portfolios <- vector(, length = 711)
for(f in list_files){
  tmp <- readRDS(paste0("data/portfolios/second_treatment/", f))
  print(ncol(tmp))
  # portfolios à 20 colonnes doivent être réduits à 10
  if(ncol(tmp)==20){
    tmp<-dplyr::select(tmp, c(1,11:20))
  }
  tmp <- dplyr::select(filter(tmp,date>='1963-07-01'),-1) # on enlève la colonne 'date'
  portfolios <- cbind(portfolios, tmp)
  
}
# dates :
tmp <- readRDS(paste0("data/portfolios/second_treatment/", f))
dates <- dplyr::select(filter(tmp,date>='1963-07-01'),1)

portfolios<-portfolios[,-1]
portfolios<-cbind(dates, portfolios)

saveRDS(portfolios, "data/portfolios.RDS")

# les fichiers censés avoir 10 portfolios en ont en réalité 19         