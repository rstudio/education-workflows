#! /usr/bin/env Rscript
# deploy tutorials (by directory) to shinyapps.io

options("rsconnect.error.trace" = TRUE)

main <- function() {
  set_account_info()
  tutorials_input <- tutorials_get_input()
  tutorials <- tutorials_resolve(tutorials_input)
  for (tutorial in tutorials) {
    deploy_tutorial(tutorial)
  }
}

gha_msg <- function(level = "notice", ..., title = NULL) {
  level <- match.arg(level, c("debug", "notice", "warning", "error"))
  command <-
    if (!is.null(title)) {
      paste0(level, " title=", title)
    } else {
      level
    }
  cat(sprintf("::%s::%s\n", level, paste(...)))

  if (identical(level, "error")) {
    stop(paste(...))
  }

  invisible()
}

set_account_info <- function() {
  rsconnect::setAccountInfo(
    name   = Sys.getenv("SHINYAPPS_NAME"),
    token  = Sys.getenv("SHINYAPPS_TOKEN"),
    secret = Sys.getenv("SHINYAPPS_SECRET")
  )
}

tutorials_get_input <- function() {
  x <- trimws(Sys.getenv("TUTORIAL_PATHS", ""))
  if (!nzchar(x)) {
    gha_msg("error", "No tutorials provided")
  }

  strsplit(x, "[[:space:],]+")[[1]]
}

tutorials_resolve <- function(tutorials) {
  # We consider these scenarios:
  # 1. The tutorial path is directly to an Rmd (all good)
  # 2. The tutorial path is a directory:
  #    - If it has one .Rmd, deploy that tutorial
  #    - If it has no .Rmds, recurse into that directory
  #    - If it has more than one .Rmd, throw a warning and discard

  paths <- c()

  while (length(tutorials)) {
    # pop first item off of stack of tutorials
    path <- tutorials[1]
    tutorials <- tutorials[-1]

    if (!fs::file_exists(path)) {
      gha_msg("warning", "Path does not exist, ignoring:", path)
      next
    }

    if (is_rmd(path)) {
      paths <- c(paths, path)
      next
    }

    if (!fs::is_dir(path)) {
      gha_msg("warning", "Path is not an .Rmd or directory, ignoring:", path)
      next
    }

    rmds <- rmds_in_dir(path)
    if (length(rmds) == 1) {
      paths <- c(paths, rmds)
      next
    }

    if (length(rmds) > 1) {
      gha_msg(
        "warning",
        "Multiple .Rmd files in directory, please specify which file(s) to deploy from:",
        path
      )
      next
    }

    # path is a directory without any Rmds, append any dirs it contains to stack
    dirs <- fs::dir_ls(path, type = "dir", recurse = FALSE)
    tutorials <- c(tutorials, dirs)
  }

  paths
}

is_rmd <- function(path) {
  identical(tolower(fs::path_ext(path)), "rmd")
}

rmds_in_dir <- function(path) {
  fs::dir_ls(path, regexp = "[.]rmd$", ignore.case = TRUE, recurse = FALSE, type = "file")
}

deploy_tutorial <- function(rmd) {
  cat(sprintf("\n::group::%s\n", rmd))
  on.exit(cat("\n::endgroup::\n"))

  rmd_file <- fs::path_file(rmd)

  rsconnect::deployApp(
    appDir = fs::path_dir(rmd),
    appPrimaryDoc = rmd_file,
    name = fs::path_ext_remove(rmd_file),
    server = Sys.getenv("SHINYAPPS_SERVER"),
    account = Sys.getenv("SHINYAPPS_NAME"),
    forceUpdate = TRUE,
    lint = FALSE,
    verbose = TRUE
  )
}




