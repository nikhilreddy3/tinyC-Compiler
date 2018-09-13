%{
#include "y.tab.h"
#include <stdio.h>
#include <math.h>

extern void yyerror(const char*);
void m_comment(void);
%}

SINGLELINE_COMMENT		"//"[^\n]*
NOT_STAR				[^"*"]|\n
NOT_SLASH 				[^"/"]|\n
NOT_SLASH_STAR 			[^"/""*"]|\n
MULTILINE_COMMENT 		"/*"{NOT_STAR}*"*"("*"|({NOT_SLASH_STAR}{NOT_STAR}*"*"))*"/"       


IDENTIFIER_NONDIGIT     [a-zA-Z]|"_"
DIGIT					[0-9]
IDENTIFIER 				{IDENTIFIER_NONDIGIT}({IDENTIFIER_NONDIGIT}|{DIGIT})*

NONZERO_DIGIT  			[1-9]
INT_CONSTANT 			{NONZERO_DIGIT}{DIGIT}*|"0"
SIGN 					"+"|"-"
DIGIT_SEQUENCE			{DIGIT}+
FRACTIONAL_CONSTANT		({DIGIT_SEQUENCE}?"."{DIGIT_SEQUENCE})|({DIGIT_SEQUENCE}".")
EXPONENT_PART			(e|E){SIGN}?{DIGIT_SEQUENCE}
FLOAT_CONSTANT			({FRACTIONAL_CONSTANT}{EXPONENT_PART}?)|({DIGIT_SEQUENCE}{EXPONENT_PART})
ENUM_CONSTANT			{IDENTIFIER}
ESCAPE_SEQUENCE			"\\\'"|"\\\""|"\\\?"|"\\\\"|"\\a"|"\\b"|"\\f"|"\\n"|"\\r"|"\\t"|"\\v"|"\\0"
C_CHAR					[^"\'""\\"\n]|{ESCAPE_SEQUENCE}
C_CHAR_SEQUENCE			{C_CHAR}+
CHAR_CONSTANT			"\'"{C_CHAR_SEQUENCE}"\'"
CONSTANT 				{INTEGER_CONSANT}|{FLOAT_CONSTANT}|{ENUM_CONSTANT}|{CHAR_CONSTANT}

S_CHAR					[^"\"""\\"\n]|{ESCAPE_SEQUENCE}
S_CHAR_SEQUENCE			{S_CHAR}+
STRING_LITERAL			"\""{S_CHAR_SEQUENCE}?"\""


%%
"//"			{/**/}
"/*"			{ m_comment();}	

"auto"			{ return AUTO; }	
"break"         { return BREAK; }
"case"          { return CASE; }
"char"          { return CHAR; }
"const"         { return CONST; }
"continue"      { return CONTINUE; }
"default"       { return DEFAULT; }
"do"            { return DO; }
"double"        { return DOUBLE; }
"else"          { return ELSE; }
"enum"          { return ENUM; }
"extern"        { return EXTERN; }
"float"         { return FLOAT; }
"for"           { return FOR; }
"goto"          { return GOTO; }
"if"            { return IF; }
"inline"        { return INLINE; }
"int"           { return INT; }
"long"          { return LONG; }
"register"      { return REGISTER; }
"restrict"      { return RESTRICT; }
"return"        { return RETURN; }
"short"         { return SHORT; }
"signed"        { return SIGNED; }
"sizeof"        { return SIZEOF; }
"static"        { return STATIC; }
"struct"        { return STRUCT; }
"switch"        { return SWITCH; }
"typedef"       { return TYPEDEF; }
"union"         { return UNION; }
"unsigned"      { return UNSIGNED; }
"void"          { return VOID; }
"volatile"      { return VOLATILE; }
"while"         { return WHILE; }
"_Bool"         { return _BOOL; }
"_Complex"      { return _COMPLEX; }
"_Imaginary"    { return _IMAGINARY; }

"["				{ return '['; }      
"]"				{ return ']'; }
"("				{ return '('; }
")"				{ return ')'; }
"{"				{ return '{'; }
"}"				{ return '}'; }
"."				{ return '.'; }
"->"			{ return PNTR_OP; }
"++"			{ return INCR_OP; }
"--"			{ return DECR_OP; }
"&"				{ return '&'; }
"*"				{ return '*'; }
"+"				{ return '+'; }
"-"				{ return '-'; }
"~"				{ return '~'; }
"!"				{ return '!'; }
"/"				{ return '/'; }
"%"				{ return '%'; }
"<<"			{ return LS_OP; }
">>"			{ return RS_OP; }
"<"				{ return '<'; }
">"				{ return '>'; }
"<="			{ return LE_OP; }
">="			{ return GE_OP; }
"=="			{ return EQ_OP; }
"!="			{ return NE_OP; }
"^"				{ return '^'; }
"|"				{ return '|'; }
"&&"			{ return AND_OP; }
"||"			{ return OR_OP; }
"?"				{ return '?'; }
":"				{ return ':'; }
";"				{ return ';'; }
"..."			{ return ELLIPSIS; }
"="				{ return '='; }
"*="			{ return MUL_ASGN; }
"/="			{ return DIV_ASGN; }
"%="			{ return MOD_ASGN; }
"+="			{ return ADD_ASGN; }
"-="			{ return SUB_ASGN; }
"<<="			{ return LS_ASGN; }
">>="			{ return RS_ASGN; }
"&="			{ return AND_ASGN; }
"^="			{ return XOR_ASGN; }
"|="			{ return OR_ASGN; }
","				{ return ','; }
"#"				{ return '#'; }

{IDENTIFIER} 			{return IDENTIFIER;}
{FLOAT_CONSTANT}		{return FLOAT_CONSTANT;}
{INT_CONSTANT}			{return INTEGER_CONSTANT;}
{CHAR_CONSTANT}  		{return CHARACTER_CONSTANT;}
{ENUM_CONSTANT}			{return ENUMERATION_CONSTANT;}
{STRING_LITERAL}		{return STRING_LITERAL;}

%%
void m_comment(void) {
	char present, prev  = 0;
	while ((present = input()) != 0) {     
		if (present == '/' && prev == '*')
			return;
		prev = present;
	}
	perror("Unterminated comment\n");
}
