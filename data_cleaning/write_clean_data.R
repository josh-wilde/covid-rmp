# Execute data cleaning
source('config.R')
source('./data_cleaning/lib_clean_data.R')

# Where should the clean files go
clean_path <- file.path(data_dir, 'clean_data')

#####
# COVID data
#####

# Deaths
clean_csse_ts(fpath = file.path(data_dir, 'COVID-19', 'csse_covid_19_data', 'csse_covid_19_time_series'),
              fname = 'time_series_covid19_deaths_US.csv',
              col_name = 'covid_cumul_deaths') %>% 
  write_csv(file.path(clean_path, 'covid_cumul_deaths.csv'))

# Cases
clean_csse_ts(fpath = file.path(data_dir, 'COVID-19', 'csse_covid_19_data', 'csse_covid_19_time_series'),
              fname = 'time_series_covid19_confirmed_US.csv',
              col_name = 'covid_cumul_cases')  %>% 
  write_csv(file.path(clean_path, 'covid_cumul_confirmed.csv'))

#####
# Claritas
#####

# Population by age and sex
clean_claritas_popfacts_xl(fpath = file.path(data_dir, 'Claritas Data Files (Demographic)'),
               fname = 'Pop-Facts 2020 Pop by Age and Sex_County.xlsx') %>% 
  write_csv(file.path(clean_path, 'claritas_pop_age_sex_fips.csv'))

# Other population facts
clean_claritas_popfacts_xl(fpath = file.path(data_dir, 'Claritas Data Files (Demographic)'),
                           fname = 'Pop-Facts2020Special_County.xlsx') %>% 
  write_csv(file.path(clean_path, 'claritas_other_demo_fips.csv'))

# Hospital facilities
clean_claritas_hc_xl(fpath = file.path(data_dir, 'Claritas Data Files (Demographic)'),
                     fname = 'healthcare facilities by county_.xlsx') %>% 
  rename_at(vars(starts_with('x')), list(~str_remove(., 'x\\d{6}_'))) %>% 
  write_csv(file.path(clean_path, 'claritas_hc_fips.csv'))

#####
# CDC Heart Atlas
#####

# Cardio deaths, percent white, percent 65+, total_pop
clean_cdc_atlas(fpath = file.path(data_dir, 'CDC Heart Atlas Data Files'),
                fname = 'hdatlas_cardio_deaths.csv') %>% 
  write_csv(file.path(clean_path, 'cdc_atlas_cardio_deaths.csv'))  

# Cardio hosp, diabetes, obesity, activity
clean_cdc_atlas(fpath = file.path(data_dir, 'CDC Heart Atlas Data Files'),
                fname = 'hdatlas_cardio_hosp.csv') %>% 
  write_csv(file.path(clean_path, 'cdc_atlas_cardio_hosp.csv'))

# Hypertension hosp, SNAP pct, median home value, median income, poverty pct
clean_cdc_atlas(fpath = file.path(data_dir, 'CDC Heart Atlas Data Files'),
                fname = 'hdatlas_hypertension_hosp.csv') %>% 
  write_csv(file.path(clean_path, 'cdc_atlas_hypertension_hosp.csv'))

# Num of hospitals
clean_cdc_atlas(fpath = file.path(data_dir, 'CDC Heart Atlas Data Files'),
                fname = 'hdatlas_n_hospitals.csv') %>% 
  write_csv(file.path(clean_path, 'cdc_atlas_n_hospitals.csv'))

# Urban/Rural
clean_cdc_atlas(fpath = file.path(data_dir, 'CDC Heart Atlas Data Files'),
                fname = 'hdatlas_urban_rural.csv') %>% 
  write_csv(file.path(clean_path, 'cdc_atlas_urban.csv'))