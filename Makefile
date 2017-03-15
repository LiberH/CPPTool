CC      = powerpc-linux-gnu-gcc-5
AS      = powerpc-linux-gnu-as
CFLAGS	= -m32 -std=c89 -ggdb -fno-tree-loop-distribute-patterns
LDFLAGS = -Wl,-T$(SRC)/script.ld,$(OBJ)/crt0.o -nostdlib

SRC = src
OBJ = obj
BIN = bin
BIN_CSM = $(BIN)/cosmic
BIN_GCC = $(BIN)/gcc
BIN_MDL = $(BIN_GCC)/malardalen
BIN_TPL = $(BIN_GCC)/trampoline

# Default:
all: dirs bin-mdl

# Directories:
DIRS = $(OBJ) $(BIN_MDL)
dirs: | $(OBJ)
$(DIRS):
	mkdir -p $(DIRS)

# crt0 file:
crt0: dirs $(OBJ)/crt0.o
$(OBJ)/crt0.o: $(SRC)/crt0.S
	$(AS) $< -o $@

# Executable files:
SRCS = $(wildcard $(SRC)/*.c)
BINS = $(SRCS:$(SRC)/%.c=$(BIN_MDL)/%)
bin-mdl: crt0 $(BINS)
	@rm -f $(BIN_MDL)/nsichneu*.elf    # too big for Dot export
	@rm -f $(BIN_MDL)/insertsort*.elf  # (HARMLESS-)Stall in -O3.elf
	@rm -f $(BIN_MDL)/ud*.elf          # bug at COSMIC compile time
$(BIN_MDL)/%: $(SRC)/%.c
	@echo "Making ELF files for ... `basename $@`"
	@$(CC) $< -o $@-O0.elf -O0 $(CFLAGS) $(LDFLAGS)
	@$(CC) $< -o $@-O1.elf -O1 $(CFLAGS) $(LDFLAGS)
	@$(CC) $< -o $@-O2.elf -O2 $(CFLAGS) $(LDFLAGS)
	@$(CC) $< -o $@-O3.elf -O3 $(CFLAGS) $(LDFLAGS)

# Benchmark suite:
malardalen:
	@for elf in $(BIN_MDL)/*.elf; do \
	  $(BEST_TRGT) --template=$(BEST_PLUGIN_PATH)/template.xml $$elf --cfg-only; \
	  dot -Tdot $$elf-cfg.dot -o $$elf.dot; \
	  $(BEST_TRGT) --template=$(BEST_PLUGIN_PATH)/template.xml $$elf; \
	done

# Cleaning:
clean:
	rm -rf ./$(OBJ)

	rm -rf ./$(BIN_CSM)/*.dot
	rm -rf ./$(BIN_CSM)/*.elf-*
	rm -rf ./$(BIN_CSM)/*.xml

	rm -rf ./$(BIN_MDL)/*.dot
	rm -rf ./$(BIN_MDL)/*.elf-*
	rm -rf ./$(BIN_MDL)/*.xml

	rm -rf ./$(BIN_TPL)/*.dot
	rm -rf ./$(BIN_TPL)/*.elf-*
	rm -rf ./$(BIN_TPL)/*.xml

