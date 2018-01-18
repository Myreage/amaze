/*************************************************************************
 *   $cours: lex/yacc
 * $section: projet
 *      $Id: util.c 440 2017-10-20 16:34:42Z ia $
 * $HeadURL: svn://lunix120.ensiie.fr/ia/cours/lex-yacc/src/labyrinthe/labgen/util.c $
 *  $Author: Ivan Auge (Email: auge@ensiie.fr)
*************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

#include "top.h"
#include "lds.h"
#include "pdt.h"

/*======================================================================*/

extern void* u_malloc(int sz)
{
    void* ret = malloc( sz );
    if ( ret==0 ) u_noMoreMem();
    return ret;
}

extern void* u_malloc0(int sz)
{
    void* ret = u_malloc( sz );
    memset(ret,0,sz);
    return ret;
}

extern char* u_strdup (Cstr str)
{
    char* dup = strdup(str);
    if ( dup==0 )
        u_noMoreMem();
    return dup;
}

extern int lg_gen (Tlds*ds, FILE* lstream, FILE*ystream, Cstr lcfname){

//.y
	fprintf(ystream,"%%{#include <stdio.h>\n#include <stdlib.h>\nint perdu = 0;\n%%}\n");
	fprintf(ystream,"%%token NW\n%%token SW\n%%token NE\n%%token SE\n%%token W\n%%token N\n%%token S\n%%token E\n%%token W\n%%%%\n\n");

//start
	Tpoint start = ds->in;
	fprintf(ystream,"e%d%d\n",start.x,start.y);
	char b = ':';

	if(!lds_check_xy(ds, start.x - 1, start.y) && !(ds->squares[start.x - 1][start.y].kind == LDS_WALL)){
		fprintf(ystream,"%cW e%d%d\n",b, start.x - 1, start.y);
		b='|';
	}
	if(!lds_check_xy(ds, start.x + 1, start.y) && !(ds->squares[start.x + 1][start.y].kind == LDS_WALL)){
		fprintf(ystream,"%cE e%d%d\n",b, start.x + 1, start.y);
		b='|';
	}
	if(!lds_check_xy(ds, start.x, start.y + 1) && !(ds->squares[start.x][start.y + 1].kind == LDS_WALL)){
		fprintf(ystream,"%cS e%d%d\n",b, start.x, start.y + 1);
		b='|';
	}
	if(!lds_check_xy(ds, start.x, start.y - 1) && !(ds->squares[start.x][start.y - 1].kind == LDS_WALL)){
		fprintf(ystream,"%cN e%d%d\n",b, start.x, start.y - 1);
		b='|';
	}
	if(!lds_check_xy(ds, start.x - 1, start.y - 1) && !(ds->squares[start.x - 1][start.y - 1].kind == LDS_WALL)){
		fprintf(ystream,"%cNW e%d%d\n",b, start.x - 1, start.y - 1);
		b='|';
	}
	if(!lds_check_xy(ds, start.x - 1, start.y + 1) && !(ds->squares[start.x - 1][start.y + 1].kind == LDS_WALL)){
		fprintf(ystream,"%cSW e%d%d\n",b, start.x - 1, start.y + 1);
		b='|';
	}
	if(!lds_check_xy(ds, start.x + 1, start.y + 1) && !(ds->squares[start.x + 1][start.y + 1].kind == LDS_WALL)){
		fprintf(ystream,"%cSE e%d%d\n",b, start.x + 1, start.y + 1);
		b='|';
	}
	if(!lds_check_xy(ds, start.x + 1, start.y - 1) && !(ds->squares[start.x + 1][start.y - 1].kind == LDS_WALL)){
		fprintf(ystream,"%cNE e%d%d\n",b, start.x + 1, start.y - 1);
		b='|';
	}

	//all states but in
	for(int i=0;i<ds->dx;i++){
		for(int j=0;j<ds->dy;j++){
			if(!(i == start.x && j == start.y) && !(ds->squares[i][j].kind == LDS_WALL)){

				fprintf(ystream,"\ne%d%d\n",i,j);
				if(ds->squares[i][j].kind == LDS_OUT){
					fprintf(ystream,": {exit(0);}");
				}
				else if(ds->squares[i][j].opt == LDS_OptWH)	{
					fprintf(ystream,":e%d%d\n", ds->squares[i][j].u.whdest.x, ds->squares[i][j].u.whdest.y);
				}
				else{
				char b = ':';

				if(!lds_check_xy(ds, i - 1, j) && !(ds->squares[i - 1][j].kind == LDS_WALL)){
					fprintf(ystream,"%cW e%d%d\n",b, i - 1, j);
					b='|';
				}
				if(!lds_check_xy(ds, i + 1, j) && !(ds->squares[i + 1][j].kind == LDS_WALL)){
					fprintf(ystream,"%cE e%d%d\n",b, i + 1, j);
					b='|';
				}
				if(!lds_check_xy(ds, i, j + 1) && !(ds->squares[i][j + 1].kind == LDS_WALL)){
					fprintf(ystream,"%cS e%d%d\n",b, i, j + 1);
					b='|';
				}
				if(!lds_check_xy(ds, i, j - 1) && !(ds->squares[i][j - 1].kind == LDS_WALL)){
					fprintf(ystream,"%cN e%d%d\n",b, i, j - 1);
					b='|';
				}
				if(!lds_check_xy(ds, i - 1, j - 1) && !(ds->squares[i - 1][j - 1].kind == LDS_WALL)){
					fprintf(ystream,"%cNW e%d%d\n",b, i - 1, j - 1);
					b='|';
				}
				if(!lds_check_xy(ds, i - 1, j + 1) && !(ds->squares[i - 1][j + 1].kind == LDS_WALL)){
					fprintf(ystream,"%cSW e%d%d\n",b, i - 1, j + 1);
					b='|';
				}
				if(!lds_check_xy(ds, i + 1, j + 1) && !(ds->squares[i + 1][j + 1].kind == LDS_WALL)){
					fprintf(ystream,"%cSE e%d%d\n",b, i + 1, j + 1);
					b='|';
				}
				if(!lds_check_xy(ds, i + 1, j - 1) && !(ds->squares[i + 1][j - 1].kind == LDS_WALL)){
					fprintf(ystream,"%cNE e%d%d\n",b, i + 1, j - 1);
					b='|';
				}
			}
			}
		}
	}
fprintf(ystream,"\n%%%%\n#include \"labres.lex.c\"\n");
fprintf(ystream,"char* filename = \"entry\";\n");

fprintf(ystream,"int yyerror(const char* mess){fprintf(stderr,\"%%s:%%d: %%s (near %%s)\\n\",filename,yylineno,mess,yytext);exit(1);}\n");
fprintf(ystream,"int main(int argc, char** argv){if(argc==2){filename = argv[1];yyin=fopen(argv[1],\"r\");}else if (argc!=1){fprintf(stderr,\"FATAL : Unexpected number of arguments\\n\");	exit(1);}return yyparse();}");

	//.l
	fprintf(lstream,"%%option noyywrap\n%%option yylineno\n%%%%\nNE {return NE; }\nNW {return NW; }\nSE {return SE; }\nSW {return SW; }\nN { return N ; }\nS { return S ; }\nW { return W; }\nE { return E; }\n#.* ;\n[ \\t\\n] ;\n. return *yytext;\n");

		return 0;
}


