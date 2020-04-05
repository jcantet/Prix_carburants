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
  prix_20200403 <- read_xml("00_Inputs/PrixCarburants_quotidien_20200403.xml")
  prix_list <- as_list(prix_20200403)
  prix_df <- as_tibble(prix_list)
  prix_df_clean <- unnest_wider(prix_df,col = "pdv_liste")
  
  # Matrice avec des listes imbriquées, mais impossible d'aller plus loin pour en faire un dataframe...
  prix_df_clean2 <- do.call(rbind,prix_list)
  
  
  # 2e essai : utilisation du package xml2
  name <- xml_name(prix_20200403)
  child <- xml_child(prix_20200403)
  children <- xml_children(prix_20200403)
  text <- xml_text(prix_20200403) # Pas bon
  all <- xml_find_all("/adresse/*") # Ne fonctionne pas
  