## ----setup--------------------------------------------------------------------
#| message: false
# install.packages("osdc")
library(osdc)


## -----------------------------------------------------------------------------
#| echo: false
registers() |>
  purrr::map_chr("name") |>
  knitr::kable(col.names = c("Register abbreviation", "Register name"))


## -----------------------------------------------------------------------------
register_data <- registers() |>
  names() |>
  simulate_registers() |>
  purrr::map(duckplyr::as_duckdb_tibble) |>
  # Convert to a DuckDB connection, as duckplyr is still
  # in early development, while the DBI-DuckDB connection
  # is more stable.
  purrr::map(duckplyr::as_tbl)


## -----------------------------------------------------------------------------
lpr <- list(
  prepare_lpr2(register_data$lpr_adm, register_data$lpr_diag),
  prepare_lpr3f(register_data$lpr3f_kontakter, register_data$lpr3f_diagnoser),
  prepare_lpr3a(register_data$lpr3a_kontakt, register_data$lpr3a_diagnose)
) |>
  join_registers()

hsr <- list(register_data$sssy, register_data$sysi) |> join_registers()


## -----------------------------------------------------------------------------
bef <- register_data$bef
lmdb <- register_data$lmdb
lab_forsker <- register_data$lab_forsker


## -----------------------------------------------------------------------------
classified_diabetes <- classify_diabetes(
  lpr = lpr,
  hsr = hsr,
  lab_forsker = lab_forsker,
  bef = bef,
  lmdb = lmdb
)

classified_diabetes


## -----------------------------------------------------------------------------
classified_diabetes <- classified_diabetes |>
  dplyr::collect()

classified_diabetes

