# Load necessary libraries
library(tidymodels)
library(tidyverse)
library(dplyr)
library(ggplot2)
library(pROC)  
library(yardstick)
library(themis)  

# Read the dataset
blueorred <- read.csv("/Users/rohanchawla/Downloads/blueorred.csv")

# Convert categorical variables
df <- blueorred %>%
  mutate(Vote = as.factor(Vote),
         Married = as.factor(Married),
         HomeOwner = as.factor(HomeOwner),
         Religious = as.factor(Religious),
         Gender = as.factor(Gender))

# Check for missing values
colSums(is.na(df))

# Check class imbalance
df %>% count(Vote)

# Set seed and split data
set.seed(125)
data_split <- initial_split(df, prop = 0.8, strata = Vote)
train_data <- training(data_split)
test_data <- testing(data_split)

# Recipe 
vote_recipe <- recipe(Vote ~ Income + Education + Married, data = train_data) %>%
  step_dummy(all_nominal_predictors(), -all_outcomes()) %>%  # Convert categorical to numeric
  step_smote(Vote) %>%  # Apply SMOTE on the factor target variable
  step_normalize(all_numeric_predictors())  # Normalize numerical predictors

#  K-Fold Cross-Validation
set.seed(125)
cv_folds <- vfold_cv(train_data, v = 10, strata = Vote)  # 10-Fold Cross Validation

# KNN Model
knn_model <- nearest_neighbor(mode = "classification", neighbors = 5) %>%
  set_engine("kknn")

# Workflow
knn_workflow <- workflow() %>%
  add_model(knn_model) %>%
  add_recipe(vote_recipe)

# Model with Cross-Validation
knn_results <- knn_workflow %>%
  fit_resamples(resamples = cv_folds, metrics = metric_set(roc_auc, accuracy, sensitivity, specificity, precision, recall, f_meas))

# Display Metrics
knn_metrics <- collect_metrics(knn_results)
print(knn_metrics)

# Train the Model
knn_fit <- knn_workflow %>% fit(data = train_data)

# Get Predictions from the Trained Model
knn_predictions <- predict(knn_fit, test_data, type = "prob") %>%
  bind_cols(predict(knn_fit, test_data)) %>%  
  bind_cols(test_data)  

knn_predictions <- knn_predictions %>%
  mutate(.pred_class = ifelse(.pred_decided > 0.5, "decided", "undecided")) %>%  
  mutate(.pred_class = as.factor(.pred_class))  # Ensure factor type

#AUC value

auc_value <- roc_auc(knn_predictions, truth = Vote, .pred_decided)
print(auc_value)  # Print AUC score

#  Compute Confusion Matrix 
conf_matrix <- conf_mat(knn_predictions, truth = Vote, estimate = .pred_class)
print(conf_matrix)

# ⃣ Compute ROC Curv
roc_curve_data <- roc(response = knn_predictions$Vote, predictor = knn_predictions$.pred_decided)


roc_df <- data.frame(
  specificity = rev(roc_curve_data$specificities), 
  sensitivity = rev(roc_curve_data$sensitivities)
)

#  Plot the ROC Curve
ggplot(data = roc_df, aes(x = 1 - specificity, y = sensitivity)) +
  geom_line(color = "blue", size = 1) +
  geom_abline(linetype = "dashed", color = "red") +
  labs(title = "ROC Curve for KNN Model",
       x = "1 - Specificity (False Positive Rate)",
       y = "Sensitivity (True Positive Rate)") +
  theme_minimal()

# Boxplot: Vote vs Income
ggplot(df, aes(x = Vote, y = Income, fill = Vote)) +
  geom_boxplot(alpha = 0.7) +
  labs(title = "Boxplot of Income by Voting Decision",
       x = "Voting Decision",
       y = "Income (Dollars)") +
  theme_minimal()
# Boxplot: Vote vs Education
ggplot(df, aes(x = Vote, y = Education, fill = Vote)) +
  geom_boxplot(alpha = 0.7) +
  labs(title = "Boxplot of Education by Voting Decision",
       x = "Voting Decision",
       y = "Years of Education") +
  theme_minimal()

