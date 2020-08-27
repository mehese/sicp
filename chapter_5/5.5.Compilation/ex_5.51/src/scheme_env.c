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

    assert(output_obj != NULL);

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
    environment_add(env_out, Add.SymbolVal, &Add);
    
    // TODO fill the rest
    
    environment_add(env_out, "null?", &LispNull);
    
    environment_add(env_out, "*", &LispNull);
    
    environment_add(env_out, "-", &LispNull);
    
    environment_add(env_out, "/", &LispNull);

    environment_add(env_out, "=", &LispNull);

    return env_out;
}


