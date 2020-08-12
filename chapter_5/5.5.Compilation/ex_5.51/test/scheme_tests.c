#include <check.h>               
#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <stdbool.h>
#include <math.h>
#include <stdlib.h>
#include "../scheme_objects.h"


START_TEST(test_create_empty_lisp_object) {
  LispObject* o;
  extern LispObject* create_empty_lisp_object(LispType);

  o = create_empty_lisp_object(NIL);
  ck_assert_int_eq(o->type, NIL);
} END_TEST

START_TEST(test_create_lisp_number) {
  LispObject* o;
  extern LispObject* create_empty_lisp_object(LispType);

  o = create_empty_lisp_object(NUMBER);
  ck_assert_int_eq(o->type, NUMBER);
  ck_assert(fabs(o->NumberVal) <  FLOAT_TOL);
  free_lisp_object(o);
} END_TEST


Suite *money_suite(void) {
  Suite *s;
  TCase *tc_core;

  s = suite_create("Scheme");
  tc_core = tcase_create("Core");

  tcase_add_test(tc_core, test_create_empty_lisp_object);
  tcase_add_test(tc_core, test_create_lisp_number);
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


