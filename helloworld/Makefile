all: run

.PHONY: run
run: compile
	@./hello

.PHONY: compile
compile:
	@nasm -felf64 hello.asm && ld hello.o -o hello
