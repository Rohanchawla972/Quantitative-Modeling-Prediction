################################################################################
# Airbnb Panel Data Analysis (year + month -> time)
# Author: Rohan Chawla
################################################################################

# Send plots to RStudio's Plots pane 
options(device = "RStudioGD")
try({ while (dev.cur() > 1) dev.off() }, silent = TRUE)

# ---- Packages ----
library(readxl)
library(dplyr)
library(ggplot2)
library(plm)
library(lmtest)
library(sandwich)
library(broom)

# ---- Load data ----
df_raw <- read_excel("Airbnb.xlsx")

# ---- Basic cleaning (separate year + month -> combined time) ----
df <- df_raw %>%
  rename(
    id     = propertyid,
    yr     = year,
    mon    = month,
    price  = avg_price,
    rating = rating
  ) %>%
  mutate(
    mon = as.numeric(mon),                        # ensure month is numeric
    t   = paste0(yr, "-", sprintf("%02d", mon)),  # "YYYY-MM"
    id  = as.factor(id),
    t   = as.factor(t)
  ) %>%
  select(id, t, price, rating) %>%
  filter(!is.na(id), !is.na(t), !is.na(price), !is.na(rating))


stopifnot(nrow(df) > 0)

# ---- Panel set-up ----
pdf <- pdata.frame(df, index = c("id","t"))

# ---- Models ----
# 1) Pooled OLS
m_ols <- lm(price ~ rating, data = df)

# 2) Fixed Effects (within)
m_fe  <- plm(price ~ rating, data = pdf, model = "within", effect = "individual")

# 3) Random Effects (GLS)
m_re  <- plm(price ~ rating, data = pdf, model = "random", effect = "individual")

# ---- Robust SE helpers ----
robust_se <- function(model, type = "HC1") vcovHC(model, type = type, cluster = "group")
tidy_plm  <- function(model) broom::tidy(coeftest(model, vcov = robust_se(model)))

cat("\n=== Pooled OLS (robust) ===\n"); print(coeftest(m_ols, vcov = vcovHC(m_ols, type = "HC1")))
cat("\n=== Fixed Effects (robust) ===\n"); print(tidy_plm(m_fe))
cat("\n=== Random Effects (robust) ===\n"); print(tidy_plm(m_re))

# R2-style diagnostics
cat("\nR2 (OLS): ", summary(m_ols)$r.squared, "\n")
cat("Within R2 (FE): ", summary(m_fe)$r.squared["rsq"], "\n")
cat("Overall R2 (RE): ", summary(m_re)$r.squared["rsq"], "\n")

# ---- Hausman test (FE vs RE) ----
cat("\n=== Hausman test (FE vs RE) ===\n"); print(phtest(m_fe, m_re))

# ---- Visuals (analysis-only; not saving files) ----

# A1) Plot means: heterogeneity across listings
df_means <- df %>% group_by(id) %>% summarise(mean_price = mean(price, na.rm = TRUE), .groups = "drop")
ggplot(df_means, aes(x = reorder(id, mean_price), y = mean_price)) +
  geom_point() +
  coord_flip() +
  labs(title = "Mean Price by Listing (Plot Means)", x = "Listing (id)", y = "Mean price")

# A2) Fixed-effect intercepts (alpha_i)
fe_eff <- fixef(m_fe, effect = "individual")
fe_df  <- tibble(id = names(fe_eff), fe_intercept = as.numeric(fe_eff))
ggplot(fe_df, aes(x = reorder(id, fe_intercept), y = fe_intercept)) +
  geom_segment(aes(xend = id, y = 0, yend = fe_intercept)) +
  geom_point() +
  coord_flip() +
  labs(title = "Fixed-Effect Intercepts by Listing", x = "Listing (id)", y = "FE intercept (alpha_i)")

# A3) Fitted values vs rating (OLS / FE / RE)
fits <- df %>%
  mutate(
    fit_ols = fitted(m_ols),
    fit_fe  = as.numeric(fitted(m_fe)),
    fit_re  = as.numeric(fitted(m_re))
  )
ggplot(fits, aes(x = rating, y = price)) +
  geom_point(alpha = 0.25) +
  geom_smooth(aes(y = fit_ols, colour = "OLS"), method = "loess", se = FALSE) +
  geom_smooth(aes(y = fit_fe,  colour = "FE"),  method = "loess", se = FALSE) +
  geom_smooth(aes(y = fit_re,  colour = "RE"),  method = "loess", se = FALSE) +
  scale_colour_manual(values = c("OLS"="black","FE"="blue","RE"="red")) +
  labs(title = "Fitted Values vs Rating", x = "Rating", y = "Price", colour = "Model")

################################################################################
# End
################################################################################
