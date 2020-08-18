#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>
#include "scheme_objects.h"
#include "scheme_env.h"

/* Primitives */

LispObject* clone_lisp_object(LispObject* in) {
    LispObject* new_lisp_object;
    new_lisp_object = malloc(sizeof(LispObject));
    assert(new_lisp_object != NULL);
    memcpy(new_lisp_object, in, sizeof(LispObject));
    
    return new_lisp_object;
}

LispObject* car(LispObject* o) {
    assert (o->type == PAIR);
    return clone_lisp_object(o->CarPointer);
}

LispObject* cdr(LispObject* o) {
    assert (o->type == PAIR);
    return clone_lisp_object(o->CdrPointer);
}

LispObject* cadr(LispObject* o) {
    assert (o->type == PAIR);
    assert (o->CdrPointer->type == PAIR);
    return clone_lisp_object(o->CdrPointer->CarPointer);
}

/* End primitives */

bool self_evaluating(LispObject* exp) {
    bool is_self_eval;
    switch (exp->type) {
        case NIL: 
        case NUMBER: 
        case BOOLEAN: 
        case PRIMITIVE_PROC:
            is_self_eval = true;
            break;
        default:
            is_self_eval = false;
    }

    return is_self_eval;
}

bool is_variable(LispObject* exp) {
    return ( exp->type == SYMBOL ) ? true : false;
}

bool is_quote(LispObject* exp) {
    return ( exp->type == QUOTED ) ? true : false;
}

bool is_definition(LispObject* exp) {
    bool result = false;
    if ((exp->type == PAIR) &&
        (exp->CarPointer->type == SYMBOL) && 
        (strcmp(exp->CarPointer->SymbolVal, "define") == 0)) {
            result = true; 
        }

    return result;
}

// TODO: move these in a more civilized location, like a header file
LispObject* eval_definition(LispObject* exp, Environment* env);
LispObject* eval(LispObject* exp, Environment* env);

LispObject* eval_definition(LispObject* exp, Environment* env) {
    LispObject *variable, *value, *evaluated_value;

    variable = cadr(exp);
    value = cadr(cdr(exp));

    evaluated_value = eval(value, env);
    environment_add(env, variable->SymbolVal, evaluated_value);

    //print_environment(env);
    return &LispNull;
}

LispObject* eval(LispObject* exp, Environment* env) {
    LispObject* output = NULL;

    if (self_evaluating(exp)) {
        output = exp;
    }
    else if (is_variable(exp)) {
        output = environment_lookup(env, exp->SymbolVal); 
    } 
    else if (is_quote(exp)) {
        output = exp->QuotePointer;
    }
    // TODO: Add assignment (set! command)
    else if (is_definition(exp)) {
        output = eval_definition(exp, env);
    }
    else {
        printf("This isn't good!\n");
        output = &LispNull;
    }

    return clone_lisp_object(output);
}


int main() {
    char input[MAX_INPUT_SIZE];

    /* It is easier to parse the input if we do some preliminary string ops
       around brackets and '() */
    char** tokens;
    LispObject *parsed_input, *evaluated_input;
    Environment* the_global_environment;

    the_global_environment = environment_init();
    for (;;) {
        printf("Scheme > ");
        fgets(input, MAX_INPUT_SIZE, stdin);
        if (strlen(input) > 1) {
            printf("\nOutput:\n");
            tokens = input_to_tokens(input);
            parsed_input = parse_input(tokens);
            evaluated_input = eval(parsed_input, the_global_environment);
            print_lisp_object(evaluated_input);
            free_lisp_object(parsed_input);
            free_lisp_object(evaluated_input);
        }
        printf("\n");
    }

    printf("All done!\n");
    
    return EXIT_SUCCESS;
}

/*
 *
 * Obviously could not have made this without peeking in different places like
 *
 * https://github.com/petermichaux/bootstrap-scheme
 *
 * https://github.com/skanev/playground/tree/master/scheme/sicp/05/support/51
 *
 * http://www.buildyourownlisp.com/contents
 *
 * Not surprisingly, few who tried their hands at actually solving the problems in 
 * SICP got this far. Unfortunately for me, the text of the problem goes like
 *     
 *     Develop a rudimentary implementation of Scheme in C (or some other low-level 
 *     language of your choice)
 *
 * Had the text mercifully not used the term low-level I would have just went for
 * Python and used Norvig's own https://norvig.com/lispy.html
 *
 */
 
