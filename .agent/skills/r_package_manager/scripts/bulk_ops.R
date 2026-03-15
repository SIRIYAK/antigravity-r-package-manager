#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  cat("❌ Usage: Rscript bulk_ops.R <command> [args]\n")
  cat("\nCommands:\n")
  cat("  update-all          - Update all installed packages\n")
  cat("  export <file>       - Export package list to file\n")
  cat("  import <file>       - Install packages from file\n")
  cat("  batch-install <pkg1,pkg2,...> - Install multiple packages\n")
  quit(status = 1)
}

command <- args[1]

if (command == "update-all") {
  cat("\n🔄 Updating all packages...\n")
  cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n")
  
  old_pkgs <- old.packages(repos = "https://cloud.r-project.org")
  
  if (is.null(old_pkgs)) {
    cat("✅ All packages are up to date!\n\n")
  } else {
    cat(sprintf("📦 Found %d packages to update:\n\n", nrow(old_pkgs)))
    for (i in 1:nrow(old_pkgs)) {
      cat(sprintf("   %s: %s → %s\n", 
                  old_pkgs[i, "Package"], 
                  old_pkgs[i, "Installed"], 
                  old_pkgs[i, "ReposVer"]))
    }
    cat("\n💡 Run: update.packages(ask = FALSE)\n\n")
  }
  
} else if (command == "export") {
  if (length(args) < 2) {
    cat("❌ Usage: Rscript bulk_ops.R export <filename>\n")
    quit(status = 1)
  }
  
  output_file <- args[2]
  installed <- installed.packages()[, c("Package", "Version")]
  
  cat(sprintf("\n📤 Exporting %d packages to %s...\n", nrow(installed), output_file))
  
  write.csv(installed, output_file, row.names = FALSE)
  
  cat("✅ Export complete!\n\n")
  
} else if (command == "import") {
  if (length(args) < 2) {
    cat("❌ Usage: Rscript bulk_ops.R import <filename>\n")
    quit(status = 1)
  }
  
  input_file <- args[2]
  
  if (!file.exists(input_file)) {
    cat(sprintf("❌ File not found: %s\n", input_file))
    quit(status = 1)
  }
  
  pkg_list <- read.csv(input_file, stringsAsFactors = FALSE)
  
  cat(sprintf("\n📥 Importing %d packages from %s...\n\n", nrow(pkg_list), input_file))
  
  missing <- character()
  for (i in 1:nrow(pkg_list)) {
    pkg <- pkg_list[i, "Package"]
    if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
      cat(sprintf("   ❌ %s (will be installed)\n", pkg))
      missing <- c(missing, pkg)
    } else {
      cat(sprintf("   ✅ %s (already installed)\n", pkg))
    }
  }
  
  if (length(missing) > 0) {
    cat(sprintf("\n💡 Install %d missing packages:\n", length(missing)))
    cat(sprintf("   install.packages(c(\"%s\"))\n\n", paste(missing, collapse = "\", \"")))
  } else {
    cat("\n✅ All packages already installed!\n\n")
  }
  
} else if (command == "batch-install") {
  if (length(args) < 2) {
    cat("❌ Usage: Rscript bulk_ops.R batch-install <pkg1,pkg2,pkg3>\n")
    quit(status = 1)
  }
  
  packages <- unlist(strsplit(args[2], ","))
  packages <- trimws(packages)
  
  cat(sprintf("\n📦 Batch installing %d packages...\n\n", length(packages)))
  
  for (pkg in packages) {
    cat(sprintf("Installing %s...\n", pkg))
    tryCatch({
      install.packages(pkg, repos = "https://cloud.r-project.org", quiet = TRUE)
      cat(sprintf("   ✅ %s installed\n", pkg))
    }, error = function(e) {
      cat(sprintf("   ❌ %s failed: %s\n", pkg, conditionMessage(e)))
    })
  }
  
  cat("\n✅ Batch installation complete!\n\n")
  
} else {
  cat(sprintf("❌ Unknown command: %s\n", command))
  quit(status = 1)
}
