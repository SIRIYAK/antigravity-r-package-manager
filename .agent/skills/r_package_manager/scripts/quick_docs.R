#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  cat("❌ Usage: Rscript quick_docs.R <command> <package_or_function>\n")
  cat("\nCommands:\n")
  cat("  vignettes <package>  - List package vignettes\n")
  cat("  help <function>      - Show function help\n")
  cat("  examples <function>  - Show function examples\n")
  cat("  cheatsheet <package> - Generate quick reference\n")
  quit(status = 1)
}

command <- args[1]
target <- if (length(args) > 1) args[2] else NULL

if (is.null(target)) {
  cat("❌ Please specify a package or function name\n")
  quit(status = 1)
}

if (command == "vignettes") {
  cat(sprintf("\n📚 Vignettes for '%s'\n", target))
  cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n")
  
  if (!require(target, character.only = TRUE, quietly = TRUE)) {
    cat(sprintf("❌ Package '%s' not installed\n", target))
    quit(status = 1)
  }
  
  vigs <- vignette(package = target)$results
  
  if (nrow(vigs) == 0) {
    cat("⚠️  No vignettes available for this package\n\n")
  } else {
    for (i in 1:nrow(vigs)) {
      cat(sprintf("📄 %s\n", vigs[i, "Title"]))
      cat(sprintf("   File: %s\n", vigs[i, "Item"]))
      cat(sprintf("   View: vignette(\"%s\", package = \"%s\")\n\n", vigs[i, "Item"], target))
    }
  }
  
} else if (command == "help") {
  cat(sprintf("\n📖 Help for '%s'\n", target))
  cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n")
  
  tryCatch({
    help_text <- capture.output(help(target))
    if (length(help_text) > 0) {
      cat("💡 Use: ?", target, "\n\n")
      cat("Quick info:\n")
      
      # Try to get function signature
      if (exists(target)) {
        func <- get(target)
        if (is.function(func)) {
          cat(sprintf("Function: %s\n", target))
          args_list <- formals(func)
          if (length(args_list) > 0) {
            cat("Arguments:\n")
            for (arg_name in names(args_list)) {
              cat(sprintf("  • %s\n", arg_name))
            }
          }
        }
      }
    } else {
      cat("❌ No help found\n")
    }
  }, error = function(e) {
    cat("❌ Error:", conditionMessage(e), "\n")
  })
  
  cat("\n")
  
} else if (command == "examples") {
  cat(sprintf("\n💡 Examples for '%s'\n", target))
  cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n")
  
  tryCatch({
    ex <- example(target, give.lines = TRUE, prompt.prefix = "")
    if (length(ex) > 0) {
      cat(paste(ex, collapse = "\n"))
      cat("\n\n💡 Run: example(\"", target, "\")\n\n", sep = "")
    } else {
      cat("⚠️  No examples available\n\n")
    }
  }, error = function(e) {
    cat("❌ Error:", conditionMessage(e), "\n\n")
  })
  
} else if (command == "cheatsheet") {
  cat(sprintf("\n📋 Quick Reference for '%s'\n", target))
  cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n")
  
  if (!require(target, character.only = TRUE, quietly = TRUE)) {
    cat(sprintf("❌ Package '%s' not installed\n", target))
    quit(status = 1)
  }
  
  # List exported functions
  exports <- ls(sprintf("package:%s", target))
  
  cat(sprintf("📦 Package: %s\n", target))
  cat(sprintf("🔧 Functions: %d\n\n", length(exports)))
  
  cat("Top functions:\n")
  for (func in head(exports, 20)) {
    if (exists(func, where = sprintf("package:%s", target))) {
      obj <- get(func, envir = as.environment(sprintf("package:%s", target)))
      if (is.function(obj)) {
        cat(sprintf("  • %s()\n", func))
      }
    }
  }
  
  if (length(exports) > 20) {
    cat(sprintf("\n... and %d more functions\n", length(exports) - 20))
  }
  
  cat("\n💡 Use: help(package = \"", target, "\")\n\n", sep = "")
  
} else {
  cat(sprintf("❌ Unknown command: %s\n", command))
  quit(status = 1)
}
