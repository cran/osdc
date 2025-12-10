## ----setup--------------------------------------------------------------------
#| include: false
library(osdc)
library(dplyr)

# TODO: Do we want this as an exported function?
#' Convert the register data sources
#'
#' @param caption Caption to add to the table.
#'
#' @return A character vector as a Markdown table.
registers_as_md_table <- function(caption = NULL) {
  registers() |>
    purrr::map(~ purrr::discard(.x, tibble::is_tibble)) |>
    purrr::map(tibble::enframe) |>
    purrr::map(tidyr::pivot_wider) |>
    purrr::map(~ dplyr::mutate(.x, dplyr::across(tidyselect::everything(), unlist))) |>
    tibble::enframe(name = "register_abbrev") |>
    tidyr::unnest(cols = value) |>
    dplyr::mutate(
      end_year = dplyr::if_else(is.na(.data$end_year), "present", as.character(.data$end_year)),
      years = glue::glue("{start_year} - {end_year}"),
      register_abbrev = glue::glue("`{register_abbrev}`")
    ) |>
    dplyr::distinct() |>
    dplyr::select(
      "Register" = "name",
      "Abbreviation" = "register_abbrev",
      "Years" = "years"
    ) |>
    knitr::kable(caption = caption)
}

#' Convert the register list to a table showing registers and their variables.
#'
#' @returns A character vector as a Markdown table.
register_variables_as_md_table <- function() {
  register_names <- registers() |>
    purrr::map("name") |>
    tibble::enframe(name = "register_abbrev", value = "register_name") |>
    dplyr::mutate(register_name = unlist(register_name))

  registers() |>
    purrr::map(~ purrr::keep(.x, tibble::is_tibble)) |>
    tibble::enframe(name = "register_abbrev") |>
    tidyr::unnest(cols = value) |>
    dplyr::mutate(value = purrr::map(value, ~ dplyr::select(.x, variable_name = name))) |>
    tidyr::unnest(cols = value) |>
    dplyr::left_join(register_names, by = c("register_abbrev" = "register_abbrev")) |>
    dplyr::mutate(Register = paste0(register_name, " (`", register_abbrev, "`)")) |>
    dplyr::select(Register, Variable = variable_name) |>
    knitr::kable()
}

#' Convert the register name into text to use in a Markdown header
#'
#' @params register The list object of the register to create a table for.
#' @params abbrev The abbreviation of the register.
#'
#' @return A character vector.
register_as_md_header <- function(register, abbrev) {
  glue::glue(
    "### `{abbrev}`: {register$name}"
  )
}

#' Converts the variables for a register into a Markdown table
#'
#' @params register The list object of the register to create a table for.
#' @params abbrev The abbreviation of the register.
#'
#' @return A character vector as a Markdown table.
#'
variables_as_md_table <- function(register, abbrev) {
  register$variables |>
    dplyr::select("name", "english_description") |>
    dplyr::mutate(english_description = stringr::str_to_sentence(.data$english_description)) |>
    knitr::kable(
      caption = glue::glue("Variables and their descriptions within the `{abbrev}` register. If you want to see what the data *should* look like, see `simulate_registers()`.")
    )
}


## -----------------------------------------------------------------------------
registers_as_md_table("Danish registers used in the OSDC algorithm.")


## -----------------------------------------------------------------------------
register_variables_as_md_table()


## -----------------------------------------------------------------------------
registers() |>
  # iwalk takes the name of the element in the list (`.y`) as well as the
  # list itself (`.x`) and passes them to the function.
  purrr::iwalk(~ {
    print(register_as_md_header(.x, .y))
    print(variables_as_md_table(.x, .y))
  })

