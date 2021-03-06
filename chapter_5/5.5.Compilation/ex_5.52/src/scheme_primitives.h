#ifndef __scheme_primitives_h__
#define __scheme_primitives_h__

#include "scheme_objects.h"

LispObject* clone_lisp_object(LispObject* in);
LispObject* lisp_car(LispObject* o);
LispObject* lisp_cdr(LispObject* o);
LispObject* lisp_cadr(LispObject* o);
LispObject* lisp_add(LispObject* o);
LispObject* cons(LispObject* car_obj, LispObject* cdr_obj);

extern LispObject Car;
extern LispObject Cdr;
extern LispObject Cadr;
extern LispObject Cons;
extern LispObject SetCar;
extern LispObject SetCdr;
extern LispObject List;
extern LispObject ListLength;
extern LispObject NullCheck;
extern LispObject PairCheck;
extern LispObject NumberCheck;
extern LispObject SymbolCheck;
extern LispObject Not;
extern LispObject Add;
extern LispObject Mul;
extern LispObject Div;
extern LispObject Sub;
extern LispObject NumEq;
extern LispObject Eq;
extern LispObject NumLessThan;
extern LispObject NumLessOrEqualThan;
extern LispObject NumGreaterThan;
extern LispObject NumGreaterOrEqualThan;

#endif
