# maintain_package.R
# Tools for ongoing package maintenance

args <- commandArgs(trailingOnly = TRUE)

if (length(args) < 2) {
    cat("Usage: Rscript maintain_package.R [action] [pkg_path]\n")
    cat("Actions: bump-version, sync-deps\n")
    quit(save = "no")
}

action <- args[1]
pkg_path <- args[2]

if (!file.exists(file.path(pkg_path, "DESCRIPTION"))) {
    stop("This directory is not an R package (no DESCRIPTION file found).")
}

# 1. Bump Version Logic
if (action == "bump-version") {
    desc <- readLines(file.path(pkg_path, "DESCRIPTION"))
    v_line_idx <- grep("^Version:", desc)
    curr_version <- gsub("Version: ", "", desc[v_line_idx])

    v_parts <- as.numeric(unlist(strsplit(curr_version, "\\.")))
    v_parts[length(v_parts)] <- v_parts[length(v_parts)] + 1
    new_version <- paste(v_parts, collapse = ".")

    desc[v_line_idx] <- paste0("Version: ", new_version)
    writeLines(desc, file.path(pkg_path, "DESCRIPTION"))
    cat(paste("🚀 Bumping version to:", new_version, "\n"))
}

# 2. Sync Dependencies Logic (Requires attachment of devtools)
if (action == "sync-deps") {
    if (!requireNamespace("attachment", quietly = TRUE)) {
        install.packages("attachment")
    }
    cat("🔍 Scanning code for dependencies and updating DESCRIPTION...\n")
    attachment::att_amend_desc(path = pkg_path)
    cat("✅ DESCRIPTION file updated with used packages.\n")
}
