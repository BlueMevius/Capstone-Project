"""Reproduce the four numerical experiments from Modeling and Simulation PDF."""
from pathlib import Path
import argparse
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

ALPHA, BETA, SIGMA = 3.59, 0.15, 1.5
T, SEED, F0 = 120, 42, 6.0

def simulate(t_steps, f0, g, alpha, beta, sigma, seed, beta_after=None, shock_step=None):
    rng = np.random.default_rng(seed)
    f = np.empty(t_steps + 1)
    f[0] = f0
    for t in range(t_steps):
        b = beta_after if beta_after is not None and shock_step is not None and t >= shock_step else beta
        f[t + 1] = max(0.0, (1.0-b)*f[t] + alpha*g + rng.normal(0, sigma))
    return f

def draw(output_dir, results_dir):
    output_dir.mkdir(parents=True, exist_ok=True)
    results_dir.mkdir(parents=True, exist_ok=True)
    steps = np.arange(T + 1)
    gs = [.35, .45, .55]
    series = [simulate(T, F0, g, ALPHA, BETA, SIGMA, SEED) for g in gs]
    fig, ax = plt.subplots(figsize=(9, 5.5))
    for g, s in zip(gs, series):
        ax.plot(steps, s, label=f"G = {g:.2f}")
    ax.set(xlabel="Simulation step", ylabel="Density per 10,000",
           title="Time-series trajectories by inequality")
    ax.legend(); fig.tight_layout(); fig.savefig(output_dir/"fig1_inequality_time_series.png", dpi=200); plt.close(fig)
    np.savetxt(results_dir/"time_series.csv",np.column_stack([steps]+series),delimiter=",",
               header="step,gini_035,gini_045,gini_055",comments="")

    grid = np.linspace(.30, .60, 200)
    fig, ax = plt.subplots(figsize=(9, 5.5))
    ax.plot(grid, ALPHA/BETA*grid)
    ax.scatter(gs,[ALPHA/BETA*g for g in gs])
    ax.set(xlabel="Gini index", ylabel="Equilibrium density per 10,000",
           title="Theoretical model equilibrium F* = (alpha / beta) G")
    fig.tight_layout(); fig.savefig(output_dir/"fig2_equilibrium_gradient.png",dpi=200); plt.close(fig)

    betas = np.linspace(.05,.35,16)
    theory = ALPHA*.45/betas
    averages = np.array([simulate(T,F0,.45,ALPHA,b,SIGMA,SEED)[-30:].mean() for b in betas])
    fig,ax=plt.subplots(figsize=(9,5.5))
    ax.plot(betas,theory,label="Theoretical F*")
    ax.plot(betas,averages,label="One-seed mean, last 30 steps")
    ax.set(xlabel="Constraint / damping beta", ylabel="Density per 10,000",
           title="Sensitivity to beta")
    ax.legend();fig.tight_layout();fig.savefig(output_dir/"fig3_sensitivity_beta.png",dpi=200);plt.close(fig)
    np.savetxt(results_dir/"sensitivity_beta.csv",np.column_stack((betas,theory,averages)),
               delimiter=",",header="beta,theoretical,one_seed_last30_mean",comments="")

    baseline=series[1]
    shocked=simulate(T,F0,.45,ALPHA,.15,SIGMA,SEED,beta_after=.30,shock_step=50)
    fig,ax=plt.subplots(figsize=(9,5.5))
    ax.plot(steps,baseline,label="Baseline beta = 0.15")
    ax.plot(steps,shocked,label="Shock: beta = 0.30 from step 50")
    ax.axvline(50,ls="--",color="gray")
    ax.set(xlabel="Simulation step",ylabel="Density per 10,000",title="Hypothetical constraint shock")
    ax.legend();fig.tight_layout();fig.savefig(output_dir/"fig4_policy_shock.png",dpi=200);plt.close(fig)
    np.savetxt(results_dir/"policy_shock.csv",np.column_stack((steps,baseline,shocked)),
               delimiter=",",header="step,baseline,shock",comments="")
    print("G = 0.45, beta = 0.15: theory =",ALPHA*.45/.15,
          "single-seed final-30 mean =",baseline[-30:].mean())

if __name__=="__main__":
    p=argparse.ArgumentParser()
    p.add_argument("--figures-dir",type=Path,default=Path("figures"))
    p.add_argument("--results-dir",type=Path,default=Path("results"))
    args=p.parse_args()
    draw(args.figures_dir,args.results_dir)
