%option noyywrap
%option yylineno
%%
("NE"|"SE"|"SW"|"NW"|"N"|"S"|"E"|"W") {char *c = strdup(yytext);
	if(strcmp(c,"N"))
		yylval.dir = 0;
	else if(strcmp(c,"NE"))
		yylval.dir = 1;
	else if(strcmp(c,"E"))
		yylval.dir = 2;
	else if(strcmp(c,"SE"))
		yylval.dir = 3;
	else if(strcmp(c,"S"))
		yylval.dir = 4;
	else if(strcmp(c,"SW"))
		yylval.dir = 5;
	else if(strcmp(c,"W"))
		yylval.dir = 6;
	else if(strcmp(c,"NW"))
		yylval.dir = 7;


	return DIR; }
"IN" {return IN;}
"SIZE" {return SIZE;}
"OUT" {return OUT;}
"SHOW" {return SHOW;}
"WALL" {return WALL;}
"UNWALL" {return UNWALL;}
"TOGGLE" {return TOGGLE;}
"PTA" {return PTA;}
"PTD" {return PTD;}
"R" {return R;}
"F" {return F;}
"FOR" {return FOR;}
";" {return TERM;}
"WH" {return WH;}
"MD" {return MD;}
"->" {return ARROW;}
[a-zA-Z]([a-zA-Z]*[0-9]*)* { yylval.varname = strdup(yytext);return IDENT; }
[0-9]+  { yylval.cst = atoi(yytext);return CNUM; }


#.* ;
[ \t\n] ;

.          return *yytext;
