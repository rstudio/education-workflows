# deploy-learnr-shinyapps-io

```yaml
on:
  push:
    branches: main
    
name: Deploy Tutorials to shinyapps.io

jobs:
  deploy:
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
            nycflights13
            tidyverse
            Lahman
            DBI
            RSQLite
            sortable
            dygraphs
            reticulate
```
