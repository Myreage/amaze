%option noyywrap
%option yylineno
%%
("NE"|"SE"|"SW"|"NW"|"N"|"S"|"E"|"W") { return DIR; }
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
[a-zA-Z]([a-zA-Z]*[0-9]*)* { return IDENT; }
[0-9]+  { yylval.valeur = atoi(yytext);return CNUM; }


#.* ;
[ \t\n] ;

.          return *yytext;
