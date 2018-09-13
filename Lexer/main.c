#include "lex.yy.c"
int main(int argc,char *argv[]) {
	if(argc>1) 
	{
	if(!(yyin=fopen(argv[1],"r"))) 
	{
		perror(argv[1]);
		return 1;
	}
	}
	int token;
	while (token = yylex()) {
		switch (token) {
			case KEYWORD: 	printf("<KEYWORD, %d, %s>\n", token, yytext);
					break;
			case IDENTIFIER: 	printf("<IDENTIFIER, %d, %s>\n", token, yytext);
				break;
			case STRING_LITERAL: 	printf("<STRING_LITERAL, %d, %s>\n", token, yytext);
				break;
			case PUNCTUATOR: 	printf("<PUNCTUATOR, %d, %s>\n", token, yytext);
				break;
			case CONSTANT: 	printf("<CONSTANT, %d, %s>\n", token, yytext);
				break;
		}
	}
	return 0;
}
