#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)
scan_path <- if (length(args) > 0) args[1] else "."

cat("\n🔍 Scanning R files for package dependencies...\n")
cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n")

r_files <- list.files(scan_path, pattern = "\\.R$|\\.Rmd$", recursive = TRUE, full.names = TRUE)

if (length(r_files) == 0) {
  cat("❌ No R files found in", scan_path, "\n")
  quit(status = 1)
}

cat(sprintf("📁 Found %d R files\n\n", length(r_files)))

all_packages <- character()

for (file in r_files) {
  content <- readLines(file, warn = FALSE)
  
  # Match library() and require()
  lib_matches <- grep("^\\s*(library|require)\\s*\\(", content, value = TRUE)
  for (match in lib_matches) {
    pkg <- gsub(".*\\(\\s*['\"]?([a-zA-Z0-9.]+)['\"]?.*", "\\1", match)
    all_packages <- c(all_packages, pkg)
  }
  
  # Match package::function()
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
  cat("✅ No external package dependencies detected\n\n")
  quit(status = 0)
}

cat(sprintf("📦 Detected %d unique packages:\n\n", length(all_packages)))

installed <- character()
missing <- character()

for (pkg in sort(all_packages)) {
  if (require(pkg, character.only = TRUE, quietly = TRUE)) {
    ver <- packageVersion(pkg)
    cat(sprintf("   ✅ %s (%s)\n", pkg, ver))
    installed <- c(installed, pkg)
  } else {
    cat(sprintf("   ❌ %s (NOT INSTALLED)\n", pkg))
    missing <- c(missing, pkg)
  }
}

cat("\n📊 Summary:\n")
cat(sprintf("   ✅ Installed: %d\n", length(installed)))
cat(sprintf("   ❌ Missing: %d\n", length(missing)))

if (length(missing) > 0) {
  cat("\n💡 Install missing packages:\n")
  cat(sprintf("   install.packages(c(\"%s\"))\n", paste(missing, collapse = "\", \"")))
  
  cat("\n📄 Save to requirements.txt:\n")
  writeLines(all_packages, "requirements.txt")
  cat("   ✅ Created requirements.txt\n")
}

cat("\n")
