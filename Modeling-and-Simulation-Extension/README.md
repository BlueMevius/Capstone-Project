# Modeling & Simulation Extension

**Modeling the Emergence of Fast-Food Density under Income Inequality: A Dynamic Simulation Study of Virginia Counties**  
**Author:** Geonwoo Roh  
**Relationship to the original project:** Follow-up to [the Virginia fast-food density and public health capstone](../README.md).

This extension takes the original capstone's **cross-sectional association** between Virginia county-level Gini coefficients and fast-food outlet density and uses it as motivation for a **discrete-time stochastic simulation**. The simulation tests how **assumed** inequality-related input, damping/market constraints, and random shocks affect *modeled* outlet density over time. It is not a new regression, a causal study, or a validated forecast.

## Why this extension was developed

The [original analysis](../paper/06-results.md) reports:

| Original capstone outcome | Finding |
|---|---|
| Gini index vs fast-food density | Pearson r = **0.2095** (weak positive) |
| Gini regression slope | **23.939** (p = **0.0181**; R² = **0.0439**) |
| Fitted county-level equation | **Density = −4.377 + 23.939 × Gini** |
| Median household income vs density | Not statistically significant (p = **0.380**) |
| Outlet density vs adult obesity | Not statistically significant (p = **0.566**) |

The subsequent model uses α = 3.59 and β = 0.15; α/β ≈ **23.933**, closely matching the original Gini **slope** of 23.939. **However, the model omits the original negative intercept**, and matching one coefficient is *parameter alignment*, not independent data validation. Read [the methodological comparison](docs/01_research_context.md).

## Main mathematical model

The paper specifies

$$F_{t+1}=(1-\beta)F_t+\alpha G+\epsilon_t,\qquad\epsilon_t\sim N(0,\sigma^2).$$

Its Python implementation imposes a nonnegative density floor: F(next) = max(0, (1−β)F + αG + ε). Here:

| Symbol | Definition | Baseline |
|---|---|---|
| F | Fast-food outlets per 10,000 residents (simulated state) | F(0) = 6 |
| G | Scenario Gini index (constant during a run) | 0.35 / 0.45 / 0.55 |
| α | Assumed inequality-related input coefficient | 3.59 |
| β | Proportional adjustment / market-constraint coefficient | 0.15 |
| σ | Standard deviation of additive Gaussian noise | 1.5 |
| t | Abstract simulation step, **not a calendar year** | 0–120 |
| seed | NumPy random seed for original single-path figures | 42 |

In the nontruncated linear model, the equilibrium is **F* = (α/β)G**. It rises linearly with G and falls **inversely**, not exponentially, with β. Because the implementation floors negative states at 0, the formula may not exactly equal the stationary mean when that floor matters.

## Main results: conditional model outcomes

| Scenario | Gini | β | Analytic F* per 10,000 |
|---|---:|---:|---:|
| Low inequality | 0.35 | 0.15 | 8.377 |
| Middle inequality | 0.45 | 0.15 | 10.770 |
| High inequality | 0.55 | 0.15 | 13.163 |
| Higher constraints | 0.45 | 0.30 | 5.385 |

**Model intervention:** At t = 50, increasing β from 0.15 to 0.30 halves the analytical equilibrium from 10.770 to 5.385. It does **not** show that any real zoning law would reduce Virginia fast-food outlets by 50%.

**Randomness matters:** With NumPy seed 42, the last-30-step simulated mean for G = 0.45 and β = 0.15 is **8.065**, not the analytical 10.770. A **new**, explicitly supplemental 1,000-run Monte Carlo check gives a cross-run mean near **10.699**. These are simulated figures, not empirical confidence intervals or policy effect estimates.

## Documentation

- [Research connection to the original capstone](docs/01_research_context.md)
- [Formal model, derivation, and assumptions](docs/02_model_and_assumptions.md)
- [Experiments and interpretation of Figures 1–4](docs/03_experiments_and_results.md)
- [Validation status, scientific limitations, and next steps](docs/04_validation_and_limitations.md)
- [Expanded and carefully qualified research manuscript](docs/05_revised_paper.md)
- [한국어 연구 설명](docs/06_korean_summary.md)

The original author-supplied nine-page PDF is retained in the accompanying downloadable project archive; the [revised manuscript](docs/05_revised_paper.md) is the expanded, GitHub-readable version included here. The PDF has **not** been silently replaced with an edited original.

## Reproduce with Python

~~~bash
cd Modeling-and-Simulation-Extension
python -m pip install -r requirements.txt
python src/simulation.py --figures-dir figures --results-dir results
python src/monte_carlo_validation.py --runs 1000 --results-dir results
~~~

The scripts create four figures and CSVs in the chosen directories. They reproduce the *model parameters and algorithm*, not a data-calibration pipeline. **Original county-level raw data, fitted parameter estimation, and time-series external validation are not included in the supplied paper.**

## Research integrity

The original 2025 capstone remains a separate observational analysis. This extension is **illustrative and mechanism-based**: it cannot prove causality, estimate real zoning effects, or simulate spatial interactions across individual counties. See [Limitations](docs/04_validation_and_limitations.md) before using its outcomes for policy arguments.
