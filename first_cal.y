%{

void yyerror (char *s);

#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <string.h>
#include "writefile.h"

int symbols[52];
int ind = 0;
int line =1;
char temp[10];
char lineW[100];

struct threeADD
{
	char result[10];
	char operand_1[10];
	char operand_2[10];
	char operator[10];
};

struct threeADD quadraple[20];
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);
int addToTable(char operand, char operator1, char operator2);
void generateCode();

%}
%code requires {
	struct incod
	{
		char codeVariable[10];
		int val;
	};
}

%union {int num; char id; int cond; struct incod code;}         /* Yacc definitions */
%start line

%token print
%token <num> number
%token <id> identifier
%token <num> _true_
%token <num> _false_

%token lt
%token gt
%token eq
%token lteq
%token gteq
%token nteq
/*
%token while_statement
%token if_statement
%token else_statement*/

%type <num> line 
%type <code> exp term ending_term condition
%type <id> assignment

%left '+' '-'
%left '*' '/' '%'

%%

line	        : assignment ';'      	{line++;}
				| line assignment ';'	{line++;}
				| print exp ';'         {
											printf("%d\n", $2.val);
											strcpy(quadraple[ind].operator, "Cprint");
											strcpy(quadraple[ind].operand_1, $2.codeVariable);
											ind++;
											line++;
										}
				| line print exp ';'	{
											printf("%d\n", $3.val);
											strcpy(quadraple[ind].operator, "Cprint");
											strcpy(quadraple[ind].operand_1, $3.codeVariable);
											ind++;line++;
										}
				| print condition ';'         {
											printf("%d\n", $2.val);
											strcpy(quadraple[ind].operator, "Cprint");
											strcpy(quadraple[ind].operand_1, $2.codeVariable);
											ind++;
											line++;
										}
				| line print condition ';'	{
											printf("%d\n", $3.val);
											strcpy(quadraple[ind].operator, "Cprint");
											strcpy(quadraple[ind].operand_1, $3.codeVariable);
											ind++;
											line++;
										}
condition		: exp lt exp				{
												$$.val = ($1.val<$3.val);
												sprintf($$.codeVariable, "_k%d", ind);
												strcpy(quadraple[ind].result, $$.codeVariable);
												strcpy(quadraple[ind].operand_1, $1.codeVariable);
												strcpy(quadraple[ind].operand_2, $3.codeVariable);
												sprintf(temp, "%c", '<');
												strcpy(quadraple[ind].operator, temp);
												ind++;
											}
				| exp gt exp				{
												$$.val = ($1.val>$3.val);
												sprintf($$.codeVariable, "_k%d", ind);
												strcpy(quadraple[ind].result, $$.codeVariable);
												strcpy(quadraple[ind].operand_1, $1.codeVariable);
												strcpy(quadraple[ind].operand_2, $3.codeVariable);
												sprintf(temp, "%c", '>');
												strcpy(quadraple[ind].operator, temp);
												ind++;
											}
				| exp eq exp				{
												$$.val = ($1.val==$3.val);
												sprintf($$.codeVariable, "_k%d", ind);
												strcpy(quadraple[ind].result, $$.codeVariable);
												strcpy(quadraple[ind].operand_1, $1.codeVariable);
												strcpy(quadraple[ind].operand_2, $3.codeVariable);
												sprintf(temp, "%s", "==");
												strcpy(quadraple[ind].operator, temp);
												ind++;
											}
				| exp lteq exp				{
												$$.val = ($1.val<=$3.val);
												sprintf($$.codeVariable, "_k%d", ind);
												strcpy(quadraple[ind].result, $$.codeVariable);
												strcpy(quadraple[ind].operand_1, $1.codeVariable);
												strcpy(quadraple[ind].operand_2, $3.codeVariable);
												sprintf(temp, "%s", "<=");
												strcpy(quadraple[ind].operator, temp);
												ind++;
											}
				| exp gteq exp				{
												$$.val = ($1.val>=$3.val);
												sprintf($$.codeVariable, "_k%d", ind);
												strcpy(quadraple[ind].result, $$.codeVariable);
												strcpy(quadraple[ind].operand_1, $1.codeVariable);
												strcpy(quadraple[ind].operand_2, $3.codeVariable);
												sprintf(temp, "%s", ">=");
												strcpy(quadraple[ind].operator, temp);
												ind++;
											}
				| exp nteq exp				{
												$$.val = ($1.val!=$3.val);
												sprintf($$.codeVariable, "_k%d", ind);
												strcpy(quadraple[ind].result, $$.codeVariable);
												strcpy(quadraple[ind].operand_1, $1.codeVariable);
												strcpy(quadraple[ind].operand_2, $3.codeVariable);
												sprintf(temp, "%s", "!=");
												strcpy(quadraple[ind].operator, temp);
												ind++;
											}
				| _true_					{
												$$.val = 1;
												sprintf($$.codeVariable, "_k%d", ind);
												strcpy(quadraple[ind].result, $$.codeVariable);
												strcpy(quadraple[ind].operand_1, "1");
												ind++;
											}
				| _false_					{
												$$.val = 0;
												sprintf($$.codeVariable, "_k%d", ind);
												strcpy(quadraple[ind].result, $$.codeVariable);
												strcpy(quadraple[ind].operand_1, "0");
												ind++;
											}
				;


