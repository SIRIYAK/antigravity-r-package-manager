#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  cat("❌ Usage: Rscript package_info.R <package_name>\n")
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
  
  cat(sprintf("📦 %s (v%s)\n", info["Package"], info["Version"]))
  cat(sprintf("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"))
  cat(sprintf("📝 Title: %s\n", info["Title"]))
  cat(sprintf("👤 Author: %s\n", info["Author"]))
  cat(sprintf("🔧 Maintainer: %s\n", info["Maintainer"]))
  
  if (!is.na(info["Depends"])) cat(sprintf("📌 Depends: %s\n", info["Depends"]))
  if (!is.na(info["Imports"])) cat(sprintf("📥 Imports: %s\n", info["Imports"]))
  if (!is.na(info["Suggests"])) cat(sprintf("💡 Suggests: %s\n", info["Suggests"]))
  if (!is.na(info["License"])) cat(sprintf("⚖️  License: %s\n", info["License"]))
  
  cat(sprintf("\n🌐 CRAN: https://cran.r-project.org/package=%s\n", pkg_name))
  
}, error = function(e) {
  cat("❌ Error:", conditionMessage(e), "\n")
  quit(status = 1)
})
