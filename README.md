# Data-Driven Geographic and Socioeconomic Determinants of Fast-Food Density and Public Health Outcomes in Virginia

**Author:** Geonwoo Roh
**Degree:** Bachelor of Science, Computational and Data Science
**Institution:** George Mason University, Fairfax, VA
**Capstone Director:** Dr. Kent Miller
**Term:** Fall Semester 2025

A capstone project submitted in partial fulfillment of the requirements for the degree of Bachelor of Science at George Mason University.

---

## Abstract

This capstone project examines how fast-food restaurant density, socioeconomic
characteristics, and public health outcomes in Virginia's counties are interrelated
through multi-source data (OpenStreetMap, American Community Survey, and County
Health Rankings 2023). The project incorporates economic and health indicators
along with geospatially based data to identify potential structural inequalities
within the food environment. Fast-food restaurant density (per 10,000 residents)
was calculated for each Virginia county and compared against socioeconomic
indicators including median household income, the Gini Index of income inequality,
and the percentage of adults (18+) who are obese. ANOVA, Pearson correlation, and
linear regression were used to test whether county-level economic and health
indicators predict the degree of fast-food density.

**Key findings:**

- There is **no statistically significant association** between fast-food density and
  median county income (linear regression p = 0.38, ANOVA p = 0.387).
- The **Gini Index** of income inequality has a **weak but statistically significant
  positive relationship** with fast-food density (p = 0.018, R² ≈ 0.044). Counties
  with higher income inequality tend to have higher fast-food density.
- Fast-food density alone is **not a significant community-level predictor** of adult
  obesity rates in Virginia (regression p = 0.566, R² ≈ 0.003).

These results suggest that structural socioeconomic inequalities, more than
absolute income, shape the commercial food environment, and that community health
is influenced by a broader set of social, environmental, and behavioral factors
than fast-food availability alone.

---

## Repository structure

```
Capstone-Project/
├── README.md                 # This file
├── docs/
│   └── Capstone-Project.pdf  # Original capstone document (PDF)
├── paper/                    # Manuscript split into Markdown chapters
│   ├── 01-abstract.md
│   ├── 02-introduction.md
│   ├── 03-prior-research.md
│   ├── 04-data.md
│   ├── 05-theory.md
│   ├── 06-results.md
│   ├── 07-conclusion.md
│   └── 08-bibliography.md
└── code/
    └── analysis.R            # R script for the full analysis pipeline
```

---

## Data sources

| Dataset | Source | Variables used |
| --- | --- | --- |
| Fast-food restaurants | OpenStreetMap Overpass API (`amenity=fast_food`) | Latitude, longitude, name |
| County boundaries | U.S. Census Bureau TIGER/Line (via `tigris`) | GEOID, NAME, geometry |
| Population and income | American Community Survey 5-Year 2023 (via `tidycensus`) | `B01003_001`, `B19013_001`, `B19083_001`, `B19081` |
| Adult obesity | 2023 County Health Rankings & Roadmaps | % adults with BMI ≥ 30 |

All datasets are filtered to Virginia counties and joined by FIPS / GEOID.

---

## How to reproduce

The analysis is implemented entirely in R. To reproduce:

1. Install R (≥ 4.2) and the packages listed below.
2. Obtain a [U.S. Census API key](https://api.census.gov/data/key_signup.html)
   and set it with `tidycensus::census_api_key("YOUR_KEY", install = TRUE)`.
3. Download the OSM fast-food extract for Virginia as `fastfood_va.geojson`
   (Overpass query: `[out:json][timeout:60]; area["ISO3166-2"="US-VA"]->.va; (node["amenity"="fast_food"](area.va); way["amenity"="fast_food"](area.va);); out center;`).
4. Download the `2023 County Health Rankings Virginia Data - v3.xlsx` file
   from the County Health Rankings website.
5. Place both files in your working directory and run:

```r
source("code/analysis.R")
```

### Required R packages

```
sf, tidyverse, dplyr, tigris, tidycensus,
readr, stringr, ggplot2, viridis, cowplot, readxl
```

---

## Methods at a glance

1. **Geospatial cleaning** — Load OSM points, normalize CRS to WGS84, convert
   non-point geometries via `st_point_on_surface()`, deduplicate by OSM ID, and
   drop entries without business names.
2. **County assignment & density** — Spatial join restaurants to Virginia
   counties; compute `fastfood_per10k = (restaurants / population) * 10,000`.
3. **Socioeconomic integration** — Pull ACS median income, Gini, and quintile
   ratios; compute top-20 / bottom-20 income ratio.
4. **Health integration** — Join 2023 County Health Rankings adult obesity rate
   by FIPS / GEOID.
5. **Statistical analysis** — Tertile counties by income; run one-way ANOVA with
   Tukey HSD; fit simple and multiple linear regressions
   (`fastfood_per10k ~ median_income`, `~ median_income + gini + income_ratio`,
   `obesity_rate ~ fastfood_per10k`).
6. **Visualization** — `ggplot2` + `viridis` choropleths for population,
   fast-food counts, density per 10k, median income, Gini index, and obesity.

---

## Citation

If you reference this work, please cite as:

> Roh, G. (2025). *Data-Driven Geographic and Socioeconomic Determinants of
> Fast-Food Density and Public Health Outcomes in Virginia.* Capstone project,
> Bachelor of Science in Computational and Data Science, George Mason
> University.

---

## License

The original manuscript is © 2025 Geonwoo Roh. All rights reserved.
Code in this repository is provided for academic reproducibility; please contact
the author before redistribution or derivative use.
