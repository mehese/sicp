#include <check.h>               
#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <stdbool.h>
#include <math.h>
#include <stdlib.h>
#include "../src/scheme_objects.h"


/*
 * Cases below parse a single atom.
 *
 * Atoms can be: NIL, BOOLEAN, SYMBOL or FUNCTION
 *
 */
START_TEST(test_null_input_parsed_correctly) {
  LispObject* o;
  char scheme_input[MAX_INPUT_SIZE];
  extern char** input_to_tokens(char*);
  extern LispObject* parse_input(char**);

  /* verify `'()` case */
  strncpy(scheme_input, "'()\n", MAX_INPUT_SIZE);
  o = parse_input(input_to_tokens(scheme_input));
  ck_assert_int_eq(o->type, NIL);
  free_lisp_object(o);

  /* verify `nil` case */
  strncpy(scheme_input, "nil\n", MAX_INPUT_SIZE);
  o = parse_input(input_to_tokens(scheme_input));
  ck_assert_int_eq(o->type, NIL);
  free_lisp_object(o);

} END_TEST


START_TEST(test_boolean_input_parsed_correctly) {
  LispObject* o;
  char scheme_input[MAX_INPUT_SIZE];
  extern char** input_to_tokens(char*);
  extern LispObject* parse_input(char**);

  /* verify `true` case */
  strncpy(scheme_input, "true\n", MAX_INPUT_SIZE);
  o = parse_input(input_to_tokens(scheme_input));
  ck_assert_int_eq(o->type, BOOLEAN);
  ck_assert(o->BoolVal ==  true);
  free_lisp_object(o);

  strncpy(scheme_input, "#t\n", MAX_INPUT_SIZE);
  o = parse_input(input_to_tokens(scheme_input));
  ck_assert_int_eq(o->type, BOOLEAN);
  ck_assert(o->BoolVal ==  true);
  free_lisp_object(o);

  /* verify `false` case */
  strncpy(scheme_input, "false\n", MAX_INPUT_SIZE);
  o = parse_input(input_to_tokens(scheme_input));
  ck_assert_int_eq(o->type, BOOLEAN);
  ck_assert(o->BoolVal ==  false);
  free_lisp_object(o);

  strncpy(scheme_input, "#f\n", MAX_INPUT_SIZE);
  o = parse_input(input_to_tokens(scheme_input));
  ck_assert_int_eq(o->type, BOOLEAN);
  ck_assert(o->BoolVal ==  false);
  free_lisp_object(o);

} END_TEST


START_TEST(test_numeric_input_parsed_correctly) {
  LispObject* o;
  char scheme_input[MAX_INPUT_SIZE];
  extern char** input_to_tokens(char*);
  extern LispObject* parse_input(char**);

  /* verify pozitive integers case */
  strncpy(scheme_input, "123\n", MAX_INPUT_SIZE);
  o = parse_input(input_to_tokens(scheme_input));
  ck_assert_int_eq(o->type, NUMBER);
  ck_assert(fabs(o->NumberVal - 123.0) < FLOAT_TOL);
  free_lisp_object(o);

  /* verify pozitive doubles case */
  strncpy(scheme_input, "1.23\n", MAX_INPUT_SIZE);
  o = parse_input(input_to_tokens(scheme_input));
  ck_assert_int_eq(o->type, NUMBER);
  ck_assert(fabs(o->NumberVal - 1.23) < FLOAT_TOL);
  free_lisp_object(o);

  /* verify negative doubles case */
  strncpy(scheme_input, "-1.23\n", MAX_INPUT_SIZE);
  o = parse_input(input_to_tokens(scheme_input));
  ck_assert_int_eq(o->type, NUMBER);
  ck_assert(fabs(o->NumberVal + 1.23) < FLOAT_TOL);
  free_lisp_object(o);

} END_TEST


