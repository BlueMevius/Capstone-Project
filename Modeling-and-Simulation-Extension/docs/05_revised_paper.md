# Modeling the Emergence of Fast-Food Density under Income Inequality
### An Exploratory Dynamic Simulation Extension of a Virginia County Food-Environment Capstone

**Research author:** Geonwoo Roh  
**Document type:** Expanded and clarified **working version** based on the supplied nine-page paper.  
**Integrity note:** This Markdown is an interpretive rewrite for documentation purposes; it is **not** a record of new empirical data collection or an independently peer-reviewed revision. Numerical simulation details follow the supplied PDF and its Appendix; additional Monte Carlo figures are explicitly identified as supplemental.

---

## Abstract (revised)

Cross-sectional analyses of local food environments may identify associations between socioeconomic conditions and fast-food outlet density, but they are not designed to characterize the evolution of outlet density over time. Motivated by county-level research on Virginia's food environment, this study presents an exploratory, reduced-form dynamic simulation that represents fast-food outlet density as a function of a fixed Gini-index scenario, proportional market adjustment, and stochastic shocks. A discrete-time model is used to examine (1) how assumed inequality-related input changes long-run equilibrium density; (2) the sensitivity of that equilibrium to the market adjustment parameter; and (3) how a hypothetical change in that parameter affects simulated trajectories. The analytically implied equilibrium is linear in the Gini index and inversely proportional to the adjustment parameter. A stylized intervention that doubles the adjustment parameter from 0.15 to 0.30 reduces the theoretical equilibrium by 50% in the medium-inequality scenario. The results are **conditional implications of the model**, not estimates of a causal effect in observed Virginia counties. Their primary contribution is to make assumptions explicit, demonstrate dynamic scenario analysis, and identify directions for future empirical calibration and validation.

**Keywords:** dynamic simulation; fast-food density; Gini index; stochastic difference equation; system dynamics; sensitivity analysis; food environment

## 1. Introduction

A community's retail food environment is shaped by demographic, socioeconomic and commercial factors. The distribution of fast-food outlets is an important descriptive feature of that environment. Research on Virginia's counties motivated an interest in whether income inequality and outlet density vary together. Cross-sectional data can be valuable for identifying patterns, but cannot on their own establish the process through which outlets appear or disappear across successive periods.

This project therefore changes the unit of inquiry: rather than estimating another cross-sectional relationship, it constructs a deliberately simplified dynamic mechanism and studies the model's behavior. This move is useful for conceptual exploration because the assumptions governing entry-like input, retention and random shocks are transparent. It is also restrictive: the mechanism is specified by the researcher, not inferred from longitudinal store histories.

The research questions are: **(RQ1)** Given an assumed positive inequality-related input, how does a higher fixed Gini index alter the simulated long-run density? **(RQ2)** How sensitive is the equilibrium to proportional adjustment/constraint? **(RQ3)** What happens to a simulated trajectory if the constraint parameter increases midway through a run? The third question is a *conditional policy thought experiment* rather than an evaluation of an observed regulation.

## 2. Conceptual Background and Theoretical Framing

The motivating literature examines food access, retail location patterns, socioeconomic status, and associated population-health outcomes. These relationships involve many mechanisms beyond income inequality alone, including purchasing behavior, land use, competition, and urban form. The present model cannot separate those mechanisms. Instead, it combines them into a positive inequality-linked input term and a density-proportional adjustment term.

Suppose an aggregate market receives a constant input $\alpha G$ during each simulated step. If existing restaurant density experiences a proportional adjustment $\beta F_t$, the net expected change is

$$E[F_{t+1}-F_t\mid F_t] = -\beta F_t+\alpha G,$$

ignoring the nonnegative floor applied by the numerical implementation. The positive coefficient on $G$ is an *assumption reflecting the proposed mechanism*. It must not be described as an empirically identified causal effect. The proportional negative adjustment yields diminishing net growth as density increases, but it is not equivalent to an explicit capacity-constrained logistic market.

This framework is appropriate for a demonstration of simple stochastic dynamics. It is not a full economic model of outlet profitability, customer behavior, or geographical selection.

## 3. Data Provenance and Relationship to the Original Capstone

The nine-page manuscript states that its motivation and parameter selection were informed by Virginia county-level food-density and socioeconomic data, including OpenStreetMap, the 2023 American Community Survey and County Health Rankings. It also states that $\alpha/\beta$ was chosen to reflect an empirical density–inequality relationship. **However, the PDF does not include the original county table, the data preparation code or a parameter-estimation report.** The source material therefore supports a description of *intended empirical grounding*, but not an independent numerical replication of that grounding.

