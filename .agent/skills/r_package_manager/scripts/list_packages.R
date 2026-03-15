#!/usr/bin/env Rscript

cat("\n📦 Installed R Packages\n")
cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n")

installed <- installed.packages()

cat(sprintf("Total packages: %d\n\n", nrow(installed)))

cat(sprintf("%-30s %-15s %-20s\n", "Package", "Version", "Library"))
cat(paste(rep("─", 70), collapse = ""), "\n")

for (i in 1:min(nrow(installed), 50)) {
  cat(sprintf("%-30s %-15s %-20s\n", 
              installed[i, "Package"],
              installed[i, "Version"],
              basename(installed[i, "LibPath"])))
}

if (nrow(installed) > 50) {
  cat(sprintf("\n... and %d more packages\n", nrow(installed) - 50))
}

cat("\n")
