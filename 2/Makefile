all: run

.PHONY: run
run: compile
	@./main

.PHONY: compile
compile:
	@yasm -f elf64 -g dwarf2 -l main.lst main.asm
	@gcc main.o -o main -z noexecstack

.PHONY: debug
debug: compile
	@gdb main

.PHONY: format
format:
	@nasmfmt *.asm
