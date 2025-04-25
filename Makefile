.PHONY: test
test: 
	Rscript -e "testthat::test_local()"
