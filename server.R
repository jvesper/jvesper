# Define server
server <- function(input, output) {
  
  # Generate the histogram plot based on user input
  output$histogram <- renderPlot({
    # Select the data to plot
    if (input$x_axis == "experience_level") {
      data_to_plot <- ds_salaries %>% 
        group_by(experience_level) %>% 
        summarize(avg_salary = mean(salary_in_usd, na.rm = TRUE))
      x_label <- "Experience Level"
    } else {
      data_to_plot <- ds_salaries %>% 
        group_by(job_title) %>% 
        summarize(avg_salary = mean(salary_in_usd, na.rm = TRUE))
      x_label <- "Job Title"
    }
    
    # Create the histogram
    if (input$density) {
      ggplot(data_to_plot, aes(x = avg_salary, y = ..count..)) + 
        geom_histogram(binwidth = (max(data_to_plot$avg_salary) - min(data_to_plot$avg_salary)) / input$bins, aes(fill = ..count..)) +
        geom_density(alpha = 0.2, fill = "black") +
        labs(title = "Salary Distribution", x = "Salary in USD", y = "Count", fill = "Number of Jobs") +
        theme_minimal()
    } else {
      ggplot(data_to_plot, aes(x = avg_salary)) + 
        geom_histogram(binwidth = (max(data_to_plot$avg_salary) - min(data_to_plot$avg_salary)) / input$bins, aes(fill = ..count..)) +
        labs(title = "Salary Distribution", x = "Salary in USD", y = "Count", fill = "Number of Jobs") +
        theme_minimal()
    }
  })
  
}

# Run the app
shinyApp(ui = ui, server = server)