# R Package Manager Skill

## Executive Summary
Enterprise-grade R package management skill providing comprehensive dependency analysis, conflict resolution, package health monitoring, and fast CRAN browsing capabilities. Designed for professional R development teams requiring robust package lifecycle management.

## Core Capabilities

### 1. Package Discovery & Intelligence
**Fast CRAN Browser**
- Instant search across 20,000+ CRAN packages
- Local caching with 24-hour refresh cycle
- Fuzzy matching on package names and descriptions
- Zero-latency browsing (no website navigation delays)

**Package Information Retrieval**
- Comprehensive metadata extraction
- Dependency chain analysis
- Maintainer and author information
- License compliance data
- Publication and update history

**Package Comparison Engine**
- Multi-package side-by-side comparison
- Metrics: version, dependencies, update frequency, license
- Automated recommendation based on recency and dependency weight
- Support for 2+ package comparisons

### 2. Dependency Management

**Dependency Graph Visualizer**
- Visual tree representation of package dependencies
- Recursive analysis up to 3 levels deep
- Identifies missing dependencies in real-time
- Detects circular dependency patterns
- Exports dependency maps for documentation

**Smart Conflict Resolver**
- Pre-installation conflict detection
- Version requirement validation
- Namespace collision detection
- Function name conflict identification
- Automated resolution suggestions

**Code-to-Package Mapper**
- Automated scanning of R and Rmd files
- Detects library(), require(), and package:: usage
- Generates requirements.txt automatically
- Identifies installed vs missing packages
- Supports recursive directory scanning

**Dependency Scanner**
- Workspace-wide dependency analysis
- Missing package detection
- Installation command generation
- Support for nested project structures

### 3. Package Health & Quality Assurance

**Health Score Analyzer**
- Multi-factor scoring algorithm (0-100 scale)
- Factors analyzed:
  - Last update date (recency scoring)
  - Dependency weight (complexity penalty)
  - Maintenance status (active vs abandoned)
  - CRAN archive status
  - License compliance flags
- Risk categorization: Excellent, Good, Fair, Poor
- Automated warning generation

**Quality Metrics**
- Package age analysis
- Update frequency tracking
- Dependency complexity scoring
- Maintainer responsiveness indicators

### 4. Package Operations

**Installation Management**
- Single package installation
- Batch installation from comma-separated lists
- Dependency-aware installation ordering
- Error handling and rollback support

**Bulk Operations**
- Update all packages with single command
- Export package lists to CSV format
- Import and sync from package lists
- Team environment replication
- Batch installation with progress tracking

**Package Inventory**
- List all installed packages
- Version information display
- Library path identification
- Sortable and filterable output

### 5. Optimization & Cleanup

**Package Size Analyzer**
- Disk space usage per package
- Top 15 largest packages identification
- Total library size calculation
- Storage optimization recommendations

**Unused Package Detection**
- Workspace code scanning
- Cross-reference with installed packages
- Identifies packages not referenced in code
- Safe removal suggestions (dependency-aware)

**Cleanup Recommendations**
- Automated optimization suggestions
- Dependency-safe removal lists
- Disk space recovery estimates

### 6. Documentation & Learning

**Quick Documentation Access**
- Vignette listing and viewing
- Function signature extraction
- Help text retrieval
- Code example generation

**Cheatsheet Generator**
- Package function inventory
- Top function listings
- Quick reference creation
- Exportable documentation

**Example Code Retrieval**
- Function usage examples
- Executable code snippets
- Best practice demonstrations

### 7. Development Tools

**Package Scaffolding**
- Professional package structure creation
- DESCRIPTION file generation
- Namespace setup
- Vignette templates
- GitHub Actions integration
- testthat framework setup

**Package Maintenance**
- Version bumping (major, minor, patch)
- Dependency synchronization
- DESCRIPTION file updates
- Automated changelog generation

**Build Utilities**
- roxygen2 documentation generation
- Package installation from source
- Test suite execution
- Build validation

## Technical Architecture

