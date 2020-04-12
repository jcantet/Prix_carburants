# OBj : préparer le code à insérer dans l'appli Shiny

# Packages ====

packages <- c("dplyr","ggplot2","plotly","forcats", "stringr", "leaflet")

for (package in packages) {
  if (!require(package, character.only = TRUE)) install.packages(package)
  library(package, character.only = TRUE)
}
rm(package,packages)

df <- readRDS(file = "00_Inputs/data_20200403.rds")


# Différence de prix entre route et autouroute pour les différents carburants
ggplot(data = df %>% 
         filter(type_route != "N" & nom != "NA"),
       aes(x=fct_reorder(.f = nom,.x = valeur,.fun=median, na.rm = TRUE),y=valeur, color = nom))+
  geom_boxplot()+
  facet_grid(~type_route) +
  labs(title = "Prix observé le 3 avril 2020 en France")

# Top5 des départements avec le prix du gazole le plus élevé / même chose avec le prix le plus faible en moyenne, hors autoroute
df %>% 
  mutate(dep = str_sub(string = cp, start = 1,end = 2)) %>% 
  filter(nom == "Gazole" & value == "prix" & type_route == "R") %>% 
  group_by(dep) %>% 
  summarize(prix_moyen = mean(valeur)) %>% 
  arrange(desc(prix_moyen)) %>% 
  top_n(5)


# prix du gazole le moins chez du 49
liste_maine_et_loire<- 
  df %>% 
  mutate(dep = str_sub(string = cp, start = 1,end = 2)) %>% 
  filter(nom == "Gazole" & value == "prix" & type_route == "R" & dep == "49")


# Carte des prix du gazole dans le Maine et Loire
pal <- colorNumeric(palette = "Reds", domain = c(min(data_carte$valeur),max(data_carte$valeur)))

# Sélection d'un ou plusieurs carburants : les étiquettes affichent tous les prix, 
# mais seuls les marqueurs avec au moins un des carburants cochés apparaissent.
# Pareil avec routes/autoroutes
data_carte <- df %>% 
  filter(nom %in% "Gazole" & type_route %in% "type_route")

leaflet() %>% 
  addProviderTiles("CartoDB") %>%
  addCircleMarkers(
    data = data_carte,
    stroke = TRUE,  # Un trait autour du marqueur ?
    color = "grey50", # Couleur de la bordure
    fillColor = ~pal(valeur), # Couleur de remplissage du marqueur
    fillOpacity = 1,
    radius = 4, # Taille du cercle
    weight = 1, # largeur de la bordure du marqueur
    # Informations affichées lorsqu'on clique sur le marqueur
    popup = ~ paste0(
      "Ville : ",
      ville,
      "<br/>",
      "Adresse : ",
      adresse,
      "<br/>",
      paste0("Prix du ", nom, " : "),
      valeur
    )) %>% 
  addLegend(data = data_carte, position = "bottomright", pal = pal, values = ~data_carte$valeur,
            title = "Prix du Gazole dans le Maine et Loire",
            opacity = 1)

# Objectif : carte des points de vente pour un code postal donné (?), choix du carburant (plusieurs possibles), routes et/ou autoroutes,
# classement dans le département en termes de prix


# Dans les box : afficher le nom de la station la moins chère avec le prix. Le prix moyen dans la zone.
# 1 onglet sur le dernier jour dispo, 1 onglet sur le passé, avec évoution au cours du temps
# 1 onglet avec données sur la France entière par département, ou alors 2d density pour voir les variations de prix par zone plus fine
# que le département

