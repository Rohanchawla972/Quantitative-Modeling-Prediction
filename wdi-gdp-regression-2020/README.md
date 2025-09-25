# GDP Prediction using World Development Indicators (2020)

## Project Objective
The goal of this project is to apply **linear regression** techniques to the World Bank’s **World Development Indicators (WDI 2020)** dataset.  
The analysis seeks to answer:  

**“How well can a country’s GDP be predicted using GDP per capita and total population?”**

This project demonstrates end-to-end data wrangling, model building, diagnostics, and visualization in **R**.
---
## Repository Structure
- **README.md** — Project overview, methodology, and results  
- **GDP_Prediction_WDI_2020.R** — R script with full analysis (data loading, cleaning, regression, diagnostics)  
- **Assignment_Report.pdf** — Final write-up with findings and plots  
- **data/wdi_2020.csv** — Dataset used in analysis  
- **LICENSE** — MIT license  
---
## Dataset
- Source: World Bank, **World Development Indicators (2020)**  
- Scope: One record per country, multiple socio-economic indicators  
- Variables selected for this project:  
  - **GDP** (NY.GDP.MKTP.CD) – Dependent variable  
  - **GDP_per_capita** (NY.GDP.PCAP.CD) – Independent predictor  
  - **Total_Pop** (SP.POP.TOTL) – Independent predictor  
- Cleaning: Missing values removed from selected columns
---
## Methodology
1. **Exploratory Data Analysis (EDA):**  
   - Summary statistics, structure check (`head`, `str`, `summary`)  
   - Correlation matrix of GDP, GDP per capita, and population  

2. **Regression Model:**  
   - Model: `GDP ~ GDP_per_capita + Total_Pop`  
   - Coefficients extracted for interpretation  
   - Predictions and residuals added back to dataset  

3. **Visualization:**  
   - Scatter plots with regression lines for **GDP vs GDP_per_capita** and **GDP vs Total_Pop**  
   - Regression equations annotated on plots  
   - Diagnostic plots: residuals vs fitted, histogram of residuals, residuals vs each predictor  

4. **Diagnostics:**  
   - Checked linearity and normality of residuals  
   - Observed heteroskedasticity at higher GDP levels → assumption violations  
---
## Results and Insights
- **Correlation Findings:**  
  - GDP vs GDP per capita: weak positive correlation (~0.14)  
  - GDP vs Total population: moderate positive correlation (~0.58)  

- **Regression Results:**  
  - Adjusted **R² ≈ 0.36** → model explains ~36% of GDP variation  
  - Both predictors significant (p < 0.05)  
  - Population shows a stronger effect on GDP than GDP per capita  

- **Diagnostics:**  
  - Residuals show non-linearity and heteroskedasticity  
  - Histogram of residuals roughly normal  
  - Model assumptions partially unmet → predictions should be interpreted cautiously  
---
## Tools & Packages
- **Language:** R  
- **Libraries:** tidyverse, dplyr, ggplot2, cowplot, scales  
- **Techniques:** Data wrangling, correlation analysis, multiple linear regression, regression diagnostics, visualization  
---
## Key Takeaway
While **population size** and **GDP per capita** both help explain differences in GDP, this model highlights the importance of demographic scale. However, limited explanatory power and assumption violations show the need for richer models (including more predictors and transformations) to capture the complexity of national GDP.

