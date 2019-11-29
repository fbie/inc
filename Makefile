gen: c.rkt
	racket c.rkt > test.s

all: gen scheme_entry.h driver.c
	gcc -O3 -Wall --omit-frame-pointer driver.c test.s -o driver

clean:
	rm -rf *.exe
	rm -rf *.s
