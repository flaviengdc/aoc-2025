MAKEFLAGS += --no-builtin-rules --no-builtin-variables

FC := gfortran
FCFLAGS := -g -O2 -fimplicit-none -Werror -Wall -Wextra -Wline-truncation -Wcharacter-truncation -Wsurprising  -Waliasing -Wimplicit-interface -Wunused-parameter -fwhole-file -fcheck=all -lasan -std=f2018 -pedantic -fbacktrace -fsanitize=address,undefined

%: %.f90 Makefile
	@$(FC) $(FCFLAGS) -o $@ $<
