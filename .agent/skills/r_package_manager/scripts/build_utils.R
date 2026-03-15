#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)

if (length(args) < 2) {
  cat("❌ Usage: Rscript build_utils.R <command> <package_path>\n")
  cat("\nCommands:\n")
  cat("  document  - Generate documentation\n")
  cat("  install   - Install package locally\n")
  cat("  test      - Run package tests\n")
  quit(status = 1)
}

command <- args[1]
pkg_path <- args[2]

if (!dir.exists(pkg_path)) {
  cat(sprintf("❌ Package path not found: %s\n", pkg_path))
  quit(status = 1)
}

if (command == "document") {
  cat("\n📝 Generating documentation...\n")
  cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n")
  
  if (!require("roxygen2", quietly = TRUE)) {
    cat("❌ roxygen2 not installed. Install with: install.packages('roxygen2')\n")
    quit(status = 1)
  }
  
  tryCatch({
    roxygen2::roxygenise(pkg_path)
    cat("✅ Documentation generated successfully!\n\n")
  }, error = function(e) {
    cat("❌ Error:", conditionMessage(e), "\n\n")
    quit(status = 1)
  })
  
} else if (command == "install") {
  cat("\n📦 Installing package...\n")
  cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n")
  
  tryCatch({
    install.packages(pkg_path, repos = NULL, type = "source")
    cat("✅ Package installed successfully!\n\n")
  }, error = function(e) {
    cat("❌ Error:", conditionMessage(e), "\n\n")
    quit(status = 1)
  })
  
} else if (command == "test") {
  cat("\n🧪 Running tests...\n")
  cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n")
  
  if (!require("testthat", quietly = TRUE)) {
    cat("❌ testthat not installed. Install with: install.packages('testthat')\n")
    quit(status = 1)
  }
  
  tryCatch({
    testthat::test_dir(file.path(pkg_path, "tests"))
    cat("\n✅ Tests completed!\n\n")
  }, error = function(e) {
    cat("❌ Error:", conditionMessage(e), "\n\n")
    quit(status = 1)
  })
  
} else {
  cat(sprintf("❌ Unknown command: %s\n", command))
  quit(status = 1)
}
