# create_package.R
# Creates a skeleton for a new R package

args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0) {
    stop("Please provide a package name. Usage: Rscript create_package.R 'MyNewPackage'")
}

pkg_name <- args[1]
pkg_path <- file.path(getwd(), pkg_name)

if (dir.exists(pkg_path)) {
    stop(paste("Directory already exists:", pkg_path))
}

cat(paste0("Creating R package template: ", pkg_name, "...\n"))

# Create directory structure
dir.create(pkg_path)
dir.create(file.path(pkg_path, "R"))
dir.create(file.path(pkg_path, "man"))
dir.create(file.path(pkg_path, "tests"))
dir.create(file.path(pkg_path, "tests", "testthat"))

# Create DESCRIPTION file
description_content <- c(
    paste0("Package: ", pkg_name),
    "Type: Package",
    "Title: What the Package Does (One Line, Title Case)",
    "Version: 0.1.0",
    "Author: First Last <email@example.com>",
    "Maintainer: First Last <email@example.com>",
    "Description: What the package does (one paragraph).",
    "License: MIT + file LICENSE",
    "Encoding: UTF-8",
    "LazyData: true",
    "RoxygenNote: 7.2.3",
    "Imports: ",
    "Suggests: ",
    "    testthat (>= 3.0.0)",
    "Config/testthat/edition: 3"
)
writeLines(description_content, file.path(pkg_path, "DESCRIPTION"))

# Create NAMESPACE file
writeLines('exportPattern("^[^\\\\.]")', file.path(pkg_path, "NAMESPACE"))

# Create a sample R function
hello_r_content <- c(
    "#' Hello World Function",
    "#'",
    "#' @return A string saying hello",
    "#' @export",
    "#'",
    "#' @examples",
    "#' hello_world()",
    "hello_world <- function() {",
    '  print("Hello, from your new R package!")',
    "}"
)
writeLines(hello_r_content, file.path(pkg_path, "R", "hello.R"))

# Create a sample test
test_content <- c(
    'test_that("hello_world works", {',
    '  expect_output(hello_world(), "Hello, from your new R package!")',
    "})"
)
writeLines(test_content, file.path(pkg_path, "tests", "testthat", "test-hello.R"))

# Create test runner
test_runner_content <- c(
    "library(testthat)",
    paste0("library(", pkg_name, ")"),
    "",
    paste0('test_check("', pkg_name, '")')
)
writeLines(test_runner_content, file.path(pkg_path, "tests", "testthat.R"))

cat(paste0("\nPackage '", pkg_name, "' created successfully at: ", pkg_path, "\n"))
cat("Next steps:\n")
cat("1. Add more functions in the R/ directory.\n")
cat("2. Use document() from roxygen2 to generate documentation.\n")
cat("3. Run tests using test().\n")
