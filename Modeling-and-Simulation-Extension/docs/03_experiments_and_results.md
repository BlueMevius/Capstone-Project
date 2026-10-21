# 3. Simulation Experiments and Results

The source PDF contains four figures (PDF pp. 3–6). The companion Python implementation [simulation.py](../src/simulation.py) reproduces their **numerical algorithm, seed and settings** and saves PNGs and CSVs after running. No charts in this document represent observed Virginia counties.

## Figure 1 — Time-series trajectories for three Gini scenarios

Hold α = 3.59, β = .15, σ = 1.5 and F0 = 6 fixed; run 120 steps with G = .35, .45 and .55.

| G | Analytical F* (outlets per 10,000) |
|---|---:|
| .35 | 8.377 |
| .45 | 10.770 |
| .55 | 13.163 |

Higher G yields higher modeled equilibrium because the **αG input is specified to be positive**. The paths use a shared random-number stream and so fluctuate with similar shapes. This is an internal model result, not a causal estimate.

## Figure 2 — Analytical inequality gradient

For β = .15, the equilibrium curve is

$$F^*=\frac{3.59}{0.15}G\approx23.9333G.$$

It is a mathematical straight line, not a scatterplot regression on county observations. Its slope closely matches the original capstone's verified empirical slope **23.939**, while **omitting the capstone regression's intercept −4.377**. This distinction matters when interpreting levels.

## Figure 3 — Sensitivity to β

Fix G = .45 and sweep β from .05 to .35 in 16 evenly spaced increments.

| β | Analytical F* |
|---:|---:|
| .05 | 32.310 |
| .10 | 16.155 |
| .15 | 10.770 |
| .20 | 8.078 |
| .25 | 6.462 |
| .30 | 5.385 |
| .35 | 4.616 |

The source paper compares each theoretical point with the **last 30 steps of one noisy trajectory**. These values can noticeably differ: at β=.15, G=.45 and seed 42, the last-30 average is **8.065** compared with theoretical **10.770**. This is not evidence of close numerical agreement from that single path; random-seed robustness must be analyzed separately.

The curve is **inverse** in β, not exponential.

## Figure 4 — Policy-shock thought experiment

At step **50**, change β from .15 to .30 while retaining G=.45, α=3.59 and the same random innovations. The calculated nontruncated equilibrium changes from 10.770 to 5.385 (exactly **−50%**); the trajectory gradually adjusts with noise. This **does not** imply any actual zoning policy would halve Virginia outlet density.

## New supplement — 1,000-run Monte Carlo

The extra [monte_carlo_validation.py](../src/monte_carlo_validation.py) script runs 1,000 trajectories with distinct seeds for each setting. The cross-run summary of *each run's final 30-step average* (not a regression confidence interval):

| G | β | Theoretical F* | Mean across runs | Run-average 2.5%–97.5% quantiles |
|---:|---:|---:|---:|---:|
| .35 | .15 | 8.377 | 8.312 | 5.389–11.443 |
| .45 | .15 | 10.770 | 10.699 | 7.733–13.837 |
| .55 | .15 | 13.163 | 13.092 | 10.126–16.230 |
| .45 | .30 | 5.385 | 5.357 | 3.841–7.055 |

These results verify robustness **within the assumed stochastic equation**, not predictive power for any observed Virginia county. Values are reproducible with the supplied numerical code and seeds.
