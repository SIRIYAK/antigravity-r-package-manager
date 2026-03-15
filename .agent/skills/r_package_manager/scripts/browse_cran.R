#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)
search_term <- if (length(args) > 0) tolower(args[1]) else ""

cache_file <- file.path(tempdir(), "cran_packages_cache.rds")
cache_age_hours <- 24

refresh_cache <- function() {
  tryCatch({
    cat("📥 Fetching CRAN package list...\n")
    pkgs <- available.packages(repos = "https://cloud.r-project.org")[, c("Package", "Version", "Title")]
    saveRDS(pkgs, cache_file)
    pkgs
  }, error = function(e) {
    cat("❌ Error fetching packages:", conditionMessage(e), "\n")
    NULL
  })
}

if (file.exists(cache_file) && difftime(Sys.time(), file.info(cache_file)$mtime, units = "hours") < cache_age_hours) {
  pkgs <- readRDS(cache_file)
} else {
  pkgs <- refresh_cache()
  if (is.null(pkgs)) quit(status = 1)
}

if (search_term != "") {
  matches <- grepl(search_term, tolower(pkgs[, "Package"])) | grepl(search_term, tolower(pkgs[, "Title"]))
  pkgs <- pkgs[matches, , drop = FALSE]
  cat(sprintf("🔍 Found %d matches for '%s'\n\n", nrow(pkgs), search_term))
} else {
  cat(sprintf("📦 Total CRAN packages: %d\n\n", nrow(pkgs)))
  pkgs <- head(pkgs, 50)
}

for (i in seq_len(min(nrow(pkgs), 50))) {
  cat(sprintf("📦 %s (%s)\n   %s\n\n", pkgs[i, "Package"], pkgs[i, "Version"], pkgs[i, "Title"]))
}

if (nrow(pkgs) > 50) cat(sprintf("... and %d more results\n", nrow(pkgs) - 50))
