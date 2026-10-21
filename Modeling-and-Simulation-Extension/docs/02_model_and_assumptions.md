# 2. Mathematical Model and Assumptions

## 2.1 Update equation

The uploaded research manuscript specifies

$$F_{t+1}=(1-\beta)F_t+\alpha G+\epsilon_t,\quad\epsilon_t\sim\mathcal N(0,\sigma^2).$$

The Appendix Python implementation then enforces nonnegativity:

$$F_{t+1}=\max\{0,(1-\beta)F_t+\alpha G+\epsilon_t\}.$$

These equations are **not identical as stochastic processes**. When the zero floor binds, it changes the expected outcome; the closed-form equilibrium below pertains strictly to the untruncated version or the corresponding deterministic approximation.

## 2.2 Parameter definitions

| Parameter | Default | Meaning | Caution |
|---|---:|---|---|
| F0 | 6.0 | Starting density (outlets per 10,000 people) | Not a 2023 observed county average |
| G | .35, .45, .55 | Constant Gini index by scenario | Not time-varying |
| α | 3.59 | Assumed Gini-associated market input | Not identified as a causal effect |
| β | .15 | Density-proportional adjustment / damping | Not a measured zoning-policy coefficient |
| σ | 1.5 | SD of i.i.d. Gaussian noise | Assumed distribution, not residual fit |
| T | 120 | Number of steps | No years/months mapping |
| seed | 42 | Reproducibility of single trajectories | Not robust uncertainty analysis alone |

The paper calls β a 'saturation parameter.' Unlike a logistic carrying capacity, the term **−βF** is proportional damping. A change in β may be *interpreted* as more constraints for an illustrative experiment, but the model does not directly identify market saturation, firm competition or any particular policy.

## 2.3 Equilibrium and stability

Assume fixed G, zero-mean shocks and no floor. Solving F* = (1−β)F* + αG gives

$$F^*=\frac{\alpha}{\beta}G.$$

The solution is dynamically stable in expectation if |1−β| < 1 (equivalently 0 < β < 2). For the experimental β ∈ [.05, .35], this condition holds.

Sensitivities are:

$$\frac{\partial F^*}{\partial G}=\frac{\alpha}{\beta}>0,\qquad
\frac{\partial F^*}{\partial\beta}=-\frac{\alpha G}{\beta^2}<0.$$

The β response is **inverse/hyperbolic, not exponential**. At fixed G, doubling β halves the *theoretical* equilibrium.

## 2.4 Random variation

The code uses independent normally distributed innovations ε with SD = 1.5. For the untruncated stationary linear AR(1), the stationary variance is

$$\operatorname{Var}(F)=\frac{\sigma^2}{1-(1-\beta)^2}.$$

This is an *assumed mathematical property*, not a fitted Virginia variability estimate. The code deliberately reuses the same NumPy seed between compared scenarios (**common random numbers**) to make visual comparisons consistent. The supplemental Monte Carlo uses different seeds to examine distributional variation.

## 2.5 No claim of temporal or spatial fit

The source PDF mentions county-level datasets for calibrating and qualitatively comparing model outputs, but its Appendix does not import them. There is no implemented county-by-county state vector, explicit spatial process, or year-by-year calibration. This section documents the model *as implemented*, rather than filling these gaps with invented evidence.
