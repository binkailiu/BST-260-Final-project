## ShinyApp for exploratory analysis of contraceptive prevalence

# load packages
library(shiny)
library(tidyverse)
library(ggplot2)
library(RColorBrewer)

# load data sets
clean <- read_csv("shiny_clean.csv") # the cleaned data set

# Define User Interface
ui <- fluidPage(
    titlePanel("Exploratory Analysis of Contraceptive and Other Predictors on Health-related Outcomes"), # title
    
    # First row: static world map of contraceptive prevalence
    fluidRow(
        sidebarLayout(
            # First left panel: explanatory text
            sidebarPanel(width = 3,
                         # Add text and hyperlinks 
                         p("There is still much imbalance in the availability of contraceptive around the world
                  according to the",
                           # hyperlink for the contraceptive data source
                           a("World Contraceptive Use",
                             href="https://www.un.org/development/desa/pd/data/world-contraceptive-use"),
                           "survey. The survey collects information on contraceptive use from the 1950s to January
                  2021, with varying data availability across counties. The figure to the right shows the
                  prevalence of using any contraceptive methods, plotted with the most recent data since 
                  the 21st century.")
            ),
            # First left panel: static map for prevalence [output$prevalence]
            mainPanel(
                plotOutput(outputId = "prevalence")
            )
        )
    ),
    
    # Second row: static world map of modern/traditional contraceptive proportion
    fluidRow(
        sidebarLayout(
            # Second left panel: explanatory text
            sidebarPanel(width = 3,
                         p("On a country level, the success of family planning programs not only depends on the overall
                  level of contraceptive, but also depends on whether modern or traditional contraceptive
                  methods are most commonly used. The figure to the right shows the proportion of modern 
                  contraceptive methods used by people in the country, plotted with the most recent data 
                  since the 21st century. The more green (or red) a country appear, the higher the proportion 
                  of people in the country use modern (or traditional) methods for birth control.")
            ),
            # Second right panel: static map for modern method [output$modern]
            mainPanel(
                plotOutput(outputId = "modern")
            )
        )
    ),
    
    # Third row: interactive world map of specific contraceptive methods proportion
    fluidRow(
        sidebarLayout(
            # Third left panel: explanatory text and input values
            sidebarPanel(width = 3,
                         p("The use of different contraceptive methods could also affect the success of birth ontrol 
                  and prevention of sexually transmitted diseases. Many aspects affect the popularity of
                  contraceptive methods, including the country's economic level, culture and religion. The 
                  figure to the right shows the proportion of different contraceptive methods, plotted with 
                  the most recent data since the 21st century. The table below shows the five categories of
                  contraceptive methods. Please select from below specific method to explore:"),
                         # Add space between
                         br(),
                         # Drop-down box: select specific contraceptive methods [input$method]
                         selectInput(inputId = "method", 
                                     label = "Categories of contraceptive methods", 
                                     choices = as.list(c("Invasive",
                                                         "Medication",
                                                         "Barrier",
                                                         "Other Modern",
                                                         "Traditional")))
            ),
            # Third right panel: interactive map for specific method [output$proportion]
            mainPanel(
                # Third left panel: categories of contraceptive methods [output$category]
                tableOutput("category"), 
                # Add space between
                br(),
                plotOutput(outputId = "proportion")
            )
        )
    )
) # END UI

# Server Function
server <- function(input, output){
    # First left panel: static map for prevalence [output$prevalence]
    output$prevalence <- renderPlot(
        clean %>% 
            ggplot(aes(x = long, y = lat, group = group)) +
            geom_polygon(aes(fill = any_method), color = "grey2") + 
            scale_fill_gradientn(name = "Prevalence (%)", 
                                 colors = brewer.pal(6, "Greens"),
                                 na.value = "white") +
            labs(title = "Most Recent Contraceptive Prevalence after 2000") + 
            theme(panel.grid.major = element_blank(), 
                  panel.background = element_blank(),
                  axis.title = element_blank(), 
                  axis.text = element_blank(),
                  axis.ticks = element_blank(), 
                  plot.title = element_text(hjust = 0.5, size = 20, face = "bold")) +
            coord_fixed(1.3)
    )
    
    # Second right panel: static map for modern method [output$modern]
    output$modern <- renderPlot(
        clean %>% 
            ggplot(aes(x = long, y = lat, group = group)) +
            geom_polygon(aes(fill = prop_modern), color = "grey2") + 
            scale_fill_gradientn(name = "Prevalence (%)", 
                                 colors = brewer.pal(6, "RdYlGn"), 
                                 na.value = "white") +
            labs(title = "Most Recent Proportion of Modern Contraceptives after 2000") + 
            theme(panel.grid.major = element_blank(), 
                  panel.background = element_blank(),
                  axis.title = element_blank(), 
                  axis.text = element_blank(),
                  axis.ticks = element_blank(), 
                  plot.title = element_text(hjust = 0.5, size = 20, face = "bold")) +
            coord_fixed(1.3)
    )
    
    # Third left panel: categories of contraceptive methods [output$category]
    output$category <- renderTable(
        data.frame(Categories = c("Invasive", "Medication", "Barrier", "Other Modern", "Traditional"),
                   Methods = c("female sterilization, male sterilization, iud, implant",
                               "injectable, pill",
                               "male condom, female condom, vaginal barrier methods",
                               "lactational amenorrhea method, emergency contraception, other modern methods",
                               "rhythm, withdrawal, other traditional methods")
        ), width = "100%"
    )
    
    # Third right panel: interactive map for specific method [output$proportion]
    output$proportion <- renderPlot(
        clean %>% 
            ggplot(aes(x = long, y = lat, group = group)) +
            geom_polygon(aes(fill = case_when(input$method == "Invasive" ~ prop_invasive,
                                              input$method == "Medication" ~ prop_medication,
                                              input$method == "Barrier" ~ prop_barrier,
                                              input$method == "Other Modern" ~ prop_otherM,
                                              input$method == "Traditional" ~ prop_traditional)),
                         color = "grey2") + 
            scale_fill_gradientn(name = "Prevalence (%)", 
                                 colors = brewer.pal(6, "Oranges"), 
                                 na.value = "white") +
            labs(title = paste0("Most Recent Proportion of ", input$method, " Contraceptive after 2000")) + 
            theme(panel.grid.major = element_blank(), 
                  panel.background = element_blank(),
                  axis.title = element_blank(), 
                  axis.text = element_blank(),
                  axis.ticks = element_blank(), 
                  plot.title = element_text(hjust = 0.5, size = 20, face = "bold")) +
            coord_fixed(1.3)
    )
} # END server

# Run the application 
shinyApp(ui = ui, server = server)