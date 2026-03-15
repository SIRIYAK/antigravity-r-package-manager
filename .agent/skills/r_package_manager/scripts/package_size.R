#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)
command <- if (length(args) > 0) args[1] else "analyze"

if (command == "analyze") {
  cat("\n💾 Analyzing package disk usage...\n")
  cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n")
  
  installed <- installed.packages()
  lib_path <- .libPaths()[1]
  
  sizes <- data.frame(
    Package = character(),
    Size_MB = numeric(),
    stringsAsFactors = FALSE
  )
  
  for (pkg in installed[, "Package"]) {
    pkg_path <- file.path(lib_path, pkg)
    if (dir.exists(pkg_path)) {
      size <- sum(file.info(list.files(pkg_path, recursive = TRUE, full.names = TRUE))$size, na.rm = TRUE)
      size_mb <- round(size / 1024 / 1024, 2)
      sizes <- rbind(sizes, data.frame(Package = pkg, Size_MB = size_mb))
    }
  }
  
  sizes <- sizes[order(-sizes$Size_MB), ]
  
  cat(sprintf("📦 Total packages: %d\n", nrow(sizes)))
  cat(sprintf("💾 Total size: %.2f MB\n\n", sum(sizes$Size_MB)))
  
  cat("🔝 Top 15 largest packages:\n\n")
  cat(sprintf("%-30s %10s\n", "Package", "Size (MB)"))
  cat(paste(rep("─", 45), collapse = ""), "\n")
  
  for (i in 1:min(15, nrow(sizes))) {
    cat(sprintf("%-30s %10.2f\n", sizes[i, "Package"], sizes[i, "Size_MB"]))
  }
  
  cat("\n💡 Tip: Run 'Rscript package_size.R unused' to find unused packages\n\n")
  
} else if (command == "unused") {
  cat("\n🔍 Finding unused packages...\n")
  cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n")
  
  r_files <- list.files(".", pattern = "\\.R$|\\.Rmd$", recursive = TRUE, full.names = TRUE)
  
  if (length(r_files) == 0) {
    cat("⚠️  No R files found in current directory\n\n")
    quit(status = 0)
  }
  
  used_packages <- character()
  
  for (file in r_files) {
    content <- readLines(file, warn = FALSE)
    
    lib_matches <- grep("^\\s*(library|require)\\s*\\(", content, value = TRUE)
    for (match in lib_matches) {
      pkg <- gsub(".*\\(\\s*['\"]?([a-zA-Z0-9.]+)['\"]?.*", "\\1", match)
      used_packages <- c(used_packages, pkg)
    }
    
    namespace_matches <- gregexpr("[a-zA-Z0-9.]+::", content)
    for (i in seq_along(content)) {
      if (namespace_matches[[i]][1] != -1) {
        matches <- regmatches(content[i], namespace_matches[[i]])
        pkgs <- gsub("::", "", unlist(matches))
        used_packages <- c(used_packages, pkgs)
      }
    }
  }
  
  used_packages <- unique(used_packages)
  installed <- installed.packages()[, "Package"]
  
  base_pkgs <- c("base", "compiler", "datasets", "graphics", "grDevices", "grid",
                 "methods", "parallel", "splines", "stats", "stats4", "tcltk",
                 "tools", "utils")
  
  unused <- setdiff(installed, c(used_packages, base_pkgs))
  
  if (length(unused) == 0) {
    cat("✅ All packages are being used!\n\n")
  } else {
    cat(sprintf("📦 Found %d potentially unused packages:\n\n", length(unused)))
    
    for (pkg in sort(unused)) {
      cat(sprintf("   • %s\n", pkg))
    }
    
    cat("\n⚠️  Note: These packages may be dependencies of other packages\n")
    cat("💡 Remove with: remove.packages(c(\"pkg1\", \"pkg2\"))\n\n")
  }
  
} else {
  cat("❌ Usage: Rscript package_size.R [analyze|unused]\n")
  quit(status = 1)
}
