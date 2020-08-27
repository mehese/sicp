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
    .SymbolVal = "nil",
    .PrimitiveFun = NULL
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
        case QUOTED: 
            printf("'");
            print_lisp_object(lisp_obj->QuotePointer);
            break;
        case PRIMITIVE_PROC:
            printf("primitive$%s ", lisp_obj->SymbolVal);
            break;
        case COMPOUND_PROCEDURE:
            printf("lambda (");
            char* curr_arg;
            for (size_t arg_i = 0; arg_i < MAX_LAMBDA_ARGS ; arg_i++) {
                curr_arg = lisp_obj->CompoundFunArgNames[arg_i];
                if (curr_arg[0] == '\0') break;
                printf("%s ", curr_arg);
            }
            printf(")");
            break;
        case PAIR: 
            printf("[");
            print_lisp_object(lisp_obj->CarPointer);
            print_lisp_object(lisp_obj->CdrPointer);
            printf("] ");
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
        free(the_object);
    } 
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
    else if (strcmp(token, "nil")  == 0) {
        output_obj = &LispNull;
    }

    // Check for boolean
    else if ((strcmp(token, "#t"   ) == 0 ) || 
             (strcmp(token, "true" ) == 0 )) {
        output_obj = create_empty_lisp_object(BOOLEAN);
        output_obj->BoolVal = true;
    } 
    else if ((strcmp(token, "#f"   ) == 0 ) || 
             (strcmp(token, "false") == 0 )) {
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
        // TODO: Free some memory here
    }

    return output_obj;
}

char** get_car_tokens(char** tokens, size_t* length_of_obj) {
    size_t seen_tokens = 1;

    char** tokens_iter;
    tokens_iter = tokens;

    // Step one, if there are any leading quotes, count until there aren't any
    if (*tokens_iter[0] == '\'') {
        ++seen_tokens;
        ++tokens_iter;
    }

    // Then count until all open brackets are closed
    if (*tokens_iter[0] == '(') {
        // List case
        unsigned int open_parens = 1;

        for (size_t i = 1; (tokens_iter[i] != NULL) && (open_parens > 0); i++) {
            seen_tokens++;
            if (*tokens_iter[i] == '(') {
                open_parens++;
            } 
            else if (*tokens_iter[i] == ')') {
                open_parens--;
            }
            //printf("%s\n", tokens[i]);
        }
    }

    char** car_tokens;
    car_tokens = calloc(seen_tokens, sizeof(char*));
    for (size_t i=0; i < seen_tokens; i++) {
        car_tokens[i] = strdup(tokens[i]);
        //printf("car_token[%zu] = %s\n", i, car_tokens[i]);
    }
    // Save the position of the last relevant token, so you can use it for
    // cdr, but only if the pointer is valid
    if (length_of_obj != NULL) *length_of_obj = seen_tokens;

    return car_tokens;
}

char** tokenize_string(char* tokenize_me) {

    const char* SEPARATOR = " ";
    char* input_cpy; // strtok is destructive

    char* input_ptr;
    int num_tokens = 0;

    input_cpy = strdup(tokenize_me);
    input_ptr = strtok(input_cpy, SEPARATOR);
    while (input_ptr != NULL) {
        num_tokens++;
        input_ptr = strtok(NULL, SEPARATOR);
    }

    char** input_strings;
    input_strings = calloc(num_tokens+1, sizeof(char *));

    input_cpy = strdup(tokenize_me);
    input_ptr = strtok(input_cpy, SEPARATOR);
    for (size_t i = 0;  i < num_tokens; i++) {
        input_strings[i] = strdup(input_ptr);
        input_ptr = strtok(NULL, SEPARATOR);
    }

    free(input_ptr);

    input_strings[num_tokens] = NULL;

    return input_strings;
}