START_TEST(test_symbol_input_parsed_correctly) {
  LispObject* o;
  char scheme_input[MAX_INPUT_SIZE] = "a\n";
  extern char** input_to_tokens(char*);
  extern LispObject* parse_input(char**);

  o = parse_input(input_to_tokens(scheme_input));
  ck_assert_int_eq(o->type, SYMBOL);
  ck_assert(strcmp(o->SymbolVal, "a") ==  0);
  free_lisp_object(o);
} END_TEST

/*
 * Cases below test quote parsing. 
 *
 */
START_TEST(test_quoted_atom_parsed_correctly) {
  LispObject* o;
  char scheme_input[MAX_INPUT_SIZE];
  extern char** input_to_tokens(char*);
  extern LispObject* parse_input(char**);

  /* symbol case */
  strncpy(scheme_input, "'a\n", MAX_INPUT_SIZE);
  o = parse_input(input_to_tokens(scheme_input));
  ck_assert_int_eq(o->type, QUOTED);
  ck_assert_int_eq(o->QuotePointer->type, SYMBOL);
  ck_assert(strcmp(o->QuotePointer->SymbolVal, "a") ==  0);
  free_lisp_object(o);
} END_TEST


START_TEST(test_quoted_quoted_atom_parsed_correctly) {
  LispObject* o;
  char scheme_input[MAX_INPUT_SIZE];
  extern char** input_to_tokens(char*);
  extern LispObject* parse_input(char**);

  /* symbol case */
  strncpy(scheme_input, "''a\n", MAX_INPUT_SIZE);
  o = parse_input(input_to_tokens(scheme_input));
  ck_assert_int_eq(o->type, QUOTED);
  ck_assert_int_eq(o->QuotePointer->type, QUOTED);
  ck_assert_int_eq(o->QuotePointer->QuotePointer->type, SYMBOL);
  ck_assert(strcmp(o->QuotePointer->QuotePointer->SymbolVal, "a") ==  0);
  free_lisp_object(o);
} END_TEST


START_TEST(test_quoted_list_parsed_correctly) {
  LispObject* o;
  char scheme_input[MAX_INPUT_SIZE];
  extern char** input_to_tokens(char*);
  extern LispObject* parse_input(char**);

  /* symbol case */
  strncpy(scheme_input, "'(a)\n", MAX_INPUT_SIZE);
  o = parse_input(input_to_tokens(scheme_input));
  ck_assert_int_eq(o->type, QUOTED);
  ck_assert_int_eq(o->QuotePointer->type, PAIR);
  ck_assert_int_eq(o->QuotePointer->CarPointer->type, SYMBOL);
  ck_assert_int_eq(o->QuotePointer->CdrPointer->type, NIL);
  ck_assert(strcmp(o->QuotePointer->CarPointer->SymbolVal, "a") ==  0);
  free_lisp_object(o);
} END_TEST

START_TEST(test_quote_in_list_parsed_correctly) {
  LispObject* o;
  char scheme_input[MAX_INPUT_SIZE];
  extern char** input_to_tokens(char*);
  extern LispObject* parse_input(char**);

  /* symbol case */
  strncpy(scheme_input, "('a)\n", MAX_INPUT_SIZE);
  o = parse_input(input_to_tokens(scheme_input));
  ck_assert_int_eq(o->type, PAIR);
  ck_assert_int_eq(o->CarPointer->type, QUOTED);
  ck_assert_int_eq(o->CdrPointer->type, NIL);
  ck_assert_int_eq(o->CarPointer->QuotePointer->type, SYMBOL);
  ck_assert(strcmp(o->CarPointer->QuotePointer->SymbolVal, "a") ==  0);
  free_lisp_object(o);
} END_TEST


