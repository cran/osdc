## ----setup--------------------------------------------------------------------
#| include: false
library(dplyr)
library(osdc)


## flowchart TB
##   subgraph data_sources["Data sources"]
##     lpr2_diag[("lpr2_diag")]
##     lpr2_adm[("lpr2_adm")]
##     lpr3a_kontakt[("lpr3a_kontakt")]
##     lpr3a_diagnose[("lpr3a_diagnose")]
##     lpr3f_kontakter[("lpr3f_kontakter")]
##     lpr3f_diagnoser[("lpr3f_diagnoser")]
##   end
## 
##   lpr2_diag & lpr2_adm --> prepare_lpr2["prepare_lpr2()"]
##   lpr3f_kontakter & lpr3f_diagnoser --> prepare_lpr3f["prepare_lpr3f()"]
##   lpr3a_kontakt & lpr3a_diagnose --> prepare_lpr3a["prepare_lpr3a()"]
## 
##   prepare_lpr2 & prepare_lpr3f & prepare_lpr3a --> join_registers["join_registers()"]
##   join_registers --> lpr[(lpr)]
## 
##   %% Styling
##   classDef default fill:#EEEEEE, color:#000000, stroke:#000000
##   style data_sources fill:#FFFFFF, color:#000000, stroke-width:0px

## -----------------------------------------------------------------------------
#| output: asis
#| echo: false
registers() |>
  purrr::imap_chr(~ glue::glue("- `{.y}`: The register or set of registers called '{.x$name}' in Danish.")) |>
  unname() |>
  cat(sep = "\n")

