# check_health.R
# Validates the R environment for the Antigravity extension

cat("\n--- Antigravity R Environment Health Check ---\n")

# 1. Check R Version
r_version <- paste(R.version$major, R.version$minor, sep = ".")
cat(sprintf("Checking R Version: %s... [OK]\n", r_version))

# 2. Check Operating System
os <- Sys.info()[["sysname"]]
cat(sprintf("Operating System detected: %s\n", os))

# 3. Check for Essential Package Management Libraries
essential_pkgs <- c("remotes", "renv", "devtools", "roxygen2", "testthat")
missing_essential <- c()

cat("\nChecking for essential development packages:\n")
for (pkg in essential_pkgs) {
    is_installed <- requireNamespace(pkg, quietly = TRUE)
    status <- if (is_installed) {
        version <- as.character(packageVersion(pkg))
        sprintf("[OK] (v%s)", version)
    } else {
        missing_essential <- c(missing_essential, pkg)
        "[MISSING]"
    }
    cat(sprintf("  %-12s: %s\n", pkg, status))
}

# 4. Check for TTS Engines (if on Linux)
if (os == "Linux") {
    cat("\nChecking for Linux TTS Engines:\n")
    has_espeak <- system("which espeak", ignore.stdout = TRUE) == 0
    has_festival <- system("which festival", ignore.stdout = TRUE) == 0

    if (has_espeak) cat("  espeak      : [OK]\n")
    if (has_festival) cat("  festival    : [OK]\n")

    if (!has_espeak && !has_festival) {
        cat("  [WARNING]: No TTS engine found. Install via 'sudo apt-get install espeak'.\n")
    }
}

# 5. Final Verdict
cat("\n--- Result ---\n")
if (length(missing_essential) == 0) {
    cat("✅ SUCCESS: Your environment is perfectly configured for R development with Antigravity!\n")
} else {
    cat("⚠️ WARNING: Some development tools are missing.\n")
    cat("To fix this, run the following in your R console:\n")
    cat(sprintf("install.packages(c(%s))\n", paste(shQuote(missing_essential), collapse = ", ")))
}
cat("--------------\n")
