%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <libgen.h>
	#include <string.h>
	#include <errno.h>

	#include "lib/top.h"

	/*======================================================================*/
	/*= Global variables                                                   =*/

	const char* gl_progname;  // base name of running program.
	const char* gl_infname;   // base name of input file name
	Tpdt* gl_pdt;             // parser private data
	Tlds* gl_lds;             // labyrinth data structure
	int   gl_warning;         // 0:do not print warnings

	void setOut(Tpoints* p)
	{
		int k = p->nb;
		int list = p->t;
		for(int i=0;i<k;i++){
			gl_lds->squares[list[i].x][list[i].y].kind = LDS_OUT;
		}
		gl_pdt->out = p;
	}

	void setIn(Tpoint* p)
	{
		gl_lds->in = p;
		gl_lds->squares[p.x][p.y].kind = LDS_IN;
		gl_pdt->in = p;
	}

%}

%union{
	int cst;
	Cstr varname;
}

%token <varname> IDENT
%token DIR
%token OUT
%token <cst> CNUM
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

file
	:	lines_before_size size lines_after_size_before_out in lines_after_size_before_out out lines_after_size
	| lines_before_size size lines_after_size_before_out out lines_after_size in lines_after_size
;

line_before_size
	: TERM
	| declaration TERM
	| IDENT '+' '=' expr TERM {int *res; pdt_var_get(gl_pdt,$1,res);$$=*res+$4;}
	| IDENT '-' '=' expr TERM {int *res; pdt_var_get(gl_pdt,$1,res);$$=*res-$4;}
	| IDENT '/' '=' expr TERM {int *res; pdt_var_get(gl_pdt,$1,res);$$=*res/$4;}
	| IDENT '%' '=' expr TERM {int *res; pdt_var_get(gl_pdt,$1,res);$$=*res%$4;}
	| IDENT '*' '=' expr TERM {int *res; pdt_var_get(gl_pdt,$1,res);$$=*res*$4;}
;

lines_before_size
	:
	| line_before_size lines_before_size
;

size
	: SIZE expr TERM {lds_size_set(gl_lds, $2, $2);}
	| SIZE expr ',' expr TERM {lds_size_set(gl_lds, $2, $4);}
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
	| OUT pt_list TERM {setOut($2);}
;

lines_after_size
	:
	| line_after_size lines_after_size
;

in
	: IN pt TERM {setIn($2);}
		}
;

out
	: OUT pt_list TERM {setOut($2);}
	}
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
	: pt {Tpoints* p = pts_new_pt($1); $$ = p; }
	| pt_list pt {pts_app_pt ($1, $2); $$ = $1;}
;

pt_list_r
	: pt r
	| pt_list_r pt r
;

pt
	: '(' expr ',' expr ')' {Tpoint p; p.x=$2; p.y=$4; $$=p;}
;

r
	:
	| ':' expr
	| ':' '*'
;

expr
  : IDENT {int *res; pdt_var_get(gl_pdt,$1,res);$$=*res;}
  | CNUM {$$=$1;}
	| '-' expr %prec UMINUS {$$=0-$2;}
	| '+' expr %prec UMINUS {$$=$2;}
  | expr '+' expr {$$=$1 + $3;}
  | expr '-' expr {$$=$1 - $3;}
	| expr '*' expr {$$=$1 * $3;}
  | expr '/' expr {$$=$1 / $3;}
	| expr '%' expr {$$=$1 % $3;}
  | '(' expr ')' {$$=$2;}
;

declaration
	: IDENT '=' expr { pdt_var_chgOrAddCloned (gl_pdt, $1, $3); }
;

%%
/*======================================================================*/
/*= program argument                                                   =*/

typedef struct _Tparam {
    char* infilename;
    FILE* instream;
    char* outfilename;
} Tparam;

