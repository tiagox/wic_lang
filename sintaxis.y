%{
#include <stdlib.h>
#include <stdio.h>
#include <strings.h>
//-- Lexer prototype required by bison, aka getNextToken()
int yylex();
int yyerror(const char *p) { printf("Error!"); }
%}
//-- SYMBOL SEMANTIC VALUES -----------------------------
%union {
  double value;
  char *symbol;
};
// %token <value> NUM
%token <symbol> VAR_NAME
%token DEF AS TYPE_NUM WHILE LP RP LC RC
//-- GRAMMAR RULES ---------------------------------------
%%
programa: sentencia
        | programa sentencia {}

sentencia: declaracion
         | loop {}

declaracion: DEF VAR_NAME AS TYPE_NUM { printf("int %s;\n", $2); }

condicion: TYPE_NUM {}

loop: WHILE LP condicion RP LC sentencia RC { printf("while ok\n"); }
%%
//-- FUNCTION DEFINITIONS ---------------------------------
int main() {
  yyparse();
  return 0;
}
