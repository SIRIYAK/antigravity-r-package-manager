#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  cat("❌ Usage: Rscript dep_graph.R <package_name>\n")
  quit(status = 1)
}

pkg_name <- args[1]

get_deps <- function(pkg, level = 0, visited = character()) {
  if (pkg %in% visited || level > 3) return(visited)
  visited <- c(visited, pkg)
  
  indent <- paste(rep("  ", level), collapse = "")
  symbol <- if (level == 0) "📦" else "├─"
  
  tryCatch({
    desc <- packageDescription(pkg)
    if (is.list(desc)) {
      cat(sprintf("%s%s %s\n", indent, symbol, pkg))
      
      deps <- desc$Imports
      if (!is.null(deps)) {
        deps <- gsub("\\s*\\([^)]+\\)", "", deps)
        deps <- trimws(unlist(strsplit(deps, ",")))
        deps <- deps[!deps %in% c("R", "base", "utils", "stats", "graphics", "grDevices")]
        
        for (d in deps) {
          visited <- get_deps(d, level + 1, visited)
        }
      }
    }
  }, error = function(e) {
    cat(sprintf("%s%s %s ❌ (not installed)\n", indent, symbol, pkg))
  })
  
  visited
}

if (!require(pkg_name, character.only = TRUE, quietly = TRUE)) {
  cat(sprintf("❌ Package '%s' not installed\n", pkg_name))
  quit(status = 1)
}

cat(sprintf("\n🌳 Dependency Tree for '%s'\n", pkg_name))
cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
get_deps(pkg_name)
cat("\n")
