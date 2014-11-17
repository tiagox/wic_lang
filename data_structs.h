typedef enum symbol_type {
  T_NUMBER,
  T_BOOLEAN,
  T_STRING
} SymbolType;

static const char *symbol_type_name[] = {
  "number",
  "boolean",
  "string"
};

typedef struct symbol_data {
  char name[50];
  SymbolType type;
} Symbol;

typedef struct variable {
  char name[50];
  SymbolType type;
} Variable;
