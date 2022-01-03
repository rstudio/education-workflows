# deploy-learnr-shinyapps-io

```yaml
on:
  workflow_run:
    workflows: ["R-CMD-check"]
    branches: [main]
    types:
      - completed

name: Deploy Tutorials to shinyapps.io

jobs:
  deploy:
    if: ${{ github.event.workflow_run.conclusion == 'success' }}
    runs-on: ubuntu-latest
    env:
      GITHUB_PAT: ${{ secrets.GITHUB_TOKEN }}
    
    steps:
      - uses: actions/checkout@v1
      
      - uses: rstudio/education-workflows/deploy-learnr-shinyapps-io@v2
        with:
          shinyapps-name: ${{ secrets.SHINYAPPS_NAME }}
          shinyapps-token: ${{ secrets.SHINYAPPS_TOKEN }}
          shinyapps-secret: ${{ secrets.SHINYAPPS_SECRET }}
          tutorials: |
            inst/tutorials
          extra-packages: |
            any::nycflights13
            any::tidyverse
            any::Lahman
            any::DBI
            any::RSQLite
            any::sortable
            any::dygraphs
            any::reticulate
```
