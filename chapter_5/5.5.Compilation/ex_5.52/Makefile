CC=gcc
CFLAGS=-Wall -g
OBJS=scheme_primitives.o scheme_objects.o scheme_env.o scheme_eval_apply.o
SRC=src

all: clean compiled_scheme

%.o: $(SRC)/%.c $(SRC)/%.h
	$(CC) $(CFLAGS) -o $@ -c $<

scheme: $(SRC)/scheme.c $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

compiled_scheme: $(SRC)/compiled.c $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^


scheme_tests.o: test/scheme_tests.c
	$(CC) $(CFLAGS) -o $@ -c $<

test: scheme_objects.o scheme_tests.o scheme_env.o scheme_primitives.o
	$(CC) $^ -lcheck -lsubunit -lm -lpthread -lrt -o scheme_$@

clean:
	rm -rfv scheme scheme_test compiled_scheme *.o *.scm~
