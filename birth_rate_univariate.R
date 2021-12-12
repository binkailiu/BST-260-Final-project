## ShinyApp for univiariate analysis of birth rate

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
    titlePanel("Exploratory Analysis of Candidate Predictors on Birth Rate"),
    
    # row: interactive scatter plot exploring relationship between predictors and outcomes
    sidebarLayout(
        # left panel: explanatory text and input values
        sidebarPanel(width = 3,
                     p("It is intuitive to speculate that prevalence of contraceptives could affect the overall 
                     effectiveness of family planning, thus reflected in the", strong("birth rate"),
                     "in a country. We also consider other candidate predictors for birth rate, including: 
                     abortion law score (1-6, 6 being the strictest), GDP, education level (average number of 
                     years in school), region, and mean age of childbreaing. Please select from below a 
                     specific predictor to explore its relationship with birth rate (per 1K population):"),
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
                           y = crude_birth_rate_perK,
                           color = region_l)) +
                geom_boxplot() + 
                scale_color_discrete(name = "Region") +
                labs(title = paste0("Relationship between Region and birth rate"),
                     x = NULL, y = "Birth Rate (per 1K)") + 
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
                           y = crude_birth_rate_perK)) +
                geom_point(color = "navy") +
                geom_smooth(method = lm, color = "maroon") +
                scale_x_continuous(limits = case_when(input$predictor == "Contraceptive Prevalence (%)" ~ c(0, 90),
                                                      input$predictor == "Abortion Law Score" ~ c(0, 6),
                                                      input$predictor == "GDP" ~ c(0, 10000), # outliers removed
                                                      input$predictor == "Average Education Level in Years" ~ c(0, 15),
                                                      input$predictor == "Mean Age of Childbearing" ~ c(25, 35))) +
                scale_y_continuous(limits = c(0, 50), breaks = seq(0, 50, 5)) +
                labs(title = paste0("Relationship between ", input$predictor, " and Birth Rate"),
                     x = input$predictor, y = "Birth Rate (per 1K)") + 
                theme_linedraw() +
                theme(plot.title = element_text(hjust = 0.5, size = 20, face = "bold"),
                      axis.title.x = element_text(size = 16, face = "bold"),
                      axis.title.y = element_text(size = 16, face = "bold"))
        }
    )
}

# Run the application 
shinyApp(ui = ui, server = server)