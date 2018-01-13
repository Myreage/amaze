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

	void wallAll(TdrawOpt opt){
		Tpoint p;
		for(int i=0;i<gl_lds->dy;i++){
			for(int j=0;j<gl_lds->dx;j++){
				p.x=i;
				p.y=j;
				lds_draw_pt(gl_lds, opt, p);
			}
		}
	}
	Tpoint sumPt(Tpoints* p){
		Tpoint res;
		res.x=0;
		res.y=0;
		for(int i=0;i<p->nb;i++){
			res.x+=p->t[i].x;
			res.y+=p->t[i].y;
		}
		return res;
	}

void drawRect(Tpoint p1,Tpoint2,TdrawOpt opt){
	Tpoint to_draw;
	if(p1.x<p2.x && p1.y<p2.y){	//cas hg->bd
		to_draw = p1;
		//arrête du haut
		for(int i=p1.x;i<p2.x;i++){
			to_draw.x = p1.x+i;
			lds_draw_pt (gl_lds, opt, to_draw);
		}
		//arrête du bas
		to_draw.x = p1.x;
		to_draw.y = p2.y;
		for(int i=p1.x;i<p2.x;i++){
			to_draw.x = p1.x+i;
			lds_draw_pt (gl_lds, opt, to_draw);
		}
		//arrête de gauche
		to_draw = p1;
		for(int i=p1.y;i<p2.y;i++){
			to_draw.y = p1.y+i;
			lds_draw_pt (gl_lds, opt, to_draw);
		}
		//arrête de droite
		to_draw.x = p2.x;
		to_draw.y = p1.y;
		for(int i=p1.y;i<p2.y;i++){
			to_draw.y = p1.y+i;
			lds_draw_pt (gl_lds, opt, to_draw);
		}

	}
	else if(p1.x<p2.x && p1.y>p2.y){	//cas bg->hd
		//arrête du haut
		to_draw.x = p1.x;
		to_draw.y = p2.y;
		for(int i=p1.x;i<p2.x;i++){
			to_draw.x = p1.x+i;
			lds_draw_pt (gl_lds, opt, to_draw);
		}
		//arrête du bas
		to_draw = p1;
		for(int i=p1.x;i<p2.x;i++){
			to_draw.x = p1.x+i;
			lds_draw_pt (gl_lds, opt, to_draw);
		}
		//arrête de gauche
		to_draw = p1;
		for(int i=p1.y;i<p2.y;i++){
			to_draw.y = p1.y-i;
			lds_draw_pt (gl_lds, opt, to_draw);
		}
		//arrête de droite
		to_draw=p2;
		for(int i=p1.y;i<p2.y;i++){
			to_draw.y = p2.y+i;
			lds_draw_pt (gl_lds, opt, to_draw);
		}

	}
	else{
		drawRect(p2,p1,opt);
	}
}

void drawRectF(Tpoint p1,Tpoint2,TdrawOpt opt){
	Tpoint to_draw;
	if(p1.x<p2.x && p1.y<p2.y){	//cas hg->bd
		for(int i=p1.x;i<p2.x;i++){
			for(int j=p1.y;j<p2.y;j++){
				to_draw.x = i;
				to_draw.y = j;
				lds_draw_pt (gl_lds, opt, to_draw);
			}
		}
	}
	else if(p1.x<p2.x && p1.y>p2.y){	//cas bg->hd
		for(int i=p1.x;i<p2.x;i++){
			for(int j=p2.y;j<p1.y;j++){
				to_draw.x = i;
				to_draw.y = j;
				lds_draw_pt (gl_lds, opt, to_draw);
			}
		}
	}
	else{
		drawRect(p2,p1,opt);
	}
}

