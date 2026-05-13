# =============================================================================
# Data-Driven Geographic and Socioeconomic Determinants of Fast-Food Density
# and Public Health Outcomes in Virginia
#
# Capstone Project — Geonwoo Roh, George Mason University, Fall 2025
#
# Full analysis pipeline:
#   1. Load packages
#   2. Read and clean OpenStreetMap fast-food data
#   3. Build county boundaries, join restaurants, compute counts + density
#   4. Pull ACS population, median income, Gini, and quintile income variables
#   5. Pull 2023 County Health Rankings adult-obesity rates
#   6. Produce choropleth maps
#   7. Run ANOVA (income tertile groups) and Tukey HSD
#   8. Fit linear regressions (income, Gini, obesity)
# =============================================================================

##############################################################################
# 0. Load packages & options
##############################################################################
library(sf)
library(tidyverse)
library(dplyr)
library(tigris)
library(tidycensus)
library(readr)
library(stringr)
library(ggplot2)
library(viridis)
library(cowplot)
library(readxl)

options(tigris_use_cache = TRUE)

# NOTE: requires a Census API key set via:
#   tidycensus::census_api_key("YOUR_KEY", install = TRUE)

##############################################################################
# 1. Read & clean Fast-Food OSM data
##############################################################################
# Expects `fastfood_va.geojson` in the working directory (Overpass query for
# amenity=fast_food in Virginia).
ff <- st_read("fastfood_va.geojson", quiet = TRUE)

# Set CRS if missing and transform to WGS84
if (is.na(st_crs(ff))) st_crs(ff) <- 4326
ff <- st_transform(ff, 4326)

# Convert non-point geometries to point centroids
if (!all(st_geometry_type(ff) %in% c("POINT", "MULTIPOINT"))) {
  ff <- st_point_on_surface(ff)
}

# Remove duplicates by OSM ID
if ("id" %in% names(ff)) {
  ff <- ff |> distinct(id, .keep_all = TRUE)
}
nrow(ff)

# Select core columns
core_cols <- c(
  "id", "name", "brand", "amenity", "cuisine",
  "addr:city", "addr:street", "addr:housenumber"
)

ff_clean <- ff |>
  select(any_of(core_cols), geometry) |>
  filter(!is.na(name))           # drop rows without a name

ff_attr <- ff_clean |> st_drop_geometry()

unknown_names <- ff_attr |>
  filter(is.na(brand), !is.na(name)) |>
  count(name, sort = TRUE)

##############################################################################
# 2. County boundaries + fast-food counts, population, income
##############################################################################
va_cnty <- counties(state = "VA", year = 2023, cb = TRUE, class = "sf") |>
  st_transform(4326) |>
  select(GEOID, NAME, geometry)

ff_join <- st_join(ff_clean, va_cnty, join = st_within) |>
  filter(!is.na(GEOID))

ff_count <- ff_join |>
  st_drop_geometry() |>
  count(GEOID, NAME, name = "fastfood_count") |>
  arrange(desc(fastfood_count))

brand_col <- intersect(c("brand", "name"), names(ff_join))[1]

ff_brand <- ff_join |>
  st_drop_geometry() |>
  mutate(
    chain = if (!is.null(brand_col)) .data[[brand_col]] else NA_character_,
    chain = ifelse(is.na(chain), "Unknown", str_squish(chain))
  ) |>
  count(chain, sort = TRUE)

# Population (ACS 2023 5-Year)
pop <- get_acs(
  geography = "county",
  variables = "B01003_001",
  state     = "VA",
  year      = 2023,
  survey    = "acs5",
  geometry  = FALSE
) |>
  select(GEOID, population = estimate)

ff_den <- ff_count |>
  left_join(pop, by = "GEOID") |>
  mutate(fastfood_per10k = (fastfood_count / population) * 10000)

write_csv(ff_den, "va_fastfood_by_county.csv")

ff_den |> arrange(desc(fastfood_per10k)) |> head(10)

# Median income, Gini, income quintiles
income_va <- get_acs(
  geography = "county",
  state     = "VA",
  year      = 2023,
  survey    = "acs5",
  variables = c(
    median_income = "B19013_001",
    gini          = "B19083_001",
    bottom20      = "B19081_001",
    top20         = "B19081_005"
  ),
  geometry = FALSE
)

income_va <- income_va |>
  select(GEOID, NAME, variable, estimate) |>
  tidyr::pivot_wider(
    names_from  = variable,
    values_from = estimate
  ) |>
  mutate(income_ratio = top20 / bottom20)

va_final <- ff_den |>
  left_join(income_va, by = "GEOID")

##############################################################################
# 3. MAPS
##############################################################################
va_map <- va_cnty |> left_join(ff_den, by = c("GEOID", "NAME"))

# Fast-food count
ggplot(va_map) +
  geom_sf(aes(fill = fastfood_count), color = "white", linewidth = 0.1) +
  scale_fill_viridis(option = "C", direction = -1) +
  labs(
    title   = "Fast-Food Restaurants by County - Virginia",
    fill    = "Count",
    caption = "OSM + ACS 2023"
  ) +
  theme_minimal()

# Density per 10k
ggplot(va_map) +
  geom_sf(aes(fill = fastfood_per10k), color = "white", linewidth = 0.1) +
  scale_fill_viridis(option = "C", direction = -1) +
  labs(
    title   = "Fast-Food Density per 10,000 Residents - Virginia",
    fill    = "Per 10k",
    caption = "OSM + ACS 2023"
  ) +
  theme_minimal()

