%{
#include <stdio.h>
#include <stdlib.h>
%}

%token IDENT
%token DIR
%token OUT
%token CNUM
%token WALL
%token PTA
%token PTD
%token WH
%token MD
%token UNWALL
%token TOGGLE
%token R
%token F
%token FOR
%token SHOW
%token TERM
%token SIZE
%token IN
%token ARROW
%left '+' '-'
%left '*' '/' '%'
%left '('
%left ')'
%left UMINUS

%%

labyrinthe
	: line
;

line
	: IN pt
	| TERM
	| declaration TERM
	| SIZE expr TERM
	| SIZE expr ',' expr TERM
	| OUT pt_list ';'
	| SHOW
	| IDENT '+' '=' expr TERM
	| IDENT '-' '=' expr TERM
	| IDENT '/' '=' expr TERM
	| IDENT '%' '=' expr TERM
	| IDENT '*' '=' expr TERM
	| WALL TERM
	| WALL PTA pt_list TERM
	| WALL PTD pt pt_list_r TERM
	| WALL R pt pt TERM
	| WALL R F pt pt TERM
	| WALL FOR ident_list IN range_list '(' expr ',' expr ')' TERM
	| UNWALL TERM
	| UNWALL PTA pt_list TERM
	| UNWALL PTD pt pt_list_r TERM
	| UNWALL R pt pt TERM
	| UNWALL R F pt pt TERM
	| UNWALL FOR ident_list IN range_list '(' expr ',' expr ')' TERM
	| TOGGLE TERM
	| TOGGLE PTA pt_list TERM
	| TOGGLE PTD pt pt_list_r TERM
	| TOGGLE R pt pt TERM
	| TOGGLE R F pt pt TERM
	| TOGGLE FOR ident_list IN range_list '(' expr ',' expr ')' TERM
	| WH pt_arrow_list TERM
	| MD pt dest_list
;

range_list
	: range
	| range_list range
;

range
  : '[' expr ':' expr ':' expr ']' {}
  | '[' expr ':' expr ':' expr '[' {}
	| '[' expr ':' expr  ']' {}
	| '[' expr ':' expr  '[' {}
;


pt_arrow_list
	: pt
	| pt ARROW pt_arrow_list
;

dest_list
	: DIR pt
	| DIR pt dest_list
;

ident_list
	: IDENT
	| ident_list IDENT
;

pt_list
	: pt {}
	| pt_list pt {}
;

pt_list_r
	: pt r
	| pt_list_r pt r
;

pt
	: '(' expr ',' expr ')' {}
;

r
	:
	| ':' expr
	| ':' '*'
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

declaration
	: IDENT '=' expr {}
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
