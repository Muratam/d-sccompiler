/+
import pegged.grammar;
import std.stdio,std.algorithm,std.math,std.range,std.string,std.conv;
import scdef;
import scsemanticanalysis;
static if(!makeModule){
	struct IRTree{
		string tag;
		string val;
		IRTree[] nodes;
	}
	enum EType {Int,Intptr,Intptrptr,Void}
	struct Decl {
		string name;
		EType type;
		int level;
	}
	struct Global{
		Var_def[] vars;
		Fun_def[] funs;
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
	}
	struct Var_def{
		Decl var;
		private static int tempIndex = 0; 
		static Var_def temp(EType type,int level){
			tempIndex ++;			
			return Var_def(Decl("#x" ~ tempIndex.to!string,type,level));
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
	}
	struct Fun_def{
		public Decl var;
		public Decl[] params;
		public Stmts stmts;
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
	}
	struct Stmts {
		public Var_def[] vars;
		public Stmt[] stmts;
		this(ParseTree p,int level){
			foreach(c;p.children){
				switch(c.name){
					case "SC.Var_def": vars ~= Var_def.make(c,level);break;
					case "SC.Stmt": stmts ~= Stmt(c,level);break;
					default : 
				}
			}
		}
	}
	struct Stmt {
		enum EStmt{Assign,WriteMem,ReadMem,Label,If,Goto,Apply,Return,Print,Stmts}
		EStmt tag;		
		SAssign	sassign;
		SWriteMem swritemem;
		SReadMem sreadmem;
		SLabel	slabel;
		SIf	sif;
		SGoto	sgoto;
		SApply	sapply;
		SReturn	sreturn;
		SPrint	sprint;
		Stmts stmts;
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
	}
	struct SAssign{ Decl var;Expr expr;}
	struct SWriteMem{ Decl dest,src;}
	struct SReadMem{ Decl dest,src;}
	struct SIf{	Decl var;SLabel l1,l2;}
	struct SGoto{ SLabel label; }
	struct SApply{ Decl dest,target;Decl[] params;}
	struct SReturn{ Decl var;}
	struct SPrint{	}
	struct SLabel{
		string name;
		static int tempIndex = 0;
		static SLabel temp(){
			tempIndex ++;
			return SLabel("#label" ~ tempIndex.to!string);
		}
	}
	struct Expr{
	}

}
+/