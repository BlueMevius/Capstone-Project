# 1. Relationship to the Original Capstone

## Verified empirical foundation

The parent repository's [Chapter 5: Results](../../paper/06-results.md) reports a study of fast-food outlet density per 10,000 residents among Virginia counties and its association with demographic, socioeconomic and health outcomes. The [parent README](../../README.md) identifies OpenStreetMap, American Community Survey 2023, and County Health Rankings 2023 as its data sources, with R-based spatial processing, ANOVA, Pearson correlations and regressions.

**Reported observational Gini model**:

$$\widehat{\mathrm{Density}}=-4.377+23.939G.$$

Pearson correlation r = 0.2095; p = 0.0181; R² = 0.0439. This is a weak but statistically significant **cross-sectional association**, explaining only about 4.4% of observed county variation. The capstone also found no significant linear relationship between median income and density (p = 0.380), or density and adult obesity (p = 0.566). These are the capstone's reported results; this extension does not re-estimate them.

## Why use a dynamic model?

A regression across counties describes a *snapshot*, not the mechanisms by which business densities change over time. This follow-up considers a stylized update rule with positive Gini-related input, density-proportional damping and random disturbances. It explores the steady-state and intervention response **under assumed mechanisms** rather than fitting observed store openings and closures.

| Aspect | Original capstone | Follow-up |
|---|---|---|
| Evidence | Virginia county observations | Synthetic outcomes from a mathematical model |
| Central question | Which measured variables are associated? | What happens under specified dynamic assumptions? |
| Primary tool | R / geospatial statistics | Python / stochastic simulation |
| Unit | Observed counties | Aggregate Gini *scenarios*, not county-specific agents |
| Time | Cross-sectional | 120 abstract steps (not actual years) |
| Validation | Regression results and significance tests | Mathematical consistency + supplemental Monte Carlo; no new field validation |

## Quantitative link and its limitations

The simulation paper's appendix sets α = 3.59 and β = 0.15, producing

$$\frac{\alpha}{\beta}=23.933\overline{3},$$

very close to the original empirical regression slope **23.939** (difference ≈ 0.0057). This agrees with the paper's statement that the ratio α/β was chosen to match the empirical relationship's gradient. It is not *new* corroboration: the positive gradient is encoded in the equilibrium equation.

**Intercept issue:** The parent regression includes an intercept of **−4.377**; the follow-up equilibrium equation **F* = (α/β)G** has intercept zero. Consequently, their level predictions differ by 4.377 outlets per 10,000 at the same G, ignoring noise and truncation. Parameter tuning to match slope is not enough to claim the whole regression was reproduced.

## Responsible project narrative

> The 2025 Virginia capstone found a statistically significant but weak positive association between county income inequality and fast-food density. The follow-up formalizes an assumed positive inequality input and a market-adjustment mechanism in a stochastic difference equation, then analyzes sensitivity and a hypothetical policy shock. It explores possible dynamic behavior but does not establish a causal relationship in real counties.

**Original source links:** [README](../../README.md), [full results](../../paper/06-results.md), [data description](../../paper/04-data.md), [R analysis](../../code/analysis.R).
