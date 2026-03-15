#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0) {
  cat("❌ Usage: Rscript install_packages.R \"package1, package2, package3\"\n")
  quit(status = 1)
}

packages <- unlist(strsplit(args[1], ","))
packages <- trimws(packages)

cat(sprintf("\n📦 Installing %d packages...\n", length(packages)))
cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n")

for (pkg in packages) {
  cat(sprintf("Installing %s...\n", pkg))
  tryCatch({
    install.packages(pkg, repos = "https://cloud.r-project.org", quiet = TRUE)
    cat(sprintf("   ✅ %s installed successfully\n\n", pkg))
  }, error = function(e) {
    cat(sprintf("   ❌ Failed: %s\n\n", conditionMessage(e)))
  })
}

cat("✅ Installation complete!\n\n")
