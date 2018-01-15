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

extern int lg_sem (Tlds*ds, const Tpdt*pdt){

	Tpoint entree = ds->in;
	Tpoints *sorties = pdt->out;

	//RS1
	if(ds->dx < 3 || ds->dy < 3){	//check size
		return 1;
	}

	//RS2
	for(int i=0;i<sorties.nb;i++){
		if(sorties->t[i].x == entree.x && sorties->t[i].y == entree.y)
			return 1;
	}
	if(ds->squares[entree.x][entree.y].opt == LDS_OptWH)
		return 1;

	//RS3
	if(sorties->nb<=0){
		return 1;
	}
	for(int i=0;i<sorties->nb;i++){
		if(ds->squares[sorties->t[i].x][sorties->t[i].y].opt == LDS_OptWH)
			return 1;
	}

	//RS4
	if(!lds_checkborder_pt(ds, ds->in))
		return 1;

	for(int i=0;i<sorties->nb;i++){
		if(!lds_checkborder_pt(ds, sorties->t[i]))
			return 1;
	}

	//RS5 - DONE par yacc

	//RS6
	for(int i=0;i<PDT_WHSIZE;i++){
		if(pdt->whin[i] == NULL)
			break;
		if(!lds_check_pt(ds, pdt->whin[i]))
			return 1;
	}
	for(int i=0;i<PDT_WHSIZE;i++){
		if(pdt->whout[i] == NULL)
			break;
		if(!lds_check_pt(ds, pdt->whout[i]))
			return 1;
	}

	//RS7
	for(int i=0;i<pdt->md->nb;i++){
			for(int j=0;j<LG_WrNb;j++){
				if(ds->squares[pdt->md->t[i].x][pdt->md->t[i].y]->u.mdp->t[j].chg){
					if(!lds_check_pt(ds, ds->squares[pdt->md->t[i].x][pdt->md->t[i].y]->u.mdp->t[j].dest))
						return 1;
			}
		}
	}

	//RS8 TODO dans le yacc

	//RS9 euh je crois que c'est bon
	//R10 TODO dans le yacc
	//RS10 TODO warning

	}

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

/*======================================================================*/
