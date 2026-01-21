# update_packages.R
# Updates all installed R packages

cat("Checking for updates for all installed packages...\n")

# Set CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

# Update all packages
update.packages(ask = FALSE, checkBuilt = TRUE)

cat("\nUpdate process completed.\n")
