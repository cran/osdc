## ----setup--------------------------------------------------------------------
#| message: false
library(osdc)


## -----------------------------------------------------------------------------
# Only showing first 2
registers() |> 
  head(2)


## -----------------------------------------------------------------------------
registers() |> 
  names()


## -----------------------------------------------------------------------------
register_data <- registers() |> 
  names() |> 
  simulate_registers() |> 
  purrr::map(duckplyr::as_duckdb_tibble) |> 
  # Convert to a DuckDB connection, as duckplyr is still
  # in early development, while the DBI-DuckDB connection
  # is more stable.
  purrr::map(duckplyr::as_tbl) 

# Show only the first two items.
register_data |> 
  head(2)


## -----------------------------------------------------------------------------
classified_diabetes <- classify_diabetes(
  kontakter = register_data$kontakter,
  diagnoser = register_data$diagnoser,
  lpr_diag = register_data$lpr_diag,
  lpr_adm = register_data$lpr_adm,
  sysi = register_data$sysi,
  sssy = register_data$sssy,
  lab_forsker = register_data$lab_forsker,
  bef = register_data$bef,
  lmdb = register_data$lmdb
) |> 
  dplyr::collect()

classified_diabetes

