# Packages ====

packages <- c("dplyr","ggplot2","tidyr","xml2")

for (package in packages) {
  if (!require(package, character.only = TRUE)) install.packages(package)
  library(package, character.only = TRUE)
}
rm(package,packages)



# Extraction des données

  # A compléter plus tard




# Mise en forme des données
  # Traitement du fichier XML source en dataframe
  Prix_20200403 <- read_xml("00_Inputs/PrixCarburants_quotidien_20200403.xml")
  Prix_list <- as_list(Prix_20200403)
  Prix_df <- data.frame(Reduce(rbind, Prix_R))
  rm(Prix_R)
  