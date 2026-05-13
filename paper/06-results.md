# Chapter 5: Results

This study seeks to understand the relationship between the geographic
distribution of fast-food establishments and socioeconomic or health-related
factors at the county level in Virginia. The underlying theoretical
assumption is that higher fast-food density may reflect and influence both
local economic disparities and public health outcomes.

As shown in Table 5.1, both tests yielded p-values greater than 0.05. We
therefore fail to reject the null hypothesis and conclude that there is no
statistically significant relationship between fast-food restaurant density
and median income levels across counties in Virginia.

## 5.1 Regression Models

As an initial test, we conducted both an ANOVA and a linear regression to
examine whether there is a statistically significant association between
fast-food density (number of fast-food restaurants per 10,000 residents) and
median household income by county.

### Table 5.1 — p-value of ANOVA and Linear Regression: Fast-Food Density by Median Income

| Test | p-value |
| --- | --- |
| ANOVA (Income vs Fast-Food Density Groups) | 0.653 |
| Linear Regression (y = Density, x = Median Income) | 0.146 |

As shown in Table 5.1, both the ANOVA and linear regression results yield
p-values greater than 0.05, which suggests that there is no statistically
significant association between median household income and fast-food
restaurant density. Therefore, the null hypothesis cannot be rejected at
the α = 0.05 level.

### Table 5.2 — ANOVA Summary: Fast-Food Density by Income Group

| Source | Df | Sum Sq | Mean Sq | F value | Pr(>F) |
| --- | --- | --- | --- | --- | --- |
| Income Group | 2 | 36.2 | 18.10 | 0.957 | 0.387 |
| Residuals | 124 | 2345.3 | 18.91 | | |

### Table 5.3 — Linear Regression Summary: Fast-Food Density vs. Median Income

| Predictor | Estimate | Std. Error | t value | Pr(>\|t\|) |
| --- | --- | --- | --- | --- |
| (Intercept) | 7.151 × 10⁰ | 1.129 × 10⁰ | 6.334 | < 0.001 *** |
| Median Income | −1.246 × 10⁻⁵ | 1.415 × 10⁻⁵ | −0.881 | 0.380 |

Residual standard error: 4.351 on 125 degrees of freedom
Multiple R²: 0.006171; Adjusted R²: −0.00178
F-statistic: 0.7761 on 1 and 125 DF; p-value: 0.38

### Fast-Food Density vs. Income Analysis

To examine the relationship between fast-food outlet density and income
levels across counties in Virginia, we conducted both a one-way ANOVA and a
simple linear regression using the variable `fastfood_per10k` (number of
fast-food outlets per 10,000 residents).

The ANOVA result shows no significant difference in fast-food density
across income groups (p = 0.387). Post-hoc analysis using Tukey HSD
confirms this result, with all pairwise p-values > 0.40.

These findings indicate that median income is not a statistically
significant predictor of fast-food density in Virginia counties. The
regression model explains a negligible amount of variance (R² ≈ 0.006), and
the slope coefficient is not statistically significant (p = 0.38). Thus, we
find no strong evidence of income-based disparity in fast-food access at
the county level.

### Fast-Food Density and Median Household Income

To explore the relationship between income level and fast-food
availability, we conducted a simple linear regression with fast-food
density (restaurants per 10,000 residents) as the dependent variable and
median household income as the independent variable.

**Regression Results.** The estimated regression model is:

$$
\widehat{\text{Fast-Food Density}} = 7.15 - 0.0000125 \times \text{Median Income}
$$

The slope coefficient was not statistically significant
(β₁ = −0.0000125, p = 0.38), indicating that median income was not a
meaningful predictor of fast-food density at the county level. The model
explains less than 1% of the variance in fast-food density (R² = 0.0062),
and the F-test for the model was not significant (F(1, 125) = 0.7761,
p = 0.38).

### Table 5.4 — Simple Linear Regression: Fast-Food Density on Median Household Income

| Variable | Estimate | Std. Error | t value | p value |
| --- | --- | --- | --- | --- |
| (Intercept) | 7.151 | 1.129 | 6.334 | < 0.001 |
| Median Income | −1.246 × 10⁻⁵ | 1.415 × 10⁻⁵ | −0.881 | 0.38 |

Residual Std. Error: 4.351 on 125 DF
Multiple R²: 0.0062; Adjusted R²: −0.0018
F-statistic: 0.7761 on 1 and 125 DF; p-value: 0.38

**Findings.** Contrary to popular assumptions, the regression results
suggest that there is no statistically significant linear relationship
between median household income and fast-food density across Virginia
counties. This supports the notion that fast-food availability may be
influenced by other factors, such as zoning, urbanicity, or demographic
composition.

### Income Inequality (Gini Index) by Fast-Food Density

