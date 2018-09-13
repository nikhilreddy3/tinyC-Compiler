a.out: main.o liblibraries.a
	cc main.o -L. -llibraries 

mainlibraries.o:	main.c myl.h
	cc -Wall -c main.c

liblibraries.a:	libraries.o
		ar -rcs liblibraries.a libraries.o

libraries.o:	libraries.c myl.h
	cc -Wall -c libraries.c
clean:
	rm a.out main.o liblibraries.a libraries.o
