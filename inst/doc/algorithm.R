## ----setup--------------------------------------------------------------------
#| include: false
library(osdc)
library(dplyr)

algorithm_df <- tibble(name = names(algorithm()), value = algorithm()) |>
  tidyr::unnest_wider(value) |>
  dplyr::select(register, name, title, logic, comments)


## -----------------------------------------------------------------------------
algorithm_df |>
  dplyr::filter(register == "lpr_diag") |>
  dplyr::select(-register) |>
  knitr::kable()


## -----------------------------------------------------------------------------
algorithm_df |>
  dplyr::filter(register == "lpr_adm") |>
  dplyr::select(-register) |>
  knitr::kable()


## -----------------------------------------------------------------------------
algorithm_df |>
  dplyr::filter(register == "diagnoser") |>
  dplyr::select(-register) |>
  knitr::kable()


## -----------------------------------------------------------------------------
algorithm_df |>
  dplyr::filter(register == "kontakter") |>
  dplyr::select(-register) |>
  knitr::kable()


## -----------------------------------------------------------------------------
algorithm_df |>
  dplyr::filter(register == "lab_forsker") |>
  dplyr::select(-register) |>
  knitr::kable()


## -----------------------------------------------------------------------------
algorithm_df |>
  dplyr::filter(register == "lmdb") |>
  dplyr::select(-register) |>
  knitr::kable()


## -----------------------------------------------------------------------------
algorithm_df |>
  dplyr::filter(is.na(register)) |>
  dplyr::select(-register) |>
  knitr::kable()

