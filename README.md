# Workflows used by RStudio Education

<!-- badges: start -->
<!-- badges: end -->

🚧🚧🚧 This repo is a work in progress 🚧🚧🚧

The primary goal of this repository is to automate package maintenance tasks for the RStudio Education team.

## Auto Package Maintenance

```yaml
on:
  pull_request:
  push:
    branches: main

name: Package Maintenance

jobs:
  auto-pkg-maintenance:
    uses: rstudio/education-workflows/.github/workflows/auto-pkg-maintenance.yaml@v1
```

### Inputs

- `source-repository-owner`: The owner of the source repo. Used to disable tasks that aren't intended for repository forks.

- `extra-packages`: A new-line separated list of extra packages to install, passed to [r-lib/actions@v2/setup-r-dependencies](https://github.com/r-lib/actions/tree/v2/setup-r-dependencies). (Currently there's no reason to use this input.)

- `cache-version`: Provides a mechanism to change the cache key for cached R dependencies. Passed to [r-lib/actions@v2/setup-r-dependencies](https://github.com/r-lib/actions/tree/v2/setup-r-dependencies).

- `pandoc-version`: Sets the pandoc version to be installed, passed to [r-lib/actions@v2/setup-pandoc](https://github.com/r-lib/actions/tree/v2/setup-pandoc).

### Tasks

Auto package maintenance performs the following common tasks:

1. Tidy the DESCRIPTION file with `usethis::use_tidy_description()`.

2. Re-document the package with `roxygen2::roxygenise()`.

3. Rebuild `README.Rmd`, `index.Rmd` or `pkgdown/index.Rmd` if any are present.

4. Check links with [urlchecker](https://github.com/r-lib/urlchecker) (only on release candidate branches that start with `rc-v*`).

5. Style R code with 2 spaces instead of tabs and remove trailing invisible characters (using [styler](https://github.com/r-lib/styler)).

6. Lint the package and provide lint feedback as annotations (in PRs) using the [lintr package](https://github.com/r-lib/lintr).

If automated package maintenance is run from an internal PR, these updates are pushed to the PR branch. If the PR originated from a fork and any of the above tasks changed the source code, the check fails with an informative message.

If auto package maintenance is run from the main branch of the primary source repository, a PR is opened with the changes. The PR is automatically managed: if subsequent changes are added to the main branch, the PR is updated via force push, or the PR is closed if the changes resolved any package maintenance needs.
