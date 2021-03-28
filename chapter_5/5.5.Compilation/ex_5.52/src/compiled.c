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

void entry1(void);

int main() {

    env = environment_init();

    val = create_lisp_atom_from_string("5");
    environment_add(env, "n", val);
    val = environment_lookup(env, "n");
    print_lisp_object(val);
    proc = create_empty_lisp_object(COMPILED_PROCEDURE);
    proc->CompoundFunEnvironment = env;
    proc->CompiledFun = &entry1;
    val = create_lisp_atom_from_string("3.14");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    val = environment_lookup(env, "n");
    print_lisp_object(val);

    putchar(10); /* print an extra newline */
    return EXIT_SUCCESS;
};


void entry1(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "n", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "+");
    val = create_lisp_atom_from_string("1");
    argl = cons(val, &LispNull);
    val = environment_lookup(env, "n");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};

/* footer here */
