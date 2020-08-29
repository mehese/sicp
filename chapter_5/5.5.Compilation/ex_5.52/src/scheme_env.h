#ifndef __scheme_env_h__
#define __scheme_env_h__

#include "scheme_objects.h"

#define MAX_ENVIRONMENT_SIZE 500

/* Just something to hold the key/value info */
typedef struct EnvironmentElement {
    char Key[MAX_SYMBOL_SIZE];
    struct LispObject* Val;
} EnvironmentElement;


typedef struct Environment {
    int Size;
    struct EnvironmentElement Elements[MAX_ENVIRONMENT_SIZE];
} Environment;


Environment* environment_init(void);
Environment* environment_copy(Environment* env_in);
void environment_add(Environment* env, char* name, LispObject* obj);
LispObject* environment_lookup(Environment* env, char* name);

/* Helper for debug */
void print_environment(Environment* env);

#endif