/*
 * This function takes a cleaned up input and tries to break it down into a
 * LispObject (either list or atom). So far in SICP we had the `read` function
 * which provided parsing the raw input into a Lisp-type structure on which 
 * we could call car/cdr and other stuff.
 *
 */
LispObject* parse_input(char** tokens) {

    LispObject* output_obj;
    // Pairs start with a ( or '( 
    if (*tokens[0] == '(') {
        char** car_tokens;
        char** cdr_tokens;
        size_t end_of_car_tokens = 0;
        output_obj = create_empty_lisp_object(PAIR);
        car_tokens = get_car_tokens(++tokens, &end_of_car_tokens);
        // Can't count less than 1 token in car
        assert(end_of_car_tokens >= 1);
        output_obj->CarPointer = parse_input(car_tokens);
        cdr_tokens = tokens + end_of_car_tokens - 1;

        // Check for end of list
        if (*cdr_tokens[1] == ')') {
            output_obj->CdrPointer = &LispNull;
        } else {
            *cdr_tokens[0] = '(';
            output_obj->CdrPointer = parse_input(cdr_tokens);
        }
    }
    // Quote case
    else if (*tokens[0] == '\'') { // End of list: NULLIFY
        char** quote_tokens;
        output_obj = create_empty_lisp_object(QUOTED);
        quote_tokens = get_car_tokens(++tokens, NULL);
        output_obj->QuotePointer = parse_input(quote_tokens);
        free(quote_tokens);
    }
    // Atom case
    else {
        output_obj = create_lisp_atom_from_string(tokens[0]);
    }

    return output_obj;
}

char** input_to_tokens(char* input) {
    int input_length = strlen(input);

    int num_new_spaces = 0;
    int brackets_open = 0;
    // TODO: remove newlines too
    // TODO: check for extra whitespace too
    // TODO: this fails when passed an expression like (lambda () 'hi) -- parser should accept () as valid input
    for (size_t i = 0; i < input_length; ++i) {
        // Replace '() by nil in input -- ideally you wouldn't modify input, but
        // let's first hack to the max and then think pretty stuff
        if ((input[i  ] == '\'') && (input_length - i > 2) && 
            (input[i+1] == '(' ) && (input[i+2] == ')')) {
            input[i  ] = 'n';
            input[i+1] = 'i';
            input[i+2] = 'l';
        }
        // Quote that isn't the nil character
        else if (input[i] == '\'') {
            num_new_spaces++;
        }
        else if (input[i] == '(') {
            num_new_spaces++;
            brackets_open++;
        } 
        if (input[i] == ')') {
            num_new_spaces++;
            brackets_open--;
            // Quick sanity check: we should never close more brackets than we opened
            assert(brackets_open >= 0);
        } 
    }
    // Quick sanity check: all open parens should be closed
    assert(brackets_open == 0);


    char* cleaned_input;
    // For each bracket we will want to add an extra space
    cleaned_input = malloc(sizeof(char) * (input_length + num_new_spaces));
    assert(cleaned_input != NULL);

    // Iterator through cleaned_input, make sure there is a space before and
    // after the parantheses
    size_t j = 0;
    char current_char;
    for (size_t i = 0; i < input_length; ++i) {
        current_char = input[i];
        if (current_char == '(') {
            cleaned_input[j] = current_char;
            cleaned_input[j+1] = ' ';
            j = j+2;

        } 
        else if (current_char == ')') {
            cleaned_input[j] = ' ';
            cleaned_input[j+1] = current_char;
            j = j+2;
        } 
        // Add a space post quote symbol, to help parse
        else if (current_char == '\'') {
            cleaned_input[j] = current_char;
            cleaned_input[j+1] = ' ';
            j = j+2;
        } 
        // Ignore newline characters 
        else if (current_char == '\n') {
            ++j;
        }
        else {
            cleaned_input[j] = current_char;
            ++j;
        }
    }
    //printf("Cleaned input: %sEND_INPUT\n", cleaned_input);
    
    return tokenize_string(cleaned_input);
}


