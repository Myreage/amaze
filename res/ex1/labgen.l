%option noyywrap
%option yylineno

%%

N { return N ; }
NW { return NW; }
NE { return NE ; }

S { return S ; }
SW { return SW; }
SE { return SE ; }

W { return W; }
E { return E; }

#.* ;
[ \t\n] ;

.          return *yytext;
