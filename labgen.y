%{
#include <stdio.h>
#include <stdlib.h>
%}

%token NUM

%left '+'
%left '*'

%%

expr
  : NUM
  | expr '+' expr { $$=$1+$3; printf("%d = %d + %d\n",$$,$1,$3); }
  | expr '*' expr { $$=$1*$3; printf("%d = %d * %d\n",$$,$1,$3); }
  | '(' expr ')' { $$=$2; printf("%d = ( %d )\n",$$,$2); }
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
