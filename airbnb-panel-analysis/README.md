# Airbnb Panel Data Analysis

This project applies **panel data econometric methods** to Airbnb listing data to investigate whether **rating scores influence average prices**. The dataset contains multiple observations per property across different months, making it ideal for panel data techniques such as Fixed Effects (FE) and Random Effects (RE) models.

---

## Project Overview
- **Goal:** Determine the effect of ratings on Airbnb prices using panel data analysis.  
- **Dataset:** `Dataset.xlsx` (monthly Airbnb data with property IDs, year, month, ratings, and average price).  
- **Methods:**  
  - Data preparation (merge year & month into a panel time variable).  
  - Pooled OLS, Fixed Effects, and Random Effects regression.  
  - Model comparison with R² metrics and Hausman test.  
  - Visual diagnostics (listing heterogeneity, intercept plots, fitted lines).  

---

## Key Steps
1. **Panel Setup**  
   - `id` = property ID  
   - `t` = combined year-month (`YYYY-MM`)  
   - `price` = average price  
   - `rating` = review rating  

2. **Models Estimated**  
   - **Pooled OLS**: Suggests ratings significantly raise prices but ignores property heterogeneity.  
   - **Fixed Effects (FE)**: Controls for unobserved listing-specific traits; coefficient negative but not significant.  
   - **Random Effects (RE)**: Balances heterogeneity and general effects; results align with FE.  

3. **Hausman Test**  
   - p ≈ 0.94 → No significant difference between FE and RE → RE is preferred.  

---

## Results
- **OLS**: Misleading, overestimates effect of ratings.  
- **FE**: Ratings not statistically significant after controlling for property-specific factors.  
- **RE**: Consistent with FE, chosen as the more efficient model.  

**Conclusion:** Ratings **do not significantly determine price** when accounting for property heterogeneity. Other factors (location, amenities, seasonality) are more important.

---

## Repository Structure
```
airbnb-panel-analysis/
│── Airbnb panel regression report.pdf # Full written report
│── Dataset.xlsx # Source dataset
│── panel_data_airbnb.R # R script with complete analysis
│── README.md # Documentation
│── LICENSE # MIT open-source license
---
```
## Tools & Libraries
- **R**: plm, lmtest, sandwich, dplyr, ggplot2, broom, readxl  
- **Methods**: Panel regression (OLS, FE, RE), Hausman test, robust standard errors  

---

## Insights
- Simple OLS ignores heterogeneity → wrong conclusions.  
- FE and RE models show ratings are **not a key driver of price**.  
- Random Effects is the best choice here → efficient & consistent.  

---

## References
- Hausman, J. A. (1978). *Specification Tests in Econometrics*. Econometrica.  
- Torres-Reyna, O. (2007). *Panel Data 101*. [Princeton University](https://www.princeton.edu/~otorres/Panel101.pdf)  
- Sylvia’s Research Project (data source).  

