## ----setup--------------------------------------------------------------------
#| include: false
library(dplyr)
library(osdc)


## -----------------------------------------------------------------------------
#| output: asis
#| echo: false
registers() |>
  purrr::imap_chr(~ glue::glue("- `{.y}`: The register called '{.x$name}' in Danish.")) |>
  unname() |> 
  cat(sep = "\n")

