fmt:
	futhark fmt *.fut
.PHONY: fmt

check: test
	futhark fmt --check *.fut
.PHONY: check

test:
	futhark test -i *.fut
.PHONY: test

%: %.fut Makefile
	futhark fmt $<
	futhark c --Werror $<

# Transform the input into something that Futhark can process
%: %.txt Makefile
	cat $< | jq -Rs > $<.in

run-example: example
	cat example.txt.in | futhark run main.fut
.PHONY: run-example

run: input
	cat input.txt.in | futhark run main.fut
.PHONY: run