The earlier capstone is the **observational foundation**, and the present document is a **dynamic modeling follow-up**. The repository's [results](../../paper/06-results.md) report Pearson r = 0.2095, a Gini slope of 23.939, intercept −4.377, p = 0.0181, and R² = 0.0439. The simulation coefficient ratio α/β = 23.9333 approximately matches that slope, but omits the observed intercept and does not independently validate a temporal causal mechanism. No new data collection is claimed in this revision.

## 4. Model and Simulation Design

### 4.1 Discrete-time equation

The paper defines the following stochastic linear difference equation:

$$F_{t+1}=(1-\beta)F_t+\alpha G+\epsilon_t,\qquad \epsilon_t\sim\mathcal N(0,\sigma^2).$$

$F_t$ is the simulated number of fast-food outlets **per 10,000 residents**, not the aggregate number of businesses in Virginia. $G$ is an exogenous, fixed Gini index. The parameters $\alpha$ and $\beta$ govern positive input and density-proportional adjustment. $\epsilon_t$ is a random disturbance with standard deviation $\sigma$.

The provided Python program ensures nonnegative results by setting negative updated states to zero:

$$F_{t+1}=\max\{0,(1-\beta)F_t+\alpha G+\epsilon_t\}.$$

Consequently, the analytical formulas derived from the *untruncated* equation may differ slightly from the stochastic program's stationary expectations when the floor binds.

### 4.2 Parameters and experiment settings

The original appendix uses: $\alpha=3.59$; baseline $\beta=0.15$; $\sigma=1.5$; $F_0=6$; random seed 42; total simulation length 120 steps. Inequality scenarios are $G\in\{0.35,0.45,0.55\}$. The sensitivity experiment varies $\beta$ between 0.05 and 0.35. The policy-shock experiment increases $\beta$ from 0.15 to 0.30 starting at step 50 in the $G=0.45$ scenario.

The time index is deliberately abstract; no mapping to years or actual rates of outlet turnover is provided. Repeated use of the same random seed produces directly comparable scenario paths under common simulated shocks, but single-seed results should not be interpreted as statistically representative.

### 4.3 Equilibrium derivation and stability

Setting mean shocks to zero and equating $F_{t+1}$ to $F_t$ yields

$$F^*=\frac{\alpha G}{\beta}.$$

For the unconstrained linear state equation, departures from the equilibrium decay under $0<\beta<2$, a condition met by the tested settings. The model therefore predicts a larger equilibrium as $G$ increases and a smaller equilibrium as $\beta$ increases, by construction.

The derivative with respect to inequality is $\partial F^*/\partial G=\alpha/\beta$. The derivative with respect to constraint is $\partial F^*/\partial\beta=-\alpha G/\beta^2$. Hence the latter relationship is **inverse**, not exponential.

## 5. Simulation Experiments and Findings

### 5.1 Income inequality and stochastic trajectories (Figure 1)

**Figure 1.** The figure is reproducible using `python src/simulation.py`; see the corresponding experiment description in [the results](03_experiments_and_results.md).

With $\beta=0.15$, the three Gini scenarios are associated with theoretical equilibrium densities of approximately 8.377, 10.770 and 13.163 outlets per 10,000 residents. A fixed sequence of random innovations generates fluctuations about these different levels. The separation in their expected levels follows directly from the chosen positive $\alpha G$ term. It is **not a newly discovered empirical regularity** of Virginia counties.

### 5.2 Equilibrium and inequality gradient (Figure 2)

**Figure 2.** The figure is reproducible using `python src/simulation.py`; see the corresponding experiment description in [the results](03_experiments_and_results.md).

The equilibrium relation implies a positive linear gradient in $G$. With the stated settings, the analytical slope is $3.59/0.15\approx23.9333$. Unlike a plot of empirical county-level observations, this curve has no fitted residuals and no uncertainty interval. It should be interpreted as an analytical property of the model. Cross-sectional observed density may show substantial dispersion from any such line because multiple omitted structural factors and measurement choices contribute to local outcomes.

### 5.3 Sensitivity to the market-adjustment parameter (Figure 3)

**Figure 3.** The figure is reproducible using `python src/simulation.py`; see the corresponding experiment description in [the results](03_experiments_and_results.md).

