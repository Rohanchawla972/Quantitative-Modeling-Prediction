library(tidyverse)
library(ggplot2)

#Loading the dataset
rohan<-read_csv("/Users/rohanchawla/Downloads/wdi_2020.csv")
head(rohan)
str(rohan)
summary(rohan)

#changing tbe names of the variables for better understanding
library(dplyr)
rohan<- rohan%>%
  rename(
    Country = `Country Name`,        
    Code = `Country Code`,          
    GDP = NY.GDP.MKTP.CD,           
    GDP_per_capita = NY.GDP.PCAP.CD,
    Pop_15_64 = SP.POP.1564.TO.ZS,  
    Pop_0_14 = SP.POP.0014.TO.ZS,   
    Pop_65_plus = SP.POP.65UP.TO.ZS,
    Total_Pop = SP.POP.TOTL,        
    CO2_Emissions = EN.ATM.CO2E.PC, 
    Safe_water_urban= SH.H2O.SMDW.UR.ZS,
    safe_water_rural= SH.H2O.BASW.RU.ZS)

#cleaning the data by removing the missing values
rohan_clean <- rohan %>%
  select(GDP, GDP_per_capita, Total_Pop) %>%
  drop_na()  

#checking the correlation coefficient between the variables
cor(rohan_clean[, c("GDP", "GDP_per_capita", "Total_Pop")], use = "complete.obs")

#Creating the regression model
model<- lm(GDP ~ GDP_per_capita+ Total_Pop, data = rohan_clean)
rohan_clean <- rohan_clean %>%
  mutate(fitted = model$fitted.values, residuals = model$residuals)
summary(model)

predict(model)

b0 <- model$coefficients["(Intercept)"]
b1<- model$coefficients[("GDP_per_capita")]
b2<- model$coefficients[("Total_Pop")]

install.packages("cowplot")
library(cowplot)

#creating scatter plot
library(ggplot2)
library(scales)  

# Create formatted regression equations
eq1 <- paste0("GDP = ", round(b0, 2), " + ", round(b1, 2), " * GDP_per_capita")
eq2 <- paste0("GDP = ", round(b0, 2), " + ", round(b2, 2), " * Total_Pop")

library(ggplot2)
library(scales)  

# Format coefficients into readable values
b0_read <- label_number(scale_cut = cut_short_scale())(b0)
b1_read <- label_number(scale_cut = cut_short_scale())(b1)
b2_read <- label_number(scale_cut = cut_short_scale())(b2)

# Create regression equations
eq1 <- paste0("GDP = ", b0_read, " + ", b1_read, " * GDP_per_capita")
eq2 <- paste0("GDP = ", b0_read, " + ", b2_read, " * Total_Pop")

# Create scatter plot
plot1_Gpd_per_capita <- ggplot(rohan_clean, aes(x= GDP_per_capita, y= GDP))+
  geom_point(color= "blue", alpha=0.6, size=1)+
  geom_abline(intercept = b0, slope = b1, color= "red", linewidth=1 )+
  scale_x_continuous(labels = label_number(scale_cut = cut_short_scale())) + 
  scale_y_continuous(labels = label_number(scale_cut = cut_short_scale())) + 
  labs(title = "GDP per Capita and GDP", x= "GDP per Capita (In thousands)", y= "GDP (In Trillions)")+
  annotate("text", 
           x = max(rohan_clean$GDP_per_capita) * 0.1,  
           y = max(rohan_clean$GDP) * 0.8,  
           label = eq1, 
           color = "black", size = 3.5, hjust = 0) + 
  theme_linedraw()
print(plot1_Gpd_per_capita)

plot2_total_pop <- ggplot(data = rohan_clean, aes(x= Total_Pop, y= GDP))+
  geom_point(color="blue", alpha= 0.6, size=1)+
  geom_abline(intercept = b0, slope = b2, color="red", linewidth=1)+
  scale_x_continuous(labels = label_number(scale_cut = cut_short_scale())) +  
  scale_y_continuous(labels = label_number(scale_cut = cut_short_scale())) + 
  labs(title = "Total Population and GDP", x="Total Population (In Millions)", y="GDP (In Trillions)")+
  annotate("text", 
           x = max(rohan_clean$Total_Pop) * 0.1,  
           y = max(rohan_clean$GDP) * 0.8, 
           label = eq2, 
           color = "black", size = 4, hjust = 0) + 
  theme_linedraw()
print(plot2_total_pop)

cowplot::plot_grid(plot1_Gpd_per_capita,plot2_total_pop)

# Checking for assumptions
#Residual vs fitted value plot
q1 <- ggplot(rohan_clean, aes(x = fitted, y = residuals)) +
  geom_point() +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  scale_x_continuous(labels = scales::label_number(scale_cut = scales::cut_short_scale())) +  
  scale_y_continuous(labels = scales::label_number(scale_cut = scales::cut_short_scale())) +  
  labs(title = "Residual vs. Fitted Values Plot", x = "Fitted Values (In Trillions)", y = "Residuals(In Trillions)") +
  theme_linedraw()

#Checking for normal distribution
q2 <- ggplot(rohan_clean, aes(x = residuals)) +
  geom_histogram(bins = 15, fill = "lightblue", color = "black") +
  scale_x_continuous(labels = scales::label_number(scale_cut = scales::cut_short_scale())) +  
  labs(title = "Histogram of Residuals", x = "Residuals (In Trillions)", y = "Count") +
  theme_linedraw()

#Residuals vs GDP per Capita
q3 <- ggplot(rohan_clean, aes(x = GDP_per_capita, y = residuals)) +
  geom_point() +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  scale_x_continuous(labels = scales::label_number(scale_cut = scales::cut_short_scale())) +  
  scale_y_continuous(labels = scales::label_number(scale_cut = scales::cut_short_scale())) +  
  labs(title = "Residuals vs GDP per Capita", x = "GDP per Capita (In Thousands)", y = "Residuals (In Trillions") +
  theme_linedraw()

#Residual vs total population
q4 <- ggplot(rohan_clean, aes(x = Total_Pop, y = residuals)) +
  geom_point() +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  scale_x_continuous(labels = scales::label_number(scale_cut = scales::cut_short_scale())) +  
  scale_y_continuous(labels = scales::label_number(scale_cut = scales::cut_short_scale())) +  
  labs(title = "Residuals vs Total Population", x = "Total Population ( In Millions)", y = "Residuals(In Trillions") +
  theme_linedraw()

cowplot::plot_grid(q1, q2, q3, q4, nrow = 2)


