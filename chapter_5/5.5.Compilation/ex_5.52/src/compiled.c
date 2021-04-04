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
void entry27(void);
void entry39(void);
void entry47(void);
void entry55(void);
void entry63(void);
void entry71(void);
void entry79(void);
void entry87(void);
void entry149(void);
void entry153(void);
void entry157(void);
void entry158(void);
void entry169(void);
void entry173(void);
void entry174(void);
void entry183(void);
void entry187(void);
void entry191(void);
void entry195(void);
void entry223(void);
void entry258(void);
void entry262(void);
void entry266(void);
void entry267(void);
void entry268(void);
void entry319(void);
void entry320(void);
void entry350(void);
void entry351(void);
void entry352(void);
void entry391(void);
void entry415(void);
void entry416(void);
void entry417(void);
void entry456(void);
void entry480(void);
void entry484(void);
void entry488(void);
void entry492(void);
void entry496(void);
void entry500(void);
void entry536(void);
void entry655(void);
void entry660(void);
void entry664(void);
void entry677(void);
void entry681(void);
void entry685(void);
void entry689(void);
void entry693(void);
void entry697(void);
void entry701(void);
void entry716(void);
void entry740(void);
void entry744(void);
void entry748(void);
void entry752(void);
void entry760(void);
void entry764(void);
void entry768(void);
void entry772(void);
void entry788(void);
void entry792(void);
void entry796(void);
void entry800(void);
void entry808(void);
void entry812(void);
void entry816(void);
void entry831(void);
void entry835(void);
void entry839(void);
void entry843(void);
void entry847(void);
void entry851(void);
void entry855(void);
void entry859(void);
void entry863(void);
void entry867(void);
void entry876(void);
void entry880(void);
void entry884(void);
void entry892(void);
void entry896(void);
void entry946(void);
void entry973(void);
void entry1003(void);
void entry1033(void);
void entry1052(void);
void entry1071(void);
void entry1075(void);
void entry1084(void);
void entry1088(void);
void entry1097(void);
void entry1119(void);
void entry1136(void);
void entry1140(void);
void entry1158(void);
void entry1162(void);
void entry1163(void);
void entry1186(void);
void entry1187(void);