assignment  	: identifier '=' exp			{
													updateSymbolVal($1, $3.val);
													sprintf(temp, "%d", $3.val);
													sprintf(temp, "%c", $1);
													strcpy(quadraple[ind].result, temp);
													sprintf(temp, "%s", $3.codeVariable);
													strcpy(quadraple[ind].operand_1, temp);

													$$ = $3.val;
													ind++;

												}
				|  identifier '=' condition		{
													updateSymbolVal($1, $3.val);
													sprintf(temp, "%c", $1);
													strcpy(quadraple[ind].result, temp);
													sprintf(temp, "%s", $3.codeVariable);
													strcpy(quadraple[ind].operand_1, temp);

													$$ = $3.val;
													ind++;

												}
				;

exp     		: term                  		{
													sprintf($$.codeVariable, "%s", $1.codeVariable);
													$$.val = $1.val;
												}
				| exp '+' term          		{
													sprintf($$.codeVariable, "_k%d", ind);
													strcpy(quadraple[ind].result, $$.codeVariable);
													strcpy(quadraple[ind].operand_1, $1.codeVariable);
													strcpy(quadraple[ind].operand_2, $3.codeVariable);
													sprintf(temp, "%c", '+');
													strcpy(quadraple[ind].operator, temp);
													$$.val = $1.val+$3.val;
													ind++;
												}
				| exp '-' term          		{
													sprintf($$.codeVariable, "_k%d", ind);
													strcpy(quadraple[ind].result, $$.codeVariable);
													strcpy(quadraple[ind].operand_1, $1.codeVariable);
													strcpy(quadraple[ind].operand_2, $3.codeVariable);
													sprintf(temp, "%c", '-');
													strcpy(quadraple[ind].operator, temp);
													$$.val = $1.val-$3.val;
													ind++;
												}

term			: ending_term					{
													$$.val = $1.val;
												}
				| term '*' ending_term          {
													sprintf($$.codeVariable, "_k%d", ind);
													strcpy(quadraple[ind].result, $$.codeVariable);
													strcpy(quadraple[ind].operand_1, $1.codeVariable);
													strcpy(quadraple[ind].operand_2, $3.codeVariable);
													sprintf(temp, "%c", '*');
													strcpy(quadraple[ind].operator, temp);
													$$.val = $1.val*$3.val;
													ind++;
												}
				| term '/' ending_term          {
													sprintf($$.codeVariable, "_k%d", ind);
													strcpy(quadraple[ind].result, $$.codeVariable);
													strcpy(quadraple[ind].operand_1, $1.codeVariable);
													strcpy(quadraple[ind].operand_2, $3.codeVariable);
													sprintf(temp, "%c", '/');
													strcpy(quadraple[ind].operator, temp);
													$$.val = $1.val/$3.val;
													ind++;
												}
				| term '%' ending_term          {
													sprintf($$.codeVariable, "_k%d", ind);
													strcpy(quadraple[ind].result, $$.codeVariable);
													strcpy(quadraple[ind].operand_1, $1.codeVariable);
													strcpy(quadraple[ind].operand_2, $3.codeVariable);
													sprintf(temp, "%c", '%');
													strcpy(quadraple[ind].operator, temp);
													$$.val = $1.val%$3.val;
													ind++;
												}
				;

ending_term	    : number                		{
													//sprintf(temp, "%d", $1);
													sprintf($$.codeVariable, "%d", $1);
													//strcpy(quadraple[ind].result, $$.codeVariable);
													//strcpy(quadraple[ind].operand_1, temp);
													$$.val = $1;
													//ind++;

												}
				| identifier            		{
													int value = symbolVal($1);
													if(value == NULL)
														yyerror("Variable not initialized");
													else
														{
															sprintf(temp, "%d", value);
															sprintf($$.codeVariable, "%c", $1);

															$$.val = value;
														}
												}
				;

%%                     /* C code */

int computeSymbolind(char token)
{
	int idx = -1;
	if(islower(token)) {
		idx = token - 'a' + 26;
	} else if(isupper(token)) {
		idx = token - 'A';
	}
	return idx;
}

/* returns the value of a given symbol */

int symbolVal(char symbol)
{
	int bucket = computeSymbolind(symbol);
	return symbols[bucket];
}

/* updates the value of a given symbol */
void updateSymbolVal(char symbol, int val)
{
	int bucket = computeSymbolind(symbol);
	symbols[bucket] = val;
}
void generateCode()
{
	int count = 0;
	char buffer[50];

	while(count < ind)
	{
		
		if (strcmp(quadraple[count].result, "")==0)
		{
			sprintf(buffer, "%s %s", quadraple[count].operator, quadraple[count].operand_1);
			writeLine(buffer);
			count++;
			continue;
		}
		sprintf(buffer, "%s := %s %s %s", quadraple[count].result, quadraple[count].operand_1,
			quadraple[count].operator, quadraple[count].operand_2);
		writeLine(buffer);
		count++;
	}
}

int main (void)
{
	yyparse();
	generateCode();
}

void yyerror (char *s) {fprintf (stderr, "%s at line %d\n", s, line);}