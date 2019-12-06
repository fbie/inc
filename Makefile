gen: c.rkt
	racket c.rkt > test.s

all: gen scheme_entry.h driver.c
	gcc -O3 -Wall --omit-frame-pointer driver.c test.s -o driver

entry: scheme_entry.c
	gcc -O3 --omit-frame-pointer -S scheme_entry.c -o scheme_entry.s

clean:
	rm -rf *.exe
	rm -rf *.s
