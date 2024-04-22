%{
#include <stdio.h>
#include <math.h>

FILE* yyin;
int yyerror(const char* p);

extern int yylex();
%}

%union symval {
    int val;
    double double_val;
    char* string; // For IDENTIFIER token

};

%token PLUS MINUS TIMES DIVIDE ASSIGNMENT
%token LPAREN RPAREN
%token SIN COS TAN
%token FOR SEMICOLON
%token IDENTIFIER LESSTHAN EQUALS GREATERTHAN INCREMENT DECREMENT PRINT
%token BLOCK_START BLOCK_END
%token <val> INT
%token <string> IDENTIFIER

%token DONE // To indicate end of input 
%nonassoc UMINUS

%type <double_val> expr statement for_loop
%type <double_val> trig_expr
%token <double_val> NUMBER


%left '*' '/' '+' '-'
%right ASSIGNMENT
%nonassoc LPAREN RPAREN
%start program

%%
/* To be output at the end */
program:
| program expr DONE{ printf("Final Result: %.2lf\n", $2); }
| program statement
;

// for-loop following the structure below:
// for (initialization; condition; update) {loop body}

// test input: for(int i = 0; i < 10; i++) {print i;}
for_loop:
FOR LPAREN for_init SEMICOLON for_cond SEMICOLON for_update RPAREN statement_block
{
    // Placeholder for for-loop logic.

}
;

for_init:
INT IDENTIFIER ASSIGNMENT expr
{
    // Handle variable initialization.
    printf("for_intilialization: int %s = %.0lf;\n", $2, $4);

}
;

for_cond:
expr LESSTHAN expr
{
    // Handle condition.
    printf("lessthan_expr: %.0lf < %.0lf;\n", $1, $3);
}
| expr GREATERTHAN expr
{
    // Handle condition.
    printf("greaterthan_expr: %.0lf > %lf;\n", $1, $3);
}
| expr EQUALS expr
{
    // Handle condition.
    printf("equal_expr: %.0lf == %lf;\n", $1, $3);
}
;

for_update:
IDENTIFIER INCREMENT
{
    // Handle increment.
    printf("id_increment: %s++;\n", $1);

}
| IDENTIFIER DECREMENT
{
    // Handle decrement.
    printf("id_decrement: %s--;\n", $1);

}
;

statement_block:
| BLOCK_START statement BLOCK_END
// Could add a statements block
{
    printf("block_start: {\n");
    // Print or handle statements inside the block.
    printf("block_end: }\n");
}
;

statement:
| for_loop
| print_statement
| expr SEMICOLON{ printf("Statement Result: %.2lf\n", $1); }
;

trig_expr:
SIN LPAREN expr RPAREN{ $$ = sin($3); }
| COS LPAREN expr RPAREN{ $$ = cos($3); }
| TAN LPAREN expr RPAREN{ $$ = tan($3); }
;

expr:
    LPAREN expr RPAREN  { $$ = $2; }
  | expr PLUS expr     { $$ = $1 + $3; }
  | expr MINUS expr    { $$ = $1 - $3; }
  | expr TIMES expr    { $$ = $1 * $3; }
  | expr DIVIDE expr   {
      if ($3 == 0) {
          yyerror("Error: Division by zero.");
          $$ = 0;
      } else {
          $$ = $1 / $3;
      }
  }
  | MINUS expr %prec UMINUS { $$ = -$2; }
  | NUMBER         { $$ = $1; }
  | trig_expr
  | IDENTIFIER
  ;

print_statement:
    PRINT expr SEMICOLON
    {
        // Handle printing the value of the expression.
    }
    ;
%%

int parser_main(int argc, char* argv[])
{
    FILE* fp = NULL;
    if (argc == 2)
    {
        fopen_s(&fp, argv[1], "rb");
        if (fp == NULL) {
            perror("Failed to open file.");
            return -1;
        }
        yyin = fp;
    }

    yyparse();

    if (fp != NULL) {
        fclose(fp);
    }

    return 0;
}

int yyerror(const char* p) {
    fprintf(stderr, "%s\n", p);
    return 0;
}
