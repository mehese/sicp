#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
#include "scheme_objects.h"
#include "scheme_primitives.h"

/* Helpers for compiler */

LispObject* cons(LispObject* car_obj, LispObject* cdr_obj) {
    LispObject* obj_out;
    obj_out = create_empty_lisp_object(PAIR);
    obj_out->CarPointer = car_obj;
    obj_out->CdrPointer = cdr_obj;
    return obj_out;
}



/* Primitives */

LispObject* clone_lisp_object(LispObject* in) {
    LispObject* new_lisp_object;
    new_lisp_object = malloc(sizeof(LispObject));
    assert(new_lisp_object != NULL);
    memcpy(new_lisp_object, in, sizeof(LispObject));
    
    return new_lisp_object;
}

LispObject* lisp_car(LispObject* o) {
    assert (o->type == PAIR);
    assert (o->CdrPointer->type == NIL);
    assert (o->CarPointer->type == PAIR);
    return clone_lisp_object(o->CarPointer->CarPointer);
}

LispObject* lisp_cdr(LispObject* o) {
    assert (o->type == PAIR);
    assert (o->CdrPointer->type == NIL);
    assert (o->CarPointer->type == PAIR);
    return clone_lisp_object(o->CarPointer->CdrPointer);
}

LispObject* lisp_cadr(LispObject* o) {
    assert (o->type == PAIR);
    assert (o->CdrPointer->type == NIL);
    assert (o->CarPointer->type == PAIR);
    assert (o->CarPointer->CdrPointer->type == PAIR);
    return clone_lisp_object(o->CarPointer->CdrPointer->CarPointer);
}

LispObject* lisp_cons(LispObject* o) {
    assert (o->type == PAIR);
    assert (o->CdrPointer->type == PAIR);
    assert (o->CdrPointer->CdrPointer->type == NIL);

    LispObject* new_obj;
    new_obj = create_empty_lisp_object(PAIR);
    new_obj->CarPointer = o->CarPointer;
    new_obj->CdrPointer = o->CdrPointer->CarPointer;
    return new_obj;
}

LispObject* lisp_add(LispObject* o) {
    assert(o->type == PAIR);
    LispObject *arg1, *arg2, *res;

    /* the car of arglist */
    arg1 = o->CarPointer;
    assert(arg1->type == NUMBER);

    /* the cadr of arglist */
    arg2 = o->CdrPointer;
    assert(o->type == PAIR);
    arg2 = arg2->CarPointer;
    assert(arg2->type == NUMBER);

    res = create_empty_lisp_object(NUMBER);
    res->NumberVal = arg1->NumberVal + arg2->NumberVal;

    return res;
}

LispObject* lisp_sub(LispObject* o) {
    assert(o->type == PAIR);
    LispObject *arg1, *arg2, *res;

    /* the car of arglist */
    arg1 = o->CarPointer;
    assert(arg1->type == NUMBER);

    /* the cadr of arglist */
    arg2 = o->CdrPointer;
    assert(o->type == PAIR);
    arg2 = arg2->CarPointer;
    assert(arg2->type == NUMBER);

    res = create_empty_lisp_object(NUMBER);
    res->NumberVal = arg1->NumberVal - arg2->NumberVal;

    return res;
}

LispObject* lisp_mul(LispObject* o) {
    assert(o->type == PAIR);
    LispObject *arg1, *arg2, *res;

    /* the car of arglist */
    arg1 = o->CarPointer;
    assert(arg1->type == NUMBER);

    /* the cadr of arglist */
    arg2 = o->CdrPointer;
    assert(o->type == PAIR);
    arg2 = arg2->CarPointer;
    assert(arg2->type == NUMBER);

    res = create_empty_lisp_object(NUMBER);
    res->NumberVal = arg1->NumberVal * arg2->NumberVal;

    return res;
}

