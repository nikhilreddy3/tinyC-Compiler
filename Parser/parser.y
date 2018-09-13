%{
	#include <stdio.h>
	#include <string.h>

	extern int yylex();
	void yyerror(char *s);
%}

%union {
int intval;
}

%token EXTERN STATIC AUTO REGISTER
%token VOID CHAR SHORT INT LONG FLOAT DOUBLE SIGNED UNSIGNED
%token _BOOL _COMPLEX _IMAGINARY
%token SIZEOF ENUM CONST RESTRICT VOLATILE INLINE TYPEDEF UNION STRUCT
%token CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK
%token RETURN

%token RS_ASGN LS_ASGN ADD_ASGN SUB_ASGN MUL_ASGN ELLIPSIS 
%token DIV_ASGN MOD_ASGN AND_ASGN XOR_ASGN OR_ASGN 
%token INCR_OP DECR_OP PNTR_OP LS_OP RS_OP LE_OP GE_OP EQ_OP NE_OP AND_OP OR_OP

%token IDENTIFIER STRING_LITERAL COMMENT
%token INTEGER_CONSTANT FLOAT_CONSTANT ENUMERATION_CONSTANT CHARACTER_CONSTANT

%start translation_unit

%%

primary_expression:	  IDENTIFIER
					| constant	
					| STRING_LITERAL
					| '(' expression ')'
					{ printf("primary_expression\n");}
					;

constant:
					  INTEGER_CONSTANT
					| FLOAT_CONSTANT
					| ENUMERATION_CONSTANT
					| CHARACTER_CONSTANT
					{ printf("constant\n"); }
					;

postfix_expression:	  primary_expression
					| postfix_expression '[' expression ']'
					| postfix_expression '(' argument_expression_list_opt ')'
					| postfix_expression '.' IDENTIFIER
					| postfix_expression PNTR_OP IDENTIFIER
					| postfix_expression INCR_OP
					| postfix_expression DECR_OP
					| '(' type_name ')' '{' initializer_list '}'
					| '(' type_name ')' '{' initializer_list '}'
					{ printf("postfix_expression\n"); } 
					;

argument_expression_list_opt:
					  %empty 
					| argument_expression_list
					;

argument_expression_list:
					  assignment_expression
					| argument_expression_list ',' assignment_expression
					{ printf("argument_expression_list\n"); }
					;

unary_expression:	  postfix_expression
					| INCR_OP unary_expression
					| DECR_OP unary_expression
					| unary_operator cast_expression
					| SIZEOF unary_expression
					| SIZEOF '(' type_name ')'
					{ printf("unary_expression\n"); }
					;

unary_operator:		  '&'
					| '*'
					| '+'
					| '-'
					| '~'
					| '!'
					{ printf("unary_operator\n"); }
					;

cast_expression:	  unary_expression
					| '(' type_name ')' cast_expression
					{ printf("cast_expression\n"); }	
					;

multiplicative_expression:
					  cast_expression
					| multiplicative_expression '*' cast_expression
					| multiplicative_expression '/' cast_expression
					| multiplicative_expression '%' cast_expression
					{ printf("multiplicative_expression\n"); }
					;

additive_expression:
					  multiplicative_expression
					| additive_expression '+' multiplicative_expression
					| additive_expression '-' multiplicative_expression
					{ printf("additive_expression\n"); }
					;

shift_expression:	  additive_expression
					| shift_expression LS_OP additive_expression
					| shift_expression RS_OP additive_expression
					{ printf("shift_expression\n"); }
					;

relational_expression:
					  shift_expression
					| relational_expression '<' shift_expression
					| relational_expression '>' shift_expression
					| relational_expression LE_OP shift_expression
					| relational_expression GE_OP shift_expression
					{ printf("relational_expression\n"); }
					;

equality_expression:
					  relational_expression
					| equality_expression EQ_OP relational_expression
					| equality_expression NE_OP relational_expression
					{ printf("equality_expression\n"); }
					;

AND_expression:		  equality_expression
					| AND_expression '&' equality_expression
					{ printf("AND_expression\n"); }
					;

exclusive_OR_expression:
					  AND_expression
					| exclusive_OR_expression '^' AND_expression
					{ printf("exclusive_OR_expression\n"); }
					;

