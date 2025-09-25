# Logistic Regression on Salmon Dataset — Coupon Usage Prediction

## Project Objective
The goal of this project is to apply **logistic regression** to consumer spending data to predict the likelihood of **coupon usage**.  
Using the `salmons.csv` dataset (from Camm et al., 2023), the project explores whether **spending** significantly influences coupon adoption, evaluates model performance, and visualizes predictive results.

---

## Repository Structure
- **README.md** — Project overview, methodology, and results  
- **Coupon_Usage_Logistic_Regression.R** — Full R script for analysis, model, and plots  
- **Assignment_Report.pdf** — 3-page write-up with findings, tables, and visuals  
- **Assignment_Brief.pdf** — Task instructions  
- **data/salmons.csv** — Dataset used  
- **LICENSE** — MIT  

---

## Dataset
- **Source**: *Business Analytics* (Camm et al., 2023), Salmon dataset  
- **Binary variable**: `Coupon` (Yes/No)  
- **Continuous predictor**: `Spending` (total consumer spending in $)  
- **Size**: ~1000 records  
- **Cleaning**: Converted categorical values, set reference level, checked for missing values (none).  

---

## Methodology
1. **Exploration**  
   - Frequency counts of coupon usage  
   - Boxplot of Spending by Coupon groups  

2. **Logistic Regression**  
   - Model: `Coupon ~ Spending`  
   - Interpretation: Each $1 increase in spending increases log-odds of coupon use by 0.00095 (~0.095%).  
   - Both intercept and slope statistically significant (p < 0.001).  

3. **Evaluation & Diagnostics**  
   - ROC curve plotted; AUC ≈ 0.881.  
   - Confusion matrix built; model metrics computed.  
   - Probability (sigmoid) curve visualized.  

---

## Results and Insights
- **Spending vs Coupon Usage**: Coupon users spend more on average than non-users.  
- **Model Significance**: Logistic regression confirmed spending is a statistically significant predictor (p < 0.001).  
- **Performance Metrics**:  
  - Accuracy: ~87%  
  - Sensitivity (Recall): ~46% (weaker at detecting coupon users)  
  - Specificity: ~95.9% (strong at detecting non-users)  
  - Precision: ~70.7%  
  - AUC: 0.881 (strong classifier overall)  

- **Takeaway**: The model reliably distinguishes coupon users from non-users, particularly effective at identifying non-users. However, moderate sensitivity shows it misses some true coupon users, suggesting opportunities to improve by incorporating more predictors.

---

## Tools & Packages
- **Language**: R  
- **Libraries**: tidyverse, ggplot2, yardstick, cowplot  
- **Techniques**: Logistic regression, ROC curve analysis, confusion matrix, model diagnostics, data visualization  

---

## Key Outcome
This project demonstrates how logistic regression can be applied to consumer behavior datasets to extract **actionable insights** on promotional effectiveness.  
It shows that **higher spending is positively associated with coupon usage**, and highlights the trade-offs between accuracy, specificity, and sensitivity in binary classification.

