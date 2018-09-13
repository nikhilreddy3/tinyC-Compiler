%{
#define	KEYWORD		10
#define	IDENTIFIER		11
#define	CONSTANT	12
#define	STRING_LITERAL		13
#define	PUNCTUATOR		14
%}

WS 						[ \t]
NEWLINE 				\n
COMMENT 				{SINGLELINE_COMMENT}|{MULTILINE_COMMENT}
SINGLELINE_COMMENT		"//"[^\n]*
NOT_STAR				[^"*"]|\n
NOT_SLASH 				[^"/"]|\n
NOT_SLASH_STAR 			[^"/""*"]|\n
MULTILINE_COMMENT		"/*"{NOT_STAR}*"*"("*"|({NOT_SLASH_STAR}{NOT_STAR}*"*"))*"/"

KEYWORD 				{KEYWORD1}|{KEYWORD2}|{KEYWORD3}|{KEYWORD4}
KEYWORD1				"auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"
KEYWORD2				"enum"|"extern"|"float"|"for"|"goto"|"if"|"inline"|"int"|"long"|"register"
KEYWORD3				"restrict"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"
KEYWORD4				"unsigned"|"void"|"volatile"|"while"|"_Bool"|"_Complex"|"_Imaginary"

IDENTIFIER_NONDIGIT     [a-zA-Z]|"_"
DIGIT					[0-9]
IDENTIFIER 				{IDENTIFIER_NONDIGIT}({IDENTIFIER_NONDIGIT}|{DIGIT})*

NONZERO_DIGIT  			[1-9]
INTEGER_CONSANT 		{NONZERO_DIGIT}{DIGIT}*
SIGN 					"+"|"-"
DIGIT_SEQUENCE			{DIGIT}+
FRACTIONAL_CONSTANT		({DIGIT_SEQUENCE}?"."{DIGIT_SEQUENCE})|({DIGIT_SEQUENCE}".")
EXPONENT_PART			(e|E){SIGN}?{DIGIT_SEQUENCE}
FLOATING_CONSTANT		({FRACTIONAL_CONSTANT}{EXPONENT_PART}?)|({DIGIT_SEQUENCE}{EXPONENT_PART})
ENUMERATOIN_CONSTANT	{IDENTIFIER}
ESCAPE_SEQUENCE			"\\\'"|"\\\""|"\\\?"|"\\\\"|"\\a"|"\\b"|"\\f"|"\\n"|"\\r"|"\\t"|"\\v"|"\\0"
C_CHAR					[^"\'""\\"\n]|{ESCAPE_SEQUENCE}
C_CHAR_SEQUENCE			{C_CHAR}+
CHARACTER_CONSTANT		"\'"{C_CHAR_SEQUENCE}"\'"
CONSTANT 				{INTEGER_CONSANT}|{FLOATING_CONSTANT}|{ENUMERATOIN_CONSTANT}|{CHARACTER_CONSTANT}

S_CHAR					[^"\"""\\"\n]|{ESCAPE_SEQUENCE}
S_CHAR_SEQUENCE			{S_CHAR}+
STRING_LITERAL			"\""{S_CHAR_SEQUENCE}?"\""

PUNCTUATOR  			{PUNCTUATOR1}|{PUNCTUATOR2}|{PUNCTUATOR3}|{PUNCTUATOR4}|{PUNCTUATOR5}|{PUNCTUATOR6}
PUNCTUATOR1 			"["|"]"|"("|")"|"{"|"}"|"."|"->"
PUNCTUATOR2 			"++"|"--"|"&"|"*"|"+"|"-"|"~"|"!"
PUNCTUATOR3 			"/"|"%"|"<<"|">>"|"<"|">"|"<="|">="|"=="|"!="|"^"|"|"|"&&"|"||"
PUNCTUATOR4 			"?"|":"|";"|"..."
PUNCTUATOR5 			"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|="
PUNCTUATOR6				","|"#"

%%
{KEYWORD}				{return KEYWORD;}
{IDENTIFIER} 			{return IDENTIFIER;}
{CONSTANT}				{return CONSTANT;}
{STRING_LITERAL}		{return STRING_LITERAL;}
{PUNCTUATOR}			{return PUNCTUATOR;}
{COMMENT}				{/*Ignore Comments*/}
%%

