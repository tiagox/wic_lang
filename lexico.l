/**
 * Exaples
 * -------
 * variables: asd123 | asd | a1b2c3 | aVar | aVar123
 * number: 123 | 123.456 | 0123.000
 * boolean: true | false
 * string; "Solo string y con comillas dobles"
 * operadores aritméticos: + - * /
 * operadores lógicos: and or not < > = # >= <=
 */
%{
#include "y.tab.h"
int i;
%}
%option noyywrap
OP_ARI "+"|"-"|"*"|"/"
OP_LOG "not"|"and"|"or"|">"|"<"|"="|"#"|">="|"<="
CADENA \"[^\"]*["]
VAL_BOOL "true"|"false"
%%
"def"                   { return DEF; }
"as"                    { return AS; }
"<-"                    { return ASSING; }
{OP_ARI}                { return OP_ARI; }
{OP_LOG}                { return OP_LOG; }
"number"                { return TYPE_NUM; }
"boolean"               { return TYPE_BOOL; }
"string"                { return TYPE_STRING; }
"if"                    { return IF; }
"while"                 { return WHILE; }
"("                     { return LP; }
")"                     { return RP; }
"{"                     { return LC; }
"}"                     { return RC; }
{CADENA}                {
                          for(i = 1; i < strlen(yytext) - 1; i++) {
                            yytext[i - 1] = yytext[i];
                          }
                          yytext[i - 1] = '\0';
                          strcpy(yylval.symbol, yytext);
                          return STRING;
                        }
{VAL_BOOL}              { return BOOL; }
[1-9][0-9]*(\.[0-9]+)?  {
                          yylval.value = atof(yytext);
                          return NUM;
                        }
"0"                     {
                          yylval.value = 0;
                          return NUM;
                        }
[a-zA-Z][a-zA-Z0-9]*    {
                          strcpy(yylval.symbol, yytext);
                          return VAR_NAME;
                        }
<<EOF>>                 { return 0; }
[ \t\n]+                { }
.                       { printf("Unrecognized token!: %s\n", yytext); exit(1); }
%%
