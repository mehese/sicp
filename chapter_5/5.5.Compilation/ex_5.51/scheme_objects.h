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
    // If it's a pair
    struct LispObject* CarPointer;
    struct LispObject* CdrPointer;
} LispObject;

extern LispObject LispNull;

void print_lisp_object(LispObject* lisp_obj);

void free_lisp_object(LispObject* the_object);

LispObject* create_empty_lisp_object(LispType ze_type);

LispObject* create_lisp_atom_from_string(char* token);

#endif
