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

    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1;
    environment_add(env, "factorial", val);
    proc = environment_lookup(env, "factorial");
    val = create_lisp_atom_from_string("5");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };

    print_lisp_object(val);
    putchar(10); /* print an extra newline */
    return EXIT_SUCCESS;
};


void entry1(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "n", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "=");
    val = create_lisp_atom_from_string("1");
    argl = cons(val, &LispNull);
    val = environment_lookup(env, "n");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        val = create_lisp_atom_from_string("1");
    } else {
        proc = environment_lookup(env, "*");
        LispObject* tmp_16;
        tmp_16 = proc;
        val = environment_lookup(env, "n");
        argl = cons(val, &LispNull);
        LispObject* tmp_12;
        tmp_12 = argl;
        proc = environment_lookup(env, "factorial");
        LispObject* tmp_11;
        tmp_11 = proc;
        proc = environment_lookup(env, "-");
        val = create_lisp_atom_from_string("1");
        argl = cons(val, &LispNull);
        val = environment_lookup(env, "n");
        argl = cons(val, argl);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        proc = tmp_11;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_12;
        argl = cons(val, argl);
        proc = tmp_16;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    };
};

/* footer here */
