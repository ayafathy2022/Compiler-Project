/******************************/
/* File: tiny.flex            */
/* Lex specification for TINY */
/******************************/

%{
#include "globals.h"
#include "util.h"
#include "scan.h"
#include "util.c"
/* lexeme of identifier or reserved word */
char tokenString[MAXTOKENLEN+1];
%}

digit       [0-9]
number      {digit}+
letter      [a-zA-Z]
identifier  {letter}+
newline     \n
whitespace  [ \t]+

/* This tells flex to read only one input file */
%option noyywrap

%%

"if"            {return IF;}
"then"          {return THEN;}
"else"          {return ELSE;}
"return"        {return RETURN;}
"while"         {return WHILE;}
"int"           {return INT;}
"void"          {return VOID;}
"input"         {return INPUT;}
"output"        {return OUTPUT;}
":="            {return ASSIGN;}
"="             {return EQ;}
"!="            {return NE;}
"=="            {return EE;}
"<"             {return LT;}
"<="            {return LE;}
">"             {return GT;}
">="            {return GE;}
"+"             {return PLUS;}
"-"             {return MINUS;}
"*"             {return TIMES;}
"/"             {return OVER;}
"("             {return LPAREN;}
")"             {return RPAREN;}
"["             {return OPRACT;}
"]"             {return CPRACT;}
"{"             {return LPRAC;}
"}"             {return RPRAC;}
";"             {return SEMI;}
","             {return COMMA;}
"/* */"         {return COMMANT;}
{number}        {return NUM;}
{identifier}    {return ID;}
{newline}       {lineno++;}
{whitespace}    {/* skip whitespace */}
"{"             { char c;
                  do
                  { c = input();
                    if (c == EOF) break;
                    if (c == '\n') lineno++;
                  } while (c != '}');
                }
.               {return ERROR;}

%%

TokenType getToken(void)
{ static int firstTime = TRUE;
  TokenType currentToken;
  if (firstTime)
  { firstTime = FALSE;
    lineno++;
    yyin = fopen("tiny.txt", "r+");
    yyout = fopen("result.txt","w+");
listing = yyout;
  }
  currentToken = yylex();
  strncpy(tokenString,yytext,MAXTOKENLEN);
  
    fprintf(listing,"\t%d: ",lineno);
    printToken(currentToken,tokenString);
  
  return currentToken;
}

int main()
{
	printf("welcome to the flex scanner: ");
	while(getToken())
	{
		printf("a new token has been detected...\n");
	}
	return 1;
}

