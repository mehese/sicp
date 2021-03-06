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
    return o->CarPointer->CarPointer;
}

LispObject* lisp_cdr(LispObject* o) {
    assert (o->type == PAIR);
    assert (o->CdrPointer->type == NIL);
    assert (o->CarPointer->type == PAIR);
    return o->CarPointer->CdrPointer;
}

LispObject* lisp_cadr(LispObject* o) {
    assert (o->type == PAIR);
    assert (o->CdrPointer->type == NIL);
    assert (o->CarPointer->type == PAIR);
    assert (o->CarPointer->CdrPointer->type == PAIR);
    return o->CarPointer->CdrPointer->CarPointer;
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

LispObject* lisp_list(LispObject* o) {
    LispObject* new_obj;

    /* No arguments -- return NULL */
    if (o->type == NIL) {
        new_obj = &LispNull;

    /* One argument -- return the arglist */
    } else if (o->CdrPointer->type == NIL ) {
        new_obj = o;
    } else {
        new_obj = cons(o->CarPointer, lisp_list(o->CdrPointer));
    }
    return new_obj;
}

LispObject* lisp_list_length(LispObject* o) {
    assert(o->type == PAIR);

    LispObject *res, *list_to_measure;
    size_t arg_length;
    bool end_of_list_found;

    list_to_measure = o->CarPointer;

    end_of_list_found = false;
    arg_length = 0;

    while (!end_of_list_found) {
        if (list_to_measure->type == NIL) {
            end_of_list_found = true;
        } else {
            assert(list_to_measure->type == PAIR);
            // Cdr down the list
            list_to_measure = list_to_measure->CdrPointer;
            arg_length++;
        }
    }

    res = create_empty_lisp_object(NUMBER);
    res->NumberVal = arg_length;
    return res;
}

LispObject* lisp_set_car(LispObject* o) {
    LispObject *var_arg, *val_arg;
    assert (o->type == PAIR);
    var_arg = o->CarPointer;
    assert (var_arg->type == PAIR);
    assert (o->CdrPointer->type == PAIR);
    assert (o->CdrPointer->CdrPointer->type == NIL);
    val_arg = o->CdrPointer->CarPointer;
    var_arg->CarPointer = val_arg;

    return &LispNull;
}

LispObject* lisp_set_cdr(LispObject* o) {
    LispObject *var_arg, *val_arg;
    assert (o->type == PAIR);
    var_arg = o->CarPointer;
    assert (var_arg->type == PAIR);
    assert (o->CdrPointer->type == PAIR);
    assert (o->CdrPointer->CdrPointer->type == NIL);
    val_arg = o->CdrPointer->CarPointer;
    var_arg->CdrPointer = val_arg;

    return &LispNull;
}

LispObject* lisp_not(LispObject* o) {
    assert(o->type == PAIR);
    LispObject *arg1, *res;

    res = create_empty_lisp_object(BOOLEAN);

    arg1 = o->CarPointer;
    if ((arg1->type == BOOLEAN) && (arg1->BoolVal == false)) {
        res->BoolVal = true;
    } else {
        res->BoolVal = false;
    }

    return res;
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

LispObject* lisp_eq(LispObject* o) {
    assert(o->type == PAIR);
    LispObject *arg1, *arg2, *res;
    
    arg1 = o->CarPointer;

    /* the cadr of arglist */
    assert(o->CdrPointer->type == PAIR);
    arg2 = o->CdrPointer->CarPointer;

    res = create_empty_lisp_object(BOOLEAN);

    /* default return value */
    res->BoolVal = false;
    
    /* In order for eq? to return true:
     *
     * - Both are Nil
     * - Both are boolean and have the same value
     * - Both are a symbol and have the same value
     * - Both are a number and have the same value
     */

    if ((arg1->type == NIL) && (arg2->type == NIL)) {
        res->BoolVal = true;
    }

    if ((arg1->type == BOOLEAN) &&
        (arg2->type == BOOLEAN) &&
        (arg1->BoolVal == arg2->BoolVal)) {
        res->BoolVal = true;
    }
 
    if ((arg1->type == SYMBOL) &&
        (arg2->type == SYMBOL) &&
        (strcmp(arg1->SymbolVal, arg2->SymbolVal) == 0)) {
        res->BoolVal = true;
    }

    if ((arg1->type == NUMBER) &&
        (arg2->type == NUMBER) &&
        (fabs(arg1->NumberVal - arg2->NumberVal) <= FLOAT_TOL)) {
        res->BoolVal = true;
    }


    return res;
}

LispObject* lisp_num_less_than(LispObject* o) {
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

    if (arg1->NumberVal < arg2->NumberVal) {
        res->BoolVal = true;
    }
    else {
        res->BoolVal = false;
    }

    return res;
}

LispObject* lisp_num_greater_than(LispObject* o) {
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

    if (arg1->NumberVal > arg2->NumberVal) {
        res->BoolVal = true;
    }
    else {
        res->BoolVal = false;
    }

    return res;
}


LispObject* lisp_num_less_or_equal_than(LispObject* o) {
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

    if (arg1->NumberVal <= arg2->NumberVal) {
        res->BoolVal = true;
    }
    else {
        res->BoolVal = false;
    }

    return res;
}

LispObject* lisp_num_greater_or_equal_than(LispObject* o) {
    assert(o->type == PAIR);
    LispObject *arg1, *arg2, *res;

    /* the car of arglist */
    arg1 = o->CarPointer;
    assert(arg1->type == NUMBER);

    /* the cadr of arglist */
    arg2 = o->CdrPointer;
    arg2 = arg2->CarPointer;
    assert(arg2->type == NUMBER);

    res = create_empty_lisp_object(BOOLEAN);

    if (arg1->NumberVal >= arg2->NumberVal) {
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
    assert (o->CdrPointer->type == NIL);
    res = create_empty_lisp_object(BOOLEAN);
    res->BoolVal = (o->CarPointer->type == NIL) ? true : false;
    return res;
}

LispObject* lisp_check_pair(LispObject* o) {
    assert(o->type == PAIR);
    LispObject* res;
    assert (o->CdrPointer->type == NIL);
    res = create_empty_lisp_object(BOOLEAN);
    res->BoolVal = (o->CarPointer->type == PAIR) ? true : false;
    return res;
}

LispObject* lisp_check_number(LispObject* o) {
    assert(o->type == PAIR);
    LispObject* res;
    assert (o->CdrPointer->type == NIL);
    res = create_empty_lisp_object(BOOLEAN);
    res->BoolVal = (o->CarPointer->type == NUMBER) ? true : false;
    return res;
}

LispObject* lisp_check_symbol(LispObject* o) {
    assert(o->type == PAIR);
    LispObject* res;
    assert (o->CdrPointer->type == NIL);
    res = create_empty_lisp_object(BOOLEAN);
    res->BoolVal = (o->CarPointer->type == SYMBOL) ? true : false;
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

LispObject SetCar = {
    .type = PRIMITIVE_PROC,
    .SymbolVal = "set-car!",
    .PrimitiveFun = &lisp_set_car
};

LispObject SetCdr = {
    .type = PRIMITIVE_PROC,
    .SymbolVal = "set-cdr!",
    .PrimitiveFun = &lisp_set_cdr
};

LispObject List = {
    .type = PRIMITIVE_PROC,
    .SymbolVal = "list",
    .PrimitiveFun = &lisp_list
};

LispObject ListLength = {
    .type = PRIMITIVE_PROC,
    .SymbolVal = "length",
    .PrimitiveFun = &lisp_list_length
};

LispObject NullCheck = {
    .type = PRIMITIVE_PROC,
    .SymbolVal = "null?",
    .PrimitiveFun = &lisp_check_null
};

LispObject PairCheck = {
    .type = PRIMITIVE_PROC,
    .SymbolVal = "pair?",
    .PrimitiveFun = &lisp_check_pair
};

LispObject NumberCheck = {
    .type = PRIMITIVE_PROC,
    .SymbolVal = "number?",
    .PrimitiveFun = &lisp_check_number
};

LispObject SymbolCheck = {
    .type = PRIMITIVE_PROC,
    .SymbolVal = "symbol?",
    .PrimitiveFun = &lisp_check_symbol
};

LispObject Not = {
    .type = PRIMITIVE_PROC,
    .SymbolVal = "not",
    .PrimitiveFun = &lisp_not
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

LispObject Eq = {
    .type = PRIMITIVE_PROC,
    .SymbolVal = "eq?",
    .PrimitiveFun = &lisp_eq,
};

LispObject NumLessThan = {
    .type = PRIMITIVE_PROC,
    .SymbolVal = "<",
    .PrimitiveFun = &lisp_num_less_than,
};

LispObject NumLessOrEqualThan = {
    .type = PRIMITIVE_PROC,
    .SymbolVal = "<=",
    .PrimitiveFun = &lisp_num_less_or_equal_than,
};

LispObject NumGreaterThan = {
    .type = PRIMITIVE_PROC,
    .SymbolVal = ">",
    .PrimitiveFun = &lisp_num_greater_than,
};

LispObject NumGreaterOrEqualThan = {
    .type = PRIMITIVE_PROC,
    .SymbolVal = ">=",
    .PrimitiveFun = &lisp_num_greater_or_equal_than,
};


