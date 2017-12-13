%option noyywrap
op (\+|\-|\/|\*|%)

%%
(NE|SE|SW|NW|N|S|E|W) { return DIR; }
([a-z|A-Z]([0-9]|[a-z|A-Z])*) { return IDENT; }
(\+|\-)?[0-9]+  { return CNUM; }
op { return op; }

#.* ;

[ \t\n] ;

#[^\n]*\n       ;
.          return *yytext;
