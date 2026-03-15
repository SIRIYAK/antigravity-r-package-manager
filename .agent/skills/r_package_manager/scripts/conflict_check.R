#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  cat("❌ Usage: Rscript conflict_check.R <package_name>\n")
  quit(status = 1)
}

pkg_name <- args[1]

cat(sprintf("\n🔍 Checking conflicts for '%s'...\n", pkg_name))
cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n")

tryCatch({
  pkgs <- available.packages(repos = "https://cloud.r-project.org")
  
  if (!pkg_name %in% pkgs[, "Package"]) {
    cat(sprintf("❌ Package '%s' not found on CRAN\n", pkg_name))
    quit(status = 1)
  }
  
  info <- pkgs[pkg_name, ]
  conflicts <- character()
  
  # Get dependencies with version requirements
  deps_raw <- info["Imports"]
  if (!is.na(deps_raw)) {
    deps_list <- unlist(strsplit(deps_raw, ","))
    deps_list <- trimws(deps_list)
    
    cat("📋 Required Dependencies:\n")
    for (dep in deps_list) {
      dep_clean <- gsub("\\s*\\([^)]+\\)", "", dep)
      dep_clean <- trimws(dep_clean)
      
      if (dep_clean %in% c("R", "base", "utils", "stats")) next
      
      version_req <- regmatches(dep, regexpr("\\([^)]+\\)", dep))
      
      if (require(dep_clean, character.only = TRUE, quietly = TRUE)) {
        installed_ver <- packageVersion(dep_clean)
        if (length(version_req) > 0) {
          cat(sprintf("   ✅ %s (installed: %s, requires: %s)\n", dep_clean, installed_ver, version_req))
        } else {
          cat(sprintf("   ✅ %s (installed: %s)\n", dep_clean, installed_ver))
        }
      } else {
        if (length(version_req) > 0) {
          cat(sprintf("   ⚠️  %s (NOT INSTALLED, requires: %s)\n", dep_clean, version_req))
        } else {
          cat(sprintf("   ⚠️  %s (NOT INSTALLED)\n", dep_clean))
        }
        conflicts <- c(conflicts, dep_clean)
      }
    }
  }
  
  # Check for namespace conflicts
  if (require(pkg_name, character.only = TRUE, quietly = TRUE)) {
    cat("\n🔄 Checking for function name conflicts...\n")
    pkg_functions <- ls(sprintf("package:%s", pkg_name))
    
    loaded_pkgs <- search()
    loaded_pkgs <- loaded_pkgs[grepl("^package:", loaded_pkgs)]
    loaded_pkgs <- loaded_pkgs[loaded_pkgs != sprintf("package:%s", pkg_name)]
    
    conflict_found <- FALSE
    for (func in head(pkg_functions, 20)) {
      for (other_pkg in loaded_pkgs) {
        if (exists(func, where = other_pkg, inherits = FALSE)) {
          if (!conflict_found) conflict_found <- TRUE
          cat(sprintf("   ⚠️  '%s' conflicts with %s\n", func, gsub("package:", "", other_pkg)))
        }
      }
    }
    
    if (!conflict_found) {
      cat("   ✅ No function conflicts detected\n")
    }
  }
  
  # Summary
  cat("\n📊 Summary:\n")
  if (length(conflicts) == 0) {
    cat("   ✅ All dependencies satisfied\n")
    cat("   ✅ Safe to install\n")
  } else {
    cat(sprintf("   ⚠️  %d missing dependencies\n", length(conflicts)))
    cat("   💡 Install missing packages first:\n")
    cat(sprintf("      install.packages(c(\"%s\"))\n", paste(conflicts, collapse = "\", \"")))
  }
  
  cat("\n")
  
}, error = function(e) {
  cat("❌ Error:", conditionMessage(e), "\n")
  quit(status = 1)
})
