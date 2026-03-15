#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 2) {
  cat("❌ Usage: Rscript compare_packages.R <package1> <package2> [package3...]\n")
  quit(status = 1)
}

packages <- args

cat("\n📊 Package Comparison\n")
cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n")

tryCatch({
  pkgs_data <- available.packages(repos = "https://cloud.r-project.org")
  
  comparison <- data.frame(
    Package = character(),
    Version = character(),
    Published = character(),
    Dependencies = integer(),
    License = character(),
    Installed = character(),
    stringsAsFactors = FALSE
  )
  
  for (pkg in packages) {
    if (!pkg %in% pkgs_data[, "Package"]) {
      cat(sprintf("⚠️  Package '%s' not found on CRAN\n", pkg))
      next
    }
    
    info <- pkgs_data[pkg, ]
    
    dep_count <- 0
    if (!is.na(info["Imports"])) {
      dep_count <- length(unlist(strsplit(info["Imports"], ",")))
    }
    
    is_installed <- if (require(pkg, character.only = TRUE, quietly = TRUE)) "✅ Yes" else "❌ No"
    
    comparison <- rbind(comparison, data.frame(
      Package = pkg,
      Version = info["Version"],
      Published = info["Published"],
      Dependencies = dep_count,
      License = substr(info["License"], 1, 20),
      Installed = is_installed,
      stringsAsFactors = FALSE
    ))
  }
  
  if (nrow(comparison) == 0) {
    cat("❌ No valid packages to compare\n")
    quit(status = 1)
  }
  
  # Print comparison table
  cat(sprintf("%-20s %-10s %-12s %-8s %-20s %-10s\n", 
              "Package", "Version", "Published", "Deps", "License", "Installed"))
  cat(paste(rep("─", 90), collapse = ""), "\n")
  
  for (i in 1:nrow(comparison)) {
    cat(sprintf("%-20s %-10s %-12s %-8d %-20s %-10s\n",
                comparison[i, "Package"],
                comparison[i, "Version"],
                comparison[i, "Published"],
                comparison[i, "Dependencies"],
                comparison[i, "License"],
                comparison[i, "Installed"]))
  }
  
  # Analysis
  cat("\n🎯 Analysis:\n")
  
  # Most recent
  comparison$Published <- as.Date(comparison$Published)
  most_recent <- comparison[which.max(comparison$Published), "Package"]
  cat(sprintf("   📅 Most Recently Updated: %s\n", most_recent))
  
  # Lightest dependencies
  lightest <- comparison[which.min(comparison$Dependencies), "Package"]
  cat(sprintf("   🪶 Lightest Dependencies: %s (%d deps)\n", 
              lightest, min(comparison$Dependencies)))
  
  # Recommendation
  cat("\n💡 Recommendation:\n")
  if (most_recent == lightest) {
    cat(sprintf("   ✅ %s is both recent and lightweight\n", most_recent))
  } else {
    cat(sprintf("   ⚖️  Choose %s for latest features or %s for minimal dependencies\n", 
                most_recent, lightest))
  }
  
  cat("\n")
  
}, error = function(e) {
  cat("❌ Error:", conditionMessage(e), "\n")
  quit(status = 1)
})
