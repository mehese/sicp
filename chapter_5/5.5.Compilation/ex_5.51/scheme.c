#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>

#define MAX_INPUT_SIZE 10000
#define MAX_SYMBOL_SIZE 50

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

static LispObject LispNull = { 
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

/*
 * This function takes a cleaned up input and tries to break it down into a
 * LispObject (either list or atom). So far in SICP we had the `read` function
 * which provided parsing the raw input into a Lisp-type structure on which 
 * we could call car/cdr and other stuff.
 *
 */
LispObject* parse_input(char* clean_input) { // TODO: Have it take a **char
    //printf("%s\n", clean_input);

    char* token;
    token = strtok(clean_input, " ");

    LispObject* output_obj;
    if ((token[0] == '(') || ((token[0] == '\'') && (token[1] == '('))) {
        //s = strtok(NULL, " ");
        //printf("%s ", s);
        printf("I'm a pair!!!\n");
        output_obj = &LispNull;
    } 
    // Atom cases below
    else if (token[0] == ')') { // End of list: NULLIFY
        output_obj = &LispNull;
    }
    else {
        output_obj = create_lisp_atom_from_string(token);
    }

    return output_obj;
}

char* clean_input(char* input) {
    int input_length = strlen(input);

    int num_brackets = 0;
    int brackets_open = 0;
    // TODO: check for extra whitespace too
    for (size_t i = 0; i < input_length; ++i) {
        // Replace '() by nil in input -- ideally you wouldn't modify input, but
        // let's first hack to the max and then think pretty stuff
        if ((input[i  ] == '\'') && (input_length - i > 2) && 
            (input[i+1] == '(' ) && (input[i+2] == ')')) {
            input[i  ] = 'n';
            input[i+1] = 'i';
            input[i+2] = 'l';
        }
        if (input[i] == '(') {
            num_brackets++;
            brackets_open++;
        } 
        if (input[i] == ')') {
            num_brackets++;
            brackets_open--;
            // Quick sanity check: we should never close more brackets than we opened
            assert(brackets_open >= 0);
        } 
    }
    // Quick sanity check: all open parens should be closed
    assert(brackets_open == 0);


    char* cleaned_input;
    // For each bracket we will want to add an extra space
    cleaned_input = malloc(sizeof(char) * (input_length + num_brackets));
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

        } else if (current_char == ')') {
            cleaned_input[j] = ' ';
            cleaned_input[j+1] = current_char;
            j = j+2;
        } else {
            cleaned_input[j] = current_char;
            ++j;
        }
    }
    
    return cleaned_input;
}

int main() {

    char input[MAX_INPUT_SIZE];

    // It is easier to parse the input if we do some preliminary string ops
    // around brackets and '()
    char* prepared;
    LispObject* parsed_input;
    for (;;) {
        printf("Scheme > ");
        fgets(input, MAX_INPUT_SIZE, stdin);
        if (strlen(input) > 1) {
            printf("\nOutput:\n");
            prepared = clean_input(input);
            parsed_input = parse_input(prepared);
            free(prepared);
            print_lisp_object(parsed_input);
            free_lisp_object(parsed_input);
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
 