### Data Sources
- **Primary**: CRAN mirror (https://cloud.r-project.org)
- **Cache**: System temp directory
- **Refresh**: 24-hour automatic cycle
- **Fallback**: Direct CRAN access on cache miss

### Performance Specifications
- **Search latency**: <100ms (cached)
- **Dependency analysis**: <500ms for 3-level trees
- **Code scanning**: 100+ files in <2 seconds
- **Cache size**: 5-10 MB (full CRAN metadata)
- **Memory footprint**: <50 MB during operations

### Security & Privacy
- **Data access**: Read-only package metadata
- **User data**: Never accessed (.rds, .RData, .csv excluded)
- **Network**: CRAN mirror only (no tracking)
- **Storage**: Temporary cache only
- **Credentials**: Never stored or transmitted

### Platform Support
- **Windows**: Full support (PowerShell/CMD)
- **macOS**: Full support (Terminal)
- **Linux**: Full support (Bash/Zsh)
- **R versions**: 4.0+ recommended

## Enterprise Use Cases

### 1. Team Environment Standardization
- Export package lists from reference environment
- Distribute to team members
- Automated synchronization
- Version consistency enforcement

### 2. Security & Compliance Auditing
- License compliance checking
- Package health monitoring
- Dependency vulnerability assessment
- Audit trail generation

### 3. CI/CD Integration
- Automated dependency detection
- Requirements file generation
- Environment reproducibility
- Build optimization

### 4. Package Evaluation
- Pre-adoption health scoring
- Alternative package comparison
- Dependency impact analysis
- Risk assessment

### 5. Environment Optimization
- Disk space management
- Unused package cleanup
- Dependency minimization
- Performance tuning

## Integration Points

### Antigravity AI Assistant
- Natural language command interface
- Context-aware suggestions
- Workflow automation
- Interactive guidance

### R Ecosystem
- CRAN repository integration
- Bioconductor compatibility
- renv environment support
- devtools workflow integration

### Development Tools
- RStudio integration
- VS Code R extension compatibility
- Git workflow support
- CI/CD pipeline integration

## Best Practices

### For Individual Developers
1. Run health checks before adopting new packages
2. Use dependency graphs to understand complexity
3. Regularly scan for unused packages
4. Export package lists for project documentation
5. Check conflicts before major updates

### For Teams
1. Maintain centralized package lists
2. Standardize on package versions
3. Regular security audits
4. Document package selection rationale
5. Use bulk operations for consistency

### For Organizations
1. Establish package approval workflows
2. Monitor license compliance
3. Track package health scores
4. Maintain audit trails
5. Implement automated testing

## Limitations & Considerations

### Known Limitations
- Dependency analysis limited to 3 levels (performance optimization)
- Cache requires periodic internet connectivity
- Some package metadata may be incomplete
- Bioconductor packages require separate configuration

### Performance Considerations
- Large workspaces (1000+ files) may take longer to scan
- First-time cache download requires ~30 seconds
- Bulk operations on 100+ packages may take several minutes

### Compatibility Notes
- Requires R 4.0+ for optimal performance
- Some features require roxygen2, testthat packages
- Windows users should configure PATH for best experience

## Future Enhancements

### Planned Features
- Bioconductor integration
- GitHub package support
- Dependency vulnerability scanning (CVE database)
- Package performance benchmarking
- Automated testing integration
- Docker environment generation

### Under Consideration
- Private repository support
- Package recommendation AI
- Automated dependency updates
- Breaking change detection
- Cost analysis for compute-intensive packages

## Support & Resources

### Documentation
- README.md: User guide and quick start
- responsible-ai.md: Privacy and security guidelines
- memory.md: Context and preference storage
- r-pkg.md: Complete command reference

### Getting Help
- Use `/r-pkg` command in Antigravity
- Check troubleshooting section in README
- Review example workflows
- Consult command reference

### Feedback & Contribution
- Report issues via GitHub
- Suggest features through community channels
- Share workflows and best practices
- Contribute to documentation

---

**Skill Version**: 1.2.0  
**Last Updated**: 2024  
**Maintained By**: Siriyak for Antigravity Community  
**License**: MIT
