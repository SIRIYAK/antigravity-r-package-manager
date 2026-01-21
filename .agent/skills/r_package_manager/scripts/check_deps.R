# check_deps.R
# Scans R files for dependencies and checks their status

args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0) {
    # Default to current directory if no path is provided
    path <- "."
} else {
    path <- args[1]
}

if (!file.exists(path)) {
    stop(paste("Path does not exist:", path))
}

# Recursively find R files
r_files <- list.files(path, pattern = "\\.[Rr]$", recursive = TRUE, full.names = TRUE)

if (length(r_files) == 0) {
    # If the path itself is a file, use it
    if (!dir.exists(path) && grepl("\\.[Rr]$", path)) {
        r_files <- path
    } else {
        stop("No R files found.")
    }
}

find_deps <- function(file_path) {
    content <- readLines(file_path, warn = FALSE)

    # Match library(pkg), require(pkg), library("pkg"), require('pkg')
    # and also pkg::function

    libs <- grep("(library|require)\\(", content, value = TRUE)
    # Extract pkg name from library/require
    pkgs <- gsub(".*(library|require)\\((['\"]?)([a-zA-Z0-9.]+)\\2.*\\).*", "\\3", libs)

    # Match pkg:: or pkg:::
    double_colon <- grep("[a-zA-Z0-9.]+:{2,3}", content, value = TRUE)
    pkgs_colon <- gsub(".*\\b([a-zA-Z0-9.]+):{2,3}.*", "\\1", double_colon)

    unique(c(pkgs, pkgs_colon))
}

all_deps <- unique(unlist(lapply(r_files, find_deps)))
# Remove empty strings or garbage
all_deps <- all_deps[all_deps != "" & !is.na(all_deps)]

cat("\n--- Dependency Check Results ---\n")
cat(sprintf("%-25s | %-10s\n", "Package", "Status"))
cat(paste0(rep("-", 40), collapse = ""), "\n")

missing_pkgs <- c()

for (pkg in all_deps) {
    is_installed <- requireNamespace(pkg, quietly = TRUE)
    status <- if (is_installed) "Installed" else "MISSING"
    cat(sprintf("%-25s | %-10s\n", pkg, status))

    if (!is_installed) {
        missing_pkgs <- c(missing_pkgs, pkg)
    }
}

if (length(missing_pkgs) > 0) {
    cat("\nTo install missing packages, run:\n")
    cat(paste0("install.packages(c('", paste(missing_pkgs, collapse = "', '"), "'))\n"))
} else {
    cat("\nAll dependencies are satisfied.\n")
}
