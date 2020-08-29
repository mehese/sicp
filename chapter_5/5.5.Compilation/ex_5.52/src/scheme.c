#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>
#include "scheme_objects.h"
#include "scheme_primitives.h"
#include "scheme_env.h"
#include "scheme_eval_apply.h"

int main() {

    LispObject *parsed_input, *evaluated_input;
    Environment* the_global_environment;

    the_global_environment = environment_init();
    for (;;) {
        //print_environment(the_global_environment);
        printf("Scheme > ");
        parsed_input = read_and_parse_input();
        evaluated_input = eval(parsed_input, the_global_environment);
        printf("\nOutput:\n"); 
        print_lisp_object(evaluated_input); 
        printf("\n");
        //TODO: make sure the two below don't mess up your environ lookups
        //free_lisp_object(parsed_input);
        //free_lisp_object(evaluated_input);
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
 * This language leaks *everything* since I didn't bother implementing an obarray.
 * It also has no cond statements, no and statements, no or statements, no syntactic
 * sugar for function definitions either. All the numbers are cast to C doubles and 
 * the arithmetic is done at that level, so best not calculate very high factorials.
 *
 * The best thing it can do is this
 *    (define factorial (lambda (n) (if (= n 1) 1 (* n (factorial (- n 1))))))
 *
 */
 