To examine the association between income inequality and the density of
fast-food restaurants across counties in Virginia, we conducted both a
correlation analysis and a linear regression using the Gini Index as the
predictor.

**Pearson Correlation.** The Pearson correlation coefficient between
fast-food density (per 10,000 residents) and the Gini Index was found to be
**0.2095**, indicating a weak but positive correlation. A simple linear
regression yielded the following model:

$$
\text{FastFood\_per10k} = -4.377 + 23.939 \cdot \text{Gini}
$$

### Table 5.5 — Simple Linear Regression: Fast-Food Density on Gini Index

| Variable | Estimate | Std. Error | t value | p value |
| --- | --- | --- | --- | --- |
| (Intercept) | −4.377 | 4.439 | −0.986 | 0.3260 |
| Gini Index | 23.939 | 9.994 | 2.395 | **0.0181** |

Residual Std. Error: 4.295 on 125 DF
Multiple R²: 0.0439; Adjusted R²: 0.0362
F-statistic: 5.734 on 1 and 125 DF; p-value: 0.0181

**Findings.** The coefficient for the Gini Index was statistically
significant (p = 0.018), suggesting that higher income inequality is
associated with greater fast-food restaurant density. The model's
explanatory power was limited, with an R² of 0.044, indicating that income
inequality explains about 4.4% of the variation in fast-food density.

### Fast-Food Density and Obesity Rates

While our statistical analysis did not find a significant relationship
between fast-food density and income level, it remains important to
consider how the spatial concentration of fast-food establishments may
affect public health outcomes directly.

**Food Desert Theory** posits that low-income communities often experience
limited access to healthy food options, leading to a reliance on
calorie-dense, nutrient-poor alternatives such as fast food [32].

Prior research has identified correlations between higher fast-food
availability and elevated obesity rates and diet-related chronic conditions
such as type 2 diabetes, particularly in underserved or marginalized
populations [33, 34].

Thus, even when there is no direct relationship with income, exploring the
potential health effects of fast-food access is essential for assessing
larger trends of health inequities in communities.

To assess our predictions that fast-food density is predictive of obesity
prevalence at the county level in Virginia, we ran three statistical tests:
a Pearson correlation, a one-way ANOVA, and a simple linear regression.
Data on obesity prevalence were taken from the 2023 County Health Rankings,
and fast-food density was operationalized as number of fast-food outlets
per 10,000 population.

**Pearson Correlation.** The Pearson correlation coefficient between
fast-food density and adult obesity rate was:

$$
r = 0.053
$$

This value indicates a very weak positive correlation, suggesting little to
no linear association between the two variables. Visual inspection of the
scatterplot (Figure 5.3) confirms the lack of a meaningful linear trend.

**ANOVA Analysis.** To explore possible non-linear group differences,
counties were categorized into tertiles based on fast-food density (Low,
Medium, High). A one-way ANOVA was conducted to compare mean obesity rates
across the three groups. The results are summarized in Table 5.6.

### Table 5.6 — ANOVA Summary: Obesity Rate by Fast-Food Density Groups

| Source | Df | Sum Sq | Mean Sq | F-value | p-value |
| --- | --- | --- | --- | --- | --- |
| Between Groups | 2 | 32.1 | 16.05 | 1.37 | 0.259 |
| Within Groups | 124 | 1454.2 | 11.73 | | |

The p-value (p = 0.259) indicates that there is no statistically
significant difference in average adult obesity rates across the Low,
Medium, and High fast-food density groups. Therefore, we fail to reject the
null hypothesis.

**Regression Model Result.** A regression model was estimated to determine
whether fast-food density significantly predicts obesity prevalence:

$$
\text{Obesity Rate}_i = \beta_0 + \beta_1 \cdot \text{FastFoodDensity}_i + \varepsilon_i
$$

Regression results are shown in Table 5.7.

### Table 5.7 — Linear Regression Summary: Fast-Food Density Predicting Obesity Rate

| Predictor | Estimate | Std. Error | p-value |
| --- | --- | --- | --- |
| Intercept (β₀) | 30.28 | 0.79 | < 0.001 |
| Fast-Food Density (β₁) | 0.021 | 0.037 | 0.566 |

There was no statistically significant slope coefficient (p = 0.566), and
the model showed that less than 1% of the variance in obesity (R² ≈ 0.003)
was explained by fast-food density. Thus, density of fast food does not
seem to be a decent predictor of county-level obesity rates.

**Findings.** The findings from the correlation, ANOVA, and linear
regression suggest that fast-food density alone is not a good predictor of
obesity rates across Virginia's counties. The data suggest that beyond
fast-food density, social, environmental, and behavioral determinants play
a role in obesity. Future analyses will examine several potential
predictors, including income and income inequality, access to physical
activity, and food insecurity, to develop multivariate explanatory models.
