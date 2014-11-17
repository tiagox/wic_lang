/**
 * Exaples
 * -------
 * variables: asd123 | asd | a1b2c3 | aVar | aVar123
 * number: 123 | 123.456 | 0123.000
 * boolean: true | false
 * string: "Solo string y con comillas dobles"
 * operadores aritméticos: + - * /
 * operadores lógicos: and or not < > = # >= <=
 */
%{
#include "data_structs.h"
#include "y.tab.h"
%}
%option noyywrap
OP_ARI "+"|"-"|"*"|"/"
OP_LOG "not"|"and"|"or"|">"|"<"|"="|"#"|">="|"<="
NUMBER "0"|(-)?[1-9][0-9]*(\.[0-9]+)?
STRING \"[^\"]*["]
BOOLEAN "true"|"false"
VAR_NAME [a-zA-Z][a-zA-Z0-9]*
%%
"def"                   { return DEF; }
"as"                    { return AS; }
"<-"                    { return ASSING; }
{OP_ARI}                { return OP_ARI; }
{OP_LOG}                { return OP_LOG; }
"number"                { return TYPE_NUMBER; }
"boolean"               { return TYPE_BOOLEAN; }
"string"                { return TYPE_STRING; }
"if"                    { return IF; }
"while"                 { return WHILE; }
"("                     { return LP; }
")"                     { return RP; }
"{"                     { return LC; }
"}"                     { return RC; }
{STRING}                {
                          // for(i = 1; i < strlen(yytext) - 1; i++) {
                          //   yytext[i - 1] = yytext[i];
                          // }
                          // yytext[i - 1] = '\0';
                          // strcpy(yylval.symbol, yytext);
                          yylval.type = 2;
                          return STRING;
                        }
{BOOLEAN}               {
                          yylval.type = 1;
                          return BOOLEAN;
                        }
{NUMBER}                {
                          // yylval.value = atof(yytext);
                          yylval.type = 0;
                          return NUMBER;
                        }
{VAR_NAME}              {
                          strcpy(yylval.symbol, yytext);
                          return VAR_NAME;
                        }
<<EOF>>                 { return 0; }
[ \t\n]+                { }
.                       { printf("Unrecognized token!: %s\n", yytext); exit(1); }
%%
