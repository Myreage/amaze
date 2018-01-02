CC=cc
CFLAGS=-lfl
EXEC=ex2
SRCGEN=./

all: gen

gen: labgen.tab.c
	$(CC) -o $(SRCGEN)labgen $(SRCGEN)labgen.tab.c $(CFLAGS)

labgen.tab.c: labgen.yy.c $(SRCGEN)labgen.y
	yacc -o  $(SRCGEN)labgen.tab.c  $(SRCGEN)labgen.y

labgen.yy.c :
	flex -o $(SRCGEN)labgen.yy.c $(SRCGEN)labgen.l

clean:
	rm -rf ./*.c ./labgen