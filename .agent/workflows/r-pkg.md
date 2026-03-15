---
description: Manage R packages using the R Package Manager Helper skill
---

### 🌐 Universal Command Format
On **Mac/Linux**, use `Rscript`.
On **Windows**, use `& "C:\Program Files\R\R-4.5.0\bin\x64\Rscript.exe"` (or your specific path).

---

### Browse CRAN Packages (Fast Local Search)
// turbo
1. Search CRAN packages locally (cached for 24h):
```bash
Rscript ".agent/skills/r_package_manager/scripts/browse_cran.R" "SEARCH_TERM"
```
2. Or browse all packages (shows first 50):
```bash
Rscript ".agent/skills/r_package_manager/scripts/browse_cran.R"
```

### Get Package Details
// turbo
1. View detailed info about a specific package:
```bash
Rscript ".agent/skills/r_package_manager/scripts/package_info.R" "PACKAGE_NAME"
```

### Dependency Graph
// turbo
1. Visualize package dependency tree:
```bash
Rscript ".agent/skills/r_package_manager/scripts/dep_graph.R" "PACKAGE_NAME"
```

### Package Health Score
// turbo
1. Check package health and maintenance status:
```bash
Rscript ".agent/skills/r_package_manager/scripts/health_score.R" "PACKAGE_NAME"
```

### Conflict Checker
// turbo
1. Check for conflicts before installing:
```bash
Rscript ".agent/skills/r_package_manager/scripts/conflict_check.R" "PACKAGE_NAME"
```

### Code Scanner
// turbo
1. Scan workspace for package dependencies:
```bash
Rscript ".agent/skills/r_package_manager/scripts/code_scanner.R" "PATH"
```

### Compare Packages
// turbo
1. Compare multiple packages side-by-side:
```bash
Rscript ".agent/skills/r_package_manager/scripts/compare_packages.R" "PKG1" "PKG2" "PKG3"
```

### Bulk Operations
// turbo
1. Update all packages:
```bash
Rscript ".agent/skills/r_package_manager/scripts/bulk_ops.R" "update-all"
```
2. Export package list:
```bash
Rscript ".agent/skills/r_package_manager/scripts/bulk_ops.R" "export" "packages.csv"
```
3. Import package list:
```bash
Rscript ".agent/skills/r_package_manager/scripts/bulk_ops.R" "import" "packages.csv"
```
4. Batch install:
```bash
Rscript ".agent/skills/r_package_manager/scripts/bulk_ops.R" "batch-install" "pkg1,pkg2,pkg3"
```

### Package Size Analysis
// turbo
1. Analyze disk usage:
```bash
Rscript ".agent/skills/r_package_manager/scripts/package_size.R" "analyze"
```
2. Find unused packages:
```bash
Rscript ".agent/skills/r_package_manager/scripts/package_size.R" "unused"
```

### Quick Documentation
// turbo
1. View package vignettes:
```bash
Rscript ".agent/skills/r_package_manager/scripts/quick_docs.R" "vignettes" "PACKAGE_NAME"
```
2. Get function help:
```bash
Rscript ".agent/skills/r_package_manager/scripts/quick_docs.R" "help" "FUNCTION_NAME"
```
3. Show examples:
```bash
Rscript ".agent/skills/r_package_manager/scripts/quick_docs.R" "examples" "FUNCTION_NAME"
```
4. Generate cheatsheet:
```bash
Rscript ".agent/skills/r_package_manager/scripts/quick_docs.R" "cheatsheet" "PACKAGE_NAME"
```

### List Installed Packages
// turbo
1. Run the list script:
```bash
Rscript ".agent/skills/r_package_manager/scripts/list_packages.R"
```

### Install New Packages
1. Run the install script with package names (e.g., "ggplot2, dplyr"):
```bash
Rscript ".agent/skills/r_package_manager/scripts/install_packages.R" "PACKAGE_NAMES"
```

### Check Dependencies in Current Folder
// turbo
1. Run the dependency check:
```bash
Rscript ".agent/skills/r_package_manager/scripts/check_deps.R" "."
```

### Build Pro Package
1. Scaffold a high-quality package with vignettes and GitHub Actions:
```bash
Rscript ".agent/skills/r_package_manager/scripts/create_package_pro.R" "PRO_PACKAGE_NAME"
```

### Maintain Package
1. Bump version or sync dependencies (replace `bump-version` with `sync-deps` if needed):
```bash
Rscript ".agent/skills/r_package_manager/scripts/maintain_package.R" "bump-version" "path/to/package"
```

### Document/Install Package
1. Run the utility script (replace `document` with `install` or `test` as needed):
```bash
Rscript ".agent/skills/r_package_manager/scripts/build_utils.R" "document" "path/to/package"
```
