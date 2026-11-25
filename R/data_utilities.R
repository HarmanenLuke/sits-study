#' Download data from Hugging Face and save to disk
#'
#' Seems like this is not available in the current CRAN distribution of the
#' sits package even though it is mentioned in the e-book.
#'
#' @param repository HF repository name as a character.
#' @param file File name as a character.
#' @param data_path Optional output directory as a character.
#' @returns Nothing, side effect is the downloaded .parquet file.
#' @examples
#' sits_from_hf(
#'   repository = "e-sensing/samples_book",
#'   file = "samples_matogrosso_mod13q1.parquet",
#'   data_path = "data"
#' )
sits_from_hf <- function(repository, file, data_path = "") {
  url <- base::sprintf(
    "https://huggingface.co/datasets/%s/resolve/main/%s",
    repository,
    file
  )

  utils::download.file(
    url,
    destfile = base::file.path(data_path, file),
    mode = "wb"
  )

  base::invisible(NULL)
}

#' A reading utility for .parquet data
#'
#' Additionally, fetches the dataset from Hugging Face if it is not found on disk.
#'
#' @param file File name as a character.
#' @param data_path Optional output directory as a character.
#' @param repository HF repository name as a character.
#' @returns Data read from `file`.
#' @examples
#' get_data(
#'   file = "samples_matogrosso_mod13q1.parquet",
#'   data_path = "data"
#' )
get_data <- function(file, data_path, repository = "e-sensing/samples_book") {
  file_path <- base::file.path(data_path, file)

  if (!base::file.exists(file_path)) {
    sits_from_hf(repository, file, data_path)
  } else {
    base::message(base::paste0("File ", file, " already exists"))
  }

  arrow::read_parquet(file_path)
}
