include conf/uhcaf.conf

all: singles

singles: compile-singles execute-singles

singles-select: compile-singles-select execute-singles-select

compile-singles:
	@echo "compiling with FC=$(FC) and FFLAGS=\"$(FFLAGS)\""
	FC=$(FC) FFLAGS="$(FFLAGS)" bash scripts/test-singles-compile-caf.sh

execute-singles:
	@bash scripts/test-singles-execute-caf.sh

compile-singles-select:
	@echo "compiling with FC=$(FC) and FFLAGS=\"$(FFLAGS)\""
	@FC=$(FC) FFLAGS="$(FFLAGS)" bash scripts/test-singles-compile-caf.sh select

execute-singles-select:
	@bash scripts/test-singles-execute-caf.sh select

clean:
	bash scripts/clean.sh

clobber:
	bash scripts/clean.sh
	-rm -rf run/bin
	-rm -rf run/compile-logs
	-rm -rf run/execute-logs

help:
	@echo "Makefile help for UH CAF Regression Test Suite"
	@echo "Available targets:"
	@echo "  - all (default)"
	@echo "    Compiles and runs all the single-file CAF tests"
	@echo "  - help"
	@echo "    Display this help"
	@echo "  - singles"
	@echo "    Compiles and runs all the single-file CAF tests"
	@echo "  - compile-singles"
	@echo "    Only compiles the single-file CAF tests"
	@echo "  - execute-singles"
	@echo "    Only executes the already compiled single-file CAF tests"
	@echo "  - singles-select"
	@echo "  - Compiles and runs selected CAF programs in the select directory"
	@echo "  - compile-singles-select"
	@echo "    Only compiles selected CAF programs in the select directory"
	@echo "  - execute-singles-select"
	@echo "    Only executes already compiled selected CAF programs in the select directory"
	@echo "Configuration variables:"
	@echo "  CONDUIT: name of communication layer to use for CAF. Using \"$(CONDUIT)\"."
	@echo "  FC     : name of CAF compiler to use. Using \"$(FC)\"."
	@echo "  FFLAGS : CAF compiler options. Using \"$(FFLAGS)\"."
