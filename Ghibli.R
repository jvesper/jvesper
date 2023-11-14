# Objective
# My goal is to group the characters by their species and then organize 
#information about each species into categories of age, height, special powers, 
#and gender. To clarify further, a "group" in this context I want to gather all 
#the characters of a particular species together so that I can analyze their data
#collectively.The dataset itself contains 56 rows (or entries) and 9 columns of 
#data. Each row represents a single character, and each column contains a 
#specific piece of information about that character (such as their name, species, 
#age, height, etc.). By organizing the data in this way, I may be able to 
#identify patterns or trends that exist within each species.

#Data Overview
#The Ghibli_characters dataset is comprised of 56 rows and 9 columns, 
#with each row representing a unique character. The data is categorized into 
#several columns including name, age (which ranges from 2 to 1302 years old), 
#height (in centimeters), special powers, country, gender, species 
#(which includes various categories such as human, spirit, cat, goddess, 
#wizard, and more), movie title, and release date of the movie.

library(readr)
library(tidyverse)
library(GGally)
Ghibli <- read_csv("Ghibli characters.csv")


head(Ghibli)


# data cleaning
# Load required packages
library(dplyr)

# Read in the dataset
Ghibli <- read.csv("Ghibli characters.csv")

# Remove duplicates in the character name column
Ghibli <- distinct(Ghibli, character.name, .keep_all = TRUE)

# Drop the irrelevant columns
Ghibli <- select(Ghibli, -c(country...place.of.residence, 
                            movie, release.date))

# age and height
library(plotly)

plot_ly(data = Ghibli, x = ~height..cm., y = ~age, text = ~character.name, type = "scatter", mode = "markers",
        marker = list(size = 5, color = "#ff6699")) %>% 
  layout(title = "Age V. Height of Ghibli Characters", 
         xaxis = list(title = "Height (cm)"), 
         yaxis = list(title = "Age"), 
         showlegend = FALSE)


# species and special powers
library(plotly)

# Create a subset of the data with only the columns needed for the plot
bubble_data <- Ghibli %>%
  select(Species, special.powers, height..cm.)

# Group the data by species, special powers and height and count the number of characters in each group
bubble_data <- bubble_data %>%
  group_by(Species, special.powers, height..cm.) %>%
  summarise(count = n())

# Create chart
library(plotly)
fig <- plot_ly(data = Ghibli, x = ~Ghibli$height..cm., 
               y = ~Ghibli$age, type = 'scatter',
               mode = 'markers', symbol = ~Ghibli$Species, 
               symbols = c('circle', 'circle-open', 'x','square', 'square-open', 
                           'diamond', 'diamond-open','cross', 'cross-open', 
                           'triangle-up', 'triangle-up-open', 
                           'hexagon','hexagon-open', 'triangle-nw', 
                           'triangle-nw-open'), 
               col = unique(Ghibli$special.powers),
               marker = list(size = 10)) %>%
  layout(xaxis = list(title="Height (cm)"),
         yaxis = list(title = "Age"),
         legend = 
           list(title=list(text = 
                             "Species (Symbol)<br>Special Powers (Color)")),
         title = list(text = 
                        "Ghibli Characters Age, Height, Species, and Powers"))


#model creation
plot_ly(bubble_data, x = ~special.powers, y = ~height..cm., size = ~count, 
        color = ~Species, colors = "Set1", type = 'scatter',
        mode = 'markers', hoverinfo = 'text',
        text = ~paste("Species: ", Species, "<br>",
                      "Special Power: ", special.powers, "<br>",
                      "Height: ", height..cm., "<br>",
                      "Count: ", count)) %>%
  layout(title = "Comparison of Species and Special Powers by Height",
         xaxis = list(title = "Special Powers"),
         yaxis = list(title = "Height (cm)"),
         showlegend = TRUE,
         height = 800)



