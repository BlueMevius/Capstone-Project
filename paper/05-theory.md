# Chapter 4: Theory

## 4.1 Research Hypothesis

This study investigates the relationships among county-level income, income
inequality, fast-food access, and public health outcomes in the state of
Virginia. The following hypotheses are formulated based on existing
literature on food environments, spatial inequality, and social determinants
of health.

### 4.1.1 Hypothesis Set 1: Median Income and Fast-Food Density

- **Null Hypothesis (H0,1):** There is no statistically significant
  association between median household income and fast-food density across
  counties in Virginia.
- **Alternative Hypothesis (Ha):** Counties with lower median household
  income exhibit higher fast-food density.

### 4.1.2 Hypothesis Set 2: Income Inequality and Fast-Food Density

- **Null Hypothesis (H0,2):** Income inequality (Gini index) is not
  significantly associated with fast-food density.
- **Alternative Hypothesis (Ha):** Counties with higher income inequality
  exhibit higher fast-food density.

### 4.1.3 Hypothesis Set 3: Public Health Outcomes and Fast-Food Density

- **Null Hypothesis (H0,5):** Fast-food density is not significantly
  associated with obesity rates.
- **Alternative Hypothesis (Ha):** Counties with higher fast-food density
  have higher obesity rates.

### 4.1.4 Potential Statistical Tests

Based on the final dataset, the following statistical models may be
applied:

- Pearson correlation test
- Ordinary Least Squares (OLS) regression
- ANOVA model, when comparing groups of counties categorized by income
  level
- Geographically Weighted Regression (GWR) for spatial heterogeneity
  (optional)

An example ANOVA model formulation:

$$
\text{FastFoodDensity}_i = \mu + \alpha_j + \varepsilon_i,
$$

where $\alpha_j$ represents the effect of county income group $j$ (e.g.,
high-income vs. low-income), and $\varepsilon_i$ is random error.

## 4.2 Socioeconomic Status

To show the disparity in access to fast food across the state of Virginia,
several choropleth maps were produced by conducting spatial joins with
OpenStreetMap (OSM) fast-food location data and the 2023 U.S. Census ACS
county boundaries.

The first map (Figure 4.2) shows the raw number of fast-food restaurants by
county. Notice that cities (represented as counties) such as Fairfax and
Virginia Beach have a high concentration of fast-food units, which suggests
that commercial food units cluster in areas with population density (urban
areas).

To represent density by population levels, fast-food restaurant density per
10,000 residents was calculated (Figure 4.3). This measure better represents
relative access to fast food, especially for rural counties that have
relatively high density per capita (e.g., Emporia, Galax), but will have
fewer raw units because of their lower overall population.

County income distributions serve as useful socioeconomic context (Figures
4.4–4.5). Northern Virginia counties have high median incomes, but the
majority of southern and southwestern counties have low household income.
The geographic disparity of income distribution will be the basis of
subsequent analysis of fast-food units by income group.

### Interpretation of Geospatial Visualizations

Maps of spatial distribution indicate that counties in southwestern and
southeastern Virginia have lower median incomes and higher fast-food
density. The adult obesity map (Figure 4.6) exhibits similar spatial
patterns, with higher rates of obesity in areas of high fast-food density
and income inequality, thus supporting the regression analysis results.

Such geographic distributions present visual support for the statistical
relationship between socioeconomic variables and health-related outcomes.

### List of Figures

| Figure | Title |
| --- | --- |
| 4.1 | Population Status in Virginia |
| 4.2 | Fast-Food Density in Virginia (raw counts) |
| 4.3 | Fast-Food Density per 10,000 Residents in Virginia |
| 4.4 | Median Income Map in Virginia |
| 4.5 | Income Inequality (Gini Index) in Virginia |
| 4.6 | Percentage of Adults with Obesity |

*Figure images are included in the original PDF at `docs/Capstone-Project.pdf`.*
