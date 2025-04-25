#' @export
`$.pallet` <- function(pallet, name) {
  if (!(name %in% names(pallet))) {
    stop(sprintf("name '%s' not found in '%s'", name, attr(pallet, "name")))
  }

  get(name, envir = pallet)
}

#' @export
print.pallet <- function(x, ...) {
  cat(paste0("<pallet:", attr(x, "name"), ">\n"))
  invisible(x)
}

.create <- function(pallet_dir) {
  pallet_name <- basename(pallet_dir)
  pallet_file_paths <- list.files(pallet_dir, "\\.R$", full.names = TRUE)

  # Load everything into a "private" namespace environment
  ns <- new.env(parent = baseenv())
  for (path in pallet_file_paths) {
    # TODO: this seems like a silly idea...
    eval(parse(text = readLines(path)), ns)
  }

  # Reassign public objects to the public pallet environment
  env <- new.env(parent = emptyenv())
  for (name in names(ns)) {
    if (substr(name, 1, 1) == ".") next
    env[[name]] <- ns[[name]]
    lockBinding(name, env)
  }
  lockEnvironment(env)

  structure(
    env,
    class = "pallet",
    name = pallet_name,
    namespace = ns
  )
}
