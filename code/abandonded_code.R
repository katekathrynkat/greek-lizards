# ABANDONED CODE :(

# Abandoned code stippets that I'd rather not delete in case they're weirdly helpful in the future
# Heads up, none of this code will run because it's disconnected from the necessary data and packages in the original Rmd files
# Code snippets are organized according to the Rmd files they came from


# 01_data_wrangling.Rmd ---------------------------------

# * * * TRAPPING EFFORT --------------------------------

# I don't think that "trapping effort" really means anything for these data, since we're arbitrarily combining units for sticky trap effort and pitfall trap effort. There's also no way to standardize diet data since the lizards were caught at different times of day and stomach contents are highly temporal. I think we're limited to using RELATIVE ABUNDANCE measures.

# Trapping effort for PREY
# prey_effort.csv: total trapping effort at each site for pitfall and sticky traps (max = 24 = 12 sticky + 12 pitfall), one row per site
prey_effort <- bind_rows(pitfall, sticky) %>% 
  select(island, site, trap, trap_id, type, condition) %>% 
  mutate(
    sticky_effort = case_when(
      type=='sticky' & condition=='GOOD' ~ 1,
      type=='sticky' & condition=='FLAW' ~ 0.5,
      TRUE ~ 0
    ),
    pitfall_effort = case_when(
      type=='pitfall' & condition=='GOOD' ~ 1,
      type=='pitfall' & condition=='FLAW' ~ 0.5,
      TRUE ~ 0
    )
  ) %>% 
  group_by(island, site) %>% 
  summarize_at(c('sticky_effort', 'pitfall_effort'), sum) %>% 
  mutate(effort = (sticky_effort + pitfall_effort))
write_csv(prey_effort, 'output_data/prey_effort.csv', col_names=TRUE)

# Trapping effort for DIET
# diet_effort.csv: total number of lizards pumped at each site, one row per site
diet_effort <- diet %>% 
  group_by(island, site) %>% 
  tally(name = 'n_lizards')
write_csv(diet_effort, 'output_data/diet_effort.csv', col_names=TRUE)


