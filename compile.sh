yacc -d first_cal.y
lex first_cal.l
gcc -g lex.yy.c y.tab.c -o calc
echo ""
echo ""
echo "The program is executing.."
echo ""
echo ""
./calc<input.in 
echo ""
echo ""
echo "The intermediate code generated to program.txt"
echo ""
cat program.txt

