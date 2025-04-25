describe("use", {
  it("assigns a pallet in the calling environment", {
    # Arrange
    temp_dir <- withr::local_tempdir()
    pallet_dir <- withr::local_tempdir("dir", temp_dir)
    writeLines("foo <- function() {}", tempfile(tmpdir = pallet_dir, fileext = ".R"))

    # Act
    use(pallet_dir)

    # Assert
    testthat::expect_in(basename(pallet_dir), ls())
  })

  it("assigns multiple pallets in the calling environment", {
    # Arrange
    temp_dir <- withr::local_tempdir()
    pallet_dir1 <- withr::local_tempdir("dir", temp_dir)
    writeLines("foo <- function() {}", tempfile(tmpdir = pallet_dir1, fileext = ".R"))
    pallet_dir2 <- withr::local_tempdir("dir", temp_dir)
    writeLines("bar <- function() {}", tempfile(tmpdir = pallet_dir2, fileext = ".R"))

    # Act
    use(pallet_dir1, pallet_dir2)

    # Assert
    testthat::expect_in(c(basename(pallet_dir1), basename(pallet_dir2)), ls())
  })
})
