# install_packages.R
# Installs R packages from CRAN

args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0) {
    stop("No packages specified. Usage: Rscript install_packages.R 'pkg1, pkg2'")
}

# Split by comma and clean up whitespace
pkgs_to_install <- unlist(strsplit(args[1], ","))
pkgs_to_install <- trimws(pkgs_to_install)

# Set CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

for (pkg in pkgs_to_install) {
    if (pkg == "") next

    cat(paste0("Checking for: ", pkg, "...\n"))

    if (!requireNamespace(pkg, quietly = TRUE)) {
        cat(paste0("Installing ", pkg, "...\n"))
        install.packages(pkg, dependencies = TRUE)
    } else {
        cat(paste0("Package ", pkg, " is already installed.\n"))
    }
}
