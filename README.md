# pallet

> _Because Go does imports right._

Pallet is a proof of concept of **directory-level imports for R**.

## Overview

A _pallet_ is a directory.
Every R script in that directory is a part of the pallet it is in.

If a function is prefixed with a dot (`.`), then it is "private" and not available outside the pallet.
However, those dot-prefixed functions can be used in other files within the same pallet.

Functions that aren't prefixed with a dot are "exported" and available outside of the pallet.

## Usage

> [!TIP]
> If you are familiar with {box}, then usage is similar to `box:use(path/to/directory)`.
> However, with pallet, the entire directory is in use (not only `__init__.R`).

### Single File

With an `.R` script in `path/to/directory` (its name doesn't matter):

```r
foo <- \() 100

.bar <- \() 23

baz <- \() foo() + .bar()
```

We can access only the functions that aren't prefixed with dot:

```r
pallet::use("path/to/directory")

directory$foo()
## 100

directory$.bar()
## Error in `$.pallet`(directory, .bar) : name '.bar' not found in 'directory'

directory$baz()
## 123
```

## Installation

```r
# install.packages("pak")
pak::pak("TymekDev/pallete")
```

## Aspirations

- [x] Single-file pallets
- [ ] Multi-file pallets
- [ ] Nested pallets
- [ ] Disallow pallet package attaching
- [ ] Pallet reloading
- [ ] Pallet Caching
- [ ] Linter for duplicated names within a pallet

## Motivation

I think Go does imports right.
Everything within a single directory (package) is available across files.
The first letter of an object name determines whether it is exported or not.
Uppercase is for exports and lowercase is for private functions.

Personally, I missed the directory-as-one in {box}.
I think it is nice to split things across multiple file without exposing them outside the directory.
