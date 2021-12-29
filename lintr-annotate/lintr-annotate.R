#! /usr/bin/env Rscript
# lint package and add file annotations via GHA messages

Sys.setlocale(locale = "C")
Sys.setenv(R_CLI_NUM_COLORS = 1)

lints <- lintr::lint_package(cache = FALSE)

# "informal" linters get notices rather than warnings
informal_linters <- c(
  "closed_curly_linter",
  "commas_linter",
  "function_left_parentheses_linter",
  "line_length_linter",
  "object_length_linter",
  "object_name_linter",
  "open_curly_linter",
  "paren_brace_linter",
  "pipe_continuation_linter",
  "single_quotes_linter",
  "spaces_inside_linter",
  "spaces_left_parentheses_linter",
  "trailing_blank_lines_linter",
  "trailing_whitespace_linter"
)

for (lint in lints) {
  msg <- sprintf(
    "\n::%s file=%s,line=%d,col=%d,endColumn=%d,title=%s::%s",
    if (lint$linter %in% informal_linters) "notice" else "warning",
    lint$filename,
    lint$line_number,
    lint$ranges[[1]][[1]],
    lint$ranges[[1]][[2]],
    paste("lintr", lint$type, lint$linter, sep = " - "),
    # print lintr message as GHA-compatible multiline log message
    paste(capture.output(print(lint)), collapse = "%0A")
  )
  cat(msg)
}
