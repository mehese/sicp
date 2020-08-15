CC=gcc
CFLAGS=-Wall -g

all: clean scheme

scheme_objects.o: scheme_objects.c scheme_objects.h
	$(CC) $(CFLAGS) -o $@ -c scheme_objects.c 

scheme: scheme.c scheme_objects.o
	$(CC) $(CFLAGS) -o $@ $^

scheme_tests.o: test/scheme_tests.c
	$(CC) $(CFLAGS) -o $@ -c $<

test: scheme_objects.o scheme_tests.o
	$(CC) $^ -lcheck -lsubunit -lm -lpthread -lrt -o scheme_$@

clean:
	rm -rfv scheme scheme_tests *.o
