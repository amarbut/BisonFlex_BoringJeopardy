CC=g++
CFLAGS=-I -O3 -std=c++11

all: boringJeopardy.out

boringJeopardy.tab.c: boringJeopardy.y
	bison -d  boringJeopardy.y

lex.yy.c: boringJeopardy.l
	flex -Ca -i boringJeopardy.l

boringJeopardy.out: boringJeopardy.l boringJeopardy.y boringJeopardy.tab.c lex.yy.c
	$(CC) $(CFLAGS) boringJeopardy.tab.c lex.yy.c -lfl -o boringJeopardy.out