extern int lg_sem (Tlds*ds, const Tpdt*pdt){

	Tpoint entree = ds->in;
	Tpoints *sorties = pdt->out;

	//wormholes
	for(int i=0;i<pdt->whnb;i++){
		ds->squares[pdt->whin[i].x][pdt->whin[i].y].opt = LDS_OptWH;
		ds->squares[pdt->whin[i].x][pdt->whin[i].y].u.whdest = pdt->whout[i];
	}

	//RS1
	if(ds->dx < 2 || ds->dy < 2){	//check size
		printf("error rs1\n");
		return 1;
	}

	//RS2
	for(int i=0;i<sorties->nb;i++){
		if(sorties->t[i].x == entree.x && sorties->t[i].y == entree.y){
			printf("error rs2\n");
			return 1;
		}
	}
	if(ds->squares[entree.x][entree.y].opt == LDS_OptWH){
		printf("error rs2\n");
		return 1;
	}

	//RS3
	if(sorties->nb<=0){
		printf("error rs3\n");
		return 1;
	}
	for(int i=0;i<sorties->nb;i++){
		if(ds->squares[sorties->t[i].x][sorties->t[i].y].opt == LDS_OptWH){
			printf("error rs3\n");
			return 1;
		}
	}

	//RS4
	if(lds_checkborder_pt(ds, ds->in)){
		printf("error rs4\n");
		return 1;
	}

	for(int i=0;i<sorties->nb;i++){
		if(lds_checkborder_pt(ds, sorties->t[i])){
			printf("%d %d\n", sorties->t[i].x, sorties->t[i].y);
			printf("error rs4\n");
			return 1;
		}
	}

	//RS5 - DONE par yacc



	//RS7
	for(int i=0;i<pdt->md->nb;i++){
			for(int j=0;j<LG_WrNb;j++){
				if(ds->squares[pdt->md->t[i].x][pdt->md->t[i].y].u.mdp->t[j].chg){
					if(lds_check_pt(ds, ds->squares[pdt->md->t[i].x][pdt->md->t[i].y].u.mdp->t[j].dest)){
						printf("error rs7\n");
						return 1;
					}
			}
		}
	}

	//RS8 TODO dans le yacc

	//RS9 euh je crois que c'est bon
	//R10 TODO dans le yacc
	//RS10 TODO warning
	return 0;
	}



/*======================================================================*/

extern void u_noMoreMem()
{
    fprintf(stderr,"%s:no more memory\n",gl_progname);
    exit(1);
}

extern int   u_error(const char*fmt,...) // like printf, return always 1
{
    char buf[10000];
    va_list ap;
    va_start(ap,fmt);
    vsprintf(buf,fmt,ap);
    va_end(ap);
    fprintf(stderr,"%s: %s\n",gl_progname,buf);
    return 1;
}
extern void u_warning(const char*fmt,...) // like printf, return always 1
{
    if ( gl_warning==0) return;
    char buf[10000];
    va_list ap;
    va_start(ap,fmt);
    vsprintf(buf,fmt,ap);
    va_end(ap);
    fprintf(stderr,"%s: %s\n",gl_progname,buf);
}

extern void yyerror(const char* fmt)
{
    fprintf(stderr,"%s",fmt);
    exit(1);
}

/*======================================================================*/
