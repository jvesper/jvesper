library(shiny)
library(ggplot2)

# Load the data
data("ds_salaries")

# Define UI
ui <- fluidPage(
  
  # Sidebar with selection inputs
  sidebarLayout(
    sidebarPanel(
      selectInput("x_axis", "X Axis",
                  choices = c("experience_level", "job_title")),
      sliderInput("bins", "Number of bins:",
                  min = 5, max = 50, value = 30),
      checkboxInput("density", "Show Density Line", value = FALSE)
    ),
    
    # Output plot
    mainPanel(
      plotOutput("histogram")
    )
  )
)
