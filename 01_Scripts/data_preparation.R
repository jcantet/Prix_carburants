# Packages ====

packages <- c("dplyr","ggplot2","tidyr","xml2","purrr")

for (package in packages) {
  if (!require(package, character.only = TRUE)) install.packages(package)
  library(package, character.only = TRUE)
}
rm(package,packages)



# Extraction des données

  # A compléter plus tard




# Importation des données
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

  # Infos sur les PDV : pdv_adresse
  adr1 <- xml_find_all(prix_20200403, "//adresse")
  adr2 <- xml_text(adr1)
  adr3 <- as_tibble(adr2)
  rm(adr1,adr2)
  
  # Infos sur les PDV : ville
  ville1 <- xml_find_all(prix_20200403, "//ville")
  ville2 <- xml_text(ville1)
  ville3 <- as_tibble(ville2)
  rm(ville1,ville2)
  
  # Infos sur les PDV : loc gps
  pdv1 <- xml_find_all(prix_20200403, "//pdv")
  pdv2 <- xml_attrs(pdv1)
  pdv3 <- as_tibble(do.call(rbind,pdv2))
  rm(pdv1,pdv2)
  head(pdv3)
  
  # On a les infos sur les prix
  prix1 <- xml_find_all(prix_20200403, "//prix")
  prix2 <- xml_attrs(prix1)
  prix3 <- as_tibble(do.call(rbind,prix2))
  head(prix3)
  rm(prix1,prix2)
  
  
  # Problème : il faut l'identifiant du point de vente pour chaque prix, sinon on ne peut pas faire le lien
    # Tentative 1 : on compte les pdv à partir de l'identifiant du carburant : pour avoir une approximation
  prix3$id <- as.numeric(prix3$id)
    for (i in 1:nrow(prix3)){
      prix3[i,5] <- ifelse(prix3[i,2] <= prix3[i+1,2],1,0)
    }
  # Environ 9722 points de ventes avec des prix --> tous les points de vente ne proposent pas ce jour des carburants
  prix3 %>% filter(!is.na(`...5`) & `...5` == 0) %>% count()

  
    # Tentative 2
  pdv_prix1 <- xml_find_all(prix_20200403, "//prix" )
  pdv_prix2 <- xml_attrs(xml_parent(pdv_prix1)) 
  # On ne peut toujours pas faire le lien entre les 2

  # Tentative 3 : début de solution
  # Fonctionne presque : lorsque la station est fermée, la structure du noeud n'est plus la même, impossible alors d'empiler les DF
  point1 <- xml_find_all(prix_20200403, "//pdv")
  longueur <- xml_length(xml_root(point1))
  df <- tibble()
  for (i in seq(1,42,1)){
    # Extraction des valeurs de tous les attributs
    temp <- point1[[i]] %>% xml_children() %>% xml_attrs()
    # Cpnversion en dataframe
    temp <- as_tibble(do.call(rbind,temp))
    # Extaction le nom des attributs/noeuds
    name <- point1[[i]] %>% xml_children() %>% xml_name() %>% as_tibble %>% filter(value %in% c("horaires","prix","rupture"))
    # Agrégation les valeurs et les boms
    temp <- cbind(name,temp)
    # Ajout de l'id dans le DF
    temp$id <- as.numeric(i)
    # Ajout du résultat de l'itétation au DF des résultats globaux
    df <- bind_rows(df,temp)
    }
  
  
  
  # autre possibilité à creuser avec la fonction xml_contents ?
  test <- xml_contents(prix_20200403)
  test2 <- xml_attrs(test)
  test2 <- as_tibble(do.call(rbind,test))
  