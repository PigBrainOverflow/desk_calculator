%{

#include <cmath>
#include <cstdio>
#define YYSTYPE double
extern int yylex();
extern void yyerror(const char* errormsg)
{
	printf("%s\n",errormsg);
}

void print_welcome()
{
	printf(
		"--------------------------------------------------\n"
		"|                                                |\n"
		"|  Welcome to McArthur's simple desk calculator! |\n"
		"|                                                |\n"
		"|  Press Enter to calculate.                     |\n"
		"|  Press Ctrl+D to quit.                         |\n"
		"|  Type in \"help\" to see more information.       |\n"
		"|                                                |\n"
		"--------------------------------------------------\n"
	);
}

void print_help()
{
	printf(
		"Operations Supported:\n"
		"+: add\n-: subtract\n*: multiply\n/: divide\n^: power\n"
		">: greater (1 for true and 0 for false)\n<: less\n>=: greater or equal\n"
		"<=: less or equal\n==: equal\n!=: not equal\nsin(): sine (in rad)\n"
		"cos(): cosine\nabs(): absolute value\nlog(): logarithm (base: e)\n"
		"----------\n"
	);
}

%}

%token NUMBER
%token GE
%token LE
%token EQ
%token NE

%token SIN
%token COS
%token ABS
%token LOG

%token HELP

%left GE LE EQ NE '>' '<'
%left '+' '-'
%left '*' '/'
%right NEG
%right '^'

%%

lines	:
	lines expr '\n' { printf("ANS=%g\n----------\n",$2); }
	| lines HELP '\n' { print_help(); }
	| lines '\n'
	|
	;

expr	:
	| SIN '(' expr ')' { $$=sin($3); }
	| COS '(' expr ')' { $$=cos($3); }
	| ABS '(' expr ')' { $$=fabs($3); }
	| LOG '(' expr ')' { $$=log($3); }
	| expr '>' expr { $$=(double)($1>$3); }
	| expr '<' expr { $$=(double)($1<$3); }
	| expr GE expr { $$=(double)($1>=$3); }
	| expr LE expr { $$=(double)($1<=$3); }
	| expr EQ expr { $$=(double)($1==$3); }
	| expr NE expr { $$=(double)($1!=$3); }
	| expr '+' expr { $$=$1+$3; }
	| expr '-' expr { $$=$1-$3; }
	| expr '*' expr { $$=$1*$3; }
	| expr '/' expr {
		if($3==0){
			printf("Math Error: Divided by 0.\n");
			$$=0;
		}
		else
			$$=$1/$3;
	}
	| '-' expr %prec NEG { $$=-$2; }
	| expr '^' expr { $$=pow($1,$3); }
	| '(' expr ')' { $$=$2; }
	| NUMBER
	;

%%

#include "lex.yy.c"

int main(int argc,char* argv[])
{
	print_welcome();
	yyset_in(stdin);
	yyparse();
	return 0;
}