# Median income choropleth (with geometry from ACS)
va_income_map <- get_acs(
  geography = "county",
  state     = "VA",
  year      = 2023,
  survey    = "acs5",
  variables = c(median_income = "B19013_001"),
  geometry  = TRUE
) |>
  select(GEOID, NAME, median_income = estimate, geometry)

ggplot(va_income_map) +
  geom_sf(aes(fill = median_income), color = "white", size = 0.1) +
  scale_fill_viridis(option = "C", direction = -1) +
  labs(title = "Median Household Income (ACS 2023)", fill = "Income") +
  theme_minimal()

# Gini choropleth
va_gini_map <- get_acs(
  geography = "county",
  state     = "VA",
  year      = 2023,
  survey    = "acs5",
  variables = c(gini = "B19083_001"),
  geometry  = TRUE
) |>
  select(GEOID, NAME, gini = estimate, geometry)

ggplot(va_gini_map) +
  geom_sf(aes(fill = gini), color = "white", size = 0.1) +
  scale_fill_viridis(option = "A", direction = -1) +
  labs(title = "Income Inequality (Gini Index)", fill = "Gini") +
  theme_minimal()

# Population choropleth
pop_va <- get_acs(
  geography = "county",
  state     = "VA",
  year      = 2023,
  survey    = "acs5",
  variables = "B01003_001",
  geometry  = FALSE
) |>
  select(GEOID, population = estimate)

va_pop_map <- va_cnty |> left_join(pop_va, by = "GEOID")

ggplot(va_pop_map) +
  geom_sf(aes(fill = population), color = "white", size = 0.1) +
  scale_fill_viridis(option = "C", direction = -1, labels = scales::comma) +
  labs(title = "Population by County (ACS 2023)", fill = "Population") +
  theme_minimal()

# Obesity choropleth from County Health Rankings
health <- read_excel(
  "2023 County Health Rankings Virginia Data - v3.xlsx",
  sheet = "Ranked Measure Data",
  skip  = 1
)

health <- health |>
  mutate(FIPS = str_pad(as.character(FIPS), 5, pad = "0"))

obesity_cols <- names(health)[str_detect(names(health), "Obesity")]

health_obesity <- health |>
  select(FIPS, County, all_of(obesity_cols))

va_obesity_map <- va_cnty |>
  left_join(health_obesity, by = c("GEOID" = "FIPS"))

obesity_col_map <- names(va_obesity_map)[
  str_detect(names(va_obesity_map), "Obesity")
][1]

ggplot(va_obesity_map) +
  geom_sf(
    aes(fill = .data[[obesity_col_map]]),
    color = "white", size = 0.1
  ) +
  scale_fill_viridis(option = "C", direction = -1) +
  labs(title = "% Adults with Obesity (2023)", fill = "% Obesity") +
  theme_minimal()

##############################################################################
# 4. ANOVA
##############################################################################
va_final_anova <- va_final |>
  filter(!is.na(median_income), !is.na(fastfood_per10k)) |>
  mutate(
    income_group = ntile(median_income, 3),
    income_group = factor(income_group, labels = c("Low", "Mid", "High"))
  )

va_final_anova |>
  group_by(income_group) |>
  summarise(
    count         = n(),
    mean_fastfood = mean(fastfood_per10k),
    sd_fastfood   = sd(fastfood_per10k),
    .groups       = "drop"
  )

anova_result <- aov(fastfood_per10k ~ income_group, data = va_final_anova)
summary(anova_result)
TukeyHSD(anova_result)

##############################################################################
# 5. Regression Models
##############################################################################
cor(va_final$fastfood_per10k, va_final$median_income, use = "complete.obs")
cor(va_final$fastfood_per10k, va_final$gini,          use = "complete.obs")
cor(va_final$fastfood_per10k, va_final$income_ratio,  use = "complete.obs")

merged <- va_final |>
  left_join(health_obesity, by = c("GEOID" = "FIPS"))

obesity_col <- names(merged)[str_detect(names(merged), "Obesity")][1]

cor_value <- cor(
  merged$fastfood_per10k, merged[[obesity_col]],
  use = "complete.obs"
)
print(paste("Correlation with Obesity:", round(cor_value, 3)))

# Fast-food density ~ Gini
model_gini <- lm(fastfood_per10k ~ gini, data = merged)
summary(model_gini)

ggplot(merged, aes(x = gini, y = fastfood_per10k)) +
  geom_point(color = "steelblue") +
  geom_smooth(method = "lm", color = "red") +
  labs(
    title = "Fast-Food Density vs. Gini Index",
    x     = "Gini Index",
    y     = "Fast-Food Restaurants per 10k residents"
  ) +
  theme_minimal()

# Fast-food density ~ median income
lm_income <- lm(fastfood_per10k ~ median_income, data = merged)
summary(lm_income)

ggplot(merged, aes(x = median_income, y = fastfood_per10k)) +
  geom_point() +
  geom_smooth(method = "lm", color = "blue") +
  labs(
    title = "Fast-Food Density vs. Median Income",
    x     = "Median Household Income",
    y     = "Fast-Food per 10k"
  ) +
  theme_minimal()

# Obesity ~ fast-food density
ggplot(merged, aes(x = fastfood_per10k, y = .data[[obesity_col]])) +
  geom_point(color = "steelblue") +
  geom_smooth(method = "lm", color = "red") +
  labs(
    title = "Fast-Food Density vs. % Adults with Obesity",
    x     = "Fast-Food Restaurants per 10k",
    y     = "% Adults with Obesity"
  ) +
  theme_minimal()
