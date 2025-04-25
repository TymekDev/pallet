describe("pallet - a single-file directory", {
  it("works with a single exported function", {
    # Arrange
    pallet_dir <- withr::local_tempdir()
    writeLines("foo <- function() {}", tempfile(tmpdir = pallet_dir, fileext = ".R"))

    # Act
    pallet <- .create(pallet_dir)

    # Assert
    testthat::expect_equal(names(pallet), "foo")
  })

  it("doesn't export dot-prefixed functions", {
    # Arrange
    pallet_dir <- withr::local_tempdir()
    writeLines("foo <- function() {}

.bar <- function() {}", tempfile(tmpdir = pallet_dir, fileext = ".R"))

    # Act
    pallet <- .create(pallet_dir)

    # Assert
    testthat::expect_equal(names(pallet), "foo")
  })

  it("attaches objects", {
    # Arrange
    pallet_dir <- withr::local_tempdir()
    writeLines("value <- 123", tempfile(tmpdir = pallet_dir, fileext = ".R"))

    # Act
    pallet <- .create(pallet_dir)

    # Assert
    testthat::expect_equal(names(pallet), "value")
    testthat::expect_equal(pallet$value, 123)
  })

  it("has functions available to each other within a single file", {
    # Arrange
    pallet_dir <- withr::local_tempdir()
    writeLines("foo <- function() .bar() + 3

.bar <- function() 2", tempfile(tmpdir = pallet_dir, fileext = ".R"))

    # Act
    pallet <- .create(pallet_dir)
    result <- pallet$foo()

    # Assert
    testthat::expect_equal(result, 5)
  })
})

describe("pallet - a multi-file directory", {
  it("works with two exported functions (one per file)", {
    # Arrange
    pallet_dir <- withr::local_tempdir()
    writeLines("foo <- function() {}", tempfile(tmpdir = pallet_dir, fileext = ".R"))
    writeLines("bar <- function() {}", tempfile(tmpdir = pallet_dir, fileext = ".R"))

    # Act
    pallet <- .create(pallet_dir)

    # Assert
    testthat::expect_equal(names(pallet), c("foo", "bar"))
  })

  it("doesn't export dot-prefixed functions", {
    # Arrange
    pallet_dir <- withr::local_tempdir()
    writeLines("foo <- function() {}", tempfile(tmpdir = pallet_dir, fileext = ".R"))
    writeLines(".bar <- function() {}", tempfile(tmpdir = pallet_dir, fileext = ".R"))

    # Act
    pallet <- .create(pallet_dir)

    # Assert
    testthat::expect_equal(names(pallet), "foo")
  })

  it("has exported functions available to each other across files", {
    # Arrange
    pallet_dir <- withr::local_tempdir()
    writeLines("foo <- function() 100", tempfile(tmpdir = pallet_dir, fileext = ".R"))
    writeLines("bar <- function() 23", tempfile(tmpdir = pallet_dir, fileext = ".R"))
    writeLines("baz <- function() foo() + bar()", tempfile(tmpdir = pallet_dir, fileext = ".R"))

    # Act
    pallet <- .create(pallet_dir)
    result <- pallet$baz()

    # Assert
    testthat::expect_equal(result, 123)
  })

  it("has unexported functions available to each other across files", {
    # Arrange
    pallet_dir <- withr::local_tempdir()
    writeLines(".foo <- function() 100", tempfile(tmpdir = pallet_dir, fileext = ".R"))
    writeLines(".bar <- function() 23", tempfile(tmpdir = pallet_dir, fileext = ".R"))
    writeLines("baz <- function() .foo() + .bar()", tempfile(tmpdir = pallet_dir, fileext = ".R"))

    # Act
    pallet <- .create(pallet_dir)
    result <- pallet$baz()

    # Assert
    testthat::expect_equal(names(pallet), "baz")
    testthat::expect_equal(result, 123)
  })
})
