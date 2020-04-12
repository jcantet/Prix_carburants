# Objectif : application finale
# Etat : squelette repris depuis le tutoriel de shinydashboard
# Préparation et brouillon dans un fichier entrainement
# Exploration dans data_valorisation

# Packages ====

packages <- c("dplyr","ggplot2","shiny","shinydashboard","leaflet","plotly")

for (package in packages) {
    if (!require(package, character.only = TRUE)) install.packages(package)
    library(package, character.only = TRUE)
}
rm(package,packages)






ui <- dashboardPage(
    dashboardHeader(title = "Basic dashboard"),
    dashboardSidebar(
        sidebarMenu(
            sidebarSearchForm(textId = "searchText", buttonId = "searchButton",label = "Search..."),
            menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
            menuItem("Widgets", icon = icon("th"), tabName = "widgets",
                     badgeLabel = "new", badgeColor = "green"),
            menuItem("Source code", icon = icon("file-code-o"), 
                     href = "https://github.com/rstudio/shinydashboard/"))),
    dashboardBody(
        tabItems(
            tabItem(tabName = "dashboard",
                    h2("Carte Leaflet"),
                    
                    fluidRow(
                        leafletOutput("mymap"))),
            tabItem(tabName = "widgets",
                    h2("Widgets tab content"),
        fluidRow(
            tabBox(
                title = "First tabBox",
                # The id lets us use input$tabset1 on the server to find the current tab
                id = "tabset1", height = "250px",
                tabPanel("Tab1", "First tab content"),
                tabPanel("Tab2", "Tab content 2")),
            tabBox(
                side = "right", height = "250px",
                selected = "Tab3",
                tabPanel("Tab1", "Tab content 1"),
                tabPanel("Tab2", "Tab content 2"),
                tabPanel("Tab3", "Note that when side=right, the tab order is reversed."))),
        fluidRow(
            tabBox(
                # Title can include an icon
                title = tagList(shiny::icon("gear"), "tabBox status"),
                tabPanel("Tab1",
                         "Currently selected tab from first box:",
                         verbatimTextOutput("tabset1Selected")),
                tabPanel("Tab2", "Tab content 2"))),
        fluidRow(
            checkboxGroupInput("checkGroup", label = h3("Checkbox group"), 
                               choices = list("Choice 1" = 1, "Choice 2" = 2, "Choice 3" = 3),
                               selected = 1)),
        hr(),
        fluidRow(column(3, verbatimTextOutput("value"))),
        fluidRow(
            # Dynamic infoBoxes
            infoBoxOutput("approvalBox"),
        # infoBoxes with fill=TRUE
            infoBox("New Orders", 10 * 2, icon = icon("credit-card"), fill = TRUE),
            infoBoxOutput("approvalBox2")),
        fluidRow(
            # A static valueBox
            valueBox(10 * 2, "New Orders", icon = icon("credit-card")),
            # Dynamic valueBoxes
            valueBoxOutput("approvalBox3"))))))

server = function(input, output) {
    
    # You can access the values of the widget (as a vector)
    # with input$checkGroup, e.g.
    output$value <- renderPrint({ input$checkGroup })
    

    # The currently selected tab from the first box
    output$tabset1Selected <- renderText({
        input$tabset1
    })
    output$progressBox <- renderInfoBox({
        infoBox(
            "Progress", paste0(25 + input$count, "%"), icon = icon("list"),
            color = "purple"
        )
    })
    output$approvalBox <- renderInfoBox({
        infoBox(
            "Approval", "80%", icon = icon("thumbs-up", lib = "glyphicon"),
            color = "yellow"
        )
    })
    output$approvalBox2 <- renderInfoBox({
        infoBox(
            "Approval", "80%", icon = icon("thumbs-up", lib = "glyphicon"),
            color = "yellow", fill = TRUE
        )
    })
    
    output$approvalBox3 <- renderValueBox({
        valueBox(
            "80%", "Approval", icon = icon("thumbs-up", lib = "glyphicon"),
            color = "yellow"
        )
    })
}


# Run the application 
shinyApp(ui = ui, server = server)
