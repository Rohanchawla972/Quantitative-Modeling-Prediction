library(ggplot2)
library(tidyverse)
library(yardstick)

# Read the CSV file containing the salmon data
salmon_data <- read.csv("/Users/rohanchawla/Documents/salmons.csv")

head(salmon_data)

str(salmon_data)

summary(salmon_data)

# Convert the 'Coupon' column to a factor with specified levels
salmon_data$Coupon <- factor(salmon_data$Coupon, levels = c("No", "Yes"))

# Display the frequency of each category in 'Coupon'
table(salmon_data$Coupon)

# Check for missing values in the dataset
colSums(is.na(salmon_data))

# Visualize spending distribution based on coupon usage
ggplot(salmon_data, aes(x = Coupon, y = Spending)) +
  geom_boxplot(fill = "skyblue", color = "black") +
  labs(x = "Coupon (No/Yes)", y = "Spending", title = "Comparison of Spending by Coupon Usage") +
  theme_linedraw()

# Set "No" as the reference level for 'Coupon'
salmon_data$Coupon <- relevel(salmon_data$Coupon, ref = "No")

# Fit a logistic regression model to predict coupon usage based on spending
coupon_model <- glm(Coupon ~ Spending, data = salmon_data, family = binomial)

# Display the summary of the logistic regression model
summary(coupon_model)

# Predict probabilities for coupon usage
salmon_data$pred_prob <- predict(coupon_model, type = "response")

# Compute ROC curve
roc_data <- tibble(
  truth = salmon_data$Coupon,  
  pred_prob = salmon_data$pred_prob 
)

# Plot ROC curve
roc_data %>%
  roc_curve(truth, pred_prob, event_level = "second") %>%
  autoplot() +
  theme_minimal() +  # Clean theme
  labs(title = "ROC Curve for Logistic Regression Model",
       x = "1 - Specificity (False Positive Rate)",
       y = "Sensitivity (True Positive Rate)") +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 16),  # Bold & larger title
    axis.title = element_text(face = "bold", size = 14),  # Bold & larger axis labels
    axis.text = element_text(size = 12),  # Larger axis text
    panel.border = element_rect(color = "black", fill = NA, linewidth = 1)  
  )

# Calculate AUC (Area Under the Curve)
auc_value <- roc_data %>%
  roc_auc(truth, pred_prob, event_level = "second")

# Print AUC value
print(auc_value)

# Extract intercept and slope from logistic regression model
intercept <- coef(coupon_model)[1]  # Intercept 
slope <- coef(coupon_model)[2]  # Coefficient for Spending

# Plot probability curve for coupon usage
ggplot(salmon_data, aes(x = Spending, y = as.numeric(Coupon) - 1)) +  
  stat_smooth(method = "glm", method.args = list(family = binomial), 
              color = "red", size = 1.5, se = FALSE) +  # Bold red curve
  labs(title = "Probability of Coupon Usage vs. Spending",
       x = "Spending ($)",
       y = "Probability of Using Coupon") +
  theme_linedraw() +  
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 18),
        axis.title = element_text(size = 18)) +
  annotate("text", x = max(salmon_data$Spending) * 0.2, 
           y = 0.1, 
           label = paste0("P(Y=1) = 1 / (1 + exp(-(", round(intercept, 2), 
                          " + ", round(slope, 5), " * Spending)))"),
           size = 4, color = "blue", hjust = 0)

# Predict class based on probability threshold of 0.5
salmon_data$pred_class <- ifelse(salmon_data$pred_prob > 0.5, "Yes", "No")

# Convert predicted class to a factor
salmon_data$pred_class <- factor(salmon_data$pred_class, levels = c("No", "Yes")) 

# Generate confusion matrix
conf_matrix <- salmon_data %>%
  conf_mat(truth = Coupon, estimate = pred_class)

# Print summary of the confusion matrix
summary(conf_matrix, event_level = "second") |> print(n = 13)

# Convert confusion matrix to a dataframe for visualization
conf_df <- as.data.frame(conf_matrix$table)
colnames(conf_df) <- c("Actual", "Predicted", "Count")

# Visualize confusion matrix as a heatmap
ggplot(conf_df, aes(x = Predicted, y = Actual, fill = Count)) +
  geom_tile(color = "black") +  # Adds grid lines
  geom_text(aes(label = Count), size = 6, color = "white") +  
  scale_fill_gradient(low = "lightcoral", high = "darkred") + 
  labs(title = "Confusion Matrix Visualization",
       x = "Predicted Label",
       y = "Actual Label") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
        axis.title = element_text(size = 12, face = "bold"), 
        axis.text = element_text(size = 12, face = "bold"), 
        legend.position = "none")
