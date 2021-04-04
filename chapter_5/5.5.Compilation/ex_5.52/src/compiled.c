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
void entry162(void);
void entry166(void);
void entry170(void);
void entry171(void);
void entry182(void);
void entry186(void);
void entry187(void);
void entry196(void);
void entry200(void);
void entry204(void);
void entry208(void);
void entry236(void);
void entry271(void);
void entry275(void);
void entry279(void);
void entry280(void);
void entry281(void);
void entry332(void);
void entry333(void);
void entry363(void);
void entry364(void);
void entry365(void);
void entry404(void);
void entry428(void);
void entry429(void);
void entry430(void);
void entry469(void);
void entry493(void);
void entry497(void);
void entry501(void);
void entry505(void);
void entry509(void);
void entry513(void);
void entry549(void);
void entry661(void);
void entry674(void);
void entry678(void);
void entry682(void);
void entry686(void);
void entry690(void);
void entry694(void);
void entry709(void);
void entry733(void);
void entry737(void);
void entry741(void);
void entry745(void);
void entry753(void);
void entry757(void);
void entry761(void);
void entry765(void);
void entry781(void);
void entry785(void);
void entry789(void);
void entry793(void);
void entry801(void);
void entry805(void);
void entry809(void);
void entry824(void);
void entry828(void);
void entry832(void);
void entry836(void);
void entry840(void);
void entry844(void);
void entry848(void);
void entry852(void);
void entry856(void);
void entry860(void);
void entry869(void);
void entry873(void);
void entry877(void);
void entry885(void);
void entry889(void);
void entry939(void);
void entry966(void);
void entry996(void);
void entry1026(void);
void entry1045(void);
void entry1064(void);
void entry1068(void);
void entry1077(void);
void entry1081(void);
void entry1090(void);
void entry1112(void);
void entry1129(void);
void entry1133(void);
void entry1151(void);
void entry1155(void);
void entry1156(void);
void entry1179(void);
void entry1180(void);

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
    environment_add(env, "tagged-list?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry162;
    environment_add(env, "primitive-procedure?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry166;
    environment_add(env, "primitive-procedure-names", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry170;
    environment_add(env, "primitive-procedure-objects", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry182;
    environment_add(env, "primitive-implementation", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry186;
    environment_add(env, "apply-in-underlying-scheme", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry187;
    environment_add(env, "apply-primitive-procedure", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry196;
    environment_add(env, "make-frame", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry200;
    environment_add(env, "frame-variables", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry204;
    environment_add(env, "frame-values", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry208;
    environment_add(env, "add-binding-to-frame!", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry236;
    environment_add(env, "extend-environment", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry271;
    environment_add(env, "enclosing-environment", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry275;
    environment_add(env, "first-frame", val);
    val = parse_lisp_object_from_string("()");
    environment_add(env, "the-empty-environment", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry279;
    environment_add(env, "define-variable!", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry332;
    environment_add(env, "setup-environment", val);
    Environment* tmp_362;
    tmp_362 = environment_copy(env);
    proc = environment_lookup(env, "setup-environment");
    argl = &LispNull;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_362);
    environment_add(env, "the-global-environment", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry363;
    environment_add(env, "lookup-variable-value", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry428;
    environment_add(env, "set-variable-value!", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry493;
    environment_add(env, "compound-procedure?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry497;
    environment_add(env, "procedure-body", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry501;
    environment_add(env, "procedure-parameters", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry505;
    environment_add(env, "make-procedure", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry509;
    environment_add(env, "procedure-environment", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry513;
    environment_add(env, "m-apply", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry549;
    environment_add(env, "eval", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry661;
    environment_add(env, "self-evaluating?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry674;
    environment_add(env, "variable?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry678;
    environment_add(env, "assignment?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry682;
    environment_add(env, "assignment-variable", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry686;
    environment_add(env, "assignment-value", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry690;
    environment_add(env, "definition?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry694;
    environment_add(env, "definition-variable", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry709;
    environment_add(env, "definition-value", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry733;
    environment_add(env, "lambda?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry737;
    environment_add(env, "lambda-parameters", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry741;
    environment_add(env, "lambda-body", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry745;
    environment_add(env, "make-lambda", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry753;
    environment_add(env, "if?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry757;
    environment_add(env, "if-predicate", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry761;
    environment_add(env, "if-consequent", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry765;
    environment_add(env, "if-alternative", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry781;
    environment_add(env, "make-if", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry785;
    environment_add(env, "begin?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry789;
    environment_add(env, "begin-actions", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry793;
    environment_add(env, "last-exp?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry801;
    environment_add(env, "first-exp", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry805;
    environment_add(env, "rest-exps", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry809;
    environment_add(env, "sequence->exp", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry824;
    environment_add(env, "make-begin", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry828;
    environment_add(env, "application?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry832;
    environment_add(env, "operator", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry836;
    environment_add(env, "operands", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry840;
    environment_add(env, "no-operands?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry844;
    environment_add(env, "first-operand", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry848;
    environment_add(env, "rest-operands", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry852;
    environment_add(env, "cond?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry856;
    environment_add(env, "cond-clauses", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry860;
    environment_add(env, "cond-else-clause?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry869;
    environment_add(env, "cond-predicate", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry873;
    environment_add(env, "cond-actions", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry877;
    environment_add(env, "cond->if", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry885;
    environment_add(env, "expand-clauses", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry939;
    environment_add(env, "list-of-values", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry966;
    environment_add(env, "eval-if", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry996;
    environment_add(env, "eval-sequence", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1026;
    environment_add(env, "eval-assignment", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1045;
    environment_add(env, "eval-definition", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1064;
    environment_add(env, "let?", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1068;
    environment_add(env, "let-variables", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1077;
    environment_add(env, "let-body", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1081;
    environment_add(env, "let-expressions", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1090;
    environment_add(env, "let->combination", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1112;
    environment_add(env, "make-let", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1129;
    environment_add(env, "make-variable-definition", val);
    val = parse_lisp_object_from_string("input:");
    environment_add(env, "input-prompt", val);
    val = parse_lisp_object_from_string("output:");
    environment_add(env, "output-prompt", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1133;
    environment_add(env, "user-print", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1151;
    environment_add(env, "driver-loop", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1179;
    environment_add(env, "prompt-for-input", val);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry1180;
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
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "tag", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_161;
    tmp_161 = environment_copy(env);
    proc = environment_lookup(env, "pair?");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_161);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        proc = environment_lookup(env, "eq?");
        LispObject* tmp_160;
        tmp_160 = proc;
        val = environment_lookup(env, "tag");
        argl = cons(val, &LispNull);
        LispObject* tmp_156;
        tmp_156 = argl;
        proc = environment_lookup(env, "car");
        val = environment_lookup(env, "exp");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_156;
        argl = cons(val, argl);
        proc = tmp_160;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    } else {
        val = create_lisp_atom_from_string("#f");
    };
};
void entry162(void) {
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
void entry166(void) {
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
void entry170(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    proc = environment_lookup(env, "map");
    val = environment_lookup(env, "primitive-procedures");
    argl = cons(val, &LispNull);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry171;
    argl = cons(val, argl);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry171(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "proc", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "list");
    LispObject* tmp_178;
    tmp_178 = proc;
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
    proc = tmp_178;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry182(void) {
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
void entry186(void) {
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
void entry187(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "proc", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "args", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "apply-in-underlying-scheme");
    LispObject* tmp_195;
    tmp_195 = proc;
    val = environment_lookup(env, "args");
    argl = cons(val, &LispNull);
    LispObject* tmp_191;
    tmp_191 = argl;
    proc = environment_lookup(env, "primitive-implementation");
    val = environment_lookup(env, "proc");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_191;
    argl = cons(val, argl);
    proc = tmp_195;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry196(void) {
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
void entry200(void) {
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
void entry204(void) {
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
void entry208(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "var", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "val", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "frame", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_235;
    tmp_235 = environment_copy(env);
    proc = environment_lookup(env, "set-car!");
    LispObject* tmp_221;
    tmp_221 = proc;
    Environment* tmp_217;
    tmp_217 = environment_copy(env);
    proc = environment_lookup(env, "cons");
    LispObject* tmp_216;
    tmp_216 = proc;
    Environment* tmp_212;
    tmp_212 = environment_copy(env);
    proc = environment_lookup(env, "car");
    val = environment_lookup(env, "frame");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_212);
    val = environment_lookup(env, "var");
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
    env = environment_copy(tmp_235);
    proc = environment_lookup(env, "set-cdr!");
    LispObject* tmp_234;
    tmp_234 = proc;
    Environment* tmp_230;
    tmp_230 = environment_copy(env);
    proc = environment_lookup(env, "cons");
    LispObject* tmp_229;
    tmp_229 = proc;
    Environment* tmp_225;
    tmp_225 = environment_copy(env);
    proc = environment_lookup(env, "cdr");
    val = environment_lookup(env, "frame");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_225);
    val = environment_lookup(env, "val");
    argl = cons(val, argl);
    proc = tmp_229;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_230);
    val = environment_lookup(env, "frame");
    argl = cons(val, argl);
    proc = tmp_234;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry236(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "vars", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "vals", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "base-env", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_270;
    tmp_270 = environment_copy(env);
    proc = environment_lookup(env, "=");
    LispObject* tmp_248;
    tmp_248 = proc;
    Environment* tmp_244;
    tmp_244 = environment_copy(env);
    proc = environment_lookup(env, "length");
    val = environment_lookup(env, "vals");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_244);
    LispObject* tmp_243;
    tmp_243 = argl;
    proc = environment_lookup(env, "length");
    val = environment_lookup(env, "vars");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_243;
    argl = cons(val, argl);
    proc = tmp_248;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_270);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        proc = environment_lookup(env, "cons");
        LispObject* tmp_256;
        tmp_256 = proc;
        val = environment_lookup(env, "base-env");
        argl = cons(val, &LispNull);
        LispObject* tmp_252;
        tmp_252 = argl;
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
        argl = tmp_252;
        argl = cons(val, argl);
        proc = tmp_256;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    } else {
        Environment* tmp_269;
    tmp_269 = environment_copy(env);
        proc = environment_lookup(env, "<");
        LispObject* tmp_268;
        tmp_268 = proc;
        Environment* tmp_264;
    tmp_264 = environment_copy(env);
        proc = environment_lookup(env, "length");
        val = environment_lookup(env, "vals");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        env = environment_copy(tmp_264);
        LispObject* tmp_263;
        tmp_263 = argl;
        proc = environment_lookup(env, "length");
        val = environment_lookup(env, "vars");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_263;
        argl = cons(val, argl);
        proc = tmp_268;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        env = environment_copy(tmp_269);
        if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
            printf("Error: Too many arguments supplied\n");
        } else {
            printf("Error: Too few arguments supplied\n");
        };
    };
};
void entry271(void) {
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
void entry275(void) {
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
void entry279(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "var", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "val", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = create_empty_lisp_object(COMPILED_PROCEDURE);
    proc->CompoundFunEnvironment = env;
    proc->CompiledFun = &entry280;
    LispObject* tmp_331;
    tmp_331 = proc;
    proc = environment_lookup(env, "first-frame");
    val = environment_lookup(env, "env");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_331;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry280(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "frame", argl->CarPointer);
    argl = argl->CdrPointer;
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry281;
    environment_add(env, "scan", val);
    proc = environment_lookup(env, "scan");
    LispObject* tmp_324;
    tmp_324 = proc;
    Environment* tmp_320;
    tmp_320 = environment_copy(env);
    proc = environment_lookup(env, "frame-values");
    val = environment_lookup(env, "frame");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_320);
    LispObject* tmp_319;
    tmp_319 = argl;
    proc = environment_lookup(env, "frame-variables");
    val = environment_lookup(env, "frame");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_319;
    argl = cons(val, argl);
    proc = tmp_324;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry281(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "vars", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "vals", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_312;
    tmp_312 = environment_copy(env);
    proc = environment_lookup(env, "null?");
    val = environment_lookup(env, "vars");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_312);
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
        Environment* tmp_311;
    tmp_311 = environment_copy(env);
        proc = environment_lookup(env, "eq?");
        LispObject* tmp_295;
        tmp_295 = proc;
        Environment* tmp_291;
    tmp_291 = environment_copy(env);
        proc = environment_lookup(env, "car");
        val = environment_lookup(env, "vars");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        env = environment_copy(tmp_291);
        val = environment_lookup(env, "var");
        argl = cons(val, argl);
        proc = tmp_295;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        env = environment_copy(tmp_311);
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
            LispObject* tmp_310;
            tmp_310 = proc;
            Environment* tmp_306;
    tmp_306 = environment_copy(env);
            proc = environment_lookup(env, "cdr");
            val = environment_lookup(env, "vals");
            argl = cons(val, &LispNull);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
            argl = cons(val, &LispNull);
            env = environment_copy(tmp_306);
            LispObject* tmp_305;
            tmp_305 = argl;
            proc = environment_lookup(env, "cdr");
            val = environment_lookup(env, "vars");
            argl = cons(val, &LispNull);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
            argl = tmp_305;
            argl = cons(val, argl);
            proc = tmp_310;
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
        };
    };
};
void entry332(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    proc = create_empty_lisp_object(COMPILED_PROCEDURE);
    proc->CompoundFunEnvironment = env;
    proc->CompiledFun = &entry333;
    LispObject* tmp_358;
    tmp_358 = proc;
    proc = environment_lookup(env, "extend-environment");
    LispObject* tmp_354;
    tmp_354 = proc;
    val = environment_lookup(env, "the-empty-environment");
    argl = cons(val, &LispNull);
    Environment* tmp_350;
    tmp_350 = environment_copy(env);
    LispObject* tmp_348;
    tmp_348 = argl;
    proc = environment_lookup(env, "primitive-procedure-objects");
    argl = &LispNull;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_348;
    argl = cons(val, argl);
    env = environment_copy(tmp_350);
    LispObject* tmp_349;
    tmp_349 = argl;
    proc = environment_lookup(env, "primitive-procedure-names");
    argl = &LispNull;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_349;
    argl = cons(val, argl);
    proc = tmp_354;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_358;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry333(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "initial-env", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_341;
    tmp_341 = environment_copy(env);
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
    env = environment_copy(tmp_341);
    Environment* tmp_340;
    tmp_340 = environment_copy(env);
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
    env = environment_copy(tmp_340);
    val = environment_lookup(env, "initial-env");
};
void entry363(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "var", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    val = parse_lisp_object_from_string("looking-up");
    print_lisp_object(val);
    val = environment_lookup(env, "var");
    print_lisp_object(val);
    putchar(10);
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry364;
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
void entry364(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry365;
    environment_add(env, "scan", val);
    Environment* tmp_424;
    tmp_424 = environment_copy(env);
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
    env = environment_copy(tmp_424);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        printf("Error: Unbound variable\n");
    } else {
        proc = create_empty_lisp_object(COMPILED_PROCEDURE);
        proc->CompoundFunEnvironment = env;
        proc->CompiledFun = &entry404;
        LispObject* tmp_423;
        tmp_423 = proc;
        proc = environment_lookup(env, "first-frame");
        val = environment_lookup(env, "env");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        proc = tmp_423;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    };
};
void entry365(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "vars", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "vals", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_400;
    tmp_400 = environment_copy(env);
    proc = environment_lookup(env, "null?");
    val = environment_lookup(env, "vars");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_400);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        proc = environment_lookup(env, "env-loop");
        LispObject* tmp_375;
        tmp_375 = proc;
        proc = environment_lookup(env, "enclosing-environment");
        val = environment_lookup(env, "env");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        proc = tmp_375;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    } else {
        Environment* tmp_399;
    tmp_399 = environment_copy(env);
        proc = environment_lookup(env, "eq?");
        LispObject* tmp_383;
        tmp_383 = proc;
        Environment* tmp_379;
    tmp_379 = environment_copy(env);
        proc = environment_lookup(env, "car");
        val = environment_lookup(env, "vars");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        env = environment_copy(tmp_379);
        val = environment_lookup(env, "var");
        argl = cons(val, argl);
        proc = tmp_383;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        env = environment_copy(tmp_399);
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
            LispObject* tmp_398;
            tmp_398 = proc;
            Environment* tmp_394;
    tmp_394 = environment_copy(env);
            proc = environment_lookup(env, "cdr");
            val = environment_lookup(env, "vals");
            argl = cons(val, &LispNull);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
            argl = cons(val, &LispNull);
            env = environment_copy(tmp_394);
            LispObject* tmp_393;
            tmp_393 = argl;
            proc = environment_lookup(env, "cdr");
            val = environment_lookup(env, "vars");
            argl = cons(val, &LispNull);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
            argl = tmp_393;
            argl = cons(val, argl);
            proc = tmp_398;
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
        };
    };
};
void entry404(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "frame", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "scan");
    LispObject* tmp_416;
    tmp_416 = proc;
    Environment* tmp_412;
    tmp_412 = environment_copy(env);
    proc = environment_lookup(env, "frame-values");
    val = environment_lookup(env, "frame");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_412);
    LispObject* tmp_411;
    tmp_411 = argl;
    proc = environment_lookup(env, "frame-variables");
    val = environment_lookup(env, "frame");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_411;
    argl = cons(val, argl);
    proc = tmp_416;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry428(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "var", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "val", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry429;
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
void entry429(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    val = create_empty_lisp_object(COMPILED_PROCEDURE);
    val->CompoundFunEnvironment = env;
    val->CompiledFun = &entry430;
    environment_add(env, "scan", val);
    Environment* tmp_489;
    tmp_489 = environment_copy(env);
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
    env = environment_copy(tmp_489);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        printf("Error: Unbound variable: SET!\n");
    } else {
        proc = create_empty_lisp_object(COMPILED_PROCEDURE);
        proc->CompoundFunEnvironment = env;
        proc->CompiledFun = &entry469;
        LispObject* tmp_488;
        tmp_488 = proc;
        proc = environment_lookup(env, "first-frame");
        val = environment_lookup(env, "env");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        proc = tmp_488;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    };
};
void entry430(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "vars", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "vals", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_465;
    tmp_465 = environment_copy(env);
    proc = environment_lookup(env, "null?");
    val = environment_lookup(env, "vars");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_465);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        proc = environment_lookup(env, "env-loop");
        LispObject* tmp_440;
        tmp_440 = proc;
        proc = environment_lookup(env, "enclosing-environment");
        val = environment_lookup(env, "env");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        proc = tmp_440;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    } else {
        Environment* tmp_464;
    tmp_464 = environment_copy(env);
        proc = environment_lookup(env, "eq?");
        LispObject* tmp_448;
        tmp_448 = proc;
        Environment* tmp_444;
    tmp_444 = environment_copy(env);
        proc = environment_lookup(env, "car");
        val = environment_lookup(env, "vars");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        env = environment_copy(tmp_444);
        val = environment_lookup(env, "var");
        argl = cons(val, argl);
        proc = tmp_448;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        env = environment_copy(tmp_464);
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
            LispObject* tmp_463;
            tmp_463 = proc;
            Environment* tmp_459;
    tmp_459 = environment_copy(env);
            proc = environment_lookup(env, "cdr");
            val = environment_lookup(env, "vals");
            argl = cons(val, &LispNull);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
            argl = cons(val, &LispNull);
            env = environment_copy(tmp_459);
            LispObject* tmp_458;
            tmp_458 = argl;
            proc = environment_lookup(env, "cdr");
            val = environment_lookup(env, "vars");
            argl = cons(val, &LispNull);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
            argl = tmp_458;
            argl = cons(val, argl);
            proc = tmp_463;
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
        };
    };
};
void entry469(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "frame", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "scan");
    LispObject* tmp_481;
    tmp_481 = proc;
    Environment* tmp_477;
    tmp_477 = environment_copy(env);
    proc = environment_lookup(env, "frame-values");
    val = environment_lookup(env, "frame");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_477);
    LispObject* tmp_476;
    tmp_476 = argl;
    proc = environment_lookup(env, "frame-variables");
    val = environment_lookup(env, "frame");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_476;
    argl = cons(val, argl);
    proc = tmp_481;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry493(void) {
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
void entry497(void) {
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
void entry501(void) {
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
void entry505(void) {
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
void entry509(void) {
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
void entry513(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "procedure", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "arguments", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_548;
    tmp_548 = environment_copy(env);
    proc = environment_lookup(env, "primitive-procedure?");
    val = environment_lookup(env, "procedure");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_548);
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
        Environment* tmp_547;
    tmp_547 = environment_copy(env);
        proc = environment_lookup(env, "compound-procedure?");
        val = environment_lookup(env, "procedure");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        env = environment_copy(tmp_547);
        if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
            proc = environment_lookup(env, "eval-sequence");
            LispObject* tmp_543;
            tmp_543 = proc;
            Environment* tmp_539;
    tmp_539 = environment_copy(env);
            proc = environment_lookup(env, "extend-environment");
            LispObject* tmp_537;
            tmp_537 = proc;
            Environment* tmp_533;
    tmp_533 = environment_copy(env);
            proc = environment_lookup(env, "procedure-environment");
            val = environment_lookup(env, "procedure");
            argl = cons(val, &LispNull);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
            argl = cons(val, &LispNull);
            env = environment_copy(tmp_533);
            val = environment_lookup(env, "arguments");
            argl = cons(val, argl);
            LispObject* tmp_532;
            tmp_532 = argl;
            proc = environment_lookup(env, "procedure-parameters");
            val = environment_lookup(env, "procedure");
            argl = cons(val, &LispNull);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
            argl = tmp_532;
            argl = cons(val, argl);
            proc = tmp_537;
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
            argl = cons(val, &LispNull);
            env = environment_copy(tmp_539);
            LispObject* tmp_538;
            tmp_538 = argl;
            proc = environment_lookup(env, "procedure-body");
            val = environment_lookup(env, "procedure");
            argl = cons(val, &LispNull);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
            argl = tmp_538;
            argl = cons(val, argl);
            proc = tmp_543;
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
void entry549(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_660;
    tmp_660 = environment_copy(env);
    proc = environment_lookup(env, "self-evaluating?");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_660);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        val = environment_lookup(env, "exp");
    } else {
        Environment* tmp_659;
    tmp_659 = environment_copy(env);
        proc = environment_lookup(env, "variable?");
        val = environment_lookup(env, "exp");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        env = environment_copy(tmp_659);
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
                Environment* tmp_658;
    tmp_658 = environment_copy(env);
                proc = environment_lookup(env, "assignment?");
                val = environment_lookup(env, "exp");
                argl = cons(val, &LispNull);
                if (proc->type == PRIMITIVE_PROC) {
                    val = apply(proc, argl);
                } else {
                    proc->CompiledFun();
                };
                env = environment_copy(tmp_658);
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
                    Environment* tmp_657;
    tmp_657 = environment_copy(env);
                    proc = environment_lookup(env, "definition?");
                    val = environment_lookup(env, "exp");
                    argl = cons(val, &LispNull);
                    if (proc->type == PRIMITIVE_PROC) {
                        val = apply(proc, argl);
                    } else {
                        proc->CompiledFun();
                    };
                    env = environment_copy(tmp_657);
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
                        Environment* tmp_656;
    tmp_656 = environment_copy(env);
                        proc = environment_lookup(env, "if?");
                        val = environment_lookup(env, "exp");
                        argl = cons(val, &LispNull);
                        if (proc->type == PRIMITIVE_PROC) {
                            val = apply(proc, argl);
                        } else {
                            proc->CompiledFun();
                        };
                        env = environment_copy(tmp_656);
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
                            Environment* tmp_655;
    tmp_655 = environment_copy(env);
                            proc = environment_lookup(env, "lambda?");
                            val = environment_lookup(env, "exp");
                            argl = cons(val, &LispNull);
                            if (proc->type == PRIMITIVE_PROC) {
                                val = apply(proc, argl);
                            } else {
                                proc->CompiledFun();
                            };
                            env = environment_copy(tmp_655);
                            if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
                                proc = environment_lookup(env, "make-procedure");
                                LispObject* tmp_592;
                                tmp_592 = proc;
                                val = environment_lookup(env, "env");
                                argl = cons(val, &LispNull);
                                Environment* tmp_588;
    tmp_588 = environment_copy(env);
                                LispObject* tmp_586;
                                tmp_586 = argl;
                                proc = environment_lookup(env, "lambda-body");
                                val = environment_lookup(env, "exp");
                                argl = cons(val, &LispNull);
                                if (proc->type == PRIMITIVE_PROC) {
                                    val = apply(proc, argl);
                                } else {
                                    proc->CompiledFun();
                                };
                                argl = tmp_586;
                                argl = cons(val, argl);
                                env = environment_copy(tmp_588);
                                LispObject* tmp_587;
                                tmp_587 = argl;
                                proc = environment_lookup(env, "lambda-parameters");
                                val = environment_lookup(env, "exp");
                                argl = cons(val, &LispNull);
                                if (proc->type == PRIMITIVE_PROC) {
                                    val = apply(proc, argl);
                                } else {
                                    proc->CompiledFun();
                                };
                                argl = tmp_587;
                                argl = cons(val, argl);
                                proc = tmp_592;
                                if (proc->type == PRIMITIVE_PROC) {
                                    val = apply(proc, argl);
                                } else {
                                    proc->CompiledFun();
                                };
                            } else {
                                Environment* tmp_654;
    tmp_654 = environment_copy(env);
                                proc = environment_lookup(env, "let?");
                                val = environment_lookup(env, "exp");
                                argl = cons(val, &LispNull);
                                if (proc->type == PRIMITIVE_PROC) {
                                    val = apply(proc, argl);
                                } else {
                                    proc->CompiledFun();
                                };
                                env = environment_copy(tmp_654);
                                if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
                                    proc = environment_lookup(env, "eval");
                                    LispObject* tmp_603;
                                    tmp_603 = proc;
                                    val = environment_lookup(env, "env");
                                    argl = cons(val, &LispNull);
                                    LispObject* tmp_599;
                                    tmp_599 = argl;
                                    proc = environment_lookup(env, "let->combination");
                                    val = environment_lookup(env, "exp");
                                    argl = cons(val, &LispNull);
                                    if (proc->type == PRIMITIVE_PROC) {
                                        val = apply(proc, argl);
                                    } else {
                                        proc->CompiledFun();
                                    };
                                    argl = tmp_599;
                                    argl = cons(val, argl);
                                    proc = tmp_603;
                                    if (proc->type == PRIMITIVE_PROC) {
                                        val = apply(proc, argl);
                                    } else {
                                        proc->CompiledFun();
                                    };
                                } else {
                                    Environment* tmp_653;
    tmp_653 = environment_copy(env);
                                    proc = environment_lookup(env, "begin?");
                                    val = environment_lookup(env, "exp");
                                    argl = cons(val, &LispNull);
                                    if (proc->type == PRIMITIVE_PROC) {
                                        val = apply(proc, argl);
                                    } else {
                                        proc->CompiledFun();
                                    };
                                    env = environment_copy(tmp_653);
                                    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
                                        proc = environment_lookup(env, "eval-sequence");
                                        LispObject* tmp_614;
                                        tmp_614 = proc;
                                        val = environment_lookup(env, "env");
                                        argl = cons(val, &LispNull);
                                        LispObject* tmp_610;
                                        tmp_610 = argl;
                                        proc = environment_lookup(env, "begin-actions");
                                        val = environment_lookup(env, "exp");
                                        argl = cons(val, &LispNull);
                                        if (proc->type == PRIMITIVE_PROC) {
                                            val = apply(proc, argl);
                                        } else {
                                            proc->CompiledFun();
                                        };
                                        argl = tmp_610;
                                        argl = cons(val, argl);
                                        proc = tmp_614;
                                        if (proc->type == PRIMITIVE_PROC) {
                                            val = apply(proc, argl);
                                        } else {
                                            proc->CompiledFun();
                                        };
                                    } else {
                                        Environment* tmp_652;
    tmp_652 = environment_copy(env);
                                        proc = environment_lookup(env, "cond?");
                                        val = environment_lookup(env, "exp");
                                        argl = cons(val, &LispNull);
                                        if (proc->type == PRIMITIVE_PROC) {
                                            val = apply(proc, argl);
                                        } else {
                                            proc->CompiledFun();
                                        };
                                        env = environment_copy(tmp_652);
                                        if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
                                            proc = environment_lookup(env, "eval");
                                            LispObject* tmp_625;
                                            tmp_625 = proc;
                                            val = environment_lookup(env, "env");
                                            argl = cons(val, &LispNull);
                                            LispObject* tmp_621;
                                            tmp_621 = argl;
                                            proc = environment_lookup(env, "cond->if");
                                            val = environment_lookup(env, "exp");
                                            argl = cons(val, &LispNull);
                                            if (proc->type == PRIMITIVE_PROC) {
                                                val = apply(proc, argl);
                                            } else {
                                                proc->CompiledFun();
                                            };
                                            argl = tmp_621;
                                            argl = cons(val, argl);
                                            proc = tmp_625;
                                            if (proc->type == PRIMITIVE_PROC) {
                                                val = apply(proc, argl);
                                            } else {
                                                proc->CompiledFun();
                                            };
                                        } else {
                                            Environment* tmp_651;
    tmp_651 = environment_copy(env);
                                            proc = environment_lookup(env, "application?");
                                            val = environment_lookup(env, "exp");
                                            argl = cons(val, &LispNull);
                                            if (proc->type == PRIMITIVE_PROC) {
                                                val = apply(proc, argl);
                                            } else {
                                                proc->CompiledFun();
                                            };
                                            env = environment_copy(tmp_651);
                                            if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
                                                proc = environment_lookup(env, "m-apply");
                                                LispObject* tmp_650;
                                                tmp_650 = proc;
                                                Environment* tmp_646;
    tmp_646 = environment_copy(env);
                                                proc = environment_lookup(env, "list-of-values");
                                                LispObject* tmp_644;
                                                tmp_644 = proc;
                                                val = environment_lookup(env, "env");
                                                argl = cons(val, &LispNull);
                                                LispObject* tmp_640;
                                                tmp_640 = argl;
                                                proc = environment_lookup(env, "operands");
                                                val = environment_lookup(env, "exp");
                                                argl = cons(val, &LispNull);
                                                if (proc->type == PRIMITIVE_PROC) {
                                                    val = apply(proc, argl);
                                                } else {
                                                    proc->CompiledFun();
                                                };
                                                argl = tmp_640;
                                                argl = cons(val, argl);
                                                proc = tmp_644;
                                                if (proc->type == PRIMITIVE_PROC) {
                                                    val = apply(proc, argl);
                                                } else {
                                                    proc->CompiledFun();
                                                };
                                                argl = cons(val, &LispNull);
                                                env = environment_copy(tmp_646);
                                                LispObject* tmp_645;
                                                tmp_645 = argl;
                                                proc = environment_lookup(env, "eval");
                                                LispObject* tmp_636;
                                                tmp_636 = proc;
                                                val = environment_lookup(env, "env");
                                                argl = cons(val, &LispNull);
                                                LispObject* tmp_632;
                                                tmp_632 = argl;
                                                proc = environment_lookup(env, "operator");
                                                val = environment_lookup(env, "exp");
                                                argl = cons(val, &LispNull);
                                                if (proc->type == PRIMITIVE_PROC) {
                                                    val = apply(proc, argl);
                                                } else {
                                                    proc->CompiledFun();
                                                };
                                                argl = tmp_632;
                                                argl = cons(val, argl);
                                                proc = tmp_636;
                                                if (proc->type == PRIMITIVE_PROC) {
                                                    val = apply(proc, argl);
                                                } else {
                                                    proc->CompiledFun();
                                                };
                                                argl = tmp_645;
                                                argl = cons(val, argl);
                                                proc = tmp_650;
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
void entry661(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_673;
    tmp_673 = environment_copy(env);
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
    env = environment_copy(tmp_673);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        val = create_lisp_atom_from_string("#t");
    } else {
        Environment* tmp_672;
    tmp_672 = environment_copy(env);
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
        env = environment_copy(tmp_672);
        if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
            val = create_lisp_atom_from_string("#t");
        } else {
            Environment* tmp_671;
    tmp_671 = environment_copy(env);
            proc = environment_lookup(env, "number?");
            val = environment_lookup(env, "exp");
            argl = cons(val, &LispNull);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
            env = environment_copy(tmp_671);
            if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
                val = create_lisp_atom_from_string("#t");
            } else {
                val = create_lisp_atom_from_string("#f");
            };
        };
    };
};
void entry674(void) {
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
void entry678(void) {
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
void entry682(void) {
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
void entry686(void) {
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
void entry690(void) {
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
void entry694(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_708;
    tmp_708 = environment_copy(env);
    proc = environment_lookup(env, "symbol?");
    LispObject* tmp_701;
    tmp_701 = proc;
    proc = environment_lookup(env, "cadr");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_701;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_708);
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
void entry709(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_732;
    tmp_732 = environment_copy(env);
    proc = environment_lookup(env, "symbol?");
    LispObject* tmp_716;
    tmp_716 = proc;
    proc = environment_lookup(env, "cadr");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_716;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_732);
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
        LispObject* tmp_731;
        tmp_731 = proc;
        Environment* tmp_727;
    tmp_727 = environment_copy(env);
        proc = environment_lookup(env, "cddr");
        val = environment_lookup(env, "exp");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        env = environment_copy(tmp_727);
        LispObject* tmp_726;
        tmp_726 = argl;
        proc = environment_lookup(env, "cdadr");
        val = environment_lookup(env, "exp");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_726;
        argl = cons(val, argl);
        proc = tmp_731;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    };
};
void entry733(void) {
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
void entry737(void) {
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
void entry741(void) {
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
void entry745(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "parameters", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "body", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "cons");
    LispObject* tmp_752;
    tmp_752 = proc;
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
    proc = tmp_752;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry753(void) {
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
void entry757(void) {
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
void entry761(void) {
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
void entry765(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_780;
    tmp_780 = environment_copy(env);
    proc = environment_lookup(env, "not");
    LispObject* tmp_776;
    tmp_776 = proc;
    proc = environment_lookup(env, "null?");
    LispObject* tmp_772;
    tmp_772 = proc;
    proc = environment_lookup(env, "cdddr");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_772;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_776;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_780);
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
void entry781(void) {
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
void entry785(void) {
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
void entry789(void) {
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
void entry793(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "seq", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "null?");
    LispObject* tmp_800;
    tmp_800 = proc;
    proc = environment_lookup(env, "cdr");
    val = environment_lookup(env, "seq");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_800;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry801(void) {
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
void entry805(void) {
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
void entry809(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "seq", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_823;
    tmp_823 = environment_copy(env);
    proc = environment_lookup(env, "null?");
    val = environment_lookup(env, "seq");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_823);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        val = environment_lookup(env, "seq");
    } else {
        Environment* tmp_822;
    tmp_822 = environment_copy(env);
        proc = environment_lookup(env, "last-exp?");
        val = environment_lookup(env, "seq");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        env = environment_copy(tmp_822);
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
void entry824(void) {
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
void entry828(void) {
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
void entry832(void) {
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
void entry836(void) {
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
void entry840(void) {
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
void entry844(void) {
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
void entry848(void) {
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
void entry852(void) {
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
void entry856(void) {
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
void entry860(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "clause", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "eq?");
    LispObject* tmp_868;
    tmp_868 = proc;
    val = parse_lisp_object_from_string("else");
    argl = cons(val, &LispNull);
    LispObject* tmp_864;
    tmp_864 = argl;
    proc = environment_lookup(env, "cond-predicate");
    val = environment_lookup(env, "clause");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_864;
    argl = cons(val, argl);
    proc = tmp_868;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry869(void) {
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
void entry873(void) {
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
void entry877(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "expand-clauses");
    LispObject* tmp_884;
    tmp_884 = proc;
    proc = environment_lookup(env, "cond-clauses");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_884;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry885(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "clauses", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_938;
    tmp_938 = environment_copy(env);
    proc = environment_lookup(env, "null?");
    val = environment_lookup(env, "clauses");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_938);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        val = create_lisp_atom_from_string("#f");
    } else {
        proc = create_empty_lisp_object(COMPILED_PROCEDURE);
        proc->CompoundFunEnvironment = env;
        proc->CompiledFun = &entry889;
        LispObject* tmp_937;
        tmp_937 = proc;
        Environment* tmp_933;
    tmp_933 = environment_copy(env);
        proc = environment_lookup(env, "cdr");
        val = environment_lookup(env, "clauses");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        env = environment_copy(tmp_933);
        LispObject* tmp_932;
        tmp_932 = argl;
        proc = environment_lookup(env, "car");
        val = environment_lookup(env, "clauses");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_932;
        argl = cons(val, argl);
        proc = tmp_937;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    };
};
void entry889(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "first", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "rest", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_925;
    tmp_925 = environment_copy(env);
    proc = environment_lookup(env, "cond-else-clause?");
    val = environment_lookup(env, "first");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_925);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        Environment* tmp_903;
    tmp_903 = environment_copy(env);
        proc = environment_lookup(env, "null?");
        val = environment_lookup(env, "rest");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        env = environment_copy(tmp_903);
        if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
            proc = environment_lookup(env, "sequence->exp");
            LispObject* tmp_902;
            tmp_902 = proc;
            proc = environment_lookup(env, "cond-actions");
            val = environment_lookup(env, "first");
            argl = cons(val, &LispNull);
            if (proc->type == PRIMITIVE_PROC) {
                val = apply(proc, argl);
            } else {
                proc->CompiledFun();
            };
            argl = cons(val, &LispNull);
            proc = tmp_902;
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
        LispObject* tmp_924;
        tmp_924 = proc;
        Environment* tmp_920;
    tmp_920 = environment_copy(env);
        proc = environment_lookup(env, "expand-clauses");
        val = environment_lookup(env, "rest");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        env = environment_copy(tmp_920);
        Environment* tmp_919;
    tmp_919 = environment_copy(env);
        LispObject* tmp_917;
        tmp_917 = argl;
        proc = environment_lookup(env, "sequence->exp");
        LispObject* tmp_913;
        tmp_913 = proc;
        proc = environment_lookup(env, "cond-actions");
        val = environment_lookup(env, "first");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        proc = tmp_913;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_917;
        argl = cons(val, argl);
        env = environment_copy(tmp_919);
        LispObject* tmp_918;
        tmp_918 = argl;
        proc = environment_lookup(env, "cond-predicate");
        val = environment_lookup(env, "first");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_918;
        argl = cons(val, argl);
        proc = tmp_924;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    };
};
void entry939(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exps", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_965;
    tmp_965 = environment_copy(env);
    proc = environment_lookup(env, "no-operands?");
    val = environment_lookup(env, "exps");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_965);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        val = parse_lisp_object_from_string("()");
    } else {
        proc = environment_lookup(env, "cons");
        LispObject* tmp_964;
        tmp_964 = proc;
        Environment* tmp_960;
    tmp_960 = environment_copy(env);
        proc = environment_lookup(env, "list-of-values");
        LispObject* tmp_958;
        tmp_958 = proc;
        val = environment_lookup(env, "env");
        argl = cons(val, &LispNull);
        LispObject* tmp_954;
        tmp_954 = argl;
        proc = environment_lookup(env, "rest-operands");
        val = environment_lookup(env, "exps");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_954;
        argl = cons(val, argl);
        proc = tmp_958;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = cons(val, &LispNull);
        env = environment_copy(tmp_960);
        LispObject* tmp_959;
        tmp_959 = argl;
        proc = environment_lookup(env, "eval");
        LispObject* tmp_950;
        tmp_950 = proc;
        val = environment_lookup(env, "env");
        argl = cons(val, &LispNull);
        LispObject* tmp_946;
        tmp_946 = argl;
        proc = environment_lookup(env, "first-operand");
        val = environment_lookup(env, "exps");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_946;
        argl = cons(val, argl);
        proc = tmp_950;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_959;
        argl = cons(val, argl);
        proc = tmp_964;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    };
};
void entry966(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_995;
    tmp_995 = environment_copy(env);
    proc = environment_lookup(env, "true?");
    LispObject* tmp_978;
    tmp_978 = proc;
    proc = environment_lookup(env, "eval");
    LispObject* tmp_974;
    tmp_974 = proc;
    val = environment_lookup(env, "env");
    argl = cons(val, &LispNull);
    LispObject* tmp_970;
    tmp_970 = argl;
    proc = environment_lookup(env, "if-predicate");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_970;
    argl = cons(val, argl);
    proc = tmp_974;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    proc = tmp_978;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_995);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        proc = environment_lookup(env, "eval");
        LispObject* tmp_986;
        tmp_986 = proc;
        val = environment_lookup(env, "env");
        argl = cons(val, &LispNull);
        LispObject* tmp_982;
        tmp_982 = argl;
        proc = environment_lookup(env, "if-consequent");
        val = environment_lookup(env, "exp");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_982;
        argl = cons(val, argl);
        proc = tmp_986;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    } else {
        proc = environment_lookup(env, "eval");
        LispObject* tmp_994;
        tmp_994 = proc;
        val = environment_lookup(env, "env");
        argl = cons(val, &LispNull);
        LispObject* tmp_990;
        tmp_990 = argl;
        proc = environment_lookup(env, "if-alternative");
        val = environment_lookup(env, "exp");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_990;
        argl = cons(val, argl);
        proc = tmp_994;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    };
};
void entry996(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exps", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_1025;
    tmp_1025 = environment_copy(env);
    proc = environment_lookup(env, "last-exp?");
    val = environment_lookup(env, "exps");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_1025);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        proc = environment_lookup(env, "eval");
        LispObject* tmp_1007;
        tmp_1007 = proc;
        val = environment_lookup(env, "env");
        argl = cons(val, &LispNull);
        LispObject* tmp_1003;
        tmp_1003 = argl;
        proc = environment_lookup(env, "first-exp");
        val = environment_lookup(env, "exps");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_1003;
        argl = cons(val, argl);
        proc = tmp_1007;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    } else {
        Environment* tmp_1024;
    tmp_1024 = environment_copy(env);
        proc = environment_lookup(env, "eval");
        LispObject* tmp_1015;
        tmp_1015 = proc;
        val = environment_lookup(env, "env");
        argl = cons(val, &LispNull);
        LispObject* tmp_1011;
        tmp_1011 = argl;
        proc = environment_lookup(env, "first-exp");
        val = environment_lookup(env, "exps");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_1011;
        argl = cons(val, argl);
        proc = tmp_1015;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        env = environment_copy(tmp_1024);
        proc = environment_lookup(env, "eval-sequence");
        LispObject* tmp_1023;
        tmp_1023 = proc;
        val = environment_lookup(env, "env");
        argl = cons(val, &LispNull);
        LispObject* tmp_1019;
        tmp_1019 = argl;
        proc = environment_lookup(env, "rest-exps");
        val = environment_lookup(env, "exps");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_1019;
        argl = cons(val, argl);
        proc = tmp_1023;
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
    };
};
void entry1026(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "set-variable-value!");
    LispObject* tmp_1044;
    tmp_1044 = proc;
    val = environment_lookup(env, "env");
    argl = cons(val, &LispNull);
    Environment* tmp_1040;
    tmp_1040 = environment_copy(env);
    LispObject* tmp_1038;
    tmp_1038 = argl;
    proc = environment_lookup(env, "eval");
    LispObject* tmp_1037;
    tmp_1037 = proc;
    val = environment_lookup(env, "env");
    argl = cons(val, &LispNull);
    LispObject* tmp_1033;
    tmp_1033 = argl;
    proc = environment_lookup(env, "assignment-value");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_1033;
    argl = cons(val, argl);
    proc = tmp_1037;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_1038;
    argl = cons(val, argl);
    env = environment_copy(tmp_1040);
    LispObject* tmp_1039;
    tmp_1039 = argl;
    proc = environment_lookup(env, "assignment-variable");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_1039;
    argl = cons(val, argl);
    proc = tmp_1044;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    val = parse_lisp_object_from_string("ok");
};
void entry1045(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "env", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "define-variable!");
    LispObject* tmp_1063;
    tmp_1063 = proc;
    val = environment_lookup(env, "env");
    argl = cons(val, &LispNull);
    Environment* tmp_1059;
    tmp_1059 = environment_copy(env);
    LispObject* tmp_1057;
    tmp_1057 = argl;
    proc = environment_lookup(env, "eval");
    LispObject* tmp_1056;
    tmp_1056 = proc;
    val = environment_lookup(env, "env");
    argl = cons(val, &LispNull);
    LispObject* tmp_1052;
    tmp_1052 = argl;
    proc = environment_lookup(env, "definition-value");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_1052;
    argl = cons(val, argl);
    proc = tmp_1056;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_1057;
    argl = cons(val, argl);
    env = environment_copy(tmp_1059);
    LispObject* tmp_1058;
    tmp_1058 = argl;
    proc = environment_lookup(env, "definition-variable");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_1058;
    argl = cons(val, argl);
    proc = tmp_1063;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    val = parse_lisp_object_from_string("ok");
};
void entry1064(void) {
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
void entry1068(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "map");
    LispObject* tmp_1076;
    tmp_1076 = proc;
    Environment* tmp_1072;
    tmp_1072 = environment_copy(env);
    proc = environment_lookup(env, "cadr");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_1072);
    val = environment_lookup(env, "car");
    argl = cons(val, argl);
    proc = tmp_1076;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry1077(void) {
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
void entry1081(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "map");
    LispObject* tmp_1089;
    tmp_1089 = proc;
    Environment* tmp_1085;
    tmp_1085 = environment_copy(env);
    proc = environment_lookup(env, "cadr");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_1085);
    val = environment_lookup(env, "cadr");
    argl = cons(val, argl);
    proc = tmp_1089;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry1090(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "cons");
    LispObject* tmp_1111;
    tmp_1111 = proc;
    Environment* tmp_1107;
    tmp_1107 = environment_copy(env);
    proc = environment_lookup(env, "let-expressions");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_1107);
    LispObject* tmp_1106;
    tmp_1106 = argl;
    proc = environment_lookup(env, "make-lambda");
    LispObject* tmp_1102;
    tmp_1102 = proc;
    Environment* tmp_1098;
    tmp_1098 = environment_copy(env);
    proc = environment_lookup(env, "let-body");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    env = environment_copy(tmp_1098);
    LispObject* tmp_1097;
    tmp_1097 = argl;
    proc = environment_lookup(env, "let-variables");
    val = environment_lookup(env, "exp");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_1097;
    argl = cons(val, argl);
    proc = tmp_1102;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_1106;
    argl = cons(val, argl);
    proc = tmp_1111;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry1112(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "var", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "exp", argl->CarPointer);
    argl = argl->CdrPointer;
    environment_add(env, "body", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = environment_lookup(env, "append");
    LispObject* tmp_1128;
    tmp_1128 = proc;
    val = environment_lookup(env, "body");
    argl = cons(val, &LispNull);
    LispObject* tmp_1124;
    tmp_1124 = argl;
    proc = environment_lookup(env, "list");
    LispObject* tmp_1123;
    tmp_1123 = proc;
    proc = environment_lookup(env, "list");
    LispObject* tmp_1119;
    tmp_1119 = proc;
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
    proc = tmp_1119;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = cons(val, &LispNull);
    val = parse_lisp_object_from_string("let");
    argl = cons(val, argl);
    proc = tmp_1123;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    argl = tmp_1124;
    argl = cons(val, argl);
    proc = tmp_1128;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry1129(void) {
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
void entry1133(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "object", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_1150;
    tmp_1150 = environment_copy(env);
    proc = environment_lookup(env, "compound-procedure?");
    val = environment_lookup(env, "object");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_1150);
    if ((val->type != BOOLEAN) || (val->BoolVal == true) ) {
        proc = environment_lookup(env, "list");
        LispObject* tmp_1149;
        tmp_1149 = proc;
        val = parse_lisp_object_from_string("<procedure-env>");
        argl = cons(val, &LispNull);
        Environment* tmp_1145;
    tmp_1145 = environment_copy(env);
        LispObject* tmp_1143;
        tmp_1143 = argl;
        proc = environment_lookup(env, "procedure-body");
        val = environment_lookup(env, "object");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_1143;
        argl = cons(val, argl);
        env = environment_copy(tmp_1145);
        LispObject* tmp_1144;
        tmp_1144 = argl;
        proc = environment_lookup(env, "procedure-parameters");
        val = environment_lookup(env, "object");
        argl = cons(val, &LispNull);
        if (proc->type == PRIMITIVE_PROC) {
            val = apply(proc, argl);
        } else {
            proc->CompiledFun();
        };
        argl = tmp_1144;
        argl = cons(val, argl);
        val = parse_lisp_object_from_string("compound-procedure");
        argl = cons(val, argl);
        proc = tmp_1149;
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
void entry1151(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    Environment* tmp_1178;
    tmp_1178 = environment_copy(env);
    proc = environment_lookup(env, "prompt-for-input");
    val = environment_lookup(env, "input-prompt");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_1178);
    Environment* tmp_1177;
    tmp_1177 = environment_copy(env);
    proc = create_empty_lisp_object(COMPILED_PROCEDURE);
    proc->CompoundFunEnvironment = env;
    proc->CompiledFun = &entry1155;
    val = read_and_parse_input();
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_1177);
    proc = environment_lookup(env, "driver-loop");
    argl = &LispNull;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry1155(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "input", argl->CarPointer);
    argl = argl->CdrPointer;
    proc = create_empty_lisp_object(COMPILED_PROCEDURE);
    proc->CompoundFunEnvironment = env;
    proc->CompiledFun = &entry1156;
    LispObject* tmp_1170;
    tmp_1170 = proc;
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
    proc = tmp_1170;
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry1156(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "output", argl->CarPointer);
    argl = argl->CdrPointer;
    Environment* tmp_1163;
    tmp_1163 = environment_copy(env);
    proc = environment_lookup(env, "announce-output");
    val = environment_lookup(env, "output-prompt");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
    env = environment_copy(tmp_1163);
    proc = environment_lookup(env, "user-print");
    val = environment_lookup(env, "output");
    argl = cons(val, &LispNull);
    if (proc->type == PRIMITIVE_PROC) {
        val = apply(proc, argl);
    } else {
        proc->CompiledFun();
    };
};
void entry1179(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "string", argl->CarPointer);
    argl = argl->CdrPointer;
    putchar(10);
    putchar(10);
    val = environment_lookup(env, "string");
    print_lisp_object(val);
    putchar(10);
};
void entry1180(void) {
    env = environment_copy(proc->CompoundFunEnvironment);
    environment_add(env, "string", argl->CarPointer);
    argl = argl->CdrPointer;
    putchar(10);
    val = environment_lookup(env, "string");
    print_lisp_object(val);
    putchar(10);
};

/* footer here */