START_TEST(test_quoted_list_in_list_parsed_correctly){
  LispObject* o;
  char scheme_input[MAX_INPUT_SIZE];
  extern char** input_to_tokens(char*);
  extern LispObject* parse_input(char**);

  /* symbol case */
  strncpy(scheme_input, "('(a))\n", MAX_INPUT_SIZE);
  o = parse_input(input_to_tokens(scheme_input));
  ck_assert_int_eq(o->type, PAIR);
  ck_assert_int_eq(o->CarPointer->type, QUOTED);
  ck_assert_int_eq(o->CdrPointer->type, NIL);
  ck_assert_int_eq(o->CarPointer->QuotePointer->type, PAIR);
  ck_assert_int_eq(o->CarPointer->QuotePointer->CarPointer->type, SYMBOL);
  ck_assert_int_eq(o->CarPointer->QuotePointer->CdrPointer->type, NIL);
  ck_assert(strcmp(o->CarPointer->QuotePointer->CarPointer->SymbolVal, "a") ==  0);
  free_lisp_object(o);
} END_TEST


START_TEST(test_quoted_quoted_list_parsed_correctly){
  LispObject* o;
  char scheme_input[MAX_INPUT_SIZE];
  extern char** input_to_tokens(char*);
  extern LispObject* parse_input(char**);

  /* symbol case */
  strncpy(scheme_input, "''(a)\n", MAX_INPUT_SIZE);
  o = parse_input(input_to_tokens(scheme_input));
  ck_assert_int_eq(o->type, QUOTED);
  ck_assert_int_eq(o->QuotePointer->type, QUOTED);
  ck_assert_int_eq(o->QuotePointer->QuotePointer->type, PAIR);
  ck_assert_int_eq(o->QuotePointer->QuotePointer->CarPointer->type, SYMBOL);
  ck_assert(strcmp(o->QuotePointer->QuotePointer->CarPointer->SymbolVal, "a") ==  0);
  free_lisp_object(o);
} END_TEST



/*
 * Cases below test list parsing. 
 *
 */
START_TEST(test_1_elem_list_parsed_correctly) {
  LispObject* o;
  char scheme_input[MAX_INPUT_SIZE] = "(a)\n";
  extern char** input_to_tokens(char*);
  extern LispObject* parse_input(char**);

  o = parse_input(input_to_tokens(scheme_input));
  ck_assert_int_eq(o->type, PAIR);
  ck_assert_int_eq(o->CarPointer->type, SYMBOL);
  ck_assert(strcmp(o->CarPointer->SymbolVal, "a") ==  0);
  ck_assert_int_eq(o->CdrPointer->type, NIL);
  free_lisp_object(o);
} END_TEST


START_TEST(test_many_elem_flat_list_parsed_correctly) {
  LispObject* o;
  char scheme_input[MAX_INPUT_SIZE];
  extern char** input_to_tokens(char*);
  extern LispObject* parse_input(char**);

  /* 2 elements */
  strncpy(scheme_input, "(a 2)\n", MAX_INPUT_SIZE);
  o = parse_input(input_to_tokens(scheme_input));
  ck_assert_int_eq(o->type, PAIR);
  ck_assert_int_eq(o->CarPointer->type, SYMBOL);
  ck_assert(strcmp(o->CarPointer->SymbolVal, "a") ==  0);
  ck_assert_int_eq(o->CdrPointer->type, PAIR);
  ck_assert_int_eq(o->CdrPointer->CarPointer->type, NUMBER);
  ck_assert_int_eq(o->CdrPointer->CdrPointer->type, NIL);
  double num_val;
  num_val = o->CdrPointer->CarPointer->NumberVal; 
  ck_assert(fabs(num_val - 2.00) < FLOAT_TOL);
  free_lisp_object(o);

  /* 3 elements */
  strncpy(scheme_input, "('() 2 a)\n", MAX_INPUT_SIZE);
  o = parse_input(input_to_tokens(scheme_input));
  ck_assert_int_eq(o->type, PAIR);
  ck_assert_int_eq(o->CarPointer->type, NIL);
  ck_assert_int_eq(o->CdrPointer->type, PAIR);
  ck_assert_int_eq(o->CdrPointer->CarPointer->type, NUMBER);
  num_val = o->CdrPointer->CarPointer->NumberVal; 
  ck_assert(fabs(num_val - 2.00) < FLOAT_TOL);
  ck_assert_int_eq(o->CdrPointer->CdrPointer->type, PAIR);
  ck_assert_int_eq(o->CdrPointer->CdrPointer->CarPointer->type, SYMBOL);
  ck_assert(strcmp(o->CdrPointer->CdrPointer->CarPointer->SymbolVal, "a") ==  0);
  ck_assert_int_eq(o->CdrPointer->CdrPointer->CdrPointer->type, NIL);
} END_TEST