int main() {

    env = environment_init();

    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1;
    environment_add(env, "map", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry27;
    environment_add(env, "caddr", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry39;
    environment_add(env, "cddr", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry47;
    environment_add(env, "cdadr", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry55;
    environment_add(env, "caadr", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry63;
    environment_add(env, "cdddr", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry71;
    environment_add(env, "cadddr", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry79;
    environment_add(env, "true?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry87;
    environment_add(env, "false?", val);
    Environment* tmp_148;
    tmp_148 = environment_copy(env);
    proc = environment_lookup(env, "list");
    LispObject* tmp_147;
    tmp_147 = proc;
    Environment* tmp_143;
    tmp_143 = environment_copy(env);
    proc = environment_lookup(env, "list");
    val = environment_lookup(env, "list");
    argl = cons(val, &LispNull);
    val = parse_lisp_object_from_string("list");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_143);
    Environment* tmp_142;
    tmp_142 = environment_copy(env);
    LispObject* tmp_124;
    tmp_124 = argl;
    proc = environment_lookup(env, "list");
    val = environment_lookup(env, "/");
    argl = cons(val, &LispNull);
    val = parse_lisp_object_from_string("/");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_124;
    argl = cons(val, argl);
    env = environment_copy(tmp_142);
    Environment* tmp_141;
    tmp_141 = environment_copy(env);
    LispObject* tmp_125;
    tmp_125 = argl;
    proc = environment_lookup(env, "list");
    val = environment_lookup(env, "*");
    argl = cons(val, &LispNull);
    val = parse_lisp_object_from_string("*");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_125;
    argl = cons(val, argl);
    env = environment_copy(tmp_141);
    Environment* tmp_140;
    tmp_140 = environment_copy(env);
    LispObject* tmp_126;
    tmp_126 = argl;
    proc = environment_lookup(env, "list");
    val = environment_lookup(env, "-");
    argl = cons(val, &LispNull);
    val = parse_lisp_object_from_string("-");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_126;
    argl = cons(val, argl);
    env = environment_copy(tmp_140);
    Environment* tmp_139;
    tmp_139 = environment_copy(env);
    LispObject* tmp_127;
    tmp_127 = argl;
    proc = environment_lookup(env, "list");
    val = environment_lookup(env, "+");
    argl = cons(val, &LispNull);
    val = parse_lisp_object_from_string("+");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_127;
    argl = cons(val, argl);
    env = environment_copy(tmp_139);
    Environment* tmp_138;
    tmp_138 = environment_copy(env);
    LispObject* tmp_128;
    tmp_128 = argl;
    proc = environment_lookup(env, "list");
    val = environment_lookup(env, "=");
    argl = cons(val, &LispNull);
    val = parse_lisp_object_from_string("=");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_128;
    argl = cons(val, argl);
    env = environment_copy(tmp_138);
    Environment* tmp_137;
    tmp_137 = environment_copy(env);
    LispObject* tmp_129;
    tmp_129 = argl;
    proc = environment_lookup(env, "list");
    val = environment_lookup(env, "null?");
    argl = cons(val, &LispNull);
    val = parse_lisp_object_from_string("null?");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_129;
    argl = cons(val, argl);
    env = environment_copy(tmp_137);
    Environment* tmp_136;
    tmp_136 = environment_copy(env);
    LispObject* tmp_130;
    tmp_130 = argl;
    proc = environment_lookup(env, "list");
    val = environment_lookup(env, "cons");
    argl = cons(val, &LispNull);
    val = parse_lisp_object_from_string("cons");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_130;
    argl = cons(val, argl);
    env = environment_copy(tmp_136);
    Environment* tmp_135;
    tmp_135 = environment_copy(env);
    LispObject* tmp_131;
    tmp_131 = argl;
    proc = environment_lookup(env, "list");
    val = environment_lookup(env, "cadr");
    argl = cons(val, &LispNull);
    val = parse_lisp_object_from_string("cadr");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_131;
    argl = cons(val, argl);
    env = environment_copy(tmp_135);
    Environment* tmp_134;
    tmp_134 = environment_copy(env);
    LispObject* tmp_132;
    tmp_132 = argl;
    proc = environment_lookup(env, "list");
    val = environment_lookup(env, "cdr");
    argl = cons(val, &LispNull);
    val = parse_lisp_object_from_string("cdr");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_132;
    argl = cons(val, argl);
    env = environment_copy(tmp_134);
    LispObject* tmp_133;
    tmp_133 = argl;
    proc = environment_lookup(env, "list");
    val = environment_lookup(env, "car");
    argl = cons(val, &LispNull);
    val = parse_lisp_object_from_string("car");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_133;
    argl = cons(val, argl);
    proc = tmp_147;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_148);
    environment_add(env, "primitive-procedures", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry149;
    environment_add(env, "primitive-procedure?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry153;
    environment_add(env, "primitive-procedure-names", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry157;
    environment_add(env, "primitive-procedure-objects", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry169;
    environment_add(env, "primitive-implementation", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry173;
    environment_add(env, "apply-in-underlying-scheme", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry174;
    environment_add(env, "apply-primitive-procedure", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry183;
    environment_add(env, "make-frame", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry187;
    environment_add(env, "frame-variables", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry191;
    environment_add(env, "frame-values", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry195;
    environment_add(env, "add-binding-to-frame!", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry223;
    environment_add(env, "extend-environment", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry258;
    environment_add(env, "enclosing-environment", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry262;
    environment_add(env, "first-frame", val);
    val = parse_lisp_object_from_string("()");
    environment_add(env, "the-empty-environment", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry266;
    environment_add(env, "define-variable!", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry319;
    environment_add(env, "setup-environment", val);
    Environment* tmp_349;
    tmp_349 = environment_copy(env);
    proc = environment_lookup(env, "setup-environment");
    argl = &LispNull;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_349);
    environment_add(env, "the-global-environment", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry350;
    environment_add(env, "lookup-variable-value", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry415;
    environment_add(env, "set-variable-value!", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry480;
    environment_add(env, "compound-procedure?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry484;
    environment_add(env, "procedure-body", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry488;
    environment_add(env, "procedure-parameters", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry492;
    environment_add(env, "make-procedure", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry496;
    environment_add(env, "procedure-environment", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry500;
    environment_add(env, "m-apply", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry536;
    environment_add(env, "eval", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry655;
    environment_add(env, "self-evaluating?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry660;
    environment_add(env, "variable?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry664;
    environment_add(env, "tagged-list?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry677;
    environment_add(env, "quoted?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry681;
    environment_add(env, "text-of-quotation", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry685;
    environment_add(env, "assignment?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry689;
    environment_add(env, "assignment-variable", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry693;
    environment_add(env, "assignment-value", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry697;
    environment_add(env, "definition?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry701;
    environment_add(env, "definition-variable", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry716;
    environment_add(env, "definition-value", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry740;
    environment_add(env, "lambda?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry744;
    environment_add(env, "lambda-parameters", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry748;
    environment_add(env, "lambda-body", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry752;
    environment_add(env, "make-lambda", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry760;
    environment_add(env, "if?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry764;
    environment_add(env, "if-predicate", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry768;
    environment_add(env, "if-consequent", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry772;
    environment_add(env, "if-alternative", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry788;
    environment_add(env, "make-if", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry792;
    environment_add(env, "begin?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry796;
    environment_add(env, "begin-actions", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry800;
    environment_add(env, "last-exp?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry808;
    environment_add(env, "first-exp", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry812;
    environment_add(env, "rest-exps", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry816;
    environment_add(env, "sequence->exp", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry831;
    environment_add(env, "make-begin", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry835;
    environment_add(env, "application?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry839;
    environment_add(env, "operator", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry843;
    environment_add(env, "operands", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry847;
    environment_add(env, "no-operands?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry851;
    environment_add(env, "first-operand", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry855;
    environment_add(env, "rest-operands", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry859;
    environment_add(env, "cond?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry863;
    environment_add(env, "cond-clauses", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry867;
    environment_add(env, "cond-else-clause?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry876;
    environment_add(env, "cond-predicate", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry880;
    environment_add(env, "cond-actions", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry884;
    environment_add(env, "cond->if", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry892;
    environment_add(env, "expand-clauses", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry946;
    environment_add(env, "list-of-values", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry973;
    environment_add(env, "eval-if", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1003;
    environment_add(env, "eval-sequence", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1033;
    environment_add(env, "eval-assignment", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1052;
    environment_add(env, "eval-definition", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1071;
    environment_add(env, "let?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1075;
    environment_add(env, "let-variables", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1084;
    environment_add(env, "let-body", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1088;
    environment_add(env, "let-expressions", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1097;
    environment_add(env, "let->combination", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1119;
    environment_add(env, "make-let", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1136;
    environment_add(env, "make-variable-definition", val);
    val = parse_lisp_object_from_string("input:");
    environment_add(env, "input-prompt", val);
    val = parse_lisp_object_from_string("output:");
    environment_add(env, "output-prompt", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1140;
    environment_add(env, "user-print", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1158;
    environment_add(env, "driver-loop", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1186;
    environment_add(env, "prompt-for-input", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1187;
    environment_add(env, "announce-output", val);
    proc = environment_lookup(env, "driver-loop");
    argl = &LispNull;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };

    putchar(10); /* print an extra newline */
    return EXIT_SUCCESS;
};


void entry1(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "fun", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "lst", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_26;
    tmp_26 = environment_copy(env);
    proc = environment_lookup(env, "null?");
    val = environment_lookup(env, "lst");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_26);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        val = parse_lisp_object_from_string("()");
    } else {
        proc = environment_lookup(env, "cons");
        LispObject* tmp_25;
        tmp_25 = proc;
        Environment* tmp_21;
    tmp_21 = environment_copy(env);
        proc = environment_lookup(env, "map");
        LispObject* tmp_19;
        tmp_19 = proc;
        Environment* tmp_15;
    tmp_15 = environment_copy(env);
        proc = environment_lookup(env, "cdr");
        val = environment_lookup(env, "lst");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        env = environment_copy(tmp_15);
        val = environment_lookup(env, "fun");
        argl = cons(val, argl);
        proc = tmp_19;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        env = environment_copy(tmp_21);
        LispObject* tmp_20;
        tmp_20 = argl;
        proc = environment_lookup(env, "fun");
        LispObject* tmp_11;
        tmp_11 = proc;
        proc = environment_lookup(env, "car");
        val = environment_lookup(env, "lst");
        argl = cons(val, &LispNull);
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
        argl = tmp_20;
        argl = cons(val, argl);
        proc = tmp_25;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    };
};
void entry27(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "l", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "car");
    LispObject* tmp_38;
    tmp_38 = proc;
    proc = environment_lookup(env, "cdr");
    LispObject* tmp_34;
    tmp_34 = proc;
    proc = environment_lookup(env, "cdr");
    val = environment_lookup(env, "l");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_34;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_38;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry39(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "l", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "cdr");
    LispObject* tmp_46;
    tmp_46 = proc;
    proc = environment_lookup(env, "cdr");
    val = environment_lookup(env, "l");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_46;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry47(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "l", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "cdr");
    LispObject* tmp_54;
    tmp_54 = proc;
    proc = environment_lookup(env, "cadr");
    val = environment_lookup(env, "l");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_54;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry55(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "l", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "car");
    LispObject* tmp_62;
    tmp_62 = proc;
    proc = environment_lookup(env, "cadr");
    val = environment_lookup(env, "l");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_62;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry63(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "l", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "cdr");
    LispObject* tmp_70;
    tmp_70 = proc;
    proc = environment_lookup(env, "cddr");
    val = environment_lookup(env, "l");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_70;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry71(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "l", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "car");
    LispObject* tmp_78;
    tmp_78 = proc;
    proc = environment_lookup(env, "cdddr");
    val = environment_lookup(env, "l");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_78;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry79(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "x", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "not");
    LispObject* tmp_86;
    tmp_86 = proc;
    proc = environment_lookup(env, "eq?");
    val = create_lisp_atom_from_string("#f");
    argl = cons(val, &LispNull);
    val = environment_lookup(env, "x");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_86;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry87(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "x", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "eq?");
    val = create_lisp_atom_from_string("#f");
    argl = cons(val, &LispNull);
    val = environment_lookup(env, "x");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry149(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "proc", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "tagged-list?");
    val = parse_lisp_object_from_string("primitive");
    argl = cons(val, &LispNull);
    val = environment_lookup(env, "proc");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry153(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    proc = environment_lookup(env, "map");
    val = environment_lookup(env, "primitive-procedures");
    argl = cons(val, &LispNull);
    val = environment_lookup(env, "car");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry157(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    proc = environment_lookup(env, "map");
    val = environment_lookup(env, "primitive-procedures");
    argl = cons(val, &LispNull);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry158;
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry158(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "proc", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "list");
    LispObject* tmp_165;
    tmp_165 = proc;
    proc = environment_lookup(env, "cadr");
    val = environment_lookup(env, "proc");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    val = parse_lisp_object_from_string("primitive");
    argl = cons(val, argl);
    proc = tmp_165;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry169(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "proc", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "cadr");
    val = environment_lookup(env, "proc");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry173(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "proc", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "args", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "proc");
    val = environment_lookup(env, "args");
    argl = cons(val, &LispNull);
    val = apply(proc,val);
};
void entry174(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "proc", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "args", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "apply-in-underlying-scheme");
    LispObject* tmp_182;
    tmp_182 = proc;
    val = environment_lookup(env, "args");
    argl = cons(val, &LispNull);
    LispObject* tmp_178;
    tmp_178 = argl;
    proc = environment_lookup(env, "primitive-implementation");
    val = environment_lookup(env, "proc");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_178;
    argl = cons(val, argl);
    proc = tmp_182;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry183(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "variables", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "values", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "cons");
    val = environment_lookup(env, "values");
    argl = cons(val, &LispNull);
    val = environment_lookup(env, "variables");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry187(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "frame", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "car");
    val = environment_lookup(env, "frame");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry191(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "frame", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "cdr");
    val = environment_lookup(env, "frame");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry195(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "var", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "val", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "frame", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_222;
    tmp_222 = environment_copy(env);
    proc = environment_lookup(env, "set-car!");
    LispObject* tmp_208;
    tmp_208 = proc;
    Environment* tmp_204;
    tmp_204 = environment_copy(env);
    proc = environment_lookup(env, "cons");
    LispObject* tmp_203;
    tmp_203 = proc;
    Environment* tmp_199;
    tmp_199 = environment_copy(env);
    proc = environment_lookup(env, "car");
    val = environment_lookup(env, "frame");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_199);
    val = environment_lookup(env, "var");
    argl = cons(val, argl);
    proc = tmp_203;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_204);
    val = environment_lookup(env, "frame");
    argl = cons(val, argl);
    proc = tmp_208;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_222);
    proc = environment_lookup(env, "set-cdr!");
    LispObject* tmp_221;
    tmp_221 = proc;
    Environment* tmp_217;
    tmp_217 = environment_copy(env);
    proc = environment_lookup(env, "cons");
    LispObject* tmp_216;
    tmp_216 = proc;
    Environment* tmp_212;
    tmp_212 = environment_copy(env);
    proc = environment_lookup(env, "cdr");
    val = environment_lookup(env, "frame");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_212);
    val = environment_lookup(env, "val");
    argl = cons(val, argl);
    proc = tmp_216;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_217);
    val = environment_lookup(env, "frame");
    argl = cons(val, argl);
    proc = tmp_221;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry223(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "vars", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "vals", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "base-env", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_257;
    tmp_257 = environment_copy(env);
    proc = environment_lookup(env, "=");
    LispObject* tmp_235;
    tmp_235 = proc;
    Environment* tmp_231;
    tmp_231 = environment_copy(env);
    proc = environment_lookup(env, "length");
    val = environment_lookup(env, "vals");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_231);
    LispObject* tmp_230;
    tmp_230 = argl;
    proc = environment_lookup(env, "length");
    val = environment_lookup(env, "vars");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_230;
    argl = cons(val, argl);
    proc = tmp_235;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_257);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        proc = environment_lookup(env, "cons");
        LispObject* tmp_243;
        tmp_243 = proc;
        val = environment_lookup(env, "base-env");
        argl = cons(val, &LispNull);
        LispObject* tmp_239;
        tmp_239 = argl;
        proc = environment_lookup(env, "make-frame");
        val = environment_lookup(env, "vals");
        argl = cons(val, &LispNull);
        val = environment_lookup(env, "vars");
        argl = cons(val, argl);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_239;
        argl = cons(val, argl);
        proc = tmp_243;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    } else {
        Environment* tmp_256;
    tmp_256 = environment_copy(env);
        proc = environment_lookup(env, "<");
        LispObject* tmp_255;
        tmp_255 = proc;
        Environment* tmp_251;
    tmp_251 = environment_copy(env);
        proc = environment_lookup(env, "length");
        val = environment_lookup(env, "vals");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        env = environment_copy(tmp_251);
        LispObject* tmp_250;
        tmp_250 = argl;
        proc = environment_lookup(env, "length");
        val = environment_lookup(env, "vars");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_250;
        argl = cons(val, argl);
        proc = tmp_255;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        env = environment_copy(tmp_256);
        if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
            printf("Error: Too many arguments supplied\n");
        } else {
            printf("Error: Too few arguments supplied\n");
        };
    };
};
void entry258(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "cdr");
    val = environment_lookup(env, "env");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry262(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "car");
    val = environment_lookup(env, "env");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry266(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "var", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "val", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = create_empty_lisp_object(COMPILED_PROCEDURE);
    proc->CompoundFunEnvironment = env;
    proc->CompiledFun = &entry267;
    LispObject* tmp_318;
    tmp_318 = proc;
    proc = environment_lookup(env, "first-frame");
    val = environment_lookup(env, "env");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_318;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry267(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "frame", argl->CarPointer);
    argl = argl->CdrPointer;
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry268;
    environment_add(env, "scan", val);
    proc = environment_lookup(env, "scan");
    LispObject* tmp_311;
    tmp_311 = proc;
    Environment* tmp_307;
    tmp_307 = environment_copy(env);
    proc = environment_lookup(env, "frame-values");
    val = environment_lookup(env, "frame");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_307);
    LispObject* tmp_306;
    tmp_306 = argl;
    proc = environment_lookup(env, "frame-variables");
    val = environment_lookup(env, "frame");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_306;
    argl = cons(val, argl);
    proc = tmp_311;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry268(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "vars", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "vals", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_299;
    tmp_299 = environment_copy(env);
    proc = environment_lookup(env, "null?");
    val = environment_lookup(env, "vars");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_299);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        proc = environment_lookup(env, "add-binding-to-frame!");
        val = environment_lookup(env, "frame");
        argl = cons(val, &LispNull);
        val = environment_lookup(env, "val");
        argl = cons(val, argl);
        val = environment_lookup(env, "var");
        argl = cons(val, argl);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    } else {
        Environment* tmp_298;
    tmp_298 = environment_copy(env);
        proc = environment_lookup(env, "eq?");
        LispObject* tmp_282;
        tmp_282 = proc;
        Environment* tmp_278;
    tmp_278 = environment_copy(env);
        proc = environment_lookup(env, "car");
        val = environment_lookup(env, "vars");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        env = environment_copy(tmp_278);
        val = environment_lookup(env, "var");
        argl = cons(val, argl);
        proc = tmp_282;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        env = environment_copy(tmp_298);
        if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
            proc = environment_lookup(env, "set-car!");
            val = environment_lookup(env, "val");
            argl = cons(val, &LispNull);
            val = environment_lookup(env, "vals");
            argl = cons(val, argl);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
        } else {
            proc = environment_lookup(env, "scan");
            LispObject* tmp_297;
            tmp_297 = proc;
            Environment* tmp_293;
    tmp_293 = environment_copy(env);
            proc = environment_lookup(env, "cdr");
            val = environment_lookup(env, "vals");
            argl = cons(val, &LispNull);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
            argl = cons(val, &LispNull);
            env = environment_copy(tmp_293);
            LispObject* tmp_292;
            tmp_292 = argl;
            proc = environment_lookup(env, "cdr");
            val = environment_lookup(env, "vars");
            argl = cons(val, &LispNull);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
            argl = tmp_292;
            argl = cons(val, argl);
            proc = tmp_297;
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
        };
    };
};
void entry319(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    proc = create_empty_lisp_object(COMPILED_PROCEDURE);
    proc->CompoundFunEnvironment = env;
    proc->CompiledFun = &entry320;
    LispObject* tmp_345;
    tmp_345 = proc;
    proc = environment_lookup(env, "extend-environment");
    LispObject* tmp_341;
    tmp_341 = proc;
    val = environment_lookup(env, "the-empty-environment");
    argl = cons(val, &LispNull);
    Environment* tmp_337;
    tmp_337 = environment_copy(env);
    LispObject* tmp_335;
    tmp_335 = argl;
    proc = environment_lookup(env, "primitive-procedure-objects");
    argl = &LispNull;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_335;
    argl = cons(val, argl);
    env = environment_copy(tmp_337);
    LispObject* tmp_336;
    tmp_336 = argl;
    proc = environment_lookup(env, "primitive-procedure-names");
    argl = &LispNull;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_336;
    argl = cons(val, argl);
    proc = tmp_341;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_345;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry320(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "initial-env", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_328;
    tmp_328 = environment_copy(env);
    proc = environment_lookup(env, "define-variable!");
    val = environment_lookup(env, "initial-env");
    argl = cons(val, &LispNull);
    val = create_lisp_atom_from_string("#t");
    argl = cons(val, argl);
    val = parse_lisp_object_from_string("true");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_328);
    Environment* tmp_327;
    tmp_327 = environment_copy(env);
    proc = environment_lookup(env, "define-variable!");
    val = environment_lookup(env, "initial-env");
    argl = cons(val, &LispNull);
    val = create_lisp_atom_from_string("#f");
    argl = cons(val, argl);
    val = parse_lisp_object_from_string("false");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_327);
    val = environment_lookup(env, "initial-env");
};
void entry350(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "var", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    val = parse_lisp_object_from_string("looking-up");
    print_lisp_object(val);
    val = environment_lookup(env, "val");
    print_lisp_object(val);
    putchar(10);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry351;
    environment_add(env, "env-loop", val);
    proc = environment_lookup(env, "env-loop");
    val = environment_lookup(env, "env");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry351(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry352;
    environment_add(env, "scan", val);
    Environment* tmp_411;
    tmp_411 = environment_copy(env);
    proc = environment_lookup(env, "eq?");
    val = environment_lookup(env, "the-empty-environment");
    argl = cons(val, &LispNull);
    val = environment_lookup(env, "env");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_411);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        printf("Error: Unbound variable\n");
    } else {
        proc = create_empty_lisp_object(COMPILED_PROCEDURE);
        proc->CompoundFunEnvironment = env;
        proc->CompiledFun = &entry391;
        LispObject* tmp_410;
        tmp_410 = proc;
        proc = environment_lookup(env, "first-frame");
        val = environment_lookup(env, "env");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        proc = tmp_410;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    };
};
void entry352(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "vars", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "vals", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_387;
    tmp_387 = environment_copy(env);
    proc = environment_lookup(env, "null?");
    val = environment_lookup(env, "vars");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_387);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        proc = environment_lookup(env, "env-loop");
        LispObject* tmp_362;
        tmp_362 = proc;
        proc = environment_lookup(env, "enclosing-environment");
        val = environment_lookup(env, "env");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        proc = tmp_362;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    } else {
        Environment* tmp_386;
    tmp_386 = environment_copy(env);
        proc = environment_lookup(env, "eq?");
        LispObject* tmp_370;
        tmp_370 = proc;
        Environment* tmp_366;
    tmp_366 = environment_copy(env);
        proc = environment_lookup(env, "car");
        val = environment_lookup(env, "vars");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        env = environment_copy(tmp_366);
        val = environment_lookup(env, "var");
        argl = cons(val, argl);
        proc = tmp_370;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        env = environment_copy(tmp_386);
        if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
            proc = environment_lookup(env, "car");
            val = environment_lookup(env, "vals");
            argl = cons(val, &LispNull);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
        } else {
            proc = environment_lookup(env, "scan");
            LispObject* tmp_385;
            tmp_385 = proc;
            Environment* tmp_381;
    tmp_381 = environment_copy(env);
            proc = environment_lookup(env, "cdr");
            val = environment_lookup(env, "vals");
            argl = cons(val, &LispNull);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
            argl = cons(val, &LispNull);
            env = environment_copy(tmp_381);
            LispObject* tmp_380;
            tmp_380 = argl;
            proc = environment_lookup(env, "cdr");
            val = environment_lookup(env, "vars");
            argl = cons(val, &LispNull);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
            argl = tmp_380;
            argl = cons(val, argl);
            proc = tmp_385;
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
        };
    };
};
void entry391(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "frame", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "scan");
    LispObject* tmp_403;
    tmp_403 = proc;
    Environment* tmp_399;
    tmp_399 = environment_copy(env);
    proc = environment_lookup(env, "frame-values");
    val = environment_lookup(env, "frame");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_399);
    LispObject* tmp_398;
    tmp_398 = argl;
    proc = environment_lookup(env, "frame-variables");
    val = environment_lookup(env, "frame");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_398;
    argl = cons(val, argl);
    proc = tmp_403;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry415(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "var", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "val", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry416;
    environment_add(env, "env-loop", val);
    proc = environment_lookup(env, "env-loop");
    val = environment_lookup(env, "env");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry416(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry417;
    environment_add(env, "scan", val);
    Environment* tmp_476;
    tmp_476 = environment_copy(env);
    proc = environment_lookup(env, "eq?");
    val = environment_lookup(env, "the-empty-environment");
    argl = cons(val, &LispNull);
    val = environment_lookup(env, "env");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_476);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        printf("Error: Unbound variable: SET!\n");
    } else {
        proc = create_empty_lisp_object(COMPILED_PROCEDURE);
        proc->CompoundFunEnvironment = env;
        proc->CompiledFun = &entry456;
        LispObject* tmp_475;
        tmp_475 = proc;
        proc = environment_lookup(env, "first-frame");
        val = environment_lookup(env, "env");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        proc = tmp_475;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    };
};
void entry417(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "vars", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "vals", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_452;
    tmp_452 = environment_copy(env);
    proc = environment_lookup(env, "null?");
    val = environment_lookup(env, "vars");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_452);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        proc = environment_lookup(env, "env-loop");
        LispObject* tmp_427;
        tmp_427 = proc;
        proc = environment_lookup(env, "enclosing-environment");
        val = environment_lookup(env, "env");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        proc = tmp_427;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    } else {
        Environment* tmp_451;
    tmp_451 = environment_copy(env);
        proc = environment_lookup(env, "eq?");
        LispObject* tmp_435;
        tmp_435 = proc;
        Environment* tmp_431;
    tmp_431 = environment_copy(env);
        proc = environment_lookup(env, "car");
        val = environment_lookup(env, "vars");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        env = environment_copy(tmp_431);
        val = environment_lookup(env, "var");
        argl = cons(val, argl);
        proc = tmp_435;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        env = environment_copy(tmp_451);
        if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
            proc = environment_lookup(env, "set-car!");
            val = environment_lookup(env, "val");
            argl = cons(val, &LispNull);
            val = environment_lookup(env, "vals");
            argl = cons(val, argl);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
        } else {
            proc = environment_lookup(env, "scan");
            LispObject* tmp_450;
            tmp_450 = proc;
            Environment* tmp_446;
    tmp_446 = environment_copy(env);
            proc = environment_lookup(env, "cdr");
            val = environment_lookup(env, "vals");
            argl = cons(val, &LispNull);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
            argl = cons(val, &LispNull);
            env = environment_copy(tmp_446);
            LispObject* tmp_445;
            tmp_445 = argl;
            proc = environment_lookup(env, "cdr");
            val = environment_lookup(env, "vars");
            argl = cons(val, &LispNull);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
            argl = tmp_445;
            argl = cons(val, argl);
            proc = tmp_450;
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
        };
    };
};
void entry456(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "frame", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "scan");
    LispObject* tmp_468;
    tmp_468 = proc;
    Environment* tmp_464;
    tmp_464 = environment_copy(env);
    proc = environment_lookup(env, "frame-values");
    val = environment_lookup(env, "frame");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_464);
    LispObject* tmp_463;
    tmp_463 = argl;
    proc = environment_lookup(env, "frame-variables");
    val = environment_lookup(env, "frame");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_463;
    argl = cons(val, argl);
    proc = tmp_468;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry480(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "p", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "tagged-list?");
    val = parse_lisp_object_from_string("procedure");
    argl = cons(val, &LispNull);
    val = environment_lookup(env, "p");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry484(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "p", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "caddr");
    val = environment_lookup(env, "p");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry488(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "p", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "cadr");
    val = environment_lookup(env, "p");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry492(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "parameters", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "body", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "list");
    val = environment_lookup(env, "env");
    argl = cons(val, &LispNull);
    val = environment_lookup(env, "body");
    argl = cons(val, argl);
    val = environment_lookup(env, "parameters");
    argl = cons(val, argl);
    val = parse_lisp_object_from_string("procedure");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry496(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "p", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "cadddr");
    val = environment_lookup(env, "p");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry500(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "procedure", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "arguments", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_535;
    tmp_535 = environment_copy(env);
    proc = environment_lookup(env, "primitive-procedure?");
    val = environment_lookup(env, "procedure");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_535);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        proc = environment_lookup(env, "apply-primitive-procedure");
        val = environment_lookup(env, "arguments");
        argl = cons(val, &LispNull);
        val = environment_lookup(env, "procedure");
        argl = cons(val, argl);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    } else {
        Environment* tmp_534;
    tmp_534 = environment_copy(env);
        proc = environment_lookup(env, "compound-procedure?");
        val = environment_lookup(env, "procedure");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        env = environment_copy(tmp_534);
        if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
            proc = environment_lookup(env, "eval-sequence");
            LispObject* tmp_530;
            tmp_530 = proc;
            Environment* tmp_526;
    tmp_526 = environment_copy(env);
            proc = environment_lookup(env, "extend-environment");
            LispObject* tmp_524;
            tmp_524 = proc;
            Environment* tmp_520;
    tmp_520 = environment_copy(env);
            proc = environment_lookup(env, "procedure-environment");
            val = environment_lookup(env, "procedure");
            argl = cons(val, &LispNull);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
            argl = cons(val, &LispNull);
            env = environment_copy(tmp_520);
            val = environment_lookup(env, "arguments");
            argl = cons(val, argl);
            LispObject* tmp_519;
            tmp_519 = argl;
            proc = environment_lookup(env, "procedure-parameters");
            val = environment_lookup(env, "procedure");
            argl = cons(val, &LispNull);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
            argl = tmp_519;
            argl = cons(val, argl);
            proc = tmp_524;
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
            argl = cons(val, &LispNull);
            env = environment_copy(tmp_526);
            LispObject* tmp_525;
            tmp_525 = argl;
            proc = environment_lookup(env, "procedure-body");
            val = environment_lookup(env, "procedure");
            argl = cons(val, &LispNull);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
            argl = tmp_525;
            argl = cons(val, argl);
            proc = tmp_530;
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
        } else {
            val = environment_lookup(env, "procedure");
            print_lisp_object(val);
            putchar(10);
            proc = environment_lookup(env, "primitive-procedure?");
            val = environment_lookup(env, "procedure");
            argl = cons(val, &LispNull);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
            print_lisp_object(val);
            putchar(10);
            printf("Error: Unknown procedure type: APPLY\n");
        };
    };
};
void entry536(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    val = parse_lisp_object_from_string("in-eval");
    print_lisp_object(val);
    Environment* tmp_654;
    tmp_654 = environment_copy(env);
    proc = environment_lookup(env, "self-evaluating?");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_654);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        val = environment_lookup(env, "exp");
    } else {
        Environment* tmp_653;
    tmp_653 = environment_copy(env);
        proc = environment_lookup(env, "variable?");
        val = environment_lookup(env, "exp");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        env = environment_copy(tmp_653);
        if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
            proc = environment_lookup(env, "lookup-variable-value");
            val = environment_lookup(env, "env");
            argl = cons(val, &LispNull);
            val = environment_lookup(env, "exp");
            argl = cons(val, argl);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
        } else {
            Environment* tmp_652;
    tmp_652 = environment_copy(env);
            proc = environment_lookup(env, "quoted?");
            val = environment_lookup(env, "exp");
            argl = cons(val, &LispNull);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
            env = environment_copy(tmp_652);
            if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
                proc = environment_lookup(env, "text-of-quotation");
                val = environment_lookup(env, "exp");
                argl = cons(val, &LispNull);
                if (proc->type == PRIMITIVE_PROC) {
                    val = apply(proc, argl);
                } else {
                    proc->CompiledFun();
                };
            } else {
                Environment* tmp_651;
    tmp_651 = environment_copy(env);
                proc = environment_lookup(env, "assignment?");
                val = environment_lookup(env, "exp");
                argl = cons(val, &LispNull);
                if (proc->type == PRIMITIVE_PROC) {
                    val = apply(proc, argl);
                } else {
                    proc->CompiledFun();
                };
                env = environment_copy(tmp_651);
                if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
                    proc = environment_lookup(env, "eval-assignment");
                    val = environment_lookup(env, "env");
                    argl = cons(val, &LispNull);
                    val = environment_lookup(env, "exp");
                    argl = cons(val, argl);
                    if (proc->type == PRIMITIVE_PROC) {
                        val = apply(proc, argl);
                    } else {
                        proc->CompiledFun();
                    };
                } else {
                    Environment* tmp_650;
    tmp_650 = environment_copy(env);
                    proc = environment_lookup(env, "definition?");
                    val = environment_lookup(env, "exp");
                    argl = cons(val, &LispNull);
                    if (proc->type == PRIMITIVE_PROC) {
                        val = apply(proc, argl);
                    } else {
                        proc->CompiledFun();
                    };
                    env = environment_copy(tmp_650);
                    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
                        proc = environment_lookup(env, "eval-definition");
                        val = environment_lookup(env, "env");
                        argl = cons(val, &LispNull);
                        val = environment_lookup(env, "exp");
                        argl = cons(val, argl);
                        if (proc->type == PRIMITIVE_PROC) {
                            val = apply(proc, argl);
                        } else {
                            proc->CompiledFun();
                        };
                    } else {
                        Environment* tmp_649;
    tmp_649 = environment_copy(env);
                        proc = environment_lookup(env, "if?");
                        val = environment_lookup(env, "exp");
                        argl = cons(val, &LispNull);
                        if (proc->type == PRIMITIVE_PROC) {
                            val = apply(proc, argl);
                        } else {
                            proc->CompiledFun();
                        };
                        env = environment_copy(tmp_649);
                        if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
                            proc = environment_lookup(env, "eval-if");
                            val = environment_lookup(env, "env");
                            argl = cons(val, &LispNull);
                            val = environment_lookup(env, "exp");
                            argl = cons(val, argl);
                            if (proc->type == PRIMITIVE_PROC) {
                                val = apply(proc, argl);
                            } else {
                                proc->CompiledFun();
                            };
                        } else {
                            Environment* tmp_648;
    tmp_648 = environment_copy(env);
                            proc = environment_lookup(env, "lambda?");
                            val = environment_lookup(env, "exp");
                            argl = cons(val, &LispNull);
                            if (proc->type == PRIMITIVE_PROC) {
                                val = apply(proc, argl);
                            } else {
                                proc->CompiledFun();
                            };
                            env = environment_copy(tmp_648);
                            if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
                                proc = environment_lookup(env, "make-procedure");
                                LispObject* tmp_585;
                                tmp_585 = proc;
                                val = environment_lookup(env, "env");
                                argl = cons(val, &LispNull);
                                Environment* tmp_581;
    tmp_581 = environment_copy(env);
                                LispObject* tmp_579;
                                tmp_579 = argl;
                                proc = environment_lookup(env, "lambda-body");
                                val = environment_lookup(env, "exp");
                                argl = cons(val, &LispNull);
                                if (proc->type == PRIMITIVE_PROC) {
                                    val = apply(proc, argl);
                                } else {
                                    proc->CompiledFun();
                                };
                                argl = tmp_579;
                                argl = cons(val, argl);
                                env = environment_copy(tmp_581);
                                LispObject* tmp_580;
                                tmp_580 = argl;
                                proc = environment_lookup(env, "lambda-parameters");
                                val = environment_lookup(env, "exp");
                                argl = cons(val, &LispNull);
                                if (proc->type == PRIMITIVE_PROC) {
                                    val = apply(proc, argl);
                                } else {
                                    proc->CompiledFun();
                                };
                                argl = tmp_580;
                                argl = cons(val, argl);
                                proc = tmp_585;
                                if (proc->type == PRIMITIVE_PROC) {
                                    val = apply(proc, argl);
                                } else {
                                    proc->CompiledFun();
                                };
                            } else {
                                Environment* tmp_647;
    tmp_647 = environment_copy(env);
                                proc = environment_lookup(env, "let?");
                                val = environment_lookup(env, "exp");
                                argl = cons(val, &LispNull);
                                if (proc->type == PRIMITIVE_PROC) {
                                    val = apply(proc, argl);
                                } else {
                                    proc->CompiledFun();
                                };
                                env = environment_copy(tmp_647);
                                if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
                                    proc = environment_lookup(env, "eval");
                                    LispObject* tmp_596;
                                    tmp_596 = proc;
                                    val = environment_lookup(env, "env");
                                    argl = cons(val, &LispNull);
                                    LispObject* tmp_592;
                                    tmp_592 = argl;
                                    proc = environment_lookup(env, "let->combination");
                                    val = environment_lookup(env, "exp");
                                    argl = cons(val, &LispNull);
                                    if (proc->type == PRIMITIVE_PROC) {
                                        val = apply(proc, argl);
                                    } else {
                                        proc->CompiledFun();
                                    };
                                    argl = tmp_592;
                                    argl = cons(val, argl);
                                    proc = tmp_596;
                                    if (proc->type == PRIMITIVE_PROC) {
                                        val = apply(proc, argl);
                                    } else {
                                        proc->CompiledFun();
                                    };
                                } else {
                                    Environment* tmp_646;
    tmp_646 = environment_copy(env);
                                    proc = environment_lookup(env, "begin?");
                                    val = environment_lookup(env, "exp");
                                    argl = cons(val, &LispNull);
                                    if (proc->type == PRIMITIVE_PROC) {
                                        val = apply(proc, argl);
                                    } else {
                                        proc->CompiledFun();
                                    };
                                    env = environment_copy(tmp_646);
                                    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
                                        proc = environment_lookup(env, "eval-sequence");
                                        LispObject* tmp_607;
                                        tmp_607 = proc;
                                        val = environment_lookup(env, "env");
                                        argl = cons(val, &LispNull);
                                        LispObject* tmp_603;
                                        tmp_603 = argl;
                                        proc = environment_lookup(env, "begin-actions");
                                        val = environment_lookup(env, "exp");
                                        argl = cons(val, &LispNull);
                                        if (proc->type == PRIMITIVE_PROC) {
                                            val = apply(proc, argl);
                                        } else {
                                            proc->CompiledFun();
                                        };
                                        argl = tmp_603;
                                        argl = cons(val, argl);
                                        proc = tmp_607;
                                        if (proc->type == PRIMITIVE_PROC) {
                                            val = apply(proc, argl);
                                        } else {
                                            proc->CompiledFun();
                                        };
                                    } else {
                                        Environment* tmp_645;
    tmp_645 = environment_copy(env);
                                        proc = environment_lookup(env, "cond?");
                                        val = environment_lookup(env, "exp");
                                        argl = cons(val, &LispNull);
                                        if (proc->type == PRIMITIVE_PROC) {
                                            val = apply(proc, argl);
                                        } else {
                                            proc->CompiledFun();
                                        };
                                        env = environment_copy(tmp_645);
                                        if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
                                            proc = environment_lookup(env, "eval");
                                            LispObject* tmp_618;
                                            tmp_618 = proc;
                                            val = environment_lookup(env, "env");
                                            argl = cons(val, &LispNull);
                                            LispObject* tmp_614;
                                            tmp_614 = argl;
                                            proc = environment_lookup(env, "cond->if");
                                            val = environment_lookup(env, "exp");
                                            argl = cons(val, &LispNull);
                                            if (proc->type == PRIMITIVE_PROC) {
                                                val = apply(proc, argl);
                                            } else {
                                                proc->CompiledFun();
                                            };
                                            argl = tmp_614;
                                            argl = cons(val, argl);
                                            proc = tmp_618;
                                            if (proc->type == PRIMITIVE_PROC) {
                                                val = apply(proc, argl);
                                            } else {
                                                proc->CompiledFun();
                                            };
                                        } else {
                                            Environment* tmp_644;
    tmp_644 = environment_copy(env);
                                            proc = environment_lookup(env, "application?");
                                            val = environment_lookup(env, "exp");
                                            argl = cons(val, &LispNull);
                                            if (proc->type == PRIMITIVE_PROC) {
                                                val = apply(proc, argl);
                                            } else {
                                                proc->CompiledFun();
                                            };
                                            env = environment_copy(tmp_644);
                                            if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
                                                proc = environment_lookup(env, "m-apply");
                                                LispObject* tmp_643;
                                                tmp_643 = proc;
                                                Environment* tmp_639;
    tmp_639 = environment_copy(env);
                                                proc = environment_lookup(env, "list-of-values");
                                                LispObject* tmp_637;
                                                tmp_637 = proc;
                                                val = environment_lookup(env, "env");
                                                argl = cons(val, &LispNull);
                                                LispObject* tmp_633;
                                                tmp_633 = argl;
                                                proc = environment_lookup(env, "operands");
                                                val = environment_lookup(env, "exp");
                                                argl = cons(val, &LispNull);
                                                if (proc->type == PRIMITIVE_PROC) {
                                                    val = apply(proc, argl);
                                                } else {
                                                    proc->CompiledFun();
                                                };
                                                argl = tmp_633;
                                                argl = cons(val, argl);
                                                proc = tmp_637;
                                                if (proc->type == PRIMITIVE_PROC) {
                                                    val = apply(proc, argl);
                                                } else {
                                                    proc->CompiledFun();
                                                };
                                                argl = cons(val, &LispNull);
                                                env = environment_copy(tmp_639);
                                                LispObject* tmp_638;
                                                tmp_638 = argl;
                                                proc = environment_lookup(env, "eval");
                                                LispObject* tmp_629;
                                                tmp_629 = proc;
                                                val = environment_lookup(env, "env");
                                                argl = cons(val, &LispNull);
                                                LispObject* tmp_625;
                                                tmp_625 = argl;
                                                proc = environment_lookup(env, "operator");
                                                val = environment_lookup(env, "exp");
                                                argl = cons(val, &LispNull);
                                                if (proc->type == PRIMITIVE_PROC) {
                                                    val = apply(proc, argl);
                                                } else {
                                                    proc->CompiledFun();
                                                };
                                                argl = tmp_625;
                                                argl = cons(val, argl);
                                                proc = tmp_629;
                                                if (proc->type == PRIMITIVE_PROC) {
                                                    val = apply(proc, argl);
                                                } else {
                                                    proc->CompiledFun();
                                                };
                                                argl = tmp_638;
                                                argl = cons(val, argl);
                                                proc = tmp_643;
                                                if (proc->type == PRIMITIVE_PROC) {
                                                    val = apply(proc, argl);
                                                } else {
                                                    proc->CompiledFun();
                                                };
                                            } else {
                                                printf("Error: Unknown expression type: EVAL\n");
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
        };
    };
};
void entry655(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_659;
    tmp_659 = environment_copy(env);
    proc = environment_lookup(env, "number?");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_659);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        val = create_lisp_atom_from_string("#t");
    } else {
        val = create_lisp_atom_from_string("#f");
    };
};
void entry660(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "symbol?");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry664(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "tag", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_676;
    tmp_676 = environment_copy(env);
    proc = environment_lookup(env, "pair?");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_676);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        proc = environment_lookup(env, "eq?");
        LispObject* tmp_675;
        tmp_675 = proc;
        val = environment_lookup(env, "tag");
        argl = cons(val, &LispNull);
        LispObject* tmp_671;
        tmp_671 = argl;
        proc = environment_lookup(env, "car");
        val = environment_lookup(env, "exp");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_671;
        argl = cons(val, argl);
        proc = tmp_675;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    } else {
        val = create_lisp_atom_from_string("#f");
    };
};
void entry677(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "tagged-list?");
    val = parse_lisp_object_from_string("quote");
    argl = cons(val, &LispNull);
    val = environment_lookup(env, "exp");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry681(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "cadr");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry685(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "tagged-list?");
    val = parse_lisp_object_from_string("set!");
    argl = cons(val, &LispNull);
    val = environment_lookup(env, "exp");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry689(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "cadr");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry693(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "caddr");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry697(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "tagged-list?");
    val = parse_lisp_object_from_string("define");
    argl = cons(val, &LispNull);
    val = environment_lookup(env, "exp");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry701(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_715;
    tmp_715 = environment_copy(env);
    proc = environment_lookup(env, "symbol?");
    LispObject* tmp_708;
    tmp_708 = proc;
    proc = environment_lookup(env, "cadr");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_708;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_715);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        proc = environment_lookup(env, "cadr");
        val = environment_lookup(env, "exp");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    } else {
        proc = environment_lookup(env, "caadr");
        val = environment_lookup(env, "exp");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    };
};
void entry716(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_739;
    tmp_739 = environment_copy(env);
    proc = environment_lookup(env, "symbol?");
    LispObject* tmp_723;
    tmp_723 = proc;
    proc = environment_lookup(env, "cadr");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_723;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_739);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        proc = environment_lookup(env, "caddr");
        val = environment_lookup(env, "exp");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    } else {
        proc = environment_lookup(env, "make-lambda");
        LispObject* tmp_738;
        tmp_738 = proc;
        Environment* tmp_734;
    tmp_734 = environment_copy(env);
        proc = environment_lookup(env, "cddr");
        val = environment_lookup(env, "exp");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        env = environment_copy(tmp_734);
        LispObject* tmp_733;
        tmp_733 = argl;
        proc = environment_lookup(env, "cdadr");
        val = environment_lookup(env, "exp");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_733;
        argl = cons(val, argl);
        proc = tmp_738;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    };
};
void entry740(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "tagged-list?");
    val = parse_lisp_object_from_string("lambda");
    argl = cons(val, &LispNull);
    val = environment_lookup(env, "exp");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry744(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "cadr");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry748(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "cddr");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry752(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "parameters", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "body", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "cons");
    LispObject* tmp_759;
    tmp_759 = proc;
    proc = environment_lookup(env, "cons");
    val = environment_lookup(env, "body");
    argl = cons(val, &LispNull);
    val = environment_lookup(env, "parameters");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    val = parse_lisp_object_from_string("lambda");
    argl = cons(val, argl);
    proc = tmp_759;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry760(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "tagged-list?");
    val = parse_lisp_object_from_string("if");
    argl = cons(val, &LispNull);
    val = environment_lookup(env, "exp");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry764(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "cadr");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry768(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "caddr");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry772(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_787;
    tmp_787 = environment_copy(env);
    proc = environment_lookup(env, "not");
    LispObject* tmp_783;
    tmp_783 = proc;
    proc = environment_lookup(env, "null?");
    LispObject* tmp_779;
    tmp_779 = proc;
    proc = environment_lookup(env, "cdddr");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_779;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_783;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_787);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        proc = environment_lookup(env, "cadddr");
        val = environment_lookup(env, "exp");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    } else {
        val = create_lisp_atom_from_string("#f");
    };
};
void entry788(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "predicate", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "consequent", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "alternative", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "list");
    val = environment_lookup(env, "alternative");
    argl = cons(val, &LispNull);
    val = environment_lookup(env, "consequent");
    argl = cons(val, argl);
    val = environment_lookup(env, "predicate");
    argl = cons(val, argl);
    val = parse_lisp_object_from_string("if");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry792(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "tagged-list?");
    val = parse_lisp_object_from_string("begin");
    argl = cons(val, &LispNull);
    val = environment_lookup(env, "exp");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry796(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "cdr");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry800(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "seq", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "null?");
    LispObject* tmp_807;
    tmp_807 = proc;
    proc = environment_lookup(env, "cdr");
    val = environment_lookup(env, "seq");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_807;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry808(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "seq", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "car");
    val = environment_lookup(env, "seq");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry812(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "seq", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "cdr");
    val = environment_lookup(env, "seq");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry816(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "seq", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_830;
    tmp_830 = environment_copy(env);
    proc = environment_lookup(env, "null?");
    val = environment_lookup(env, "seq");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_830);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        val = environment_lookup(env, "seq");
    } else {
        Environment* tmp_829;
    tmp_829 = environment_copy(env);
        proc = environment_lookup(env, "last-exp?");
        val = environment_lookup(env, "seq");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        env = environment_copy(tmp_829);
        if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
            proc = environment_lookup(env, "first-exp");
            val = environment_lookup(env, "seq");
            argl = cons(val, &LispNull);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
        } else {
            proc = environment_lookup(env, "make-begin");
            val = environment_lookup(env, "seq");
            argl = cons(val, &LispNull);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
        };
    };
};
void entry831(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "seq", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "cons");
    val = environment_lookup(env, "seq");
    argl = cons(val, &LispNull);
    val = parse_lisp_object_from_string("begin");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry835(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "pair?");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry839(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "car");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry843(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "cdr");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry847(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "ops", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "null?");
    val = environment_lookup(env, "ops");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry851(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "ops", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "car");
    val = environment_lookup(env, "ops");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry855(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "ops", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "cdr");
    val = environment_lookup(env, "ops");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry859(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "tagged-list?");
    val = parse_lisp_object_from_string("cond");
    argl = cons(val, &LispNull);
    val = environment_lookup(env, "exp");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry863(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "cdr");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry867(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "clause", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "eq?");
    LispObject* tmp_875;
    tmp_875 = proc;
    val = parse_lisp_object_from_string("else");
    argl = cons(val, &LispNull);
    LispObject* tmp_871;
    tmp_871 = argl;
    proc = environment_lookup(env, "cond-predicate");
    val = environment_lookup(env, "clause");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_871;
    argl = cons(val, argl);
    proc = tmp_875;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry876(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "clause", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "car");
    val = environment_lookup(env, "clause");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry880(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "clause", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "cdr");
    val = environment_lookup(env, "clause");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry884(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "expand-clauses");
    LispObject* tmp_891;
    tmp_891 = proc;
    proc = environment_lookup(env, "cond-clauses");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_891;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry892(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "clauses", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_945;
    tmp_945 = environment_copy(env);
    proc = environment_lookup(env, "null?");
    val = environment_lookup(env, "clauses");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_945);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        val = create_lisp_atom_from_string("#f");
    } else {
        proc = create_empty_lisp_object(COMPILED_PROCEDURE);
        proc->CompoundFunEnvironment = env;
        proc->CompiledFun = &entry896;
        LispObject* tmp_944;
        tmp_944 = proc;
        Environment* tmp_940;
    tmp_940 = environment_copy(env);
        proc = environment_lookup(env, "cdr");
        val = environment_lookup(env, "clauses");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        env = environment_copy(tmp_940);
        LispObject* tmp_939;
        tmp_939 = argl;
        proc = environment_lookup(env, "car");
        val = environment_lookup(env, "clauses");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_939;
        argl = cons(val, argl);
        proc = tmp_944;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    };
};
void entry896(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "first", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "rest", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_932;
    tmp_932 = environment_copy(env);
    proc = environment_lookup(env, "cond-else-clause?");
    val = environment_lookup(env, "first");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_932);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        Environment* tmp_910;
    tmp_910 = environment_copy(env);
        proc = environment_lookup(env, "null?");
        val = environment_lookup(env, "rest");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        env = environment_copy(tmp_910);
        if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
            proc = environment_lookup(env, "sequence->exp");
            LispObject* tmp_909;
            tmp_909 = proc;
            proc = environment_lookup(env, "cond-actions");
            val = environment_lookup(env, "first");
            argl = cons(val, &LispNull);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
            argl = cons(val, &LispNull);
            proc = tmp_909;
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
        } else {
            printf("Error: ELSE clause isn't last: COND->IF\n");
        };
    } else {
        proc = environment_lookup(env, "make-if");
        LispObject* tmp_931;
        tmp_931 = proc;
        Environment* tmp_927;
    tmp_927 = environment_copy(env);
        proc = environment_lookup(env, "expand-clauses");
        val = environment_lookup(env, "rest");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        env = environment_copy(tmp_927);
        Environment* tmp_926;
    tmp_926 = environment_copy(env);
        LispObject* tmp_924;
        tmp_924 = argl;
        proc = environment_lookup(env, "sequence->exp");
        LispObject* tmp_920;
        tmp_920 = proc;
        proc = environment_lookup(env, "cond-actions");
        val = environment_lookup(env, "first");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        proc = tmp_920;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_924;
        argl = cons(val, argl);
        env = environment_copy(tmp_926);
        LispObject* tmp_925;
        tmp_925 = argl;
        proc = environment_lookup(env, "cond-predicate");
        val = environment_lookup(env, "first");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_925;
        argl = cons(val, argl);
        proc = tmp_931;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    };
};
void entry946(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exps", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_972;
    tmp_972 = environment_copy(env);
    proc = environment_lookup(env, "no-operands?");
    val = environment_lookup(env, "exps");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_972);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        val = parse_lisp_object_from_string("()");
    } else {
        proc = environment_lookup(env, "cons");
        LispObject* tmp_971;
        tmp_971 = proc;
        Environment* tmp_967;
    tmp_967 = environment_copy(env);
        proc = environment_lookup(env, "list-of-values");
        LispObject* tmp_965;
        tmp_965 = proc;
        val = environment_lookup(env, "env");
        argl = cons(val, &LispNull);
        LispObject* tmp_961;
        tmp_961 = argl;
        proc = environment_lookup(env, "rest-operands");
        val = environment_lookup(env, "exps");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_961;
        argl = cons(val, argl);
        proc = tmp_965;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        env = environment_copy(tmp_967);
        LispObject* tmp_966;
        tmp_966 = argl;
        proc = environment_lookup(env, "eval");
        LispObject* tmp_957;
        tmp_957 = proc;
        val = environment_lookup(env, "env");
        argl = cons(val, &LispNull);
        LispObject* tmp_953;
        tmp_953 = argl;
        proc = environment_lookup(env, "first-operand");
        val = environment_lookup(env, "exps");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_953;
        argl = cons(val, argl);
        proc = tmp_957;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_966;
        argl = cons(val, argl);
        proc = tmp_971;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    };
};
void entry973(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_1002;
    tmp_1002 = environment_copy(env);
    proc = environment_lookup(env, "true?");
    LispObject* tmp_985;
    tmp_985 = proc;
    proc = environment_lookup(env, "eval");
    LispObject* tmp_981;
    tmp_981 = proc;
    val = environment_lookup(env, "env");
    argl = cons(val, &LispNull);
    LispObject* tmp_977;
    tmp_977 = argl;
    proc = environment_lookup(env, "if-predicate");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_977;
    argl = cons(val, argl);
    proc = tmp_981;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_985;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_1002);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        proc = environment_lookup(env, "eval");
        LispObject* tmp_993;
        tmp_993 = proc;
        val = environment_lookup(env, "env");
        argl = cons(val, &LispNull);
        LispObject* tmp_989;
        tmp_989 = argl;
        proc = environment_lookup(env, "if-consequent");
        val = environment_lookup(env, "exp");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_989;
        argl = cons(val, argl);
        proc = tmp_993;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    } else {
        proc = environment_lookup(env, "eval");
        LispObject* tmp_1001;
        tmp_1001 = proc;
        val = environment_lookup(env, "env");
        argl = cons(val, &LispNull);
        LispObject* tmp_997;
        tmp_997 = argl;
        proc = environment_lookup(env, "if-alternative");
        val = environment_lookup(env, "exp");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_997;
        argl = cons(val, argl);
        proc = tmp_1001;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    };
};
void entry1003(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exps", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_1032;
    tmp_1032 = environment_copy(env);
    proc = environment_lookup(env, "last-exp?");
    val = environment_lookup(env, "exps");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_1032);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        proc = environment_lookup(env, "eval");
        LispObject* tmp_1014;
        tmp_1014 = proc;
        val = environment_lookup(env, "env");
        argl = cons(val, &LispNull);
        LispObject* tmp_1010;
        tmp_1010 = argl;
        proc = environment_lookup(env, "first-exp");
        val = environment_lookup(env, "exps");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_1010;
        argl = cons(val, argl);
        proc = tmp_1014;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    } else {
        Environment* tmp_1031;
    tmp_1031 = environment_copy(env);
        proc = environment_lookup(env, "eval");
        LispObject* tmp_1022;
        tmp_1022 = proc;
        val = environment_lookup(env, "env");
        argl = cons(val, &LispNull);
        LispObject* tmp_1018;
        tmp_1018 = argl;
        proc = environment_lookup(env, "first-exp");
        val = environment_lookup(env, "exps");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_1018;
        argl = cons(val, argl);
        proc = tmp_1022;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        env = environment_copy(tmp_1031);
        proc = environment_lookup(env, "eval-sequence");
        LispObject* tmp_1030;
        tmp_1030 = proc;
        val = environment_lookup(env, "env");
        argl = cons(val, &LispNull);
        LispObject* tmp_1026;
        tmp_1026 = argl;
        proc = environment_lookup(env, "rest-exps");
        val = environment_lookup(env, "exps");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_1026;
        argl = cons(val, argl);
        proc = tmp_1030;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    };
};
void entry1033(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "set-variable-value!");
    LispObject* tmp_1051;
    tmp_1051 = proc;
    val = environment_lookup(env, "env");
    argl = cons(val, &LispNull);
    Environment* tmp_1047;
    tmp_1047 = environment_copy(env);
    LispObject* tmp_1045;
    tmp_1045 = argl;
    proc = environment_lookup(env, "eval");
    LispObject* tmp_1044;
    tmp_1044 = proc;
    val = environment_lookup(env, "env");
    argl = cons(val, &LispNull);
    LispObject* tmp_1040;
    tmp_1040 = argl;
    proc = environment_lookup(env, "assignment-value");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_1040;
    argl = cons(val, argl);
    proc = tmp_1044;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_1045;
    argl = cons(val, argl);
    env = environment_copy(tmp_1047);
    LispObject* tmp_1046;
    tmp_1046 = argl;
    proc = environment_lookup(env, "assignment-variable");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_1046;
    argl = cons(val, argl);
    proc = tmp_1051;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    val = parse_lisp_object_from_string("ok");
};
void entry1052(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "define-variable!");
    LispObject* tmp_1070;
    tmp_1070 = proc;
    val = environment_lookup(env, "env");
    argl = cons(val, &LispNull);
    Environment* tmp_1066;
    tmp_1066 = environment_copy(env);
    LispObject* tmp_1064;
    tmp_1064 = argl;
    proc = environment_lookup(env, "eval");
    LispObject* tmp_1063;
    tmp_1063 = proc;
    val = environment_lookup(env, "env");
    argl = cons(val, &LispNull);
    LispObject* tmp_1059;
    tmp_1059 = argl;
    proc = environment_lookup(env, "definition-value");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_1059;
    argl = cons(val, argl);
    proc = tmp_1063;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_1064;
    argl = cons(val, argl);
    env = environment_copy(tmp_1066);
    LispObject* tmp_1065;
    tmp_1065 = argl;
    proc = environment_lookup(env, "definition-variable");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_1065;
    argl = cons(val, argl);
    proc = tmp_1070;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    val = parse_lisp_object_from_string("ok");
};
void entry1071(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "tagged-list?");
    val = parse_lisp_object_from_string("let");
    argl = cons(val, &LispNull);
    val = environment_lookup(env, "exp");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry1075(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "map");
    LispObject* tmp_1083;
    tmp_1083 = proc;
    Environment* tmp_1079;
    tmp_1079 = environment_copy(env);
    proc = environment_lookup(env, "cadr");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_1079);
    val = environment_lookup(env, "car");
    argl = cons(val, argl);
    proc = tmp_1083;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry1084(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "cddr");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry1088(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "map");
    LispObject* tmp_1096;
    tmp_1096 = proc;
    Environment* tmp_1092;
    tmp_1092 = environment_copy(env);
    proc = environment_lookup(env, "cadr");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_1092);
    val = environment_lookup(env, "cadr");
    argl = cons(val, argl);
    proc = tmp_1096;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry1097(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "cons");
    LispObject* tmp_1118;
    tmp_1118 = proc;
    Environment* tmp_1114;
    tmp_1114 = environment_copy(env);
    proc = environment_lookup(env, "let-expressions");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_1114);
    LispObject* tmp_1113;
    tmp_1113 = argl;
    proc = environment_lookup(env, "make-lambda");
    LispObject* tmp_1109;
    tmp_1109 = proc;
    Environment* tmp_1105;
    tmp_1105 = environment_copy(env);
    proc = environment_lookup(env, "let-body");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_1105);
    LispObject* tmp_1104;
    tmp_1104 = argl;
    proc = environment_lookup(env, "let-variables");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_1104;
    argl = cons(val, argl);
    proc = tmp_1109;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_1113;
    argl = cons(val, argl);
    proc = tmp_1118;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry1119(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "var", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "body", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "append");
    LispObject* tmp_1135;
    tmp_1135 = proc;
    val = environment_lookup(env, "body");
    argl = cons(val, &LispNull);
    LispObject* tmp_1131;
    tmp_1131 = argl;
    proc = environment_lookup(env, "list");
    LispObject* tmp_1130;
    tmp_1130 = proc;
    proc = environment_lookup(env, "list");
    LispObject* tmp_1126;
    tmp_1126 = proc;
    proc = environment_lookup(env, "list");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    val = environment_lookup(env, "var");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_1126;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    val = parse_lisp_object_from_string("let");
    argl = cons(val, argl);
    proc = tmp_1130;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_1131;
    argl = cons(val, argl);
    proc = tmp_1135;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry1136(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "variable", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "definition", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "list");
    val = environment_lookup(env, "definition");
    argl = cons(val, &LispNull);
    val = environment_lookup(env, "variable");
    argl = cons(val, argl);
    val = parse_lisp_object_from_string("define");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry1140(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "object", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_1157;
    tmp_1157 = environment_copy(env);
    proc = environment_lookup(env, "compound-procedure?");
    val = environment_lookup(env, "object");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_1157);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        proc = environment_lookup(env, "list");
        LispObject* tmp_1156;
        tmp_1156 = proc;
        val = parse_lisp_object_from_string("<procedure-env>");
        argl = cons(val, &LispNull);
        Environment* tmp_1152;
    tmp_1152 = environment_copy(env);
        LispObject* tmp_1150;
        tmp_1150 = argl;
        proc = environment_lookup(env, "procedure-body");
        val = environment_lookup(env, "object");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_1150;
        argl = cons(val, argl);
        env = environment_copy(tmp_1152);
        LispObject* tmp_1151;
        tmp_1151 = argl;
        proc = environment_lookup(env, "procedure-parameters");
        val = environment_lookup(env, "object");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_1151;
        argl = cons(val, argl);
        val = parse_lisp_object_from_string("compound-procedure");
        argl = cons(val, argl);
        proc = tmp_1156;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        print_lisp_object(val);
    } else {
        val = environment_lookup(env, "object");
        print_lisp_object(val);
    };
};
void entry1158(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    Environment* tmp_1185;
    tmp_1185 = environment_copy(env);
    proc = environment_lookup(env, "prompt-for-input");
    val = environment_lookup(env, "input-prompt");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_1185);
    Environment* tmp_1184;
    tmp_1184 = environment_copy(env);
    proc = create_empty_lisp_object(COMPILED_PROCEDURE);
    proc->CompoundFunEnvironment = env;
    proc->CompiledFun = &entry1162;
    val = read_and_parse_input();
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_1184);
    proc = environment_lookup(env, "driver-loop");
    argl = &LispNull;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry1162(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "input", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = create_empty_lisp_object(COMPILED_PROCEDURE);
    proc->CompoundFunEnvironment = env;
    proc->CompiledFun = &entry1163;
    LispObject* tmp_1177;
    tmp_1177 = proc;
    proc = environment_lookup(env, "eval");
    val = environment_lookup(env, "the-global-environment");
    argl = cons(val, &LispNull);
    val = environment_lookup(env, "input");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_1177;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry1163(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "output", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_1170;
    tmp_1170 = environment_copy(env);
    proc = environment_lookup(env, "announce-output");
    val = environment_lookup(env, "output-prompt");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_1170);
    proc = environment_lookup(env, "user-print");
    val = environment_lookup(env, "output");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry1186(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "string", argl->CarPointer);
    argl = argl->CdrPointer;
    putchar(10);
    putchar(10);
    val = environment_lookup(env, "string");
    print_lisp_object(val);
    putchar(10);
};
void entry1187(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "string", argl->CarPointer);
    argl = argl->CdrPointer;
    putchar(10);
    val = environment_lookup(env, "string");
    print_lisp_object(val);
    putchar(10);
};

/* footer here */
