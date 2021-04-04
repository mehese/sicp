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
void entry154(void);
void entry167(void);
void entry171(void);
void entry175(void);
void entry176(void);
void entry187(void);
void entry191(void);
void entry192(void);
void entry201(void);
void entry205(void);
void entry209(void);
void entry213(void);
void entry241(void);
void entry276(void);
void entry280(void);
void entry284(void);
void entry285(void);
void entry286(void);
void entry337(void);
void entry338(void);
void entry368(void);
void entry369(void);
void entry370(void);
void entry409(void);
void entry433(void);
void entry434(void);
void entry435(void);
void entry474(void);
void entry498(void);
void entry502(void);
void entry506(void);
void entry510(void);
void entry514(void);
void entry518(void);
void entry554(void);
void entry666(void);
void entry679(void);
void entry683(void);
void entry687(void);
void entry691(void);
void entry695(void);
void entry699(void);
void entry714(void);
void entry738(void);
void entry742(void);
void entry746(void);
void entry750(void);
void entry758(void);
void entry762(void);
void entry766(void);
void entry770(void);
void entry786(void);
void entry790(void);
void entry794(void);
void entry798(void);
void entry806(void);
void entry810(void);
void entry814(void);
void entry829(void);
void entry833(void);
void entry837(void);
void entry841(void);
void entry845(void);
void entry849(void);
void entry853(void);
void entry857(void);
void entry861(void);
void entry865(void);
void entry874(void);
void entry878(void);
void entry882(void);
void entry890(void);
void entry894(void);
void entry944(void);
void entry971(void);
void entry1001(void);
void entry1031(void);
void entry1050(void);
void entry1069(void);
void entry1073(void);
void entry1082(void);
void entry1086(void);
void entry1095(void);
void entry1117(void);
void entry1134(void);
void entry1138(void);
void entry1156(void);
void entry1160(void);
void entry1161(void);
void entry1184(void);
void entry1185(void);

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
    Environment* tmp_153;
    tmp_153 = environment_copy(env);
    proc = environment_lookup(env, "list");
    LispObject* tmp_152;
    tmp_152 = proc;
    Environment* tmp_148;
    tmp_148 = environment_copy(env);
    proc = environment_lookup(env, "list");
    val = environment_lookup(env, "<");
    argl = cons(val, &LispNull);
    val = parse_lisp_object_from_string("<");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_148);
    Environment* tmp_147;
    tmp_147 = environment_copy(env);
    LispObject* tmp_127;
    tmp_127 = argl;
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
    argl = tmp_127;
    argl = cons(val, argl);
    env = environment_copy(tmp_147);
    Environment* tmp_146;
    tmp_146 = environment_copy(env);
    LispObject* tmp_128;
    tmp_128 = argl;
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
    argl = tmp_128;
    argl = cons(val, argl);
    env = environment_copy(tmp_146);
    Environment* tmp_145;
    tmp_145 = environment_copy(env);
    LispObject* tmp_129;
    tmp_129 = argl;
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
    argl = tmp_129;
    argl = cons(val, argl);
    env = environment_copy(tmp_145);
    Environment* tmp_144;
    tmp_144 = environment_copy(env);
    LispObject* tmp_130;
    tmp_130 = argl;
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
    argl = tmp_130;
    argl = cons(val, argl);
    env = environment_copy(tmp_144);
    Environment* tmp_143;
    tmp_143 = environment_copy(env);
    LispObject* tmp_131;
    tmp_131 = argl;
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
    argl = tmp_131;
    argl = cons(val, argl);
    env = environment_copy(tmp_143);
    Environment* tmp_142;
    tmp_142 = environment_copy(env);
    LispObject* tmp_132;
    tmp_132 = argl;
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
    argl = tmp_132;
    argl = cons(val, argl);
    env = environment_copy(tmp_142);
    Environment* tmp_141;
    tmp_141 = environment_copy(env);
    LispObject* tmp_133;
    tmp_133 = argl;
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
    argl = tmp_133;
    argl = cons(val, argl);
    env = environment_copy(tmp_141);
    Environment* tmp_140;
    tmp_140 = environment_copy(env);
    LispObject* tmp_134;
    tmp_134 = argl;
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
    argl = tmp_134;
    argl = cons(val, argl);
    env = environment_copy(tmp_140);
    Environment* tmp_139;
    tmp_139 = environment_copy(env);
    LispObject* tmp_135;
    tmp_135 = argl;
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
    argl = tmp_135;
    argl = cons(val, argl);
    env = environment_copy(tmp_139);
    Environment* tmp_138;
    tmp_138 = environment_copy(env);
    LispObject* tmp_136;
    tmp_136 = argl;
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
    argl = tmp_136;
    argl = cons(val, argl);
    env = environment_copy(tmp_138);
    LispObject* tmp_137;
    tmp_137 = argl;
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
    argl = tmp_137;
    argl = cons(val, argl);
    proc = tmp_152;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_153);
    environment_add(env, "primitive-procedures", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry154;
    environment_add(env, "tagged-list?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry167;
    environment_add(env, "primitive-procedure?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry171;
    environment_add(env, "primitive-procedure-names", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry175;
    environment_add(env, "primitive-procedure-objects", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry187;
    environment_add(env, "primitive-implementation", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry191;
    environment_add(env, "apply-in-underlying-scheme", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry192;
    environment_add(env, "apply-primitive-procedure", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry201;
    environment_add(env, "make-frame", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry205;
    environment_add(env, "frame-variables", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry209;
    environment_add(env, "frame-values", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry213;
    environment_add(env, "add-binding-to-frame!", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry241;
    environment_add(env, "extend-environment", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry276;
    environment_add(env, "enclosing-environment", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry280;
    environment_add(env, "first-frame", val);
    val = parse_lisp_object_from_string("()");
    environment_add(env, "the-empty-environment", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry284;
    environment_add(env, "define-variable!", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry337;
    environment_add(env, "setup-environment", val);
    Environment* tmp_367;
    tmp_367 = environment_copy(env);
    proc = environment_lookup(env, "setup-environment");
    argl = &LispNull;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_367);
    environment_add(env, "the-global-environment", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry368;
    environment_add(env, "lookup-variable-value", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry433;
    environment_add(env, "set-variable-value!", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry498;
    environment_add(env, "compound-procedure?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry502;
    environment_add(env, "procedure-body", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry506;
    environment_add(env, "procedure-parameters", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry510;
    environment_add(env, "make-procedure", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry514;
    environment_add(env, "procedure-environment", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry518;
    environment_add(env, "m-apply", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry554;
    environment_add(env, "eval", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry666;
    environment_add(env, "self-evaluating?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry679;
    environment_add(env, "variable?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry683;
    environment_add(env, "assignment?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry687;
    environment_add(env, "assignment-variable", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry691;
    environment_add(env, "assignment-value", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry695;
    environment_add(env, "definition?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry699;
    environment_add(env, "definition-variable", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry714;
    environment_add(env, "definition-value", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry738;
    environment_add(env, "lambda?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry742;
    environment_add(env, "lambda-parameters", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry746;
    environment_add(env, "lambda-body", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry750;
    environment_add(env, "make-lambda", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry758;
    environment_add(env, "if?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry762;
    environment_add(env, "if-predicate", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry766;
    environment_add(env, "if-consequent", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry770;
    environment_add(env, "if-alternative", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry786;
    environment_add(env, "make-if", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry790;
    environment_add(env, "begin?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry794;
    environment_add(env, "begin-actions", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry798;
    environment_add(env, "last-exp?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry806;
    environment_add(env, "first-exp", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry810;
    environment_add(env, "rest-exps", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry814;
    environment_add(env, "sequence->exp", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry829;
    environment_add(env, "make-begin", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry833;
    environment_add(env, "application?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry837;
    environment_add(env, "operator", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry841;
    environment_add(env, "operands", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry845;
    environment_add(env, "no-operands?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry849;
    environment_add(env, "first-operand", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry853;
    environment_add(env, "rest-operands", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry857;
    environment_add(env, "cond?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry861;
    environment_add(env, "cond-clauses", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry865;
    environment_add(env, "cond-else-clause?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry874;
    environment_add(env, "cond-predicate", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry878;
    environment_add(env, "cond-actions", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry882;
    environment_add(env, "cond->if", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry890;
    environment_add(env, "expand-clauses", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry944;
    environment_add(env, "list-of-values", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry971;
    environment_add(env, "eval-if", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1001;
    environment_add(env, "eval-sequence", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1031;
    environment_add(env, "eval-assignment", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1050;
    environment_add(env, "eval-definition", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1069;
    environment_add(env, "let?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1073;
    environment_add(env, "let-variables", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1082;
    environment_add(env, "let-body", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1086;
    environment_add(env, "let-expressions", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1095;
    environment_add(env, "let->combination", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1117;
    environment_add(env, "make-let", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1134;
    environment_add(env, "make-variable-definition", val);
    val = parse_lisp_object_from_string("input:");
    environment_add(env, "input-prompt", val);
    val = parse_lisp_object_from_string("output:");
    environment_add(env, "output-prompt", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1138;
    environment_add(env, "user-print", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1156;
    environment_add(env, "driver-loop", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1184;
    environment_add(env, "prompt-for-input", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1185;
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
void entry154(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "tag", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_166;
    tmp_166 = environment_copy(env);
    proc = environment_lookup(env, "pair?");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_166);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        proc = environment_lookup(env, "eq?");
        LispObject* tmp_165;
        tmp_165 = proc;
        val = environment_lookup(env, "tag");
        argl = cons(val, &LispNull);
        LispObject* tmp_161;
        tmp_161 = argl;
        proc = environment_lookup(env, "car");
        val = environment_lookup(env, "exp");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_161;
        argl = cons(val, argl);
        proc = tmp_165;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    } else {
        val = create_lisp_atom_from_string("#f");
    };
};
void entry167(void) {
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
void entry171(void) {
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
void entry175(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    proc = environment_lookup(env, "map");
    val = environment_lookup(env, "primitive-procedures");
    argl = cons(val, &LispNull);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry176;
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry176(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "proc", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "list");
    LispObject* tmp_183;
    tmp_183 = proc;
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
    proc = tmp_183;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry187(void) {
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
void entry191(void) {
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
void entry192(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "proc", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "args", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "apply-in-underlying-scheme");
    LispObject* tmp_200;
    tmp_200 = proc;
    val = environment_lookup(env, "args");
    argl = cons(val, &LispNull);
    LispObject* tmp_196;
    tmp_196 = argl;
    proc = environment_lookup(env, "primitive-implementation");
    val = environment_lookup(env, "proc");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_196;
    argl = cons(val, argl);
    proc = tmp_200;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry201(void) {
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
void entry205(void) {
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
void entry209(void) {
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
void entry213(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "var", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "val", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "frame", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_240;
    tmp_240 = environment_copy(env);
    proc = environment_lookup(env, "set-car!");
    LispObject* tmp_226;
    tmp_226 = proc;
    Environment* tmp_222;
    tmp_222 = environment_copy(env);
    proc = environment_lookup(env, "cons");
    LispObject* tmp_221;
    tmp_221 = proc;
    Environment* tmp_217;
    tmp_217 = environment_copy(env);
    proc = environment_lookup(env, "car");
    val = environment_lookup(env, "frame");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_217);
    val = environment_lookup(env, "var");
    argl = cons(val, argl);
    proc = tmp_221;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_222);
    val = environment_lookup(env, "frame");
    argl = cons(val, argl);
    proc = tmp_226;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_240);
    proc = environment_lookup(env, "set-cdr!");
    LispObject* tmp_239;
    tmp_239 = proc;
    Environment* tmp_235;
    tmp_235 = environment_copy(env);
    proc = environment_lookup(env, "cons");
    LispObject* tmp_234;
    tmp_234 = proc;
    Environment* tmp_230;
    tmp_230 = environment_copy(env);
    proc = environment_lookup(env, "cdr");
    val = environment_lookup(env, "frame");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_230);
    val = environment_lookup(env, "val");
    argl = cons(val, argl);
    proc = tmp_234;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_235);
    val = environment_lookup(env, "frame");
    argl = cons(val, argl);
    proc = tmp_239;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry241(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "vars", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "vals", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "base-env", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_275;
    tmp_275 = environment_copy(env);
    proc = environment_lookup(env, "=");
    LispObject* tmp_253;
    tmp_253 = proc;
    Environment* tmp_249;
    tmp_249 = environment_copy(env);
    proc = environment_lookup(env, "length");
    val = environment_lookup(env, "vals");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_249);
    LispObject* tmp_248;
    tmp_248 = argl;
    proc = environment_lookup(env, "length");
    val = environment_lookup(env, "vars");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_248;
    argl = cons(val, argl);
    proc = tmp_253;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_275);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        proc = environment_lookup(env, "cons");
        LispObject* tmp_261;
        tmp_261 = proc;
        val = environment_lookup(env, "base-env");
        argl = cons(val, &LispNull);
        LispObject* tmp_257;
        tmp_257 = argl;
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
        argl = tmp_257;
        argl = cons(val, argl);
        proc = tmp_261;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    } else {
        Environment* tmp_274;
    tmp_274 = environment_copy(env);
        proc = environment_lookup(env, "<");
        LispObject* tmp_273;
        tmp_273 = proc;
        Environment* tmp_269;
    tmp_269 = environment_copy(env);
        proc = environment_lookup(env, "length");
        val = environment_lookup(env, "vals");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        env = environment_copy(tmp_269);
        LispObject* tmp_268;
        tmp_268 = argl;
        proc = environment_lookup(env, "length");
        val = environment_lookup(env, "vars");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_268;
        argl = cons(val, argl);
        proc = tmp_273;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        env = environment_copy(tmp_274);
        if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
            printf("Error: Too many arguments supplied\n");
        } else {
            printf("Error: Too few arguments supplied\n");
        };
    };
};
void entry276(void) {
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
void entry280(void) {
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
void entry284(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "var", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "val", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = create_empty_lisp_object(COMPILED_PROCEDURE);
    proc->CompoundFunEnvironment = env;
    proc->CompiledFun = &entry285;
    LispObject* tmp_336;
    tmp_336 = proc;
    proc = environment_lookup(env, "first-frame");
    val = environment_lookup(env, "env");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_336;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry285(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "frame", argl->CarPointer);
    argl = argl->CdrPointer;
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry286;
    environment_add(env, "scan", val);
    proc = environment_lookup(env, "scan");
    LispObject* tmp_329;
    tmp_329 = proc;
    Environment* tmp_325;
    tmp_325 = environment_copy(env);
    proc = environment_lookup(env, "frame-values");
    val = environment_lookup(env, "frame");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_325);
    LispObject* tmp_324;
    tmp_324 = argl;
    proc = environment_lookup(env, "frame-variables");
    val = environment_lookup(env, "frame");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_324;
    argl = cons(val, argl);
    proc = tmp_329;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry286(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "vars", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "vals", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_317;
    tmp_317 = environment_copy(env);
    proc = environment_lookup(env, "null?");
    val = environment_lookup(env, "vars");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_317);
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
        Environment* tmp_316;
    tmp_316 = environment_copy(env);
        proc = environment_lookup(env, "eq?");
        LispObject* tmp_300;
        tmp_300 = proc;
        Environment* tmp_296;
    tmp_296 = environment_copy(env);
        proc = environment_lookup(env, "car");
        val = environment_lookup(env, "vars");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        env = environment_copy(tmp_296);
        val = environment_lookup(env, "var");
        argl = cons(val, argl);
        proc = tmp_300;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        env = environment_copy(tmp_316);
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
            LispObject* tmp_315;
            tmp_315 = proc;
            Environment* tmp_311;
    tmp_311 = environment_copy(env);
            proc = environment_lookup(env, "cdr");
            val = environment_lookup(env, "vals");
            argl = cons(val, &LispNull);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
            argl = cons(val, &LispNull);
            env = environment_copy(tmp_311);
            LispObject* tmp_310;
            tmp_310 = argl;
            proc = environment_lookup(env, "cdr");
            val = environment_lookup(env, "vars");
            argl = cons(val, &LispNull);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
            argl = tmp_310;
            argl = cons(val, argl);
            proc = tmp_315;
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
        };
    };
};
void entry337(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    proc = create_empty_lisp_object(COMPILED_PROCEDURE);
    proc->CompoundFunEnvironment = env;
    proc->CompiledFun = &entry338;
    LispObject* tmp_363;
    tmp_363 = proc;
    proc = environment_lookup(env, "extend-environment");
    LispObject* tmp_359;
    tmp_359 = proc;
    val = environment_lookup(env, "the-empty-environment");
    argl = cons(val, &LispNull);
    Environment* tmp_355;
    tmp_355 = environment_copy(env);
    LispObject* tmp_353;
    tmp_353 = argl;
    proc = environment_lookup(env, "primitive-procedure-objects");
    argl = &LispNull;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_353;
    argl = cons(val, argl);
    env = environment_copy(tmp_355);
    LispObject* tmp_354;
    tmp_354 = argl;
    proc = environment_lookup(env, "primitive-procedure-names");
    argl = &LispNull;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_354;
    argl = cons(val, argl);
    proc = tmp_359;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_363;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry338(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "initial-env", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_346;
    tmp_346 = environment_copy(env);
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
    env = environment_copy(tmp_346);
    Environment* tmp_345;
    tmp_345 = environment_copy(env);
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
    env = environment_copy(tmp_345);
    val = environment_lookup(env, "initial-env");
};
void entry368(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "var", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry369;
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
void entry369(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry370;
    environment_add(env, "scan", val);
    Environment* tmp_429;
    tmp_429 = environment_copy(env);
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
    env = environment_copy(tmp_429);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        printf("Error: Unbound variable\n");
    } else {
        proc = create_empty_lisp_object(COMPILED_PROCEDURE);
        proc->CompoundFunEnvironment = env;
        proc->CompiledFun = &entry409;
        LispObject* tmp_428;
        tmp_428 = proc;
        proc = environment_lookup(env, "first-frame");
        val = environment_lookup(env, "env");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        proc = tmp_428;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    };
};
void entry370(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "vars", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "vals", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_405;
    tmp_405 = environment_copy(env);
    proc = environment_lookup(env, "null?");
    val = environment_lookup(env, "vars");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_405);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        proc = environment_lookup(env, "env-loop");
        LispObject* tmp_380;
        tmp_380 = proc;
        proc = environment_lookup(env, "enclosing-environment");
        val = environment_lookup(env, "env");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        proc = tmp_380;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    } else {
        Environment* tmp_404;
    tmp_404 = environment_copy(env);
        proc = environment_lookup(env, "eq?");
        LispObject* tmp_388;
        tmp_388 = proc;
        Environment* tmp_384;
    tmp_384 = environment_copy(env);
        proc = environment_lookup(env, "car");
        val = environment_lookup(env, "vars");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        env = environment_copy(tmp_384);
        val = environment_lookup(env, "var");
        argl = cons(val, argl);
        proc = tmp_388;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        env = environment_copy(tmp_404);
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
            LispObject* tmp_403;
            tmp_403 = proc;
            Environment* tmp_399;
    tmp_399 = environment_copy(env);
            proc = environment_lookup(env, "cdr");
            val = environment_lookup(env, "vals");
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
            proc = environment_lookup(env, "cdr");
            val = environment_lookup(env, "vars");
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
    };
};
void entry409(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "frame", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "scan");
    LispObject* tmp_421;
    tmp_421 = proc;
    Environment* tmp_417;
    tmp_417 = environment_copy(env);
    proc = environment_lookup(env, "frame-values");
    val = environment_lookup(env, "frame");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_417);
    LispObject* tmp_416;
    tmp_416 = argl;
    proc = environment_lookup(env, "frame-variables");
    val = environment_lookup(env, "frame");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_416;
    argl = cons(val, argl);
    proc = tmp_421;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry433(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "var", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "val", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry434;
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
void entry434(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry435;
    environment_add(env, "scan", val);
    Environment* tmp_494;
    tmp_494 = environment_copy(env);
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
    env = environment_copy(tmp_494);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        printf("Error: Unbound variable: SET!\n");
    } else {
        proc = create_empty_lisp_object(COMPILED_PROCEDURE);
        proc->CompoundFunEnvironment = env;
        proc->CompiledFun = &entry474;
        LispObject* tmp_493;
        tmp_493 = proc;
        proc = environment_lookup(env, "first-frame");
        val = environment_lookup(env, "env");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        proc = tmp_493;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    };
};
void entry435(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "vars", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "vals", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_470;
    tmp_470 = environment_copy(env);
    proc = environment_lookup(env, "null?");
    val = environment_lookup(env, "vars");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_470);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        proc = environment_lookup(env, "env-loop");
        LispObject* tmp_445;
        tmp_445 = proc;
        proc = environment_lookup(env, "enclosing-environment");
        val = environment_lookup(env, "env");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        proc = tmp_445;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    } else {
        Environment* tmp_469;
    tmp_469 = environment_copy(env);
        proc = environment_lookup(env, "eq?");
        LispObject* tmp_453;
        tmp_453 = proc;
        Environment* tmp_449;
    tmp_449 = environment_copy(env);
        proc = environment_lookup(env, "car");
        val = environment_lookup(env, "vars");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        env = environment_copy(tmp_449);
        val = environment_lookup(env, "var");
        argl = cons(val, argl);
        proc = tmp_453;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        env = environment_copy(tmp_469);
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
            LispObject* tmp_468;
            tmp_468 = proc;
            Environment* tmp_464;
    tmp_464 = environment_copy(env);
            proc = environment_lookup(env, "cdr");
            val = environment_lookup(env, "vals");
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
            proc = environment_lookup(env, "cdr");
            val = environment_lookup(env, "vars");
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
    };
};
void entry474(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "frame", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "scan");
    LispObject* tmp_486;
    tmp_486 = proc;
    Environment* tmp_482;
    tmp_482 = environment_copy(env);
    proc = environment_lookup(env, "frame-values");
    val = environment_lookup(env, "frame");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_482);
    LispObject* tmp_481;
    tmp_481 = argl;
    proc = environment_lookup(env, "frame-variables");
    val = environment_lookup(env, "frame");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_481;
    argl = cons(val, argl);
    proc = tmp_486;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry498(void) {
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
void entry502(void) {
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
void entry506(void) {
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
void entry510(void) {
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
void entry514(void) {
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
void entry518(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "procedure", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "arguments", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_553;
    tmp_553 = environment_copy(env);
    proc = environment_lookup(env, "primitive-procedure?");
    val = environment_lookup(env, "procedure");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_553);
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
        Environment* tmp_552;
    tmp_552 = environment_copy(env);
        proc = environment_lookup(env, "compound-procedure?");
        val = environment_lookup(env, "procedure");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        env = environment_copy(tmp_552);
        if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
            proc = environment_lookup(env, "eval-sequence");
            LispObject* tmp_548;
            tmp_548 = proc;
            Environment* tmp_544;
    tmp_544 = environment_copy(env);
            proc = environment_lookup(env, "extend-environment");
            LispObject* tmp_542;
            tmp_542 = proc;
            Environment* tmp_538;
    tmp_538 = environment_copy(env);
            proc = environment_lookup(env, "procedure-environment");
            val = environment_lookup(env, "procedure");
            argl = cons(val, &LispNull);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
            argl = cons(val, &LispNull);
            env = environment_copy(tmp_538);
            val = environment_lookup(env, "arguments");
            argl = cons(val, argl);
            LispObject* tmp_537;
            tmp_537 = argl;
            proc = environment_lookup(env, "procedure-parameters");
            val = environment_lookup(env, "procedure");
            argl = cons(val, &LispNull);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
            argl = tmp_537;
            argl = cons(val, argl);
            proc = tmp_542;
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
            argl = cons(val, &LispNull);
            env = environment_copy(tmp_544);
            LispObject* tmp_543;
            tmp_543 = argl;
            proc = environment_lookup(env, "procedure-body");
            val = environment_lookup(env, "procedure");
            argl = cons(val, &LispNull);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
            argl = tmp_543;
            argl = cons(val, argl);
            proc = tmp_548;
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
void entry554(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_665;
    tmp_665 = environment_copy(env);
    proc = environment_lookup(env, "self-evaluating?");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_665);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        val = environment_lookup(env, "exp");
    } else {
        Environment* tmp_664;
    tmp_664 = environment_copy(env);
        proc = environment_lookup(env, "variable?");
        val = environment_lookup(env, "exp");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        env = environment_copy(tmp_664);
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
            val = environment_lookup(env, "exp");
            if (val->type == QUOTED) {
                val = create_empty_lisp_object(BOOLEAN);
                val->BoolVal = true;
            } else {
                val = create_empty_lisp_object(BOOLEAN);
                val->BoolVal = false;
            };
            if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
                val = environment_lookup(env, "exp");
                val = val->QuotePointer;
            } else {
                Environment* tmp_663;
    tmp_663 = environment_copy(env);
                proc = environment_lookup(env, "assignment?");
                val = environment_lookup(env, "exp");
                argl = cons(val, &LispNull);
                if (proc->type == PRIMITIVE_PROC) {
                    val = apply(proc, argl);
                } else {
                    proc->CompiledFun();
                };
                env = environment_copy(tmp_663);
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
                    Environment* tmp_662;
    tmp_662 = environment_copy(env);
                    proc = environment_lookup(env, "definition?");
                    val = environment_lookup(env, "exp");
                    argl = cons(val, &LispNull);
                    if (proc->type == PRIMITIVE_PROC) {
                        val = apply(proc, argl);
                    } else {
                        proc->CompiledFun();
                    };
                    env = environment_copy(tmp_662);
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
                        Environment* tmp_661;
    tmp_661 = environment_copy(env);
                        proc = environment_lookup(env, "if?");
                        val = environment_lookup(env, "exp");
                        argl = cons(val, &LispNull);
                        if (proc->type == PRIMITIVE_PROC) {
                            val = apply(proc, argl);
                        } else {
                            proc->CompiledFun();
                        };
                        env = environment_copy(tmp_661);
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
                            Environment* tmp_660;
    tmp_660 = environment_copy(env);
                            proc = environment_lookup(env, "lambda?");
                            val = environment_lookup(env, "exp");
                            argl = cons(val, &LispNull);
                            if (proc->type == PRIMITIVE_PROC) {
                                val = apply(proc, argl);
                            } else {
                                proc->CompiledFun();
                            };
                            env = environment_copy(tmp_660);
                            if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
                                proc = environment_lookup(env, "make-procedure");
                                LispObject* tmp_597;
                                tmp_597 = proc;
                                val = environment_lookup(env, "env");
                                argl = cons(val, &LispNull);
                                Environment* tmp_593;
    tmp_593 = environment_copy(env);
                                LispObject* tmp_591;
                                tmp_591 = argl;
                                proc = environment_lookup(env, "lambda-body");
                                val = environment_lookup(env, "exp");
                                argl = cons(val, &LispNull);
                                if (proc->type == PRIMITIVE_PROC) {
                                    val = apply(proc, argl);
                                } else {
                                    proc->CompiledFun();
                                };
                                argl = tmp_591;
                                argl = cons(val, argl);
                                env = environment_copy(tmp_593);
                                LispObject* tmp_592;
                                tmp_592 = argl;
                                proc = environment_lookup(env, "lambda-parameters");
                                val = environment_lookup(env, "exp");
                                argl = cons(val, &LispNull);
                                if (proc->type == PRIMITIVE_PROC) {
                                    val = apply(proc, argl);
                                } else {
                                    proc->CompiledFun();
                                };
                                argl = tmp_592;
                                argl = cons(val, argl);
                                proc = tmp_597;
                                if (proc->type == PRIMITIVE_PROC) {
                                    val = apply(proc, argl);
                                } else {
                                    proc->CompiledFun();
                                };
                            } else {
                                Environment* tmp_659;
    tmp_659 = environment_copy(env);
                                proc = environment_lookup(env, "let?");
                                val = environment_lookup(env, "exp");
                                argl = cons(val, &LispNull);
                                if (proc->type == PRIMITIVE_PROC) {
                                    val = apply(proc, argl);
                                } else {
                                    proc->CompiledFun();
                                };
                                env = environment_copy(tmp_659);
                                if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
                                    proc = environment_lookup(env, "eval");
                                    LispObject* tmp_608;
                                    tmp_608 = proc;
                                    val = environment_lookup(env, "env");
                                    argl = cons(val, &LispNull);
                                    LispObject* tmp_604;
                                    tmp_604 = argl;
                                    proc = environment_lookup(env, "let->combination");
                                    val = environment_lookup(env, "exp");
                                    argl = cons(val, &LispNull);
                                    if (proc->type == PRIMITIVE_PROC) {
                                        val = apply(proc, argl);
                                    } else {
                                        proc->CompiledFun();
                                    };
                                    argl = tmp_604;
                                    argl = cons(val, argl);
                                    proc = tmp_608;
                                    if (proc->type == PRIMITIVE_PROC) {
                                        val = apply(proc, argl);
                                    } else {
                                        proc->CompiledFun();
                                    };
                                } else {
                                    Environment* tmp_658;
    tmp_658 = environment_copy(env);
                                    proc = environment_lookup(env, "begin?");
                                    val = environment_lookup(env, "exp");
                                    argl = cons(val, &LispNull);
                                    if (proc->type == PRIMITIVE_PROC) {
                                        val = apply(proc, argl);
                                    } else {
                                        proc->CompiledFun();
                                    };
                                    env = environment_copy(tmp_658);
                                    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
                                        proc = environment_lookup(env, "eval-sequence");
                                        LispObject* tmp_619;
                                        tmp_619 = proc;
                                        val = environment_lookup(env, "env");
                                        argl = cons(val, &LispNull);
                                        LispObject* tmp_615;
                                        tmp_615 = argl;
                                        proc = environment_lookup(env, "begin-actions");
                                        val = environment_lookup(env, "exp");
                                        argl = cons(val, &LispNull);
                                        if (proc->type == PRIMITIVE_PROC) {
                                            val = apply(proc, argl);
                                        } else {
                                            proc->CompiledFun();
                                        };
                                        argl = tmp_615;
                                        argl = cons(val, argl);
                                        proc = tmp_619;
                                        if (proc->type == PRIMITIVE_PROC) {
                                            val = apply(proc, argl);
                                        } else {
                                            proc->CompiledFun();
                                        };
                                    } else {
                                        Environment* tmp_657;
    tmp_657 = environment_copy(env);
                                        proc = environment_lookup(env, "cond?");
                                        val = environment_lookup(env, "exp");
                                        argl = cons(val, &LispNull);
                                        if (proc->type == PRIMITIVE_PROC) {
                                            val = apply(proc, argl);
                                        } else {
                                            proc->CompiledFun();
                                        };
                                        env = environment_copy(tmp_657);
                                        if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
                                            proc = environment_lookup(env, "eval");
                                            LispObject* tmp_630;
                                            tmp_630 = proc;
                                            val = environment_lookup(env, "env");
                                            argl = cons(val, &LispNull);
                                            LispObject* tmp_626;
                                            tmp_626 = argl;
                                            proc = environment_lookup(env, "cond->if");
                                            val = environment_lookup(env, "exp");
                                            argl = cons(val, &LispNull);
                                            if (proc->type == PRIMITIVE_PROC) {
                                                val = apply(proc, argl);
                                            } else {
                                                proc->CompiledFun();
                                            };
                                            argl = tmp_626;
                                            argl = cons(val, argl);
                                            proc = tmp_630;
                                            if (proc->type == PRIMITIVE_PROC) {
                                                val = apply(proc, argl);
                                            } else {
                                                proc->CompiledFun();
                                            };
                                        } else {
                                            Environment* tmp_656;
    tmp_656 = environment_copy(env);
                                            proc = environment_lookup(env, "application?");
                                            val = environment_lookup(env, "exp");
                                            argl = cons(val, &LispNull);
                                            if (proc->type == PRIMITIVE_PROC) {
                                                val = apply(proc, argl);
                                            } else {
                                                proc->CompiledFun();
                                            };
                                            env = environment_copy(tmp_656);
                                            if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
                                                proc = environment_lookup(env, "m-apply");
                                                LispObject* tmp_655;
                                                tmp_655 = proc;
                                                Environment* tmp_651;
    tmp_651 = environment_copy(env);
                                                proc = environment_lookup(env, "list-of-values");
                                                LispObject* tmp_649;
                                                tmp_649 = proc;
                                                val = environment_lookup(env, "env");
                                                argl = cons(val, &LispNull);
                                                LispObject* tmp_645;
                                                tmp_645 = argl;
                                                proc = environment_lookup(env, "operands");
                                                val = environment_lookup(env, "exp");
                                                argl = cons(val, &LispNull);
                                                if (proc->type == PRIMITIVE_PROC) {
                                                    val = apply(proc, argl);
                                                } else {
                                                    proc->CompiledFun();
                                                };
                                                argl = tmp_645;
                                                argl = cons(val, argl);
                                                proc = tmp_649;
                                                if (proc->type == PRIMITIVE_PROC) {
                                                    val = apply(proc, argl);
                                                } else {
                                                    proc->CompiledFun();
                                                };
                                                argl = cons(val, &LispNull);
                                                env = environment_copy(tmp_651);
                                                LispObject* tmp_650;
                                                tmp_650 = argl;
                                                proc = environment_lookup(env, "eval");
                                                LispObject* tmp_641;
                                                tmp_641 = proc;
                                                val = environment_lookup(env, "env");
                                                argl = cons(val, &LispNull);
                                                LispObject* tmp_637;
                                                tmp_637 = argl;
                                                proc = environment_lookup(env, "operator");
                                                val = environment_lookup(env, "exp");
                                                argl = cons(val, &LispNull);
                                                if (proc->type == PRIMITIVE_PROC) {
                                                    val = apply(proc, argl);
                                                } else {
                                                    proc->CompiledFun();
                                                };
                                                argl = tmp_637;
                                                argl = cons(val, argl);
                                                proc = tmp_641;
                                                if (proc->type == PRIMITIVE_PROC) {
                                                    val = apply(proc, argl);
                                                } else {
                                                    proc->CompiledFun();
                                                };
                                                argl = tmp_650;
                                                argl = cons(val, argl);
                                                proc = tmp_655;
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
void entry666(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_678;
    tmp_678 = environment_copy(env);
    proc = environment_lookup(env, "eq?");
    val = create_lisp_atom_from_string("#t");
    argl = cons(val, &LispNull);
    val = environment_lookup(env, "exp");
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_678);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        val = create_lisp_atom_from_string("#t");
    } else {
        Environment* tmp_677;
    tmp_677 = environment_copy(env);
        proc = environment_lookup(env, "eq?");
        val = create_lisp_atom_from_string("#f");
        argl = cons(val, &LispNull);
        val = environment_lookup(env, "exp");
        argl = cons(val, argl);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        env = environment_copy(tmp_677);
        if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
            val = create_lisp_atom_from_string("#t");
        } else {
            Environment* tmp_676;
    tmp_676 = environment_copy(env);
            proc = environment_lookup(env, "number?");
            val = environment_lookup(env, "exp");
            argl = cons(val, &LispNull);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
            env = environment_copy(tmp_676);
            if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
                val = create_lisp_atom_from_string("#t");
            } else {
                val = create_lisp_atom_from_string("#f");
            };
        };
    };
};
void entry679(void) {
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
void entry683(void) {
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
void entry687(void) {
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
void entry691(void) {
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
void entry695(void) {
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
void entry699(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_713;
    tmp_713 = environment_copy(env);
    proc = environment_lookup(env, "symbol?");
    LispObject* tmp_706;
    tmp_706 = proc;
    proc = environment_lookup(env, "cadr");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_706;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_713);
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
void entry714(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_737;
    tmp_737 = environment_copy(env);
    proc = environment_lookup(env, "symbol?");
    LispObject* tmp_721;
    tmp_721 = proc;
    proc = environment_lookup(env, "cadr");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_721;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_737);
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
        LispObject* tmp_736;
        tmp_736 = proc;
        Environment* tmp_732;
    tmp_732 = environment_copy(env);
        proc = environment_lookup(env, "cddr");
        val = environment_lookup(env, "exp");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        env = environment_copy(tmp_732);
        LispObject* tmp_731;
        tmp_731 = argl;
        proc = environment_lookup(env, "cdadr");
        val = environment_lookup(env, "exp");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_731;
        argl = cons(val, argl);
        proc = tmp_736;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    };
};
void entry738(void) {
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
void entry742(void) {
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
void entry746(void) {
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
void entry750(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "parameters", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "body", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "cons");
    LispObject* tmp_757;
    tmp_757 = proc;
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
    proc = tmp_757;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry758(void) {
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
void entry762(void) {
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
void entry766(void) {
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
void entry770(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_785;
    tmp_785 = environment_copy(env);
    proc = environment_lookup(env, "not");
    LispObject* tmp_781;
    tmp_781 = proc;
    proc = environment_lookup(env, "null?");
    LispObject* tmp_777;
    tmp_777 = proc;
    proc = environment_lookup(env, "cdddr");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_777;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_781;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_785);
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
void entry786(void) {
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
void entry790(void) {
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
void entry794(void) {
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
void entry798(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "seq", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "null?");
    LispObject* tmp_805;
    tmp_805 = proc;
    proc = environment_lookup(env, "cdr");
    val = environment_lookup(env, "seq");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_805;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry806(void) {
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
void entry810(void) {
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
void entry814(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "seq", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_828;
    tmp_828 = environment_copy(env);
    proc = environment_lookup(env, "null?");
    val = environment_lookup(env, "seq");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_828);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        val = environment_lookup(env, "seq");
    } else {
        Environment* tmp_827;
    tmp_827 = environment_copy(env);
        proc = environment_lookup(env, "last-exp?");
        val = environment_lookup(env, "seq");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        env = environment_copy(tmp_827);
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
void entry829(void) {
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
void entry833(void) {
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
void entry837(void) {
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
void entry841(void) {
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
void entry845(void) {
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
void entry849(void) {
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
void entry853(void) {
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
void entry857(void) {
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
void entry861(void) {
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
void entry865(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "clause", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "eq?");
    LispObject* tmp_873;
    tmp_873 = proc;
    val = parse_lisp_object_from_string("else");
    argl = cons(val, &LispNull);
    LispObject* tmp_869;
    tmp_869 = argl;
    proc = environment_lookup(env, "cond-predicate");
    val = environment_lookup(env, "clause");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_869;
    argl = cons(val, argl);
    proc = tmp_873;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry874(void) {
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
void entry878(void) {
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
void entry882(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "expand-clauses");
    LispObject* tmp_889;
    tmp_889 = proc;
    proc = environment_lookup(env, "cond-clauses");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_889;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry890(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "clauses", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_943;
    tmp_943 = environment_copy(env);
    proc = environment_lookup(env, "null?");
    val = environment_lookup(env, "clauses");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_943);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        val = create_lisp_atom_from_string("#f");
    } else {
        proc = create_empty_lisp_object(COMPILED_PROCEDURE);
        proc->CompoundFunEnvironment = env;
        proc->CompiledFun = &entry894;
        LispObject* tmp_942;
        tmp_942 = proc;
        Environment* tmp_938;
    tmp_938 = environment_copy(env);
        proc = environment_lookup(env, "cdr");
        val = environment_lookup(env, "clauses");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        env = environment_copy(tmp_938);
        LispObject* tmp_937;
        tmp_937 = argl;
        proc = environment_lookup(env, "car");
        val = environment_lookup(env, "clauses");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_937;
        argl = cons(val, argl);
        proc = tmp_942;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    };
};
void entry894(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "first", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "rest", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_930;
    tmp_930 = environment_copy(env);
    proc = environment_lookup(env, "cond-else-clause?");
    val = environment_lookup(env, "first");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_930);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        Environment* tmp_908;
    tmp_908 = environment_copy(env);
        proc = environment_lookup(env, "null?");
        val = environment_lookup(env, "rest");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        env = environment_copy(tmp_908);
        if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
            proc = environment_lookup(env, "sequence->exp");
            LispObject* tmp_907;
            tmp_907 = proc;
            proc = environment_lookup(env, "cond-actions");
            val = environment_lookup(env, "first");
            argl = cons(val, &LispNull);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
            argl = cons(val, &LispNull);
            proc = tmp_907;
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
        LispObject* tmp_929;
        tmp_929 = proc;
        Environment* tmp_925;
    tmp_925 = environment_copy(env);
        proc = environment_lookup(env, "expand-clauses");
        val = environment_lookup(env, "rest");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        env = environment_copy(tmp_925);
        Environment* tmp_924;
    tmp_924 = environment_copy(env);
        LispObject* tmp_922;
        tmp_922 = argl;
        proc = environment_lookup(env, "sequence->exp");
        LispObject* tmp_918;
        tmp_918 = proc;
        proc = environment_lookup(env, "cond-actions");
        val = environment_lookup(env, "first");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        proc = tmp_918;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_922;
        argl = cons(val, argl);
        env = environment_copy(tmp_924);
        LispObject* tmp_923;
        tmp_923 = argl;
        proc = environment_lookup(env, "cond-predicate");
        val = environment_lookup(env, "first");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_923;
        argl = cons(val, argl);
        proc = tmp_929;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    };
};
void entry944(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exps", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_970;
    tmp_970 = environment_copy(env);
    proc = environment_lookup(env, "no-operands?");
    val = environment_lookup(env, "exps");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_970);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        val = parse_lisp_object_from_string("()");
    } else {
        proc = environment_lookup(env, "cons");
        LispObject* tmp_969;
        tmp_969 = proc;
        Environment* tmp_965;
    tmp_965 = environment_copy(env);
        proc = environment_lookup(env, "list-of-values");
        LispObject* tmp_963;
        tmp_963 = proc;
        val = environment_lookup(env, "env");
        argl = cons(val, &LispNull);
        LispObject* tmp_959;
        tmp_959 = argl;
        proc = environment_lookup(env, "rest-operands");
        val = environment_lookup(env, "exps");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_959;
        argl = cons(val, argl);
        proc = tmp_963;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        env = environment_copy(tmp_965);
        LispObject* tmp_964;
        tmp_964 = argl;
        proc = environment_lookup(env, "eval");
        LispObject* tmp_955;
        tmp_955 = proc;
        val = environment_lookup(env, "env");
        argl = cons(val, &LispNull);
        LispObject* tmp_951;
        tmp_951 = argl;
        proc = environment_lookup(env, "first-operand");
        val = environment_lookup(env, "exps");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_951;
        argl = cons(val, argl);
        proc = tmp_955;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_964;
        argl = cons(val, argl);
        proc = tmp_969;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    };
};
void entry971(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_1000;
    tmp_1000 = environment_copy(env);
    proc = environment_lookup(env, "true?");
    LispObject* tmp_983;
    tmp_983 = proc;
    proc = environment_lookup(env, "eval");
    LispObject* tmp_979;
    tmp_979 = proc;
    val = environment_lookup(env, "env");
    argl = cons(val, &LispNull);
    LispObject* tmp_975;
    tmp_975 = argl;
    proc = environment_lookup(env, "if-predicate");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_975;
    argl = cons(val, argl);
    proc = tmp_979;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_983;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_1000);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        proc = environment_lookup(env, "eval");
        LispObject* tmp_991;
        tmp_991 = proc;
        val = environment_lookup(env, "env");
        argl = cons(val, &LispNull);
        LispObject* tmp_987;
        tmp_987 = argl;
        proc = environment_lookup(env, "if-consequent");
        val = environment_lookup(env, "exp");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_987;
        argl = cons(val, argl);
        proc = tmp_991;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    } else {
        proc = environment_lookup(env, "eval");
        LispObject* tmp_999;
        tmp_999 = proc;
        val = environment_lookup(env, "env");
        argl = cons(val, &LispNull);
        LispObject* tmp_995;
        tmp_995 = argl;
        proc = environment_lookup(env, "if-alternative");
        val = environment_lookup(env, "exp");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_995;
        argl = cons(val, argl);
        proc = tmp_999;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    };
};
void entry1001(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exps", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_1030;
    tmp_1030 = environment_copy(env);
    proc = environment_lookup(env, "last-exp?");
    val = environment_lookup(env, "exps");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_1030);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        proc = environment_lookup(env, "eval");
        LispObject* tmp_1012;
        tmp_1012 = proc;
        val = environment_lookup(env, "env");
        argl = cons(val, &LispNull);
        LispObject* tmp_1008;
        tmp_1008 = argl;
        proc = environment_lookup(env, "first-exp");
        val = environment_lookup(env, "exps");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_1008;
        argl = cons(val, argl);
        proc = tmp_1012;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    } else {
        Environment* tmp_1029;
    tmp_1029 = environment_copy(env);
        proc = environment_lookup(env, "eval");
        LispObject* tmp_1020;
        tmp_1020 = proc;
        val = environment_lookup(env, "env");
        argl = cons(val, &LispNull);
        LispObject* tmp_1016;
        tmp_1016 = argl;
        proc = environment_lookup(env, "first-exp");
        val = environment_lookup(env, "exps");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_1016;
        argl = cons(val, argl);
        proc = tmp_1020;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        env = environment_copy(tmp_1029);
        proc = environment_lookup(env, "eval-sequence");
        LispObject* tmp_1028;
        tmp_1028 = proc;
        val = environment_lookup(env, "env");
        argl = cons(val, &LispNull);
        LispObject* tmp_1024;
        tmp_1024 = argl;
        proc = environment_lookup(env, "rest-exps");
        val = environment_lookup(env, "exps");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_1024;
        argl = cons(val, argl);
        proc = tmp_1028;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    };
};
void entry1031(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "set-variable-value!");
    LispObject* tmp_1049;
    tmp_1049 = proc;
    val = environment_lookup(env, "env");
    argl = cons(val, &LispNull);
    Environment* tmp_1045;
    tmp_1045 = environment_copy(env);
    LispObject* tmp_1043;
    tmp_1043 = argl;
    proc = environment_lookup(env, "eval");
    LispObject* tmp_1042;
    tmp_1042 = proc;
    val = environment_lookup(env, "env");
    argl = cons(val, &LispNull);
    LispObject* tmp_1038;
    tmp_1038 = argl;
    proc = environment_lookup(env, "assignment-value");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_1038;
    argl = cons(val, argl);
    proc = tmp_1042;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_1043;
    argl = cons(val, argl);
    env = environment_copy(tmp_1045);
    LispObject* tmp_1044;
    tmp_1044 = argl;
    proc = environment_lookup(env, "assignment-variable");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_1044;
    argl = cons(val, argl);
    proc = tmp_1049;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    val = parse_lisp_object_from_string("ok");
};
void entry1050(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "define-variable!");
    LispObject* tmp_1068;
    tmp_1068 = proc;
    val = environment_lookup(env, "env");
    argl = cons(val, &LispNull);
    Environment* tmp_1064;
    tmp_1064 = environment_copy(env);
    LispObject* tmp_1062;
    tmp_1062 = argl;
    proc = environment_lookup(env, "eval");
    LispObject* tmp_1061;
    tmp_1061 = proc;
    val = environment_lookup(env, "env");
    argl = cons(val, &LispNull);
    LispObject* tmp_1057;
    tmp_1057 = argl;
    proc = environment_lookup(env, "definition-value");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_1057;
    argl = cons(val, argl);
    proc = tmp_1061;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_1062;
    argl = cons(val, argl);
    env = environment_copy(tmp_1064);
    LispObject* tmp_1063;
    tmp_1063 = argl;
    proc = environment_lookup(env, "definition-variable");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_1063;
    argl = cons(val, argl);
    proc = tmp_1068;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    val = parse_lisp_object_from_string("ok");
};
void entry1069(void) {
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
void entry1073(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "map");
    LispObject* tmp_1081;
    tmp_1081 = proc;
    Environment* tmp_1077;
    tmp_1077 = environment_copy(env);
    proc = environment_lookup(env, "cadr");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_1077);
    val = environment_lookup(env, "car");
    argl = cons(val, argl);
    proc = tmp_1081;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry1082(void) {
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
void entry1086(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "map");
    LispObject* tmp_1094;
    tmp_1094 = proc;
    Environment* tmp_1090;
    tmp_1090 = environment_copy(env);
    proc = environment_lookup(env, "cadr");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_1090);
    val = environment_lookup(env, "cadr");
    argl = cons(val, argl);
    proc = tmp_1094;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry1095(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "cons");
    LispObject* tmp_1116;
    tmp_1116 = proc;
    Environment* tmp_1112;
    tmp_1112 = environment_copy(env);
    proc = environment_lookup(env, "let-expressions");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_1112);
    LispObject* tmp_1111;
    tmp_1111 = argl;
    proc = environment_lookup(env, "make-lambda");
    LispObject* tmp_1107;
    tmp_1107 = proc;
    Environment* tmp_1103;
    tmp_1103 = environment_copy(env);
    proc = environment_lookup(env, "let-body");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_1103);
    LispObject* tmp_1102;
    tmp_1102 = argl;
    proc = environment_lookup(env, "let-variables");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_1102;
    argl = cons(val, argl);
    proc = tmp_1107;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_1111;
    argl = cons(val, argl);
    proc = tmp_1116;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry1117(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "var", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "body", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "append");
    LispObject* tmp_1133;
    tmp_1133 = proc;
    val = environment_lookup(env, "body");
    argl = cons(val, &LispNull);
    LispObject* tmp_1129;
    tmp_1129 = argl;
    proc = environment_lookup(env, "list");
    LispObject* tmp_1128;
    tmp_1128 = proc;
    proc = environment_lookup(env, "list");
    LispObject* tmp_1124;
    tmp_1124 = proc;
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
    proc = tmp_1124;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    val = parse_lisp_object_from_string("let");
    argl = cons(val, argl);
    proc = tmp_1128;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_1129;
    argl = cons(val, argl);
    proc = tmp_1133;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry1134(void) {
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
void entry1138(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "object", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_1155;
    tmp_1155 = environment_copy(env);
    proc = environment_lookup(env, "compound-procedure?");
    val = environment_lookup(env, "object");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_1155);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        proc = environment_lookup(env, "list");
        LispObject* tmp_1154;
        tmp_1154 = proc;
        val = parse_lisp_object_from_string("<procedure-env>");
        argl = cons(val, &LispNull);
        Environment* tmp_1150;
    tmp_1150 = environment_copy(env);
        LispObject* tmp_1148;
        tmp_1148 = argl;
        proc = environment_lookup(env, "procedure-body");
        val = environment_lookup(env, "object");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_1148;
        argl = cons(val, argl);
        env = environment_copy(tmp_1150);
        LispObject* tmp_1149;
        tmp_1149 = argl;
        proc = environment_lookup(env, "procedure-parameters");
        val = environment_lookup(env, "object");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_1149;
        argl = cons(val, argl);
        val = parse_lisp_object_from_string("compound-procedure");
        argl = cons(val, argl);
        proc = tmp_1154;
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
void entry1156(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    Environment* tmp_1183;
    tmp_1183 = environment_copy(env);
    proc = environment_lookup(env, "prompt-for-input");
    val = environment_lookup(env, "input-prompt");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_1183);
    Environment* tmp_1182;
    tmp_1182 = environment_copy(env);
    proc = create_empty_lisp_object(COMPILED_PROCEDURE);
    proc->CompoundFunEnvironment = env;
    proc->CompiledFun = &entry1160;
    val = read_and_parse_input();
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_1182);
    proc = environment_lookup(env, "driver-loop");
    argl = &LispNull;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry1160(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "input", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = create_empty_lisp_object(COMPILED_PROCEDURE);
    proc->CompoundFunEnvironment = env;
    proc->CompiledFun = &entry1161;
    LispObject* tmp_1175;
    tmp_1175 = proc;
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
    proc = tmp_1175;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry1161(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "output", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_1168;
    tmp_1168 = environment_copy(env);
    proc = environment_lookup(env, "announce-output");
    val = environment_lookup(env, "output-prompt");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_1168);
    proc = environment_lookup(env, "user-print");
    val = environment_lookup(env, "output");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry1184(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "string", argl->CarPointer);
    argl = argl->CdrPointer;
    putchar(10);
    putchar(10);
    val = environment_lookup(env, "string");
    print_lisp_object(val);
    putchar(10);
};
void entry1185(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "string", argl->CarPointer);
    argl = argl->CdrPointer;
    putchar(10);
    val = environment_lookup(env, "string");
    print_lisp_object(val);
    putchar(10);
};

/* footer here */
