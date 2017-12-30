%{
#include <stdio.h>
#include <stdlib.h>

/********************************************/
/****************LINKED LISTS****************/
/********************************************/

typedef struct t_liste {
  int info;
  struct t_liste *suivant;
} Cellule, *Liste;

/* Test de vacuité */

int isEmpty(Liste liste){
  if (liste == NULL) return 1;
  else return 0;
}

/* Constructeur */

Liste newList(int head, Liste tail){
  Cellule *c;
  c = (Cellule*)malloc(sizeof(Cellule));
  c->info = head;
  c->suivant = tail;
  return c;
}

/* Affichage */

void printList(Liste liste){
  if(!isEmpty(liste)){
    printf("[%d]->", liste->info);
    printList(liste->suivant);
  }
  else{
    printf("[]\n");
  }
}

/*longueur liste*/
int listLength(Liste liste){
  if(!isEmpty(liste)) return 1 + listLength(liste->suivant);
  else return 0;
}

Liste invertList(Liste liste) {
  Liste res = NULL;
  while (!isEmpty(liste)) {
      Liste suivant = liste->suivant;
      liste->suivant = res;
      res = liste;
      liste = suivant;
  }
  return res;
}

/*Recherche de la présence d'un élement*/
int search(Liste liste, int e){
  while(!isEmpty(liste)){
    if (e==liste->info){
      return 1;
    }
    liste = liste->suivant;
    }

    return 0;
}

/*Suppression de tous les élements e d'une liste*/
Liste delete(int e, Liste liste){
  Liste res=NULL;

  if(liste->info == e){

    return liste->suivant;

  }

  else{

    while(!isEmpty(liste)){

      if (liste->info != e){
        res = newList(liste->info, res);
      }
      liste = liste->suivant;
    }

    return invertList(res);
  }
}
/********************************************/
/****************VARIABLES*******************/
/********************************************/

int size[2];
Liste** maze;

%}

%union {
	int valeur;
}

%token IDENT
%token DIR
%token OUT
%token <valeur>CNUM
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

%type <valeur> expr

%left '+' '-'
%left '*' '/' '%'
%left '('
%left ')'
%left UMINUS

%%

file
	:	lines_before_size size lines_after_size_before_out in lines_after_size_before_out out lines_after_size
	| lines_before_size size lines_after_size_before_out out lines_after_size in lines_after_size
;

line_before_size
	: TERM
	| declaration TERM
	| IDENT '+' '=' expr TERM
	| IDENT '-' '=' expr TERM
	| IDENT '/' '=' expr TERM
	| IDENT '%' '=' expr TERM
	| IDENT '*' '=' expr TERM
;

lines_before_size
	:
	| line_before_size lines_before_size
;

size
	: SIZE expr TERM 	{
											size[0]=$2;size[1]=$2;
											maze = malloc($2*sizeof(Liste*));
											for(int i=0;i<$2;i++){
												maze[i] = malloc($2*sizeof(Liste));
											}
										}
	| SIZE expr ',' expr TERM 	{
																size[0]=$2;size[1]=$4;
																maze = malloc($2*sizeof(Liste*));
																for(int i=0;i<$2;i++){
																	maze[i] = malloc($4*sizeof(Liste));
																}
															}
;

line_after_size_before_out
	: TERM
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
	| MD pt dest_list TERM
	| SHOW TERM
;

lines_after_size_before_out
	:
	| line_after_size_before_out lines_after_size_before_out
;


line_after_size
	: TERM
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
	| MD pt dest_list TERM
	| SHOW TERM
	| OUT pt_list TERM
;

lines_after_size
	:
	| line_after_size lines_after_size
;

in
	: IN pt TERM
;

out
	: OUT pt_list TERM
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
  | CNUM {$$=$1;}
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
#include "labgen.yy.c"
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
		int y = yyparse();
    return y;
}
