#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>
#include "scheme_objects.h"

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
 
