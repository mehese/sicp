#ifndef __scheme_objects_h__
#define __scheme_objects_h__

#define MAX_INPUT_SIZE 10000
#define MAX_SYMBOL_SIZE 50
#define MAX_LAMBDA_ARGS 50
#define FLOAT_TOL 1e-6

typedef enum LispType {
    NIL, BOOLEAN, NUMBER, SYMBOL, PRIMITIVE_PROC, COMPOUND_PROCEDURE, 
    QUOTED, PAIR 
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
    /* Primitive Function Impl:
     *  a pointer to a function that returns a pointer to LispObject
     *  that also takes in a LispObject argument
     * */
    struct LispObject* (*PrimitiveFun)(struct LispObject* o);
    /* Compound function Impl:
     *
     *  a list of parameterers, up to MAX_LAMBDA_ARGS arguments of size up to MAX_SYMBOL_SIZE
     *  a list of instructions
     *  an environment
     *
     */
    char CompoundFunArgNames[MAX_LAMBDA_ARGS][MAX_SYMBOL_SIZE];
    struct LispObject* CompoundFunInstructionSequence;

 } LispObject;

extern LispObject LispNull;

void print_lisp_object(LispObject* lisp_obj);

void free_lisp_object(LispObject* the_object);

LispObject* create_empty_lisp_object(LispType ze_type);

LispObject* parse_input(char** tokens);

char** tokenize_string(char* tokenize_me);

char** input_to_tokens(char* input);
#endif
