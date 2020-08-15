#ifndef __scheme_objects_h__
#define __scheme_objects_h__

#define MAX_INPUT_SIZE 10000
#define MAX_SYMBOL_SIZE 50
#define FLOAT_TOL 1e-6

typedef enum LispType {
    NIL, BOOLEAN, NUMBER, SYMBOL, FUNCTION, QUOTED, PAIR 
} LispType;

typedef struct LispObject {
    LispType type;
    double NumberVal;
    bool BoolVal;
    char SymbolVal[MAX_SYMBOL_SIZE];
    /* Quote contents */
    struct LispObject* QuotePointer;
    /* Pair contents */
    struct LispObject* CarPointer;
    struct LispObject* CdrPointer;
} LispObject;

extern LispObject LispNull;

void print_lisp_object(LispObject* lisp_obj);

void free_lisp_object(LispObject* the_object);

LispObject* parse_input(char** tokens);

char** tokenize_string(char* tokenize_me);

char** input_to_tokens(char* input);
#endif
