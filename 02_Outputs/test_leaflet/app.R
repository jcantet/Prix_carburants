# Obj : tester leaflet dans shiny et les fonctionnalités possibles

# Packages ====

packages <- c("dplyr","ggplot2","shiny","shinydashboard","leaflet","plotly")

for (package in packages) {
    if (!require(package, character.only = TRUE)) install.packages(package)
    library(package, character.only = TRUE)
}
rm(package,packages)


# Chargement des données 
df <- readRDS(file = "C:/Users/jorda/Documents/exploRation/Prix_carburants/00_Inputs/data_20200403.rds")
df <- df %>% filter(nom == "Gazole")


ui <- dashboardPage(
    dashboardHeader(title = "Basic dashboard"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
            menuItem("Widgets", icon = icon("th"), tabName = "widgets",
                     badgeLabel = "new", badgeColor = "green"))),
    dashboardBody(
        tabItems(
            tabItem(tabName = "dashboard",
                    h2("Carte Leaflet"),
                    fluidRow(
                        checkboxGroupInput("checkbox", label = h3("Radios button"), 
                                           choices = list("Route" = "R", "Autoroute" = "A"),
                                           selected = "R"),
                        leafletOutput("mymap"))))))




server <- function(input, output, session) {
    # Il faut autant de bloc 'observe' que de personnalisation possible via les critères
    
    
    # Reactive expression for the data subsetted to what the user selected
    df_filter <- reactive({
        df %>% filter(type_route %in% input$checkbox)
    })

    
    # Carte de base
    output$mymap <- renderLeaflet({
        # If you want to set your own colors manually:
        pal <- colorFactor(
            palette = c('skyblue', 'orange'),
            domain = df$type_route
        )
        
        leaflet("map") %>%
            setView(lng = 2.2529,lat = 46.4547, zoom = 5) %>% 
            addProviderTiles(providers$CartoDB,
                             options = providerTileOptions(noWrap = TRUE)) %>% 
            addCircleMarkers(data = df_filter(),
                             stroke = TRUE,  # Un trait autour du marqueur ?
                             color = "grey50", # Couleur de la bordure
                             fillColor = ~pal(type_route), # Couleur de remplissage du marqueur
                             fillOpacity = 1,
                             radius = 2, # Taille du cercle
                             weight = 1)
    })
}

shinyApp(ui = ui, server = server)
