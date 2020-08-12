#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>
#include "scheme_objects.h"


LispObject LispNull = { 
    .type = NIL, 
    .NumberVal = 0.0,
    .BoolVal = false,
    .SymbolVal = "nil" 
};


void print_lisp_object(LispObject* lisp_obj) {
    switch (lisp_obj->type) {
        case NIL: 
            printf("'() ");
            break;
        case NUMBER: 
            printf("%.4f ", lisp_obj->NumberVal);
            break;
        case BOOLEAN: 
            (lisp_obj->BoolVal == true) ? printf("#t ") : printf("#f ");
            break;
        case SYMBOL: 
            printf("%s ", lisp_obj->SymbolVal);
            break;
        default: 
            printf("lol, not implemented!");
    }
}


void free_lisp_object(LispObject* the_object) {
    if (the_object->type == PAIR) {
        free_lisp_object(the_object->CarPointer);
        free_lisp_object(the_object->CdrPointer);
    }
    else if (the_object->type != NIL) {
        //printf("freeing "); print_lisp_object(the_object); 
        free(the_object);
    } 
    //printf(". ");
}


LispObject* create_empty_lisp_object(LispType ze_type) {
    LispObject* new_lisp_object;
    new_lisp_object = malloc(sizeof(LispObject));
    // Check for an out of memory error
    assert(new_lisp_object != NULL);
    new_lisp_object->type = ze_type;
    new_lisp_object->NumberVal = 0;
    // MAX_SYMBOL_SIZE - 1 because we always want to keep the last '\0'
    for (int i=0; i<MAX_SYMBOL_SIZE-1; i++)
        new_lisp_object->SymbolVal[i] = '\0';
    new_lisp_object->CarPointer = &LispNull;
    new_lisp_object->CdrPointer = &LispNull;
    return new_lisp_object;
}


LispObject* create_lisp_atom_from_string(char* token) {
    LispObject* output_obj;

    double num_val;
    char* err_ptr;

    // Try to convert the token to a double 
    num_val = strtod(token, &err_ptr);
    if (err_ptr != token) {
        // Conversion to float successful, it's a number!
        output_obj = create_empty_lisp_object(NUMBER);
        output_obj->NumberVal = num_val;
    }

    // Check if it's the null object
    else if (strcmp(token, "nil\n")  == 0) {
        output_obj = &LispNull;
    }

    // Check for boolean
    else if ((strcmp(token, "#t\n"   ) == 0 ) || 
             (strcmp(token, "true\n" ) == 0 )) {
        output_obj = create_empty_lisp_object(BOOLEAN);
        output_obj->BoolVal = true;
    } 
    else if ((strcmp(token, "#f\n"   ) == 0 ) || 
             (strcmp(token, "false\n") == 0 )) {
        output_obj = create_empty_lisp_object(BOOLEAN);
        output_obj->BoolVal = false;
    }

    // Habemus symbol
    else {
        output_obj = create_empty_lisp_object(SYMBOL);

        // Need to remove end character that strtok adds for some reason
        int i = 0;
        char* token_iter = token;
        while ((token_iter != NULL) && (i < MAX_SYMBOL_SIZE)) {
            if (*token_iter == '\n') break;
            output_obj->SymbolVal[i] = *token_iter;
            token_iter++;
            i++;
        }
    }

    return output_obj;
}


