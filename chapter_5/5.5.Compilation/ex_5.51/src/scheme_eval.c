#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>
#include "scheme_eval.h"
#include "scheme_objects.h"

/* Just something to hold the key/value info */
typedef struct EnvironmentElement {
    char Key[MAX_SYMBOL_SIZE];
    struct LispObject* Val;
} EnvironmentElement;

typedef struct Environment {
    int Size;
    struct EnvironmentElement Elements[MAX_ENVIRONMENT_SIZE];
} Environment;

Environment the_empty_environment = {
    .Size = 0
};

Environment* environment_copy(Environment* env_in) {
    Environment* env_out;
    env_out = malloc(sizeof(Environment));
    
    env_out->Size = env_in->Size;
    for (size_t i; i < MAX_ENVIRONMENT_SIZE; ++i) {
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

void environment_add(Environment* env, char* str, LispObject* obj) {
    
    printf("env-Size: %d\n", env->Size);
    env->Size = env->Size + 1;
}

Environment* environment_init() {
    Environment* env_out;

    /* Object contents 
     *
     * Primitives: LispObject type SYMBOL
     *  "primitiveCar"
     *  "primitiveCdr"
     *  "primitiveCons"
     *  "primitiveNull"
     *  "primitiveAdd"
     *  "primitiveMul"
     *  "primitiveSub"
     *  "primitiveDiv"
     *  "primitiveTrue"
     *
     */
    env_out = environment_copy(&the_empty_environment);
    environment_add(env_out, "primitiveCar", NULL);

    return env_out;
}

int main(void) {
    //EnvironmentElement* env_elem;
    printf("Hi!\n");

    //env_elem = malloc(sizeof(EnvironmentElement));
    //strcpy(env_elem->Key, "Hello");
    //env_elem->Val = &LispNull;

    //print_lisp_object(env_elem->Val);
    
    Environment *new_env, *newer_env;

    new_env = environment_copy(&the_empty_environment);
    printf("Size: %d\n", new_env->Size);
    printf("Contents 0: %s\n", new_env->Elements[0].Key);
    newer_env = environment_init();
    printf("Size init: %d\n", newer_env->Size);
    return EXIT_SUCCESS;
}
