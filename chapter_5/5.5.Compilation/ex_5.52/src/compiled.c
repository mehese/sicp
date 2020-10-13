#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>
#include "scheme_objects.h"
#include "scheme_primitives.h"
#include "scheme_env.h"
#include "scheme_eval_apply.h"

LispObject *expr, *proc, *val, *argl;

Environment *env;

int main() {

    env = environment_init();

    val = create_lisp_atom_from_string("2");
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        val = create_lisp_atom_from_string("#f");
        if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
            val = create_lisp_atom_from_string("2");
        } else {
            val = create_lisp_atom_from_string("69");
        };
    } else {
        val = create_lisp_atom_from_string("3");
    };

    print_lisp_object(val);
    putchar(10); /* print an extra newline */
    return EXIT_SUCCESS;
};

/* footer here */
