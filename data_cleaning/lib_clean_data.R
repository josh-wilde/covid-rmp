# Functions to clean the different CSV files

source('config.R')

#####
# COVID data
#####

clean_csse_ts <- function(fpath, fname, col_name, clean_path, clean_fname){
  read_csv(file.path(fpath, fname)) %>%
    clean_names() %>% # clean the column names
    select(fips, matches('x\\d{1,2}_\\d{1,2}_\\d{1,2}')) %>% 
    pivot_longer(cols = -fips, 
                 names_to = 'date', 
                 values_to = col_name) %>% 
    group_by(fips) %>% 
    summarise(!!col_name := sum(!!sym(col_name))) %>% 
    mutate(fips = as.numeric(fips)) %>% 
    filter(fips >= 1000 & fips < 80000) %>%  # excludes cruises, KC, Nantucket, couple "out of" areas, and islands/territories
    write_csv(file.path(clean_path, clean_fname))
}

# Deaths
clean_csse_ts(fpath = file.path(data_dir, 'COVID-19', 'csse_covid_19_data', 'csse_covid_19_time_series'),
              fname = 'time_series_covid19_deaths_US.csv',
              col_name = 'covid_cumul_deaths',
              clean_path = file.path(data_dir, 'clean_data'),
              clean_fname = 'covid_cumul_deaths.csv')

# Cases
clean_csse_ts(fpath = file.path(data_dir, 'COVID-19', 'csse_covid_19_data', 'csse_covid_19_time_series'),
              fname = 'time_series_covid19_confirmed_US.csv',
              col_name = 'covid_cumul_cases',
              clean_path = file.path(data_dir, 'clean_data'),
              clean_fname = 'covid_cumul_confirmed.csv')  

#####
# Claritas
#####

clean_claritas <- function(fpath, fname, clean_path, clean_fname) {
  read_excel(file.path(fpath, fname)) %>%
    clean_names() %>% # clean the column names
    mutate(fips = as.numeric(comp_gcode)) %>% 
    select(comp_geo_level, comp_gcode, fips, everything()) %>% 
    write_csv(file.path(clean_path, clean_fname))
}

# Population
clean_claritas(fpath = file.path(data_dir, 'Claritas Data Files (Demographic)'),
               fname = 'Pop-Facts 2020 Pop by Age and Sex_County.xlsx',
               clean_path = file.path(data_dir, 'clean_data'),
               clean_fname = 'claritas_pop_age_sex_fips.csv')

#####
# CDC Heart Atlas
#####

fpath <- file.path(data_dir, 'CDC Heart Atlas Data Files')


