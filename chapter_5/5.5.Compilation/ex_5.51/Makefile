CC=gcc
CFLAGS=-Wall -g

all: clean scheme

scheme_primitives.o: src/scheme_primitives.c src/scheme_primitives.h
	$(CC) $(CFLAGS) -o $@ -c $<

scheme_objects.o: src/scheme_objects.c src/scheme_objects.h
	$(CC) $(CFLAGS) -o $@ -c $<

scheme_env.o: src/scheme_env.c src/scheme_env.h
	$(CC) $(CFLAGS) -o $@ -c $<

scheme: src/scheme.c scheme_objects.o scheme_env.o scheme_primitives.o
	$(CC) $(CFLAGS) -o $@ $^

scheme_tests.o: test/scheme_tests.c
	$(CC) $(CFLAGS) -o $@ -c $<

test: scheme_objects.o scheme_tests.o scheme_env.o scheme_primitives.o
	$(CC) $^ -lcheck -lsubunit -lm -lpthread -lrt -o scheme_$@

clean:
	rm -rfv scheme scheme_test *.o
