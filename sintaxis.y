%{
#include <stdlib.h>
#include <stdio.h>
//-- Lexer prototype required by bison, aka getNextToken()
int yylex();
int yyerror(const char *p) { printf("Error!\n"); }
%}
//-- SYMBOL SEMANTIC VALUES -----------------------------
%union {
  double value;
  char symbol[50];
};
%token <value> NUM
%token <symbol> BOOL
%token <symbol> STRING
%token <symbol> DEF VAR_NAME AS
%token <symbol> TYPE_NUM TYPE_BOOL TYPE_STRING
%token <symbol> ASSING
%token <symbol> IF WHILE
%token <symbol> OP_ARI OP_LOG LP RP LC RC
%type <symbol> operacion asignacion
//-- GRAMMAR RULES ---------------------------------------
%%
programa: sentencia
        | programa sentencia {}

sentencia: declaracion
         | asignacion
         | bucle
         | condicional {}

declaracion: DEF VAR_NAME AS TYPE_NUM { printf("def number success.\n", $2);}
           | DEF VAR_NAME AS TYPE_BOOL { printf("def bool success.\n", $2);}
           | DEF VAR_NAME AS TYPE_STRING { printf("def string success.\n", $2);}

asignacion: VAR_NAME ASSING NUM { printf("assign number success.\n"); }
          | VAR_NAME ASSING booleano { printf("assign boolean success.\n"); }
          | VAR_NAME ASSING STRING { printf("assign string success.\n"); }
          | VAR_NAME ASSING VAR_NAME { printf("assign variable success.\n"); }
          | VAR_NAME ASSING operacion { printf("assign operation success.\n"); }

operacion: LP VAR_NAME OP_ARI VAR_NAME RP
         | LP VAR_NAME OP_ARI NUM RP
         | LP NUM OP_ARI NUM RP
         | LP NUM OP_ARI VAR_NAME RP
         | LP VAR_NAME OP_LOG NUM RP
         | LP NUM OP_LOG NUM RP
         | LP NUM OP_LOG VAR_NAME RP
         | LP VAR_NAME OP_LOG VAR_NAME RP  {}

booleano: BOOL
        | OP_LOG VAR_NAME
        | VAR_NAME OP_LOG NUM
        | NUM OP_LOG NUM
        | NUM OP_LOG VAR_NAME
        | VAR_NAME OP_LOG VAR_NAME { printf("boolean success.\n"); }

bucle: WHILE LP booleano RP LC programa RC { printf("while success.\n"); }
     | WHILE LP VAR_NAME RP LC programa RC { printf("while success.\n"); }

condicional: IF LP booleano RP LC programa RC { printf("if success.\n"); }
           | IF LP VAR_NAME RP LC programa RC { printf("if success.\n"); }
%%
//-- FUNCTION DEFINITIONS ---------------------------------
int main() {
  yyparse();
  return 0;
}
