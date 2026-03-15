#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)
scan_path <- if (length(args) > 0) args[1] else "."

cat("\n🔍 Checking dependencies in:", scan_path, "\n")
cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n")

r_files <- list.files(scan_path, pattern = "\\.R$|\\.Rmd$", recursive = TRUE, full.names = TRUE)

if (length(r_files) == 0) {
  cat("❌ No R files found\n\n")
  quit(status = 1)
}

cat(sprintf("📁 Found %d R files\n\n", length(r_files)))

all_packages <- character()

for (file in r_files) {
  content <- readLines(file, warn = FALSE)
  
  lib_matches <- grep("^\\s*(library|require)\\s*\\(", content, value = TRUE)
  for (match in lib_matches) {
    pkg <- gsub(".*\\(\\s*['\"]?([a-zA-Z0-9.]+)['\"]?.*", "\\1", match)
    all_packages <- c(all_packages, pkg)
  }
  
  namespace_matches <- gregexpr("[a-zA-Z0-9.]+::", content)
  for (i in seq_along(content)) {
    if (namespace_matches[[i]][1] != -1) {
      matches <- regmatches(content[i], namespace_matches[[i]])
      pkgs <- gsub("::", "", unlist(matches))
      all_packages <- c(all_packages, pkgs)
    }
  }
}

all_packages <- unique(all_packages)
all_packages <- all_packages[!all_packages %in% c("base", "stats", "utils", "graphics", "grDevices", "methods")]

if (length(all_packages) == 0) {
  cat("✅ No external dependencies found\n\n")
  quit(status = 0)
}

cat(sprintf("📦 Found %d unique packages:\n\n", length(all_packages)))

missing <- character()

for (pkg in sort(all_packages)) {
  if (require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat(sprintf("   ✅ %s\n", pkg))
  } else {
    cat(sprintf("   ❌ %s (MISSING)\n", pkg))
    missing <- c(missing, pkg)
  }
}

if (length(missing) > 0) {
  cat(sprintf("\n⚠️  %d missing packages\n", length(missing)))
  cat("\n💡 Install with:\n")
  cat(sprintf("   install.packages(c(\"%s\"))\n", paste(missing, collapse = "\", \"")))
} else {
  cat("\n✅ All dependencies satisfied!\n")
}

cat("\n")
