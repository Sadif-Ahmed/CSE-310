#!/bin/bash

yacc -d -Wcounterexamples -Wother -Wconflicts-sr parser.y
echo 'Generated the parser C file as well the header file'
flex scanner.l
echo 'Generated the scanner C file'
g++ -w -g lex.yy.c y.tab.c -fsanitize=address -o out
echo 'Linked lex.yy.c and y.tab.c files, now running'
./out inp.txt
