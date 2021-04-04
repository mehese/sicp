#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>
#include <stdint.h>
#include "scheme_objects.h"
#include "scheme_env.h"
#include "scheme_primitives.h"

Environment the_empty_environment = {
    .Size = 0
};

Environment* environment_copy(Environment* env_in) {
    Environment* env_out;
    env_out = malloc(sizeof(Environment));
    assert(env_out != NULL);
    
    env_out->Size = env_in->Size;
    for (size_t i = 0; i < MAX_ENVIRONMENT_SIZE; ++i) {
        if (i < env_in->Size) {
            strcpy(env_out->Elements[i].Key, env_in->Elements[i].Key);
            env_out->Elements[i].Val = env_in->Elements[i].Val;
        }
        else { // Empty spaces
            strcpy(env_out->Elements[i].Key, "");
            env_out->Elements[i].Val = NULL;
        }

    }

    return env_out;
}

/* Helper function to list the contents on an environment at one time */
void print_environment(Environment* env) {
    printf("Environment:\n");
    for (size_t i = 0; i < env->Size; i++) {
        printf("    << %zu %s ", i, env->Elements[i].Key);
        print_lisp_object(env->Elements[i].Val);
        printf(">>\n");
    }
    printf("Environment End\n");
}

void environment_add(Environment* env, char* name, LispObject* obj) {
    strcpy(env->Elements[env->Size].Key, name);
    env->Elements[env->Size].Val = obj;
    env->Size = env->Size + 1;
}

LispObject* environment_lookup(Environment* env, char* name) {
    assert(env->Size >= 1);
    char key[MAX_SYMBOL_SIZE] = "";
    LispObject* output_obj = NULL;

    for (size_t i = env->Size-1; i != SIZE_MAX; --i) {
        strcpy(key,env->Elements[i].Key); 
        //printf("[%zu] %s = %s? %d\n", i, key, name, strcmp(key, name));
        if (strcmp(key, name) == 0) {
            output_obj = env->Elements[i].Val;
            break;

        } 
    }

    if (output_obj == NULL) {
        printf("Did not find %s in environment:\n", name);
        print_environment(env);
        exit(1);
    }

    return output_obj;
}

Environment* environment_init(void) {
    Environment* env_out;

    /* 
     * Initial Environment contents: Primitives
     *
     */

    env_out = environment_copy(&the_empty_environment);
    
    environment_add(env_out, Car.SymbolVal, &Car);
    environment_add(env_out, Cdr.SymbolVal, &Cdr);
    environment_add(env_out, Cadr.SymbolVal, &Cadr);
    environment_add(env_out, Cons.SymbolVal, &Cons);
    environment_add(env_out, List.SymbolVal, &List);
    environment_add(env_out, Not.SymbolVal, &Not);
    environment_add(env_out, Add.SymbolVal, &Add);
    environment_add(env_out, Sub.SymbolVal, &Sub);
    environment_add(env_out, Mul.SymbolVal, &Mul);
    environment_add(env_out, Div.SymbolVal, &Div);
    environment_add(env_out, NumEq.SymbolVal, &NumEq);
    environment_add(env_out, SymEq.SymbolVal, &SymEq);
    environment_add(env_out, NumLessThan.SymbolVal, &NumLessThan);
    environment_add(env_out, NumLessOrEqualThan.SymbolVal, &NumLessOrEqualThan);
    environment_add(env_out, NumGreaterThan.SymbolVal, &NumGreaterThan);
    environment_add(env_out, NumGreaterOrEqualThan.SymbolVal, &NumGreaterOrEqualThan);
    environment_add(env_out, NullCheck.SymbolVal, &NullCheck);
    environment_add(env_out, PairCheck.SymbolVal, &PairCheck);
    environment_add(env_out, NumberCheck.SymbolVal, &NumberCheck);

    return env_out;
}