START_TEST(test_nested_list_parsed_correctly) {
  LispObject* o;
  char scheme_input[MAX_INPUT_SIZE];
  extern char** input_to_tokens(char*);
  extern LispObject* parse_input(char**);

  // 1 elem
  strncpy(scheme_input, "((a))\n", MAX_INPUT_SIZE);
  o = parse_input(input_to_tokens(scheme_input));
  ck_assert_int_eq(o->type, PAIR);
  ck_assert_int_eq(o->CarPointer->type, PAIR);
  ck_assert_int_eq(o->CdrPointer->type, NIL);
  ck_assert_int_eq(o->CarPointer->CarPointer->type, SYMBOL);
  ck_assert(strcmp(o->CarPointer->CarPointer->SymbolVal, "a") ==  0);
  ck_assert_int_eq(o->CarPointer->CdrPointer->type, NIL);
  free_lisp_object(o);

  // 2 elem
  strncpy(scheme_input, "(a (b))\n", MAX_INPUT_SIZE);
  o = parse_input(input_to_tokens(scheme_input));
  ck_assert_int_eq(o->type, PAIR);
  ck_assert_int_eq(o->CarPointer->type, SYMBOL);
  ck_assert(strcmp(o->CarPointer->SymbolVal, "a") ==  0);
  ck_assert_int_eq(o->CdrPointer->type, PAIR);
  ck_assert_int_eq(o->CdrPointer->CarPointer->type, PAIR);
  ck_assert_int_eq(o->CdrPointer->CdrPointer->type, NIL);
  ck_assert_int_eq(o->CdrPointer->CarPointer->CarPointer->type, SYMBOL);
  ck_assert(strcmp(o->CdrPointer->CarPointer->CarPointer->SymbolVal, "b") ==  0);
  ck_assert_int_eq(o->CdrPointer->CarPointer->CdrPointer->type, NIL);
 } END_TEST


Suite *money_suite(void) {
  Suite *s;
  TCase *tc_core;

  s = suite_create("Scheme");
  tc_core = tcase_create("Core");

  /*  Atom tests */
  tcase_add_test(tc_core, test_null_input_parsed_correctly);
  tcase_add_test(tc_core, test_boolean_input_parsed_correctly);
  tcase_add_test(tc_core, test_numeric_input_parsed_correctly);
  tcase_add_test(tc_core, test_symbol_input_parsed_correctly);

  /* Quote tests */
  tcase_add_test(tc_core, test_quoted_atom_parsed_correctly);
  tcase_add_test(tc_core, test_quoted_quoted_atom_parsed_correctly);
  tcase_add_test(tc_core, test_quoted_list_parsed_correctly);
  tcase_add_test(tc_core, test_quote_in_list_parsed_correctly);
  tcase_add_test(tc_core, test_quoted_list_in_list_parsed_correctly);
  tcase_add_test(tc_core, test_quoted_quoted_list_parsed_correctly);

  /* List tests */
  tcase_add_test(tc_core, test_1_elem_list_parsed_correctly);
  tcase_add_test(tc_core, test_many_elem_flat_list_parsed_correctly);
  tcase_add_test(tc_core, test_nested_list_parsed_correctly);

  suite_add_tcase(s, tc_core);

  return s;
}

int main(void) {
  int no_failed = 0;                   
  Suite *s;                            
  SRunner *runner;                     

  s = money_suite();                   
  runner = srunner_create(s);          

  srunner_run_all(runner, CK_NORMAL);  
  no_failed = srunner_ntests_failed(runner); 
  srunner_free(runner);                      
  return (no_failed == 0) ? EXIT_SUCCESS : EXIT_FAILURE;  
}


