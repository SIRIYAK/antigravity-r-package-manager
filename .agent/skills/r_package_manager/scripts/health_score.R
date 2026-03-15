#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  cat("❌ Usage: Rscript health_score.R <package_name>\n")
  quit(status = 1)
}

pkg_name <- args[1]

tryCatch({
  pkgs <- available.packages(repos = "https://cloud.r-project.org")
  
  if (!pkg_name %in% pkgs[, "Package"]) {
    cat(sprintf("❌ Package '%s' not found on CRAN\n", pkg_name))
    quit(status = 1)
  }
  
  info <- pkgs[pkg_name, ]
  score <- 100
  warnings <- character()
  
  cat(sprintf("\n🏥 Health Score for '%s'\n", pkg_name))
  cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n")
  
  # Check publication date
  pub_date <- info["Published"]
  if (!is.na(pub_date)) {
    days_old <- as.numeric(difftime(Sys.Date(), as.Date(pub_date), units = "days"))
    cat(sprintf("📅 Last Updated: %s (%d days ago)\n", pub_date, days_old))
    
    if (days_old > 730) {
      score <- score - 30
      warnings <- c(warnings, "⚠️  Package not updated in 2+ years")
    } else if (days_old > 365) {
      score <- score - 15
      warnings <- c(warnings, "⚠️  Package not updated in 1+ year")
    }
  }
  
  # Check dependencies
  deps <- info["Depends"]
  imports <- info["Imports"]
  dep_count <- 0
  if (!is.na(imports)) {
    dep_count <- length(unlist(strsplit(imports, ",")))
  }
  cat(sprintf("📦 Dependencies: %d\n", dep_count))
  
  if (dep_count > 20) {
    score <- score - 15
    warnings <- c(warnings, "⚠️  Heavy dependency chain (20+ packages)")
  }
  
  # Check maintainer
  maintainer <- info["Maintainer"]
  if (!is.na(maintainer)) {
    cat(sprintf("👤 Maintainer: %s\n", maintainer))
  }
  
  # Check license
  license <- info["License"]
  if (!is.na(license)) {
    cat(sprintf("⚖️  License: %s\n", license))
    if (grepl("GPL-3", license)) {
      warnings <- c(warnings, "ℹ️  GPL-3 license (copyleft - check compatibility)")
    }
  }
  
  # Check if archived
  if (!is.na(info["Archived"])) {
    score <- 0
    warnings <- c(warnings, "❌ Package is ARCHIVED on CRAN")
  }
  
  # Final score
  score <- max(0, score)
  cat(sprintf("\n🎯 Health Score: %d/100\n", score))
  
  if (score >= 80) {
    cat("✅ Status: Excellent - Safe to use\n")
  } else if (score >= 60) {
    cat("⚠️  Status: Good - Minor concerns\n")
  } else if (score >= 40) {
    cat("⚠️  Status: Fair - Consider alternatives\n")
  } else {
    cat("❌ Status: Poor - Use with caution\n")
  }
  
  if (length(warnings) > 0) {
    cat("\n⚠️  Warnings:\n")
    for (w in warnings) {
      cat(sprintf("   %s\n", w))
    }
  }
  
  cat("\n")
  
}, error = function(e) {
  cat("❌ Error:", conditionMessage(e), "\n")
  quit(status = 1)
})
