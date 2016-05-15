module smallc.scintermediate;
import pegged.grammar;
import std.stdio,std.algorithm,std.math,std.range,std.string,std.conv;
import smallc.scdef,smallc.sctrim,smallc.scsemanticanalysis;

enum EType {Int,Intptr,Intptrptr}
struct Var {
	string name;
	EType type;
	int level;
	static Var make(SCTree t,int level){
		auto id = t.searchByTag("ID");
		auto type = new SCType( t.searchByTag("Type_info"));
		EType res = EType.Int;
		if (type.type == "int *") res = EType.Intptr;
		if (type.type == "int * *") res = EType.Intptrptr;
		return Var(id.val,res,level);
	}
	public string toString() const {
		return "(" ~ name ~ " : " ~ type.to!string ~ " , " ~ level.to!string ~ ")";
	}
}

class Global{
	public Var_def[] var_defs;
	public Fun_def[] fun_defs;
	public this (SCTree t){
		if (t.tag == "SC")t = t.hits[0];
		assert (t.tag == "Global");
		foreach(h;t.hits){
			switch(h.tag){
			case "Var_def":
				var_defs ~= new Var_def(Var.make(h,0));	
				break;
			case "Fun_def":
				//fun_def ~=  
				break;
			default:break;
			}
		}
	}
	public override string toString() const {
		return "[" ~ var_defs.map!(a => a.toString()).fold!"a~','~b" ~ "]";
	}
}
class Var_def{
	public Var var;
	private static int tempIndex = 0; 
	public this(Var var){this.var = var;}
	static Var_def temp(EType type,int level){
		tempIndex ++;			
		return new Var_def(Var("#x" ~ tempIndex.to!string,type,level));
	}
	public override string toString() const {
		return "Var_def " ~ var.toString() ~ " ";
	}
}
class Fun_def{
	public Var var;
	public Var[] params;
	public Stmts stmts;
}
class Stmts {
	public Var_def[] vars;
	public Stmt[] stmts;
}
class Stmt {}
class SAssign : Stmt{ 
	public Var var;
	public Expr expr;
}
class SWriteMem : Stmt{
	public Var dest,src;
}
class SReadMem : Stmt{ 
	public Var dest,src;
}
class SIf : Stmt{
	public Var var;
	public SLabel l1,l2;
}
class SGoto : Stmt{ 
	public SLabel label; 
}
class SApply : Stmt{ 
	public Var dest,target;
	public Var[] args;
}
class SReturn : Stmt{ 
	public Var var;
}
class SPrint : Stmt{
	public Var var;
}
class SLabel : Stmt{
	public string name;
	static int tempIndex = 0;
	this(string name){this.name = name;}
	public static SLabel temp(){
		tempIndex ++;
		return new SLabel("#label" ~ tempIndex.to!string);
	}
}
class Expr{}
class EVar : Expr{
	public Var var;
}
class ELit : Expr{
	public int num;
}
class EAop : Expr{ // + - * /
	public string Op;
	public Expr L,R;
}
class ERop : Expr{
	public string Op;
	public Expr L,R;
}
class EAddr : Expr{ //&a
	public Var var;
}
// & : int => int*
// * : int* => int
//   : int** => int
// - : int,int => int
//   : int*,int => int*
//   : int**,int => int**
//int a; -a;
//int*a; *(a - 10 )
//int*a[3];
//int a(){int*a[3],b;a = &&a;}
/+
//Global
this(ParseTree p){
	if (p.name == "SC") p = p.children[0];
	foreach(c;p.children){
		switch(c.name){
			case "SC.Var_def": vars ~= Var_def.make(c,0);break;				
			case "SC.Fun_def": funs ~= Fun_def(c);break;
			//prototype ignore
			default:
		}
	}
}
static Var_def[] make(ParseTree p,int level){
	Var_def[] res;
	foreach(c;p.children[1..$]){
		string id = raw(c).val;
		EType type = EType.Int;
		if (raw(c).generic == "ptr" || raw(c).generic == "array")
			type = EType.Intptr;
		res ~= Var_def(Decl(id,type,level));
	}
	return res;
}
//Fun_def
	this(ParseTree p){
		auto fun_declare = p.children[0];
		auto returnType = raw(fun_declare.children[0]).val;
		auto returnTypeGeneric = raw(fun_declare.children[1]).generic;
		auto id = raw(fun_declare.children[1]).val;
		if (returnTypeGeneric == "")var = Decl(id,EType.Int,0);	
		else var = Decl(id,EType.Intptr,0);
		if (fun_declare.children.length > 2) {
			foreach(param;fun_declare.children[2..$]){
				auto envtr = raw(param.children[0]).val;
				auto pid  = raw(param.children[1]).val;
				auto ptypegeneric  = raw(param.children[1]).generic;
				if (ptypegeneric == "")params ~= Decl(pid,EType.Int,1);	
				else params ~= Decl(pid,EType.Intptr,1);
			}
		}
		stmts = Stmts(p.children[1],2);
	}
//Stmts
	this(ParseTree p,int level){
		foreach(c;p.children){
			switch(c.name){
				case "SC.Var_def": vars ~= Var_def.make(c,level);break;
				case "SC.Stmt": stmts ~= Stmt(c,level);break;
				default : 
			}
		}
	}
//Stmt
	string toString(){
		switch(tag){
			case EStmt.Assign:return sassign.to!string;
			case EStmt.WriteMem:return swritemem.to!string;
			case EStmt.ReadMem:return sreadmem.to!string;
			case EStmt.Label:return slabel.to!string;
			case EStmt.If:return sif.to!string;
			case EStmt.Goto:return sgoto.to!string;
			case EStmt.Apply:return sapply.to!string;
			case EStmt.Return:return sreturn.to!string;
			case EStmt.Print:return sprint.to!string;
			case EStmt.Stmts:return stmts.to!string;
			default:break;
		}
		return "";
	}		
	this (ParseTree p,int level){
		switch(p.children[0].matches[0]){
			case "if":{ 
				tag = EStmt.If;					
			}
			default:break;
		}
		switch(p.children[0].name){
			case "SC.Expr":{
			}
			case "SC.Stmts":{
			}
			default:break;
		}
	}		

+/