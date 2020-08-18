CC=gcc
CFLAGS=-Wall -g

all: clean foo 

scheme_objects.o: scheme_objects.c scheme_objects.h
	$(CC) $(CFLAGS) -o $@ -c $<

foo: scheme_env.c scheme_objects.o
	$(CC) $(CFLAGS) -o $@ $^

clean:
	rm -rfv foo *.o
