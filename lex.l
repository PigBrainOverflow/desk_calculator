%option noyywrap

number	[0-9]+\.?|[0-9]*\.[0-9]+

%%

[ \t]	{ /* no action */ }
{number}	{ sscanf(yytext,"%lf",&yylval); return NUMBER; }
"help"	{ return HELP; }
"sin"	{ return SIN; }
"cos"	{ return COS; }
"abs"	{ return ABS; }
"log"	{ return LOG; }
">="	{ return GE; }
"<="	{ return LE; }
"=="	{ return EQ; }
"!="	{ return NE; }
\n|.	{ return yytext[0]; }

%%