%{
#include <stdio.h>
#include <stdlib.h>

int perdu = 0;
%}

%token N
%token S
%token E
%token W


%%

start
	: N smt { perdu=1; }
	| S { perdu=1; }
	| E { perdu=1; }
	| W smt { perdu=1; }
	| E e1
	| S s1
;

e1
	: N smt { perdu=1; }
	| S smt { perdu=1; }
	| E { perdu=1; }
	| W { perdu=1; }
	|	E e2
	| W start
;

e2
	: N smt { perdu=1; }
	| S { perdu=1; }
	| E smt { perdu=1; }
	| W { perdu=1; }
	| S e3
	| W e1
;

e3
	: N { perdu=1; }
	| S
	| E smt { perdu=1; }
	| W smt { perdu=1; }
	| S e4
	| N e2
;

e4
	: N { perdu=1; }
	| S smt { perdu=1; }
	| E smt { perdu=1; }
	| W { perdu=1; }
	| N e3
	| W s3
;


s1
	: N { perdu=1; }
	| S { perdu=1; }
	| E smt { perdu=1; }
	| W smt { perdu=1; }
	|	S s2
	| N start
;

s2
	: N { perdu=1; }
	| S smt { perdu=1; }
	| E { perdu=1; }
	| W smt { perdu=1; }
	| E s3
	| N s1
;

s3
	: N smt{ perdu=1; }
	| S smt { perdu=1; }
	| E
	| W { perdu=1; }
	| E s4
	| W s2
;

s4
	: N { perdu=1; }
	| S smt { perdu=1; }
	| E smt{ perdu=1; }
	| W { perdu=1; }
	| N e3
	| W s3
;

smt
	:
	| N smt
	| S smt
	| W smt
	| E smt
;



%%
#include "lex.yy.c"
char* filename = "entry";

int yyerror(const char* mess)
{
    fprintf(stderr,"%s:%d: %s (near %s)\n",filename,yylineno,mess,yytext);
    exit(1);
}
int main(int argc, char** argv)
{
	if(argc==2){
		filename = argv[1];
		yyin=fopen(argv[1],"r");
	}
	else if (argc!=1){
		fprintf(stderr,"FATAL : Unexpected number of arguments\n");
		exit(1);
	}
		yyparse();
		if(perdu)
			printf("Vous avez perdu...\n");
		else
			printf("Gagné !\n");
    return 0;
}
