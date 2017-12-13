%{
#include <stdio.h>
#include <stdlib.h>
%}

%token IDENT
%token DIR
%token OUT
%token CNUM
%token SHOW
%token SIZE
%token IN
%left '+' '-'
%left '*' '/' '%'
%left UMINUS

%%

labyrinthe
	: line
;

line
	: IN pt
	| declaration ';'
	| SIZE expr ';'
	| SIZE expr ',' expr ';'
	| OUT pt_list ';'
	| SHOW
	| IDENT '+' '=' expr ';'
	| IDENT '-' '=' expr ';'
	| IDENT '/' '=' expr ';'
	| IDENT '%' '=' expr ';'
	| IDENT '*' '=' expr ';'
;

pt_list
	: pt {}
	| pt_list pt {}
;

pt
	: '(' expr ',' expr ')' {}
;

declaration
	: IDENT '=' expr {}
;

expr
  : IDENT
  | CNUM
	| '-' expr %prec UMINUS {}
	| '+' expr %prec UMINUS {}
  | expr '+' expr {}
  | expr '-' expr {}
	| expr '*' expr
  | expr '/' expr
	| expr '%' expr
  | '(' expr ')' {}
;

range
  : '[' expr ':' expr ':' expr ']' {}
  | '[' expr ':' expr ':' expr '[' {}
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
