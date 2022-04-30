%{
#include "y.tab.h"
%}
%%
"print"				   {return print;}
"True"				   {return _true_;}
"False"				   {return _false_;}

"<"					   {return lt;}
">"					   {return gt;}
"=="				   {return eq;}
"<="				   {return lteq;}
">="				   {return gteq;}
"!="				   {return nteq;}

[a-zA-Z]			   {yylval.id = yytext[0]; return identifier;}
[0-9]+                 {yylval.num = atoi(yytext); return number;}
[ \t\n]                ;
[-+=;*/(){}%]           {return yytext[0];}
.                      {ECHO; yyerror ("unexpected character"); exit(1);}

%%
int yywrap (void) {return 1;}
