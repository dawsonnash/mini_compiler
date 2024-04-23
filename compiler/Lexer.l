%{

#include "Parser.tab.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define fileno _fileno

%}
%option noyywrap yylineno


%%
"done" { return DONE; }
"+"     { return PLUS; }
"-"     { return MINUS; }
"*"     { return TIMES; }
"/"     { return DIVIDE; }
"="		{ return ASSIGNMENT; }
"("     { return LPAREN; }
")"     { return RPAREN; }
"sin"   { return SIN; }
"cos"   { return COS; }
"tan"   { return TAN; }
"for"   { return FOR; }
"while" { return WHILE; }
";"     { return SEMICOLON; }
"int"   { return INT; }
"print" { return PRINT; }
"<"     { return LESSTHAN; }
">"     { return GREATERTHAN; }
"++"    { return INCREMENT; }
"--"    { return DECREMENT; }
"=="	{ return EQUALS; }
"{"     { return BLOCK_START; }
"}"     { return BLOCK_END; }



[a-zA-Z_][a-zA-Z0-9_]* { yylval.string = _strdup(yytext); return IDENTIFIER; }

[0-9]+\.?[0-9]*		{ yylval.double_val = atof(yytext); return NUMBER; }	// Defining all numbers to include floating point numbers
\.?[0-9]+			{ yylval.double_val = atof(yytext); return NUMBER; }

[ \t\n]+ { /* Ignores whitespace and newlines */ }
.		{ printf("Unknown char: %s\n", yytext); }

%%


