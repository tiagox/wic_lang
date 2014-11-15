%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
//-- Lexer prototype required by bison, aka getNextToken()
int yylex();
int yyerror(const char *p);

typedef enum {
  T_NUMBER = 0,
  T_BOOLEAN = 1,
  T_STRING = 2
} SymbolType;

typedef struct {
  char name[50];
  int type;
} Symbol;

Symbol symbolTable[50];

int symbolTableIndex;

void addNode(char *name, SymbolType type);
void printTable();
int getType(char *name);

%}
//-- SYMBOL SEMANTIC VALUES -----------------------------
%union {
  double value;
  char symbol[50];
  int type;
};

%token <symbol> TYPE_NUMBER TYPE_BOOLEAN TYPE_STRING
%token <symbol> DEF AS
%token <symbol> ASSING
%token <symbol> IF WHILE
%token <symbol> OP_ARI OP_LOG LP RP LC RC

%token <type> NUMBER BOOLEAN STRING
%token <symbol> VAR_NAME
%type <type> operacion asignacion
%type <type> booleano


//-- GRAMMAR RULES ---------------------------------------
%%
programa: sentencia
        | programa sentencia {}

sentencia: declaracion
         | asignacion
         | bucle
         | condicional {}

declaracion: DEF VAR_NAME AS TYPE_NUMBER  { addNode($2, T_NUMBER); }
           | DEF VAR_NAME AS TYPE_BOOLEAN { addNode($2, T_BOOLEAN); }
           | DEF VAR_NAME AS TYPE_STRING  { addNode($2, T_STRING); }

asignacion: VAR_NAME ASSING NUMBER    {
                                        SymbolType type = getType($1);

                                        if (type == -1) {
                                          yyerror("Variable no declarada");
                                        }

                                        if (type != $3) {
                                          yyerror("Error de tipos en asignacion");
                                        }
                                      }
          | VAR_NAME ASSING booleano  {
                                        SymbolType type = getType($1);

                                        if (type == -1) {
                                          yyerror("Variable no declarada");
                                        }

                                        if (type != $3) {
                                          yyerror("Error de tipos en asignacion");
                                        }
                                      }
          | VAR_NAME ASSING STRING    {
                                        SymbolType type = getType($1);

                                        if (type == -1) {
                                          yyerror("Variable no declarada");
                                        }

                                        if (type != $3) {
                                          yyerror("Error de tipos en asignacion");
                                        }
                                      }
          | VAR_NAME ASSING operacion {
                                        SymbolType type = getType($1);

                                        if (type == -1) {
                                          yyerror("Variable no declarada");
                                        }

                                        if (type != $3) {
                                          yyerror("Error de tipos en asignacion");
                                        }
                                      }
          | VAR_NAME ASSING VAR_NAME  {
                                        SymbolType type_left = getType($1);

                                        if (type_left == -1) {
                                          yyerror("Variable no declarada");
                                        }

                                        SymbolType type_rigth = getType($3);

                                        if (type_rigth == -1) {
                                          yyerror("Variable no declarada");
                                        }

                                        if (type_left != type_rigth) {
                                          yyerror("Error de tipos en asignacion");
                                        }
                                      }

operacion: LP VAR_NAME OP_LOG VAR_NAME RP {
                                            SymbolType type_left = getType($2);

                                            if (type_left == -1) {
                                              yyerror("Variable no declarada");
                                            }

                                            SymbolType type_rigth = getType($4);

                                            if (type_rigth == -1) {
                                              yyerror("Variable no declarada");
                                            }

                                            if (type_left != type_rigth) {
                                              yyerror("Error de tipos en operacion");
                                            }

                                            $$ = T_BOOLEAN;
                                          }
         | LP VAR_NAME OP_ARI VAR_NAME RP {
                                            SymbolType type_left = getType($2);

                                            if (type_left == -1) {
                                              yyerror("Variable no declarada");
                                            }

                                            SymbolType type_rigth = getType($4);

                                            if (type_rigth == -1) {
                                              yyerror("Variable no declarada");
                                            }

                                            if (type_left != type_rigth) {
                                              yyerror("Error de tipos en operacion");
                                            }

                                            $$ = T_NUMBER;
                                          }
         | LP VAR_NAME OP_LOG NUMBER RP   {
                                            SymbolType type_left = getType($2);

                                            if (type_left == -1) {
                                              yyerror("Variable no declarada");
                                            }

                                            if (type_left != $4) {
                                              yyerror("Error de tipos en operacion");
                                            }

                                            $$ = T_BOOLEAN;
                                          }
         | LP VAR_NAME OP_ARI NUMBER RP   {
                                            SymbolType type_left = getType($2);

                                            if (type_left == -1) {
                                              yyerror("Variable no declarada");
                                            }

                                            if (type_left != $4) {
                                              yyerror("Error de tipos en operacion");
                                            }

                                            $$ = T_NUMBER;
                                          }
         | LP NUMBER OP_LOG NUMBER RP     {
                                            if ($2 != $4) {
                                              yyerror("Error de tipos en operacion");
                                            }

                                            $$ = T_BOOLEAN;
                                          }
         | LP NUMBER OP_ARI NUMBER RP     {
                                            if ($2 != $4) {
                                              yyerror("Error de tipos en operacion");
                                            }

                                            $$ = T_NUMBER;
                                          }
         | LP NUMBER OP_LOG VAR_NAME RP   {
                                            SymbolType type_rigth = getType($4);

                                            if (type_rigth == -1) {
                                              yyerror("Variable no declarada");
                                            }

                                            if ($2 != type_rigth) {
                                              yyerror("Error de tipos en operacion");
                                            }

                                            $$ = T_BOOLEAN;
                                          }
         | LP NUMBER OP_ARI VAR_NAME RP   {
                                            SymbolType type_rigth = getType($4);

                                            if (type_rigth == -1) {
                                              yyerror("Variable no declarada");
                                            }

                                            if ($2 != type_rigth) {
                                              yyerror("Error de tipos en operacion");
                                            }

                                            $$ = T_NUMBER;
                                          }

