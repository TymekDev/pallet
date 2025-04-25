#' @export
use <- function(...) {
  env <- parent.frame()
  for (dir in list(...)) {
    if (!dir.exists(dir)) {
      stop(sprintf("directory '%s' doesn't exist", dir))
    }

    pallet <- .create(dir)
    assign(attr(pallet, "name"), pallet, envir = env)
  }
}
