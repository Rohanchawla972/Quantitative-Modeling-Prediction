# Ted & Poppy Churn Analysis — Predicting Subscription Retention

## Project Objective
Ted & Poppy, a small family-owned pet shop, recently launched a **dog food subscription service**. They observed a rising **churn rate** and needed to understand **why customers were leaving** and **how to improve retention**.  
This project applies advanced analytics and machine learning to:
- Diagnose **key drivers of churn and retention**,
- Evaluate multiple predictive models, and
- Provide **actionable, business-ready recommendations** for reducing churn.

---

## Repository Structure
- **README.md** — Project overview and documentation  
- **data/**
  - `tedpoppydata_final.csv` — Main dataset with subscription, demographic, and behavioral features  
  - `ted_and_poppy_metadata_final.csv` — Metadata (data dictionary with feature descriptions)  
- **code/**
  - `704_Group_Project_Group29.qmd` — Full R/Quarto analysis (EDA → modeling → evaluation → outputs)  
- **report/**
  - `704_Group_Project_Group29.pdf` — A2 poster summarizing business problem, analysis, and recommendations  
- **outputs/**
  - Figures and tables exported for the poster and report  
- **LICENSE** — MIT license  

---

## Dataset Overview
- **Source**: Provided as part of BUSINFO 704 (University of Auckland).  
- **Rows**: ~200,000 (sampled for analysis)  
- **Target variable**: `retained_binary` (factor: *Churned* vs *Retained*)  
- **Feature types**:
  - **Demographic**: gender, location, dog stage (puppy/adult/senior)  
  - **Behavioral**: purchase counts, spending, days since last purchase, subscription frequency  
  - **Engagement**: community activity, survey responses, support tickets, email interaction  
  - **Operational**: subscription type, discounts, payment method  
- **Metadata file** (`ted_and_poppy_metadata_final.csv`) documents variable names, types, and descriptions.

---

## Methodology

### Data Preparation
- Cleaned and recoded categorical variables (`TRUE/FALSE` flags, survey responses, device/browser usage).  
- Converted numeric fields (e.g., days since last purchase).  
- Standardized target variable: **0 = Churned, 1 = Retained**.  
- Preprocessing pipeline:
  - Handle missing values (`step_naomit`)  
  - Normalize numeric predictors (`step_normalize`)  
  - One-hot encode categoricals (`step_dummy`)  
  - Remove zero-variance predictors (`step_zv`)  

### Exploratory Analysis
- **Numeric features**: tested differences between churn groups (t-tests, Levene’s variance tests).  
- **Categorical features**: chi-square tests of association with churn.  
- **Descriptive summaries**: retention rates by subscription, discounts, dog stage, and activity.

### Modeling Approach
- **Train/test split**: 75% / 25%, stratified by churn.  
- **Cross-validation**: 10-fold stratified CV.  
- **Models compared**:
  - Logistic Regression (baseline, explainable)  
  - K-Nearest Neighbours  
  - Random Forest (ranger)  
  - XGBoost  
  - LightGBM  
  - Neural Network (MLP)  
- **Evaluation metrics**:
  - ROC AUC (primary)  
  - Accuracy, Balanced Accuracy  
  - Sensitivity, Specificity  
  - Precision, Recall, F1  

### Model Finalization
- LightGBM was selected as the **final model** based on highest ROC AUC and balanced performance.  
- Final evaluation performed on the **test set**.  
- Variable importance (VIP) extracted for interpretability.

---

## Results & Insights

### Key Findings
- **Churn patterns**: Higher churn associated with infrequent purchases, lower engagement, and short tenure.  
- **Discounts**: Deep initial discounts were linked to **higher early churn** (unsustainable retention).  
- **Engagement**: Customers active in the community and with more recent purchases were more likely to be retained.  
- **Survey responses**: Dissatisfied or non-responders churned at significantly higher rates.  

### Model Performance (Test Set)
- **ROC AUC**: High, indicating strong discrimination between churned and retained customers.  
- **Accuracy**: Balanced across classes.  
- **Confusion Matrix**: Showed good specificity (detecting retained) and moderate sensitivity (detecting churners).  

### Variable Importance (LightGBM)
Top predictors of retention:  
1. Tenure (subscription length)  
2. Days since last purchase  
3. Discounted rate at sign-up  
4. Community engagement metrics  
5. Support ticket activity  

---

## Business Recommendations
1. **Improve Onboarding** — focus on first 60 days; nurture campaigns to prevent early churn.  
2. **Discount Strategy** — limit deep acquisition discounts; replace with sustainable loyalty rewards.  
3. **Engagement Programs** — encourage community activity (forums, referrals, user-generated content).  
4. **Billing & Operations** — pre-empt card expiry failures; improve delivery reliability.  
5. **Targeted Retention Offers** — use churn predictions to offer retention incentives only to high-risk customers (preserve margins).  

---

## Tools & Packages
- **Language**: R (Quarto)  
- **Libraries**: tidymodels, themis, ranger, xgboost, lightgbm, bonsai, kknn, vip, ggplot2, dplyr  
- **Techniques**:  
  - Data wrangling & preprocessing  
  - Statistical tests (t-test, chi-square)  
  - Machine learning classifiers (GLM, KNN, RF, XGB, LGBM, NN)  
  - Model explainability (variable importance)  
  - Visualization (ROC, confusion matrix, boxplots, cohort analysis)  

---

## Key Takeaway
This project demonstrates how **machine learning + explainable insights** can uncover the drivers of churn in subscription businesses.  
For Ted & Poppy, applying these methods provides **clear strategies to improve retention, increase lifetime value, and reduce churn-related losses**.

