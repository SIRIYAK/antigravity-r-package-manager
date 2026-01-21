#' Better CSV Exporter
#'
#' A modernized version of legacy export functions.
#'
#' @param data A data frame to export.
#' @param filename Character string for the output path.
#' @importFrom utils write.csv
#' @export
#'
#' @examples
#' \dontrun{
#' export_data(mtcars, "my_data.csv")
#' }
export_data <- function(data, filename) {
    if (!is.data.frame(data)) {
        stop("Input 'data' must be a data frame.")
    }

    # Standardize column names (modern touch)
    names(data) <- gsub("[^a-zA-Z0-9]", "_", names(data))

    utils::write.csv(data, file = filename, row.names = FALSE)
    message(paste("Successfully exported to", filename))
}