void ptd(Tpoints* p,TdrawOpt opt){
	Tpoint counter=p->t[0];
	Tpoint new_p;
	for(int i=0;i<p->nb;i++){
		new_p.x = counter.x + p->t[i].x;
		new_p.y = counter.y + p->t[i].y;
		lds_draw_pt (gl_lds, opt, new_p);
	}
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
	| WALL TERM {wallAll(LG_DrawWall);}
	| WALL PTA pt_list TERM {lds_draw_pts(gl_lds, LG_DrawWall, $3);}
	| WALL PTD pt_list_r TERM {ptd(Tpoints* p,LG_DrawWall);}
	| WALL R pt pt TERM {drawRect($3,$4,LG_DrawWall);}
	| WALL R F pt pt TERM {drawRectF($3,$4,LG_DrawWall);}
	| WALL FOR ident_list IN range_list '(' expr ',' expr ')' TERM
	| UNWALL TERM {wallAll(LG_DrawUnwall);}
	| UNWALL PTA pt_list TERM {lds_draw_pts(gl_lds, LG_DrawUnWall, $3);}
	| UNWALL PTD pt pt_list_r TERM {ptd(Tpoints* p,LG_DrawUnWall);}
	| UNWALL R pt pt TERM {drawRect($3,$4,LG_DrawUnWall);}
	| UNWALL R F pt pt TERM {drawRectF($3,$4,LG_DrawUnWall);}
	| UNWALL FOR ident_list IN range_list '(' expr ',' expr ')' TERM
	| TOGGLE TERM {wallAll(LG_DrawToggle;}
	| TOGGLE PTA pt_list TERM {lds_draw_pts(gl_lds, LG_DrawToggle, $3);}
	| TOGGLE PTD pt pt_list_r TERM {ptd(Tpoints* p,LG_DrawToggle);}
	| TOGGLE R pt pt TERM {drawRect($3,$4,LG_DrawToggle);}
	| TOGGLE R F pt pt TERM {drawRectF($3,$4,LG_DrawToggle);}
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
	| WALL TERM {wallAll(LG_DrawWall);}
	| WALL PTA pt_list TERM {lds_draw_pts(gl_lds, LG_DrawWall, $3);}
	| WALL PTD pt_list_r TERM {ptd(Tpoints* p,LG_DrawWall);}
	| WALL R pt pt TERM {drawRect($3,$4,LG_DrawWall);}
	| WALL R F pt pt TERM {drawRectF($3,$4,LG_DrawWall);}
	| WALL FOR ident_list IN range_list '(' expr ',' expr ')' TERM
	| UNWALL TERM {wallAll(LG_DrawUnwall);}
	| UNWALL PTA pt_list TERM {lds_draw_pts(gl_lds, LG_DrawUnWall, $3);}
	| UNWALL PTD pt pt_list_r TERM {ptd(Tpoints* p,LG_DrawUnWall);}
	| UNWALL R pt pt TERM {drawRect($3,$4,LG_DrawUnWall);}
	| UNWALL R F pt pt TERM {drawRectF($3,$4,LG_DrawUnWall);}
	| UNWALL FOR ident_list IN range_list '(' expr ',' expr ')' TERM
	| TOGGLE TERM {wallAll(LG_DrawToggle;}
	| TOGGLE PTA pt_list TERM {lds_draw_pts(gl_lds, LG_DrawToggle, $3);}
	| TOGGLE PTD pt pt_list_r TERM {ptd(Tpoints* p,LG_DrawToggle);}
	| TOGGLE R pt pt TERM {drawRect($3,$4,LG_DrawToggle);}
	| TOGGLE R F pt pt TERM {drawRectF($3,$4,LG_DrawToggle);}
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
	: p { Tpoints* p = pts_new_pt($1); $$ = p;}
	| pt_list_r pt r {
		Tpoints* res = $1
		Tpoint p = $2;
		pts_app_pt ($1, p);
		Tpoint counter = p;
		if($3==9999999999) {
			counter = sumPt(res);
			while(counter.x<gl_lds->dx && counter.y<gl_lds->dy){
				pts_app_pt(plist,p);;
				counter = sumPt(res);
			}
		}
		else {
			for(int i=0;i<$3;i++){
				pts_app_pt(plist,p);;
			}
		}
	}

pt
	: '(' expr ',' expr ')' {Tpoint p; p.x=$2; p.y=$4; $$=p;}
;

r
	: {$$=1;}
	| ':' expr {$$=$2;}
	| ':' '*'	{$$=9999999999;}
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