static Tparam main_getParam(int argc, char*argv[])
{
    char *p = strdup(argv[0]);
    gl_progname = strdup(basename(p));
    free(p);

    Tparam param;
    if ( argc==1 ) {
        param.infilename="stdin";
        param.instream=stdin;
        param.outfilename="labres";
        return param;
    }
    if ( argc==2 ) {
        param.infilename=argv[1];
        param.instream=0;
        param.outfilename="labres";
    } else if ( argc==3 ) {
        param.infilename=argv[1];
        param.instream=0;
        param.outfilename=argv[3];
    } else {
        fprintf(stderr,"%s: to many arguments. usage: %s if exec\n",
                gl_progname,gl_progname);
        exit(1);
    }

    if ( (param.instream=fopen(param.infilename,"r"))==0 ) {
        fprintf(stderr,"%s: can not open %s file for reading: %s\n",
                gl_progname,param.infilename,strerror(errno));
        exit(1);
    }

    return param;
}

/*======================================================================*/
/*= main program                                                       =*/

int main(int argc, char*argv[])
{
    Tparam param=main_getParam(argc,argv);

    char* p = strdup(param.infilename);
    gl_infname = strdup(basename(p));
    free(p);

    gl_pdt = pdt_new();
    gl_lds = lds_new();

    // parsing
    extern FILE* yyin;
    yyin = param.instream;
    if ( yyparse() )
        return 1; // mess. printed by yyparse
    fclose( param.instream );
    //yydestroy();

    // check semantique
    if ( lg_sem(gl_lds, gl_pdt) )
        return 1; // mess. printed by lg_sem
    pdt_free( gl_pdt );

    // génération of labres lex & yacc codes
    // into lfname and yfname files
    char  lfname[FNAME_SZ],  yfname[FNAME_SZ];
    char  lcfname[FNAME_SZ], ycfname[FNAME_SZ];
    FILE *lstream,         *ystream;
    sprintf(lfname,  "%s.l",     param.outfilename);
    sprintf(yfname,  "%s.y",     param.outfilename);
    sprintf(lcfname, "%s.lex.c", param.outfilename);
    sprintf(ycfname, "%s.tab.c", param.outfilename);
    if ( (lstream=fopen(lfname,"w"))==0 ) {
        fprintf(stderr,"%s: can not open %s file for writing: %s\n",
                gl_progname,lfname,strerror(errno));
        exit(1);
    }
    if ( (ystream=fopen(yfname,"w"))==0 ) {
        fprintf(stderr,"%s: can not open %s file for writing: %s\n",
                gl_progname,yfname,strerror(errno));
        exit(1);
    }
    if ( lg_gen(gl_lds,lstream,ystream,lcfname) )
        return 1; // mess. printed by lg_gen
    fclose(lstream); fclose(ystream);
    lds_free( gl_lds );

    // génération of labres from lfname (lex) and yfname (yacc) files
    int status=0;
    char cmd[4*FNAME_SZ+100];
    sprintf(cmd,"bison -o %s %s 2>/dev/null",ycfname,yfname);
    if ( system(cmd)!=0 )
        exit(u_error("parser generation fails: %s",cmd));
    sprintf(cmd,"flex -o %s %s",lcfname,lfname);
    if ( system(cmd)!=0 )
        exit(u_error("parser generation fails: %s",cmd));
    sprintf(cmd,"gcc -g -o %s %s",param.outfilename,ycfname);
    if ( system(cmd)!=0 ) {
        u_error("parser generation fails: %s",cmd);
        u_error("no way from input to output",cmd);
        status = 1;
    }
#if 0
    sprintf(cmd,"rm -f %s %s %s %s",lfname,lcfname,yfname,ycfname);
    if ( system(cmd)!=0 )
        u_error("cleanup of parser generation fails: %s\n",
            gl_progname,cmd);
#endif

    if ( status==0 )
        fprintf(stderr,"%s: %s labyrinth resolver is generated.\n",
            gl_progname,param.outfilename);
    free( (char*)gl_progname );
    free( (char*)gl_infname );
    return status;
}

/*======================================================================*/
