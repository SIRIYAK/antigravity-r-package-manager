# R Package Manager Helper

This skill provides a comprehensive suite of tools for managing R packages within the Antigravity environment. It streamlines the installation, updating, and dependency management processes for R developers.

## Capabilities

1.  **List Installed Packages**: Quickly view all installed R packages and their versions.
2.  **Install Packages**: Install packages from CRAN, Bioconductor, or GitHub.
3.  **Update Packages**: Keep your R environment up to date by updating specific or all packages.
4.  **Dependency Management**: Scan R scripts to identify and install missing dependencies.
5.  **Environment Health Check**: Verify if the R installation and critical libraries (like `devtools`, `remotes`) are correctly configured.
6.  **Package Template Creation**: Generate a standard R package skeleton.
7.  **Build & Document**: Utilities to run `devtools::document()`, `build()`, and `install()`.

## Usage Instructions

### 1. List Installed Packages
Use this to see what's available in your current R library path.
```powershell
& "C:\Program Files\R\R-4.5.0\bin\x64\Rscript.exe" ".agent/skills/r_package_manager/scripts/list_packages.R"
```

### 2. Install a Package
Install one or more packages from CRAN. Use the `packages` argument.
```powershell
& "C:\Program Files\R\R-4.5.0\bin\x64\Rscript.exe" ".agent/skills/r_package_manager/scripts/install_packages.R" "ggplot2, dplyr"
```

### 3. Check and Install Dependencies
Analyze a script or directory for `library()` or `require()` calls and install missing ones.
```powershell
& "C:\Program Files\R\R-4.5.0\bin\x64\Rscript.exe" ".agent/skills/r_package_manager/scripts/check_deps.R" "path/to/your/script.R"
```

### 4. Update All Packages
Update all currently installed packages to their latest versions.
```powershell
& "C:\Program Files\R\R-4.5.0\bin\x64\Rscript.exe" ".agent/skills/r_package_manager/scripts/update_packages.R"
```

### 5. Create a New Package Template
Generate a full R package directory structure with sample code and tests.
```powershell
& "C:\Program Files\R\R-4.5.0\bin\x64\Rscript.exe" ".agent/skills/r_package_manager/scripts/create_package.R" "MyNewPackage"
```

### 6. Document and Build a Package
Automate common `devtools` tasks.
```powershell
# Generate documentation (roxygen2)
& "C:\Program Files\R\R-4.5.0\bin\x64\Rscript.exe" ".agent/skills/r_package_manager/scripts/build_utils.R" "document" "path/to/package"

# Install locally
& "C:\Program Files\R\R-4.5.0\bin\x64\Rscript.exe" ".agent/skills/r_package_manager/scripts/build_utils.R" "install" "path/to/package"
```

### 7. Run Health Check
Verify your local environment is ready for development.
```powershell
& "C:\Program Files\R\R-4.5.0\bin\x64\Rscript.exe" ".agent/skills/r_package_manager/scripts/check_health.R"
```

## Setup & Requirements
- **Windows**: If `Rscript` is not in your PATH, use the full path: `& "C:\Program Files\R\R-x.x.x\bin\x64\Rscript.exe"`.
- **Mac/Linux**: Ensure R is installed and run simply as `Rscript`.
- **Paths**: The scripts use relative paths based on the workspace root. Ensure you are in the project root when running them.

---
*Developed by Antigravity - Cross-platform compatible R management.*
