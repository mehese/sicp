#ifndef __scheme_eval_apply_h__
#define __scheme_eval_apply_h__

LispObject* eval(LispObject* exp, Environment* env);
LispObject* apply(LispObject* procedure, LispObject* arguments);

#endif
