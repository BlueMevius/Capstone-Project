# 4. Validation, Scientific Limits and Future Improvements

## What was validated?

Distinguish three separate goals:

1. **Reproducibility:** Can the four original-style numerical experiments be executed with the paper's parameters and random seed? **Yes**: run [simulation.py](../src/simulation.py).
2. **Internal consistency and stochastic uncertainty:** Do independent repeats cluster about the analytic equilibrium, and how variable are individual runs? **Addressed illustratively** by the additional Monte Carlo exercise (1,000 seeds), which was *not* in the original manuscript.
3. **External empirical validity:** Does the model predict real opening/closure time series and actual zoning responses across Virginia counties? **Not demonstrated** by the nine-page manuscript or accompanying code.

The parent capstone supplies authentic observational cross-sectional findings, but a correlation coefficient, a slope-matched α/β ratio, and a model-based simulation do not by themselves establish a causal transition mechanism.

## Primary limitations

- The dynamic model has **no actual county-specific or spatial states** despite being motivated by county data.
- The time-step index is abstract: it cannot be interpreted as calendar years.
- G is fixed in each run; there is no endogenous change in inequality.
- The positive αG input assumes the directional relationship the figure then displays.
- β bundles damping, competition, saturation and hypothetical policy into one coefficient without external estimation.
- The zero-intercept equilibrium line differs from the parent regression's observed intercept **−4.377**.
- The PDF does not provide the full calibration algorithm, fitting objective or cleaned observational data required to independently re-estimate α and β.
- A nonnegative floor changes stochastic stationary expectations relative to the simple untruncated analytic formula.
- The original figure uses just one seed; the last-30 mean may be far from theoretical F*.
- The results make **no claim** about individual health impacts or obesity causation.

## Responsible interpretations

**Valid:** “In this reduced-form model, increasing β lowers the theoretical long-run density; the chosen positive αG term yields higher long-run density under higher fixed Gini scenarios.”

**Invalid without further evidence:** “Income inequality causes restaurant openings”; “This zoning law would cut fast-food locations by 50%”; “The model has been validated on Virginia historical trajectories.”

## Practical next steps

| Priority | Task | Needed work |
|---|---|---|
| High | Reproduce parent empirical results | Verify the R pipeline and clean county table, including unit definitions and sample inclusion |
| High | Make calibration auditable | Publish how α/β was chosen, justify α vs β separately and retain fitted uncertainty |
| High | Quantify model uncertainty | Report runs, seed strategy, quantiles, means and sampling variability |
| Medium | Align equilibrium and regression | Test an intercept/constant term rather than pretending the negative observed intercept is zero |
| Medium | Add temporal data | Obtain historical county-year outlet densities to estimate transition rates |
| Medium | Include spatial mechanisms | County interactions, urbanicity, competing retail locations, geography |
| Future | Evaluate policy causally | Identify observed interventions and use an appropriate counterfactual design |

This is an exploratory modeling extension appropriate for reproducible demonstrations and hypothesis development, not standalone empirical policy guidance.
