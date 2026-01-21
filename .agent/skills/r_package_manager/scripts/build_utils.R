# build_utils.R
# Helper functions for building and documenting R packages

args <- commandArgs(trailingOnly = TRUE)

if (length(args) < 2) {
    cat("Usage: Rscript build_utils.R [action] [pkg_path]\n")
    cat("Actions: document, build, install, test\n")
    quit(save = "no")
}

action <- args[1]
pkg_path <- args[2]

if (!dir.exists(pkg_path)) {
    stop(paste("Package path does not exist:", pkg_path))
}

# Set CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

# Ensure devtools/roxygen2 are available
if (!requireNamespace("devtools", quietly = TRUE)) install.packages("devtools")
if (!requireNamespace("roxygen2", quietly = TRUE)) install.packages("roxygen2")

library(devtools)

cat(paste0("Performing action: ", action, " on ", pkg_path, "...\n"))

if (action == "document") {
    devtools::document(pkg_path)
    cat("Documentation generated.\n")
} else if (action == "build") {
    devtools::build(pkg_path)
} else if (action == "install") {
    devtools::install(pkg_path, upgrade = "never")
} else if (action == "test") {
    devtools::test(pkg_path)
} else {
    stop(paste("Unknown action:", action))
}