inclusive_OR_expression:
					  exclusive_OR_expression
					| inclusive_OR_expression '|' exclusive_OR_expression
					{ printf("inclusive_OR_expression\n"); }
					;

logical_AND_expression:
					  inclusive_OR_expression
					| logical_AND_expression AND_OP inclusive_OR_expression
					{ printf("logical_AND_expression\n"); }
					;

logical_OR_expression:
					  logical_AND_expression
					| logical_OR_expression OR_OP logical_AND_expression
					{ printf("logical_OR_expression\n"); }
					;

conditional_expression:
					  logical_OR_expression
					| logical_OR_expression '?' expression ':' conditional_expression
					{ printf("conditional_expression\n"); }
					;

assignment_expression:
					  conditional_expression
					| unary_expression assignment_operator assignment_expression
					{ printf("assignment_expression\n"); }
					;

assignment_operator:  '='
					| MUL_ASGN
					| DIV_ASGN
					| MOD_ASGN
					| ADD_ASGN
					| SUB_ASGN
					| LS_ASGN
					| RS_ASGN
					| AND_ASGN
					| XOR_ASGN
					| OR_ASGN
					{ printf("assignment_operator\n"); }
					;

expression_opt:		  %empty
					| expression
					;

expression:			  assignment_expression
					| expression ',' assignment_expression
					{ printf("expression\n"); }
					;

constant_expression:  conditional_expression
					{ printf("constant_expression\n"); }
					;

declaration:		  declaration_specifiers init_declarator_list_opt ';'
					{ printf("declaration\n"); }
					;

declaration_specifiers_opt:
					  %empty
					| declaration_specifiers
					{ printf("declaration_specifiers_opt\n"); }
					;

declaration_specifiers:
					  storage_class_specifier declaration_specifiers_opt
					| type_specifier declaration_specifiers_opt
					| type_qualifier declaration_specifiers_opt
					| function_specifier declaration_specifiers_opt
					{ printf("declaration_specifiers\n"); }
					;

init_declarator_list_opt:
					  %empty
					| init_declarator_list
					{ printf("init_declarator_list_opt\n"); }
					;

init_declarator_list:
					  init_declarator
					| init_declarator_list ',' init_declarator
					{ printf("init_declarator_list\n"); }
					;

init_declarator:      declarator
					| declarator '=' initializer
					{ printf("init_declarator\n"); }
					;

storage_class_specifier:
					  EXTERN
					| STATIC
					| AUTO
					| REGISTER
					{ printf("storage_class_specifier\n"); }
					;

type_specifier:		  VOID
					| CHAR
					| SHORT
					| INT
					| LONG
					| FLOAT
					| DOUBLE
					| SIGNED
					| UNSIGNED
					| _BOOL
					| _COMPLEX
					| _IMAGINARY
					| enum_specifier
					{ printf("type_specifier\n"); }
					;

specifier_qualifier_list_opt:
					  specifier_qualifier_list
					| %empty
					{ printf("specifier_qualifier_list_opt\n"); }
					;

specifier_qualifier_list:
					  type_specifier specifier_qualifier_list_opt
					| type_qualifier specifier_qualifier_list_opt
					{ printf("specifier_qualifier_list\n"); }
					;

IDENTIFIER_opt:		  %empty
					| IDENTIFIER
					{ printf("IDENTIFIER_opt\n"); }
					;

enum_specifier:		  ENUM IDENTIFIER_opt '{' enumerator_list '}'
					| ENUM IDENTIFIER_opt '{' enumerator_list '}'
					| ENUM IDENTIFIER
					{ printf("enum_specifier\n"); }
					;

enumerator_list:      enumerator
					| enumerator_list ',' enumerator
					{ printf("enumerator_list\n"); }
					;

enumerator:			  IDENTIFIER
					| IDENTIFIER '=' constant_expression
					{ printf("enumerator\n"); }

type_qualifier:		  CONST
					| RESTRICT
					| VOLATILE
					{ printf("type_qualifier\n"); }
					;

function_specifier:   INLINE
					{ printf("function_specifier\n"); }
					;

declarator:			  pointer_opt direct_declarator
					{ printf("declarator\n"); }
					;

