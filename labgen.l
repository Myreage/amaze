/*IDENT [a-z|A-Z]([0-9]|[a-z|A-Z])*
CNUM (\+|\-)?[0-9]+
DIR (NE|SE|SW|NW|N|S|E|W)*/

%option noyywrap

%%
(NE|SE|SW|NW|N|S|E|W) { return DIR; }
([a-z|A-Z]([0-9]|[a-z|A-Z])*) { return IDENT; }
(\+|\-)?[0-9]+  { return CNUM; }
(IDENT|CNUM|\+|\-|\*|\/|\%|\s)* { return exprBuff; }
\(exprBuff\)|exprBuff { return expr; }
#.* ;

[ \t\n] ;

#[^\n]*\n       ;
.          return *yytext;
