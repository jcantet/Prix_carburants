# Packages ====

packages <- c("dplyr","ggplot2","tidyr","xml2","purrr","repdv_id")

for (package in packages) {
  if (!require(package, character.only = TRUE)) install.packages(package)
  library(package, character.only = TRUE)
}
rm(package,packages)



# Extraction des données

  # A compléter plus tard




# Mise en forme des données
  # # Traitement du fichier XML source en dataframe
  # prix_20200403 <- read_xml("00_Inputs/PrixCarburants_quotidien_20200403.xml")
  # prix_list <- as_list(prix_20200403)
  # prix_df <- as_tibble(prix_list)
  # prix_df_clean <- unnest_wider(prix_df,col = "pdv_liste")
  
  # Matrice avec des listes imbriquées, mais impossible d'aller plus loin pour en faire un dataframe...
  prix_20200403 <- read_xml("00_Inputs/PrixCarburants_quotidien_20200403.xml")
  # prix_list <- as_list(prix_20200403)
  # prix_df_clean2 <- do.call(rbind,prix_list)
  # 
  # for (i in seq(1,10,1)){
  #   print(prix_df_clean2[[1]][i])
  # }
  # 
  # # Id station / nom carburant / prix
  # # Tous les libellés des catégories avec les enfants, et les enfants des enfants
  # test <- as_tibble(xml_name(xml_children(xml_children(xml_children(prix_20200403)))))
  # # On a une valeur uniquement si on a un attribut et pas un noeud
  # valeur <- as_tibble(xml_text(xml_children(xml_children(xml_children(prix_20200403)))))
  # data <- as.data.frame(c(test,valeur))
  # 
  # 
  # # On refait la même chose à un autre niveau
  # test2 <- as_tibble(xml_name(xml_children(xml_children(prix_20200403))))
  # # On a une valeur uniquement si on a un attribut et pas un noeud
  # valeur2 <- (as_tibble(xml_text(xml_children(xml_children(prix_20200403)))))
  # data2 <- as.data.frame(c(test2,valeur2))
  # 
  # # On refait à un autre niveau encore
  # test3 <- as_tibble(xml_name(xml_children((prix_20200403))))
  # # On a une valeur uniquement si on a un attribut et pas un noeud
  # valeur3 <- (as_tibble(xml_text(xml_children(prix_20200403))))
  # data3 <- as.data.frame(c(test3,valeur3))  
  

  # Il faut faire un dataset avec toutes ses informations =====
  # On a les infos sur les prix
  prix1 <- xml_find_all(prix_20200403, "//prix" )
  prix2 <- xml_attrs(prix1)
  prix3 <- as_tibble(do.call(rbind,prix2))
  head(prix3)
  
  
  # Infos sur les PDV : pdv_adresse
  adr1 <- xml_find_all(prix_20200403, "//adresse")
  adr2 <- xml_text(adr1)
  adr3 <- as_tibble(adr2)
  
  # Infos sur les PDV : ville
  ville1 <- xml_find_all(prix_20200403, "//ville")
  ville2 <- xml_text(ville1)
  ville3 <- as_tibble(ville2)
  
  
  # Infos sur les PDV : loc gps
  pdv1 <- xml_find_all(prix_20200403, "//pdv" )
  pdv2 <- xml_attrs(pdv1)
  pdv3 <- as_tibble(do.call(rbind,pdv2))
  head(pdv3)
  


  