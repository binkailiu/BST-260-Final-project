## ShinyApp for univiariate analysis of HIV prevalence

# load packages
library(shiny)
library(tidyverse)
library(ggplot2)
library(RColorBrewer)

# load data sets
clean <- read_csv("shiny_clean.csv") # the cleaned data set

# Define User Interface
ui <- fluidPage(
    # title
    titlePanel("Exploratory Analysis of Candidate Predictors on HIV Prevalence"),
    
    # row: interactive scatter plot exploring relationship between predictors and outcomes
    sidebarLayout(
        # left panel: explanatory text and input values
        sidebarPanel(width = 3,
                     p("We also consider other candidate predictors for birth rate, including: 
                     abortion law score (1-6, 6 being the strictest), GDP, education level (average number of 
                     years in school), region, and mean age of childbreaing. Please select from below a 
                     specific predictor to explore its relationship with HIV prevalence:"),
                     # Add space between
                     br(),
                     # Drop-down box: select specific contraceptive methods [input$predictor]
                     selectInput(inputId = "predictor", 
                                 label = "Candidate predictors of birth rate", 
                                 choices = as.list(c("Contraceptive Prevalence (%)",
                                                     "Abortion Law Score",
                                                     "GDP",
                                                     "Average Education Level in Years",
                                                     "Region",
                                                     "Mean Age of Childbearing"))),
        ),
        # right panel: interactive scatter plots for predictors [output$univariate]
        mainPanel(
            br(),
            p("The prevalence of contraceptives can affect not only health outcomes related to
            reproduction, by also affect patterns of sexually-transmitted diseases (STDs) in the 
            country. One of the STDs causing great concern is", strong("HIV prevalence"),
              "of a country."),
            br(),
            plotOutput(outputId = "univariate")
        )
    )
)

# Server Function
server <- function(input, output){
    # remove NAs for plotting
    full_region <- reactive(clean %>% filter(!is.na(region_l)))
    
    # right panel: interactive scatter plots for predictors [output$univariate]
    output$univariate <- renderPlot(
        if (input$predictor == "Region") {
            full_region() %>%
                ggplot(aes(x = region_l,
                           y = HIV_prev,
                           color = region_l)) +
                geom_boxplot() + 
                scale_y_log10() +
                scale_color_discrete(name = "Region") +
                labs(title = paste0("Relationship between Region and HIV Prevalence"),
                     x = NULL, y = "HIV Prevalence (%, log-10 scale)") + 
                theme_linedraw() +
                theme(plot.title = element_text(hjust = 0.5, size = 20, face = "bold"),
                      axis.title.y = element_text(size = 16, face = "bold"),
                      axis.text.x = element_text(angle = 60, hjust = 1, size = 12, face = "bold"))
        } else {
            clean %>% 
                ggplot(aes(x = case_when(input$predictor == "Contraceptive Prevalence (%)" ~ any_method,
                                         input$predictor == "Abortion Law Score" ~ score,
                                         input$predictor == "GDP" ~ gdp,
                                         input$predictor == "Average Education Level in Years" ~ years_in_school,
                                         input$predictor == "Mean Age of Childbearing" ~ mean_age_of_childbearing),
                           y = HIV_prev)) +
                geom_point(color = "navy") +
                geom_smooth(method = lm, color = "maroon") +
                scale_x_continuous(limits = case_when(input$predictor == "Contraceptive Prevalence (%)" ~ c(0, 90),
                                                      input$predictor == "Abortion Law Score" ~ c(0, 6),
                                                      input$predictor == "GDP" ~ c(0, 10000), # outliers removed
                                                      input$predictor == "Average Education Level in Years" ~ c(0, 15),
                                                      input$predictor == "Mean Age of Childbearing" ~ c(25, 35))) +
                scale_y_log10(limits = c(1, 30), breaks = seq(0, 35, 5)) +
                labs(title = paste0("Relationship between ", input$predictor, "\n and HIV Prevalence"),
                     x = input$predictor, y = "HIV Prevalence (%, log-10 scale)") + 
                theme_linedraw() +
                theme(plot.title = element_text(hjust = 0.5, size = 20, face = "bold"),
                      axis.title.x = element_text(size = 16, face = "bold"),
                      axis.title.y = element_text(size = 16, face = "bold"))
        }
    )
}

# Run the application 
shinyApp(ui = ui, server = server)