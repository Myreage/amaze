%{
#include <stdio.h>
#include <stdlib.h>
%}

%token N
%token NE
%token NW
%token S
%token SE
%token SW
%token E
%token W


%%


%%
#include "lex.yy.c"
int yyerror(const char* mess)
{
    fprintf(stderr,"line:%d %s (near %s)\n",yylineno,mess,yytext);
    exit(1);
}
int main()
{
    return yyparse();
}
