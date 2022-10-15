all: run

.PHONY: run
run: link
	@./main

.PHONY: compile
compile:
	@yasm -f elf64 -g dwarf2 -l main.lst main.asm

.PHONY: link
link: compile
	@gcc main.o -o main
