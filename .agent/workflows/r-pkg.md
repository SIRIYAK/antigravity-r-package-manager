---
description: Manage R packages using the R Package Manager Helper skill
---

### 🌐 Universal Command Format
On **Mac/Linux**, use `Rscript`.
On **Windows**, use `& "C:\Program Files\R\R-4.5.0\bin\x64\Rscript.exe"` (or your specific path).

---

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

### Create New Package
1. Run the creation script with your package name:
```bash
Rscript ".agent/skills/r_package_manager/scripts/create_package.R" "PACKAGE_NAME"
```

### Document/Install Package
1. Run the utility script (replace `document` with `install` or `test` as needed):
```bash
Rscript ".agent/skills/r_package_manager/scripts/build_utils.R" "document" "path/to/package"
```