For fixed $G=0.45$, the theoretical equilibrium falls nonlinearly as $\beta$ rises. In particular, moving from $\beta=0.05$ to $\beta=0.35$ changes the theoretical equilibrium from approximately 32.310 to 4.616 outlets per 10,000 residents. The second line in the plot is computed from the last 30 steps of a **single stochastic path** for each $\beta$ and therefore can be noticeably below or above the theoretical values. This difference should not be minimized as proof of close fit. A useful enhancement is to report repeated simulations and the distribution of estimates.

### 5.4 Hypothetical policy shock (Figure 4)

**Figure 4.** The figure is reproducible using `python src/simulation.py`; see the corresponding experiment description in [the results](03_experiments_and_results.md).

The intervention is represented by increasing $\beta$ from 0.15 to 0.30 beginning at step 50. This changes the hypothetical steady state from $10.770$ to $5.385$ outlets per 10,000 residents in the medium-Gini scenario, a modeled **50%** reduction in equilibrium. The actual state approaches the new value gradually and with random variation. This result **cannot be converted into a real-world percentage impact** without empirical evidence linking specific regulations to the parameter and establishing a relevant causal design.

### 5.5 Additional stochastic robustness checks (new)

To make the dependence on random shocks visible, the companion code repeats the process 1,000 times using distinct seeds for each parameter configuration. For $G=0.45$ and $\beta=0.15$, the average of each path's final 30 steps is **8.065** in the original seed-42 run. Across 1,000 runs the corresponding average is approximately **10.699**, closer to the untruncated theoretical 10.770. The 2.5th and 97.5th percentiles of run averages are about **7.733** and **13.837**. This is a simulation robustness exercise only; it offers **no new evidence of empirical causal validity**.

See `03_experiments_and_results.md` and `results/supplemental_monte_carlo.csv` for the other scenarios and quantiles.

## 6. Validation Strategy and Limitations

The framework is reproducible at the code level: the included scripts generate the four modeled plots and tables from the stated parameters. Its equations are transparent and yield analytic steady-state predictions. Nonetheless, **internal consistency is not external validation**.

The supplied paper does not provide the county-level records or preprocessing necessary to replicate its stated empirical calibration. There is no documented county-level train/test split, longitudinal holdout validation, statistical estimation of $\beta$ from zoning restrictions, or fitted error assessment against observed historical store-count trajectories. Consequently, the present results should be interpreted as illustrative scenario simulations.

Additional restrictions include: (i) fixed inequality across time; (ii) no counties represented as distinct spatial units; (iii) no demographics beyond $G$ in the dynamic equation; (iv) no intercept in the equilibrium line; (v) additive Gaussian shocks and a hard zero lower bound; (vi) no explicit economic entry/exit decision model; and (vii) an abstract, dimensionless step length.

Further work should recover the original capstone's cleaning and statistical-analysis pipeline; publish data definitions and parameter-fitting procedures; explore multi-year county observations; use repeated simulations with uncertainty summaries; compare alternative functional forms; and, for policy questions, estimate relationships from observed interventions rather than assigning an arbitrary value to $\beta$.

## 7. Conclusion

This project extends an empirical food-environment research question into a transparent, reduced-form dynamic simulation. Under its specified assumptions, a larger fixed Gini input produces a higher equilibrium outlet density, while stronger density-proportional adjustment lowers that equilibrium. A mid-run increase in the adjustment parameter shifts simulated trajectories toward a lower long-run level. These findings describe **what the model implies**, rather than establishing the dynamics or policy responsiveness of fast-food establishments in actual Virginia counties.

The research contribution lies in linking an observational motivation with explicit dynamic assumptions, reproducible computational experimentation and sensitivity analysis. The model also exposes precisely what additional evidence would be required for stronger empirical or causal claims. Future extensions could include county-level spatial interactions, longitudinal estimation and agent-based market-entry decisions.

## Supporting materials and references

- Source paper: `../reports/Modeling_and_Simulation_original.pdf` (original content and bibliography, pp. 1–9).
- Reproduction code: `../src/simulation.py` (same model specification and baseline conditions).
- Supplemental code: `../src/monte_carlo_validation.py` (additional independent-seed simulations, **not** in original paper).
- Original capstone: [Virginia capstone results](../../paper/06-results.md) (reported cross-sectional Gini slope 23.939, intercept −4.377, p = 0.0181, R² = 0.0439).

**Reference policy:** This expanded working text intentionally does not reproduce the original PDF's long bibliography verbatim. The primary paper includes its reference list on p. 9; verify individual bibliographic details before formal publication.