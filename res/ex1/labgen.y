%{
#include <stdio.h>
#include <stdlib.h>
%}

%token N
%token S
%token E
%token W


%%

start
	: E { printf("Perdu !\n"); }
	| E e1
	| S { printf("Perdu !\n"); }
	| S s1
;

e1
	: E { printf("Perdu !\n"); }
	|	E e2
	| W start
;

e2
	: S { printf("Perdu !\n"); }
	| S e3
	| W e1
;

e3
	: S	{ printf("Bien joué bite !\n"); }
	| S e4
	| N e2
;

e4
	: N e3
	| W s3
;


s1
	: S { printf("Perdu !\n"); }
	|	S s2
	| N start
;

s2
	: E { printf("Perdu !\n"); }
	| E s3
	| N s1
;

s3
	: E	{ printf("Bien joué bite !\n"); }
	| E s4
	| W s2
;

s4
	: N e3
	| W s3
;


%%

#include "lex.yy.c"
int yyerror(const char* mess)
{
    fprintf(stderr,"Perdu t'es trop nul wesh\n");
    exit(1);
}
int main()
{
    return yyparse();
}
