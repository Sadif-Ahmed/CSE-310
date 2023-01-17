yacc -d -y -v 1905058.y
echo 'Generated the parser C file as well the header file'
g++ -w -c -o y.o y.tab.c
echo 'Generated the parser object file'
flex 1905058.l
echo 'Generated the scanner C file'
g++ -w -c -o l.o lex.yy.c
echo 'Generated the scanner object file'
g++ -o a.out y.o l.o -lfl
echo 'All ready, running'
./a.out input.txt