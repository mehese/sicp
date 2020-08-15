#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>
#include "scheme_objects.h"

int main() {
    char input[MAX_INPUT_SIZE];

    // It is easier to parse the input if we do some preliminary string ops
    // around brackets and '()
    char** tokens;
    LispObject* parsed_input;
    for (;;) {
        printf("Scheme > ");
        fgets(input, MAX_INPUT_SIZE, stdin);
        if (strlen(input) > 1) {
            printf("\nOutput:\n");
            tokens = input_to_tokens(input);
            parsed_input = parse_input(tokens);
            // TODO free these pointers
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
 
