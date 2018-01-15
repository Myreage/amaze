
CC=cc
CFLAGS=-lfl
EXEC=ex2
SRCGEN=./labgen/
SRCLIB=./labgen/lib/
SRCEX2=./res/ex2/
SRCEX1=./res/ex1/

all: gen ex1 ex2

gen: labgen.tab.c pdt.o lds.o top.o vars.o points.o wr.o
	$(CC) -o $(SRCGEN)labgen $(SRCGEN)labgen.tab.c wr.o vars.o points.o pdt.o lds.o top.o $(CFLAGS)

pdt.o:
	$(CC) -c $(SRCLIB)pdt.c

lds.o:
	$(CC) -c $(SRCLIB)lds.c

vars.o:
	$(CC) -c $(SRCLIB)vars.c

wr.o:
	$(CC) -c $(SRCLIB)wr.c

points.o:
	$(CC) -c $(SRCLIB)points.c

top.o:
	$(CC) -c $(SRCLIB)top.c

labgen.tab.c: labgen.yy.c $(SRCGEN)labgen.y
	yacc -o  $(SRCGEN)labgen.tab.c  $(SRCGEN)labgen.y

labgen.yy.c :
	flex -o $(SRCGEN)labgen.yy.c $(SRCGEN)labgen.l

ex1: labresex1.tab.c
	$(CC) -o $(SRCEX1)ex1 $(SRCEX1)labresex1.tab.c $(CFLAGS)

labresex1.tab.c: labresex1.yy.c $(SRCEX1)labres.y
	yacc -o $(SRCEX1)labresex1.tab.c  $(SRCEX1)labres.y

labresex1.yy.c :
	flex -o $(SRCEX1)labresex1.yy.c $(SRCEX1)labres.l

ex2: labresex2.tab.c
	$(CC) -o $(SRCEX2)ex2 $(SRCEX2)labresex2.tab.c $(CFLAGS)

labresex2.tab.c: labresex2.yy.c  $(SRCEX2)labres.y
	yacc -o  $(SRCEX2)labresex2.tab.c  $(SRCEX2)labres.y

labresex2.yy.c :
	flex -o $(SRCEX2)labresex2.yy.c $(SRCEX2)labres.l


clean: clnex1
	rm -rf ./labgen/*.c ./labgen/labgen ./*.o

clnex1: clnex2
	rm -rf ./res/ex1/*.c ./res/ex1/ex1

clnex2:
	rm -rf $(SRCEX2)*.c $(SRCEX2)ex2
