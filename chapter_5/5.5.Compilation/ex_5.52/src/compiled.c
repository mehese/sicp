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

    Environment* tmp_4;
    tmp_4 = environment_copy(env);
    proc = environment_lookup(env, "list");
    val = create_lisp_atom_from_string("4");
    argl = cons(val, &LispNull);
    val = create_lisp_atom_from_string("3");
    argl = cons(val, argl);
    val = create_lisp_atom_from_string("2");
    argl = cons(val, argl);
    val = create_lisp_atom_from_string("1");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_4);
    environment_add(env, "p", val);
    Environment* tmp_13;
    tmp_13 = environment_copy(env);
    proc = environment_lookup(env, "set-cdr!");
    LispObject* tmp_12;
    tmp_12 = proc;
    val = parse_lisp_object_from_string("b");
    argl = cons(val, &LispNull);
    LispObject* tmp_8;
    tmp_8 = argl;
    proc = environment_lookup(env, "cdr");
    val = environment_lookup(env, "p");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_8;
    argl = cons(val, argl);
    proc = tmp_12;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_13);
    val = environment_lookup(env, "p");
    print_lisp_object(val);

    putchar(10); /* print an extra newline */
    return EXIT_SUCCESS;
};



/* footer here */