direct_declarator:    IDENTIFIER
					| '(' declarator ')'
					| direct_declarator '[' type_qualifier_list_opt assignment_expression  ']'
					| direct_declarator '[' STATIC type_qualifier_list_opt  assignment_expression  ']'
					| direct_declarator '[' type_qualifier_list STATIC assignment_expression  ']'
					| direct_declarator '[' type_qualifier_list_opt '*' ']'
					| direct_declarator '(' parameter_type_list ')'
					| direct_declarator '(' identifier_list_opt ')'
					{ printf("direct_declarator\n"); }
					;

pointer_opt:		  %empty
					| pointer
					{ printf("pointer_opt\n"); }
					;

pointer:			  '*' type_qualifier_list_opt
					| '*' type_qualifier_list_opt pointer
					{ printf("pointer\n"); }
					;

type_qualifier_list_opt:
					  %empty
					| type_qualifier_list
					;

type_qualifier_list:
					  type_qualifier
					| type_qualifier_list type_qualifier
					{ printf("type_qualifier_list\n"); }
					;

parameter_type_list:
					  parameter_list
					| parameter_list ',' ELLIPSIS
					{ printf("parameter_type_list\n"); }
					;

parameter_list:		  parameter_declaration
					| parameter_list ',' parameter_declaration
					{ printf("parameter_list\n"); }
					;

parameter_declaration:
					  declaration_specifiers declarator
					| declaration_specifiers
					{ printf("parameter_declaration\n"); }
					;

identifier_list_opt:
					  %empty
					| identifier_list
					;

identifier_list:	  IDENTIFIER
					| identifier_list ',' IDENTIFIER
					{ printf("identfier_list\n"); }
					;

type_name:			  specifier_qualifier_list
					{ printf("type_name\n"); }
					;

initializer:		  assignment_expression
					| '{' initializer_list '}'
					| '{' initializer_list ',' '}'
					{ printf("initializer\n"); }
					;

initializer_list:	  designation_opt initializer
					| initializer_list ',' designation_opt initializer
					{ printf("\n"); }
					;

designation_opt:	  %empty
					| designation
					;

designation:		  designator_list '='
					{ printf("designation\n"); }
					;	

designator_list:	  designator
					| designator_list designator
					{ printf("designator_list\n"); }
					;

designator:			  '[' constant_expression ']'
					| '.' IDENTIFIER
					{ printf("designator\n"); }
					;	  

statement:			  labeled_statement
					| compound_statement
					| expression_statement
					| selection_statement
					| iteration_statement
					| jump_statement
					{ printf("statement\n"); }
					;

labeled_statement: 	  IDENTIFIER ':' statement
					| CASE constant_expression ':' statement
					| DEFAULT ':' statement
					{ printf("labeled_statement\n"); }
					;

compound_statement:   '{' block_item_list_opt '}'
					{ printf("compound_statement\n"); }
					;

block_item_list_opt:		
					  %empty
					| block_item_list
					;

block_item_list:	  block_item
					| block_item_list block_item
					{ printf("block_item_list\n"); }
					;			  

block_item:			  declaration
					| statement
					{ printf("block_item\n"); }
					;

expression_statement:
					  expression_opt ';'
					{ printf("expression_statement\n"); }
					;

selection_statement:
					  IF '(' expression ')' statement
					| IF '(' expression ')' statement ELSE statement
					| SWITCH '(' expression ')' statement
					{ printf("selection_statement\n"); }
					;


iteration_statement:
					  WHILE '(' expression ')' statement
					| DO statement WHILE '(' expression ')' ';'
					| FOR '(' expression_opt ';' expression_opt ';' expression_opt ')' statement
					| FOR '(' declaration expression_opt ';' expression_opt ')' statement
					{ printf("iteration_statement\n"); }
					;

jump_statement:		  GOTO IDENTIFIER
					| CONTINUE ';'
					| BREAK ';'
					| RETURN expression_opt ';'

translation_unit:	  external_declaration
					| translation_unit external_declaration
					{ printf("translational_unit\n"); }
					;

external_declaration:
					  function_definition
					| declaration
					{ printf("external_declaration\n"); }
					;

function_definition:
					  declaration_specifiers declarator declaration_list_opt compound_statement
					{ printf("function_definition\n"); }
					;

declaration_list_opt:
					  declaration_list
					| %empty
					;

declaration_list:	  declaration
					| declaration_list declaration
					{ printf("declaration_list\n"); }
					;

%%
void yyerror(char *s) {
	printf ("\nERROR: %s\n",s);
}















