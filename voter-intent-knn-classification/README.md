# Voter Intent Prediction with KNN (tidymodels)

## Project Objective  
This project applies **K-Nearest Neighbors (KNN)** classification using the **tidymodels** framework in R to predict whether a voter is **decided** or **undecided**.  
The analysis explores how socio-economic factors such as **income, education, and marital status** influence voting intent and evaluates the model’s performance with proper resampling and diagnostics.

---

## Repository Structure  
- **README.md** — Project overview and documentation  
- **code/knn_vote_classifier.R** — Full R script with preprocessing, modeling, evaluation, and visualizations  
- **report/Voter_Classification_Report.pdf** — Assignment report with results and discussion  
- **data/blueorred.csv** — Dataset used for training and testing  
- **LICENSE** — MIT license  

---

## Dataset  
- **Source**: Provided via BUSINFO 704 Assignment 6 (based on Camm et al., *Business Analytics*, 2023)  
- **Target variable**: `Vote` (*decided* vs *undecided*)  
- **Predictors used**: `Income`, `Education`, `Married`  
- **Preprocessing steps**:  
  - Converted categorical predictors into factors  
  - One-hot encoded categorical predictors (`step_dummy`)  
  - Balanced classes using **SMOTE** (`step_smote`)  
  - Normalized numeric predictors (`step_normalize`)  

---

## Methodology  
1. **Data Splitting**  
   - 80/20 stratified split into train/test sets  
   - 10-fold cross-validation for training  

2. **Model Building**  
   - KNN classifier (`neighbors = 5`, engine = `"kknn"`)  
   - Workflow = recipe + model  

3. **Evaluation Metrics**  
   - ROC AUC (primary)  
   - Accuracy, Sensitivity, Specificity  
   - Precision, Recall, F1 Score  

4. **Visualizations**  
   - ROC Curve with AUC  
   - Confusion Matrix heatmap  
   - Boxplots of **Income vs Vote** and **Education vs Vote**  

---

## Results & Insights  
- **Cross-Validation:** Stable ROC AUC and accuracy across folds  
- **Test Performance:**  
  - ROC AUC: strong discrimination between classes  
  - Accuracy: balanced overall performance  
  - Confusion Matrix: highlights trade-off between sensitivity and specificity  
- **Exploratory Findings:**  
  - Higher income and education levels generally correlated with being *decided*  

---

## Tools & Packages  
- **Language:** R  
- **Libraries:** tidymodels, tidyverse, dplyr, ggplot2, yardstick, pROC, themis  
- **Techniques:** KNN classification, SMOTE resampling, cross-validation, model evaluation, visualization  

---

## Key Takeaway  
This project demonstrates how **KNN with tidymodels** can classify voter intent using socio-economic variables.  
While the model performs well overall, sensitivity to undecided voters remains a challenge, suggesting potential improvements through **hyperparameter tuning** or **alternative classifiers** (e.g., logistic regression, decision trees).

