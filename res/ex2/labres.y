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
	| S smt { perdu=1; }
	| E smt { perdu=1; }
	| W smt { perdu=1; }
;

smt
	:
	| N smt
	| S smt
	| W smt
	| E smt
;

%%
#include "labresex2.yy.c"
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
		if(perdu){
			printf("Vous avez perdu...\n");
			return 1;
		}
		else{
			printf("Gagné !\n");
    	return 0;
		}
}
