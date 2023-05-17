# Workflows used by RStudio Education

<!-- badges: start -->
<!-- badges: end -->

🚧🚧🚧 This repo is a work in progress 🚧🚧🚧

The primary goal of this repository is to automate package maintenance tasks for the RStudio Education team.

## Auto Package Maintenance

### Usage

To use the **auto-pkg-maintenance** workflow, create a new workflow in your repository at: `.github/workflows/auto-pkg-maintenance.yaml`.

The safest option is to run maintenance on `pull_request` events or `push` events to your `main` branch.

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

The disadvantage of the above configuration is that the automated package maintenance will not be able to push back to pull requests from forked repositories. This is because the `pull_request` event has limited scope for writing back to forked repos, in order to [prevent abusive PRs](https://securitylab.github.com/research/github-actions-preventing-pwn-requests/).

In short: auto package maintenance is a low-risk action but should not be run against untrusted code. It is possible to enable the auto package maintenance workflow to push back to externally contributed pull requests, but only after the repository owner has manually reviewed the code and added an **auto-pkg-maintenance** label to the PR.

```yaml
on:
  pull_request_target:
    types: [opened, synchronize, labeled]
  push:
    branches: main

name: Package Maintenance

jobs:
  auto-pkg-maintenance:
    # optionally skip workflow if a specific label is missing (uncomment to enable)
    # if: github.event_name == 'push' || contains(github.event.pull_request.labels.*.name, 'auto-pkg-maintenance')
    uses: rstudio/education-workflows/.github/workflows/auto-pkg-maintenance.yaml@v1
```

`auto-pkg-maintenance` is configured to stop immediately if the PR is missing the **auto-pkg-maintenance** label. In the above configuration, auto maintenance will run when a PR is labelled so that adding the correct label triggers a maintenance workflow run. If you want, you can also configure the calling action to skip maintenance entirely if the label is missing.

### Inputs

- `source-repository-owner`: The owner of the source repo. Used to disable tasks that aren't intended for repository forks.

- `extra-packages`: A new-line separated list of extra packages to install, passed to [r-lib/actions@v2/setup-r-dependencies](https://github.com/r-lib/actions/tree/v2/setup-r-dependencies). (Currently there's no reason to use this input.)

- `cache-version`: Provides a mechanism to change the cache key for cached R dependencies. Passed to [r-lib/actions@v2/setup-r-dependencies](https://github.com/r-lib/actions/tree/v2/setup-r-dependencies).

- `pandoc-version`: Sets the pandoc version to be installed, passed to [r-lib/actions@v2/setup-pandoc](https://github.com/r-lib/actions/tree/v2/setup-pandoc).

- `install-local-package`: Installs the local package in the runner, without dependencies, when `"true"`.

- `style-roxyen-examples`: Should the indentation of the examples in the roxygen documentation be adjusted? Defaults to `"true"`.

### Tasks

Auto package maintenance performs the following common tasks:

1. Tidy the DESCRIPTION file with `usethis::use_tidy_description()`.

2. Re-document the package with `roxygen2::roxygenise()`.

3. Rebuild `README.Rmd`, `index.Rmd` or `pkgdown/index.Rmd` if any are present.

4. Check links with [urlchecker](https://github.com/r-lib/urlchecker) (only on release candidate branches that start with `rc-v*`).

5. Style R code with 2 spaces instead of tabs and remove trailing invisible characters (using [styler](https://github.com/r-lib/styler)).

6. Lint the package and provide lint feedback as annotations (in PRs) using the [lintr package](https://github.com/r-lib/lintr).

### Auto Maintenance Updates

If automated package maintenance is run from an internal PR, these updates are pushed to the PR branch. If the PR originated from a fork and any of the above tasks changed the source code, the check fails with an informative message.

If auto package maintenance is run from the main branch of the primary source repository, a PR is opened with the changes. The PR is automatically managed: if subsequent changes are added to the main branch, the PR is updated via force push, or the PR is closed if the changes resolved any package maintenance needs. The branch name for the automated PR is `auto-pkg-maintenance`, and this workflow assumes the default branch is `main`.

## Development

Currently, the workflows and actions in the branch are `v1`. When you make changes to the updates, the `v1` tag should be (forcefully) moved forward to the latest commit in `rstudio/education-workflows`. To do this run:

```bash
git tag -f v1 && git push origin --tags -f
```

## License ![CC0 licensed](https://img.shields.io/github/license/rstudio/education-workflows)

All examples in this repository are published with the [CC0](./LICENSE) license.


