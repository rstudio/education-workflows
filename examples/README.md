# Complete Workflows

These workflows are intended to be copied directly into your `.github/workflows` directory and modified as needed.

You can use [usethis](https://usethis.r-lib.org) to copy this workflow into your project.

```r
usethis::use_github_action(
  url = "https://raw.githubusercontent.com/rstudio/education-workflows/main/examples/pkgdown.yaml"
)
```

This action:

1. Deploys the documentation of the current version of the package in the `main` branch to GitHub Pages.
2. Deploys previews of the package documentation to the `preview/pr<number>` subdirectory for PRs that change or update the documentation.
3. Cleans up previews when PRs are closed.
4. Deploys package documentation when tags starting with `v` are pushed, e.g. `v0.1.0`. The package documentation is deployed to a subdirectory of the GitHub Pages site that matches the tag, e.g. `SITE_URL/v0.1.0/`.

This currently requires the latest version of [r-lib/pkgdown](https://pkgdown.r-lib.org) from GitHub.