booleano: BOOLEAN                 {
                                    $$ = T_BOOLEAN;
                                  }
        | OP_LOG VAR_NAME         {
                                    SymbolType type = getType($2);

                                    if (type == -1) {
                                      yyerror("Variable no declarada");
                                    }

                                    if (type != T_BOOLEAN) {
                                      yyerror("La variable debe ser booleana");
                                    }

                                    $$ = T_BOOLEAN;
                                  }
        | VAR_NAME OP_LOG NUMBER  {
                                    SymbolType type_left = getType($1);

                                    if (type_left == -1) {
                                      yyerror("Variable no declarada");
                                    }

                                    if (type_left != $3) {
                                      yyerror("Error de tipos en condicion");
                                    }

                                    $$ = T_BOOLEAN;
                                  }
        | NUMBER OP_LOG NUMBER    {
                                    $$ = T_BOOLEAN;
                                  }
        | NUMBER OP_LOG VAR_NAME  {
                                    SymbolType type_rigth = getType($3);

                                    if (type_rigth == -1) {
                                      yyerror("Variable no declarada");
                                    }

                                    if ($1 != type_rigth) {
                                      yyerror("Error de tipos en condicion");
                                    }

                                    $$ = T_BOOLEAN;
                                  }
        | VAR_NAME OP_LOG VAR_NAME {
                                      SymbolType type_left = getType($1);

                                      if (type_left == -1) {
                                        yyerror("Variable no declarada");
                                      }

                                      SymbolType type_rigth = getType($3);

                                      if (type_rigth == -1) {
                                        yyerror("Variable no declarada");
                                      }

                                      if (type_left != type_rigth) {
                                        yyerror("Error de tipos en condicion");
                                      }

                                      $$ = T_BOOLEAN;
                                    }

bucle: WHILE LP booleano RP LC programa RC {}
     | WHILE LP VAR_NAME RP LC programa RC {
                                              SymbolType type = getType($3);

                                              if (type == -1) {
                                                yyerror("Variable no declarada");
                                              }

                                              if (type != T_BOOLEAN) {
                                                yyerror("Error de tipo en condicion");
                                              }

                                            }

condicional: IF LP booleano RP LC programa RC {}
           | IF LP VAR_NAME RP LC programa RC {
                                                SymbolType type = getType($3);

                                                if (type == -1) {
                                                  yyerror("Variable no declarada");
                                                }

                                                if (type != T_BOOLEAN) {
                                                  yyerror("Error de tipo en condicion");
                                                }

                                              }
%%
//-- FUNCTION DEFINITIONS ---------------------------------
int main() {
  symbolTableIndex = 0;

  yyparse();
  printf("Compilacion existosa.\n");
  return 0;
}

int yyerror(const char *p) {
  printf("Error!: %s.\n", p);
  exit(1);
}

/**
 * Agrega una variable a la tabla de símbolos.
 * @param name Nombre de la variable.
 * @param type Tipo de la variable.
 */
void addNode(char *name, SymbolType type) {
  Symbol symbol;
  strcpy(symbol.name, name);
  symbol.type = type;
  symbolTable[symbolTableIndex] = symbol;
  symbolTableIndex++;
}

void printTable() {
  int i;
  for (i = 0; i < symbolTableIndex; i++) {
    printf("%s\t%d\n", symbolTable[i].name, symbolTable[i].type);
  }
}

/**
 * @param name Nombre de la variable.
 * @return     Retorna el tipo del simbolo. Si no existe, devuelve -1.
 */
int getType(char *name) {
  int i = 0;
  while (i < symbolTableIndex) {
    if (strcmp(name, symbolTable[i].name) == 0) {
      return symbolTable[i].type;
    }
    i++;
  }
  return -1;
}
