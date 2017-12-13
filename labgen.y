%{
#include <stdio.h>
#include <stdlib.h>
%}

%token IDENT
%token DIR
%token CNUM

%%

expr
  : IDENT
  | CNUM
  | expr '+' expr
  | expr '-' expr
  | expr '*' expr
  | expr '/' expr
  | expr '%' expr
  | expr ' ' expr
  | '(' expr ')'
;

pt
  : '(' expr ',' expr ')'
;



%%
#include "lex.yy.c"

int yyerror(const char* mess)
{
    fprintf(stderr,"FATAL: %s (near %s)\n",mess,yytext);
    exit(1);
}

int main()
{
    return yyparse();
}
