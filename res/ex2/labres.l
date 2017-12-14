%option noyywrap
%option yylineno

%%

N { return N ; }
S { return S ; }
W { return W; }
E { return E; }

#.* ;
[ \t\n] ;

.          return *yytext;