LispObject* lisp_div(LispObject* o) {
    assert(o->type == PAIR);
    LispObject *arg1, *arg2, *res;

    /* the car of arglist */
    arg1 = o->CarPointer;
    assert(arg1->type == NUMBER);

    /* the cadr of arglist */
    arg2 = o->CdrPointer;
    assert(o->type == PAIR);
    arg2 = arg2->CarPointer;
    assert(arg2->type == NUMBER);
    assert(fabs(arg2->NumberVal) >= FLOAT_TOL);

    res = create_empty_lisp_object(NUMBER);
    res->NumberVal = arg1->NumberVal / arg2->NumberVal;

    return res;
}


LispObject* lisp_num_eq(LispObject* o) {
    assert(o->type == PAIR);
    LispObject *arg1, *arg2, *res;

    /* the car of arglist */
    arg1 = o->CarPointer;
    assert(arg1->type == NUMBER);

    /* the cadr of arglist */
    arg2 = o->CdrPointer;
    assert(o->type == PAIR);
    arg2 = arg2->CarPointer;
    assert(arg2->type == NUMBER);

    res = create_empty_lisp_object(BOOLEAN);

    if (fabs(arg1->NumberVal - arg2->NumberVal) < FLOAT_TOL) {
        res->BoolVal = true;
    }
    else {
        res->BoolVal = false;
    }

    return res;
}

LispObject* lisp_sym_eq(LispObject* o) {
    assert(o->type == PAIR);
    LispObject *arg1, *arg2, *res;

    /* the car of arglist */
    arg1 = o->CarPointer;
    assert(arg1->type == SYMBOL);

    /* the cadr of arglist */
    arg2 = o->CdrPointer;
    assert(o->type == PAIR);
    arg2 = arg2->CarPointer;
    assert(arg2->type == SYMBOL);

    res = create_empty_lisp_object(BOOLEAN);

    if (strcmp(arg1->SymbolVal, arg2->SymbolVal) == 0) {
        res->BoolVal = true;
    }
    else {
        res->BoolVal = false;
    }

    return res;
}

LispObject* lisp_check_null(LispObject* o) {
    assert(o->type == PAIR);
    LispObject* res;
    assert (o->type == PAIR);
    assert (o->CdrPointer->type == NIL);
    printf("Type is %d\n", o->CarPointer->type);
    res = create_empty_lisp_object(BOOLEAN);
    res->BoolVal = (o->CarPointer->type == NIL) ? true : false;
    return res;
}


/* End primitives */

LispObject Car = {
    .type = PRIMITIVE_PROC,
    .SymbolVal = "car",
    .PrimitiveFun = &lisp_car
};

LispObject Cdr = {
    .type = PRIMITIVE_PROC,
    .SymbolVal = "cdr",
    .PrimitiveFun = &lisp_cdr
};


LispObject Cadr = {
    .type = PRIMITIVE_PROC,
    .SymbolVal = "cadr",
    .PrimitiveFun = &lisp_cadr
};


LispObject Cons = {
    .type = PRIMITIVE_PROC,
    .SymbolVal = "cons",
    .PrimitiveFun = &lisp_cons
};

LispObject NullCheck = {
    .type = PRIMITIVE_PROC,
    .SymbolVal = "null?",
    .PrimitiveFun = &lisp_check_null
};

LispObject Add = {
    .type = PRIMITIVE_PROC,
    .SymbolVal = "+",
    .PrimitiveFun = &lisp_add
};

LispObject Mul = {
    .type = PRIMITIVE_PROC,
    .SymbolVal = "*",
    .PrimitiveFun = &lisp_mul
};

LispObject Sub = {
    .type = PRIMITIVE_PROC,
    .SymbolVal = "-",
    .PrimitiveFun = &lisp_sub
};

LispObject Div = {
    .type = PRIMITIVE_PROC,
    .SymbolVal = "/",
    .PrimitiveFun = &lisp_div
};

LispObject NumEq = {
    .type = PRIMITIVE_PROC,
    .SymbolVal = "=",
    .PrimitiveFun = &lisp_num_eq,
};

LispObject SymEq = {
    .type = PRIMITIVE_PROC,
    .SymbolVal = "eq?",
    .PrimitiveFun = &lisp_sym_eq,
};


