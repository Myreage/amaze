%option noyywrap

%%
(NE|SE|SW|NW|N|S|E|W) { return DIR; }
"IN" {return IN;}
"SIZE" {return SIZE;}
"OUT" {return OUT;}
"SHOW" {return SHOW;}
[a-zA-Z]([a-zA-Z]*[0-9]*)* { return IDENT; }
[0-9]+  { return CNUM; }


#.* ;
[ \t\n] ;

.          return *yytext;
