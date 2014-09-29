/**
 * Exaples
 * -------
 * variables: asd123 | asd | a1b2c3 | aVar | aVar123
 * numeros: 123 | 123.456 | 0123.000
 * boolean: true | false
 * operadores: + - * / and or not
 * cadenas: 'asd'
 */
%{
#include "y.tab.h"
int i;
%}
%option noyywrap
/*[1-9][0-9]*(\.[0-9]+)?  { yylval.value = atof(yytext); return NUM; }*/
%%
"def"                 { return DEF; }
"as"                  { return AS; }
"number"              { return TYPE_NUM; }
"while"               { return WHILE; }
"("                   { return LP; }
")"                   { return RP; }
"{"                   { return LC; }
"}"                   { return RC; }
[a-zA-Z][a-zA-Z0-9]*  {
                        yylval.symbol = malloc(strlen(yytext) + 1);
                        strcpy(yylval.symbol, yytext);
                        return VAR_NAME;
                      }
<<EOF>>               { return 0; }
[ \t\n]+              { }
.                     { printf("Unrecognized token!"); exit(1); }
%%
