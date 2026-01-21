# list_packages.R
# Lists installed R packages with their versions

pkgs <- as.data.frame(installed.packages())
pkgs <- pkgs[, c("Package", "Version", "LibPath")]

# Sort by Package Name
pkgs <- pkgs[order(pkgs$Package), ]

# Format output for easy reading in terminal
cat(sprintf("%-25s | %-15s | %s\n", "Package", "Version", "Library Path"))
cat(paste0(rep("-", 80), collapse = ""), "\n")

for (i in seq_len(nrow(pkgs))) {
    pkg_name <- pkgs$Package[i]
    version <- pkgs$Version[i]
    lib_path <- pkgs$LibPath[i]
    cat(sprintf("%-25s | %-15s | %s\n", pkg_name, version, lib_path))
}
