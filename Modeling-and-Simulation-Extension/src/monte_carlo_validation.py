"""Additional 1,000-run stochastic robustness check (not in original PDF)."""
import argparse
import csv
from pathlib import Path
import numpy as np
from simulation import simulate, ALPHA, F0, SIGMA, T

def main(n, out):
    if n < 2:
        raise ValueError("At least two independent runs are required")
    out.mkdir(parents=True,exist_ok=True)
    cases=[("low",.35,.15),("medium",.45,.15),("high",.55,.15),("higher_constraint",.45,.30)]
    rows=[]
    for name,g,beta in cases:
        values=np.array([simulate(T,F0,g,ALPHA,beta,SIGMA,10_000+i)[-30:].mean()
                         for i in range(n)])
        rows.append({"scenario":name,"gini":g,"beta":beta,"theoretical_F_star":ALPHA*g/beta,
                     "mean_across_runs":values.mean(),"sd_across_runs":values.std(ddof=1),
                     "q025":np.quantile(values,.025),"q975":np.quantile(values,.975),"runs":n})
    with (out/"supplemental_monte_carlo.csv").open("w",newline="",encoding="utf-8") as fp:
        writer=csv.DictWriter(fp,fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)
    for row in rows:
        print(row)
    print("These are distributional summaries of simulation runs, NOT confidence intervals for empirical policy effects.")

if __name__=="__main__":
    p=argparse.ArgumentParser()
    p.add_argument("--runs",type=int,default=1000)
    p.add_argument("--results-dir",type=Path,default=Path("results"))
    args=p.parse_args()
    main(args.runs,args.results_dir)
