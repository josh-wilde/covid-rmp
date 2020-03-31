# Functions to clean the different CSV files

source('config.R')

#####
# COVID data
#####

clean_csse_ts <- function(fpath, fname, col_name){
  by_state_col <- paste0(col_name, '_by_state')
  
  read_csv(file.path(fpath, fname)) %>%
    clean_names() %>% # clean the column names
    select(uid, fips, state=province_state, matches('x\\d{1,2}_\\d{1,2}_\\d{1,2}')) %>% 
    pivot_longer(cols = matches('x\\d{1,2}_\\d{1,2}_\\d{1,2}'), 
                 names_to = 'date', 
                 values_to = col_name) %>% 
    group_by(uid, fips, state) %>% 
    summarise(!!col_name := sum(!!sym(col_name))) %>% 
    ungroup() %>% 
    group_by(state) %>% 
    mutate(!!by_state_col := sum(!!sym(col_name))) %>% 
    ungroup() %>% 
    mutate(fips = as.numeric(fips))
}




#####
# Claritas
#####

clean_claritas_popfacts_xl <- function(fpath, fname) {
  read_excel(file.path(fpath, fname)) %>%
    clean_names() %>% # clean the column names
    mutate(fips = as.numeric(comp_gcode)) %>% 
    select(comp_geo_level, comp_gcode, fips, everything()) 
}

clean_claritas_hc_xl <- function(fpath, fname) {
  read_excel(file.path(fpath, fname)) %>%
    clean_names() %>% # clean the column names
    mutate(fips = as.numeric(cty_gcode)) %>% 
    select(cty_gcode, fips, everything()) 
}

#####
# CDC Heart Atlas
#####

clean_cdc_atlas <- function(fpath, fname) {
  read_csv(file.path(fpath, fname)) %>% 
    clean_names() %>% 
    mutate(display_name = str_remove_all(display_name, '("|\\(|\\))'),
           fips = cnty_fips) %>% 
    select(fips, everything())
}

#####
# Kaiser
#####

clean_kaiser_xl <- function(fpath, fname) {
  read_excel(file.path(fpath, fname)) %>%
    clean_names() %>% # clean the column names
    mutate(fips = as.numeric(cnty_fips)) %>% 
    select(cnty_fips, fips, everything()) 
}

