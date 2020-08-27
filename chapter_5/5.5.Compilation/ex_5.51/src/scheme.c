#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>
#include "scheme_objects.h"
#include "scheme_primitives.h"
#include "scheme_env.h"

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

bool is_tagged_with(LispObject* exp, char* tag) {
    if ((exp->type == PAIR) &&
        (exp->CarPointer->type == SYMBOL) && 
        (strcmp(exp->CarPointer->SymbolVal, tag) == 0))
            return true; 
    else return false;
    
}

bool is_definition(LispObject* exp) {
    return is_tagged_with(exp, "define");
}

bool is_lambda(LispObject* exp) {
    return is_tagged_with(exp, "lambda");
}

// TODO: move these in a more civilized location, like a header file
LispObject* eval_definition(LispObject* exp, Environment* env);
LispObject* eval(LispObject* exp, Environment* env);
LispObject* apply(LispObject* procedure, LispObject* arguments);

LispObject* eval_definition(LispObject* exp, Environment* env) {
    LispObject *variable, *value, *evaluated_value;

    variable = exp->CdrPointer->CarPointer;
    value = exp->CdrPointer->CdrPointer->CarPointer;

    evaluated_value = eval(value, env);
    environment_add(env, variable->SymbolVal, evaluated_value);

    //print_environment(env);
    return &LispNull;
}

LispObject* list_of_values(LispObject* exp, Environment* env) {
    if (exp->type == NIL) return &LispNull;
    LispObject* output;
    output = create_empty_lisp_object(PAIR);
    output->CarPointer = eval(exp->CarPointer, env);
    output->CdrPointer = list_of_values(exp->CdrPointer, env);

    return output;
}

LispObject* make_procedure(LispObject* exp, Environment* env) {
    LispObject *output, *arg_list, *instruction_sequence;
    output = create_empty_lisp_object(COMPOUND_PROCEDURE);
    /* initialize arguments to end of string */
    for (size_t arg_i = 0; arg_i < MAX_LAMBDA_ARGS; arg_i++)
        for (size_t char_i = 0; char_i < MAX_SYMBOL_SIZE; char_i++) {
            output->CompoundFunArgNames[arg_i][char_i] = '\0';
        }
    arg_list = exp->CdrPointer->CarPointer;
    assert(arg_list->type == PAIR);

    /* Initialize the argument list (remember environment lookup is done on string) */
    LispObject *curr_lambda_arg, *rest_of_args; 
    rest_of_args = arg_list;
    for (size_t arg_i = 0; arg_i < MAX_LAMBDA_ARGS ; arg_i++) {
        if (rest_of_args->type == NIL) break;
        curr_lambda_arg = rest_of_args->CarPointer;
        assert(curr_lambda_arg->type == SYMBOL);
        rest_of_args = rest_of_args->CdrPointer;
        strcpy(output->CompoundFunArgNames[arg_i], curr_lambda_arg->SymbolVal);

    }

    /* Save the instruction sequence */
    instruction_sequence = exp->CdrPointer->CdrPointer;
    assert(instruction_sequence->type == PAIR);
    output->CompoundFunInstructionSequence = instruction_sequence;

    /* Save the environment */
    output->CompoundFunEnvironment = env;

    //print_environment(output->CompoundFunEnvironment);

    return output;
}

LispObject* eval(LispObject* exp, Environment* env) {
    LispObject* output = NULL;

    if (self_evaluating(exp)) { 
        // here you might be able to return directly, no cloning
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
    else if (is_lambda(exp)) {
        output = make_procedure(exp, env);
    }
    else if (exp->type == PAIR) {
        LispObject* operator;
        LispObject* list_of_operands;
        operator = eval(exp->CarPointer, env);
        list_of_operands = list_of_values(exp->CdrPointer, env);
        output = apply(operator, list_of_operands);
    }
    else {
        printf("This isn't good!\n");
        output = &LispNull;
    }

    return clone_lisp_object(output);
}

LispObject* apply(LispObject* procedure, LispObject* arguments) {
    LispObject* output;

    if (procedure->type == PRIMITIVE_PROC) {
        output = procedure->PrimitiveFun(arguments);
    }
    else if (procedure->type == COMPOUND_PROCEDURE) {
        printf("In compound apply!\n");
        print_environment(procedure->CompoundFunEnvironment);

        /* Extending environment with passed arguments */
        Environment* env;
        char* curr_arg_name;
        LispObject *rest_of_args, *curr_arg_val;
        env = environment_copy(procedure->CompoundFunEnvironment);
    
        rest_of_args = arguments;
        for (size_t arg_i = 0; arg_i < MAX_LAMBDA_ARGS; arg_i++) {
            curr_arg_name = procedure->CompoundFunArgNames[arg_i];
            if (curr_arg_name[0] == '\0') break;

            assert(rest_of_args->type == PAIR);
            curr_arg_val = rest_of_args->CarPointer;
            environment_add(env, curr_arg_name, curr_arg_val);
            rest_of_args = rest_of_args->CdrPointer;
        }
        print_environment(env);

        /* Evaluating each of the instructions in the list*/
        output = &LispNull; // Default return type

        LispObject *rest_of_instructions, *current_instruction;
        rest_of_instructions = procedure->CompoundFunInstructionSequence;

        while (rest_of_instructions->type != NIL) {
            current_instruction = rest_of_instructions->CarPointer;
            output = eval(current_instruction, env);
            
            rest_of_instructions = rest_of_instructions->CdrPointer;
        }

    }
    else {
        printf("Error applying procedure: ");
        print_lisp_object(procedure);
        printf("\n");
        output = &LispNull;
    }

    return output;
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
        //print_environment(the_global_environment);
        printf("Scheme > ");
        fgets(input, MAX_INPUT_SIZE, stdin);
        if (strlen(input) > 1) {
            printf("\nOutput:\n");
            tokens = input_to_tokens(input);
            parsed_input = parse_input(tokens);
            evaluated_input = eval(parsed_input, the_global_environment);
            print_lisp_object(evaluated_input);
            //TODO: make sure the two below don't mess up your environ lookups
            //free_lisp_object(parsed_input);
            //free_lisp_object(evaluated_input);
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
 
