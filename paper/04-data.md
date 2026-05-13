# Chapter 3: Data

## 3.1 Fast-Food Restaurant Data

Specific fast-food restaurant location data were retrieved using the
OpenStreetMap (OSM) Overpass API. Queries filtered for establishments tagged
as `amenity=fast_food` across all counties and independent cities in
Virginia. The data included latitude, longitude, and business name. For
aggregation and density by county, latitude and longitude were geospatially
joined with county-level geometries constructed from the U.S. Census
Bureau's TIGER/Line shapefiles.

## 3.2 Population and Income Data

Demographic data were gathered for total population and median household
income by county through the `tidycensus` R package, utilizing the U.S.
Census Bureau's 2023 American Community Survey (ACS) 5-Year Estimates. FIPS
codes were added to ensure that the data were spatially aligned for
analysis.

## 3.3 Health Data

County-level health outcomes were sourced from the 2023 County Health
Rankings & Roadmaps dataset, provided by the University of Wisconsin
Population Health Institute and the Robert Wood Johnson Foundation. The
variable of interest was **Adult Obesity**, defined as the percentage of
adults (aged 20 and older) with a body mass index (BMI) of 30 or higher. The
dataset was filtered to retain Virginia counties only, and joined to the
primary dataset by county name and FIPS code.

## 3.4 Data Preprocessing and Analysis Workflow

### 3.4.1 Geospatial Data Cleaning

The fast-food restaurant dataset was obtained from OpenStreetMap using the
`amenity=fast_food` tag for all locations in Virginia. Using the `sf`
package, the data was loaded in GeoJSON format. If geometries were not of
type `POINT`, they were converted using `st_point_on_surface()` to ensure
spatial compatibility. Entries without valid business names were removed,
and duplicates were filtered by OpenStreetMap ID where available.

### 3.4.2 County Assignment and Density Calculation

Using TIGER/Line shapefiles accessed via the `tigris` package, county
boundaries for Virginia were imported. A spatial join (`st_join`) was
performed to assign each restaurant to its containing county. The number of
fast-food restaurants per county was then counted, and population data from
the ACS 2023 dataset (`B01003_001`) was joined via the `tidycensus` API.
Fast-food density per 10,000 residents was calculated as:

$$
\text{Fast-Food Density} = \frac{\text{Number of Restaurants}}{\text{Total Population}} \times 10{,}000
$$

### 3.4.3 Socioeconomic Variable Integration

Median household income (`B19013_001`), Gini index (`B19083_001`), and
income quintile ratios (`B19081`) were extracted from the 2023 ACS 5-Year
Estimates. After reshaping with `pivot_wider()`, a new variable was
calculated as the ratio between top and bottom income quintiles:

$$
\text{Income Ratio} = \frac{\text{Top 20\% Income}}{\text{Bottom 20\% Income}}
$$

These variables were joined with the fast-food density dataset using
`GEOID` as the primary key.

### 3.4.4 Health Data Integration

Adult obesity rates by county were extracted from the 2023 County Health
Rankings & Roadmaps Excel file. The FIPS codes were standardized and
matched with county `GEOID`s to ensure alignment. The obesity rate was
extracted as the percentage of adults with a BMI ≥ 30.

### 3.4.5 Statistical Analysis

Counties were categorized into tertiles (Low, Mid, High) based on median
household income using `ntile()` from the `dplyr` package. An ANOVA test
was conducted to assess the differences in fast-food density across income
groups:

$$
H_0: \mu_{\text{Low}} = \mu_{\text{Mid}} = \mu_{\text{High}}
\qquad
H_A: \text{at least one group differs}
$$

Tukey's HSD post-hoc test was used to identify which income groups
differed.

### 3.4.6 Regression Models

Two linear regression models were built:

1. **Fast-food density predicted by income:**

   $$
   \text{fastfood\_per10k} \sim \text{median\_income}
   $$

2. **Fast-food density predicted by all socioeconomic factors:**

   $$
   \text{fastfood\_per10k} \sim \text{median\_income} + \text{gini} + \text{income\_ratio}
   $$

Finally, a regression model was also used to estimate the relationship
between fast-food density and adult obesity rate:

$$
\text{obesity\_rate} \sim \text{fastfood\_per10k}
$$

### 3.4.7 Visualization

All maps were produced using `ggplot2` and `viridis` color scales.
County-level choropleths visualized:

- Raw fast-food counts
- Fast-food density per 10,000 residents
- Median household income
- Gini index
- Side-by-side comparison of density and income using `cowplot`

All processing, analysis, and visualization were conducted entirely within
the R environment.
