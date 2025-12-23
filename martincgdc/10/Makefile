run:
	julia --project=. ./bin/main.jl
.PHONY: run

test:
	julia --project -e 'using Pkg; Pkg.test()'
.PHONY: test

test-watch:
	julia --project=. ./watch.jl
.PHONY: test-watch

fmt:
	jlfmt --inplace .
.PHONY: fmt
