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

    proc = environment_lookup(env, "list");
    argl = &LispNull;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    print_lisp_object(val);

    putchar(10); /* print an extra newline */
    return EXIT_SUCCESS;
};



/* footer here */
