module smallc.scdef;
const makeModule = false;

const scdefstr = `SC:
	Global   <- (Var_def / Fun_proto / Fun_def)+ endOfInput?
	Var_def  < Type Declare (:',' Declare)* :';'
	Fun_proto < Fun_declare ';'
	Fun_def  < Fun_declare Stmts
	Fun_declare < Type Def_ID :'(' Param? (:',' Param)* :')'
	Param    < Type Def_ID
	Stmts    < ^'{' Var_def* Stmt* :'}' 
	Stmt     < ^';' 
             / ^'if' :'(' Expr :')' Stmt (:'else' Stmt)?
             / ^'while' :'(' Expr :')' Stmt               
             / ^'for' :'(' Expr? ^';' Expr? ^';' Expr? ^')' Stmt
             / ^'return' Expr? :';'
             / Stmts / Expr :';'
	Expr < Expr ^','  EB00 / EB00
	EB00 < EB01 ^'='  EB00 / EB01 
	EB01 < EB01 ^'||' EB02 / EB02
	EB02 < EB02 ^'&&' EB03 / EB03
	EB03 < EB03 (^'==' / ^'!=') EB04 / EB04
	EB04 < EB04 (^'<=' / ^'>=' / ^'<' / ^'>') EB05 / EB05
	EB05 < EB05 (^'+' / ^'-') EB06 / EB06
	EB06 < EB06 (^'*' / ^'/') Postfix_expr / Postfix_expr
	Postfix_expr < (^'-' / ^'&' / ^'*') Postfix_expr / Unary_expr
	Unary_expr   < Apply / Array / Primary_expr
	Primary_expr < ID / NUM / :'(' Expr :')'	
	Apply    < ID :'(' EB00? (:',' EB00)* :')'
	Array    < Primary_expr (:'[' Expr :']' )+
	Type     < 'int' / 'void'
	Declare  < Def_ID (:'[' NUM ']')? 
	Def_ID   < (^'*')? ID
	ID       < !Keyword identifier
	NUM      < ~([0-9]+)
	Keyword  < Type / 'if' / 'while' / 'for' / 'return' 
`;
//	Spacing  < (space / endOfLine)+