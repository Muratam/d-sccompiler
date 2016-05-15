module smallc.scintermediate;
import pegged.grammar;
import std.stdio,std.algorithm,std.math,std.range,std.string,std.conv;
import smallc.scdef,smallc.sctrim,smallc.scsemanticanalysis;

enum EType {Int,Intptr,Intptrptr}

struct Var {
	string name;
	EType type;
	int level;
	int arrayNum = 0;
	static Var make(SCTree t,int level){
		auto id = t.searchByTag("ID");
		auto type = new SCType( t.searchByTag("Type_info"));
		EType res = EType.Int;
		if (type.type == "int *") res = EType.Intptr;
		if (type.type == "int * *") res = EType.Intptrptr;
		int arrayNum = 0;
		if (t.canFindByTag("array"))
			arrayNum = t.searchByTag("array").val.to!int;
		return Var(id.val,res,level,arrayNum);
	}
	public string toString() const {
		return "("
			~ name ~ ":"
			~ type.to!string ~ ","
			~ level.to!string
			~ (arrayNum > 0 ?",[" ~ arrayNum.to!string ~ "]": "") ~ ")";
	}
}

class Global{
	public Var_def[] var_defs = [];
	public Fun_def[] fun_defs = [];
	public this (SCTree t){
		Var_def.init();
		LabelStmt.init();
		if (t.tag == "SC")t = t.hits[0];
		assert (t.tag == "Global");
		foreach(h;t.hits){
			switch(h.tag){
			case "Var_def":
				var_defs ~= new Var_def(Var.make(h,0));	
				break;
			case "Fun_def":
				fun_defs ~= new Fun_def(h); 
				break;
			default:break;
			}
		}
	}
	public override string toString() const {
		string res = "Global IRTree :\n";
		if (var_defs.length > 0)
			res ~= var_defs.map!(a => a.toString()).fold!`a~"\n"~b` ~ "\n";
		if (fun_defs.length > 0)
			res ~= fun_defs.map!"a.toString()".fold!`a~"\n"~b`;
		return  res ;
	}
}
class Var_def {
	public Var var;
	static int tempIndex = 0; 
	public this(Var var){
		this.var = var;
		varList ~= var;
	}
	static Var_def temp(EType type,int level){
		tempIndex ++;			
		return new Var_def(Var("#x" ~ tempIndex.to!string,type,level));
	}
	public override string toString() const {
		return "Var_def " ~ var.toString() ~ " ";
	}
	static Var[] varList = [];
	public static Var searchVar(string id,int level){
		foreach_reverse(v;varList){
			if (v.name != id) continue;
			if (v.level > level) continue;
			return v;
		}
		assert(true);
		return varList[0];
	}
	public static void init(){
		tempIndex = 0;
		varList = [];
	}
}
class Fun_def{
	public Var var;
	public Var[] params = [];
	public CmpdStmt cmpdStmt;
	public this (SCTree t){
		assert (t.tag == "Fun_def");
		auto declare = t.searchByTag("Fun_declare");
		var = Var.make(declare,0);
		if(declare.hits.length > 2){
			foreach(h;declare.hits[2..$]){
				params ~= Var.make(h,1);
			}
		}
		cmpdStmt = new CmpdStmt(t.hits[1],2);
	}

	public override string toString () const {
		string res = "func " ~ var.toString() ~ "\n  : params[";
		if (params.length > 0)
			res ~= params.map!"a.toString()".fold!"a~','~b";
		res ~= "]\n  : " ~ cmpdStmt.toString() ;
		return res;
	}
}
class CmpdStmt : Stmt{
	public Var_def[] vars;
	public Stmt[] stmts;
	public int level;
	AssignStmt makeTemp(EType type,Expr expr){
		auto temp = Var_def.temp(type,this.level);
		vars ~= temp;
		auto assigned = new AssignStmt(temp.var,expr);
		stmts ~= assigned;
		return assigned;
	}
	AssignStmt addExpr(SCTree t){
		assert(t.tag == "Expr");		
		final switch(t.hits.length){
		case 1:
			final switch(t.hits[0].tag){
			case "NUM":
				return makeTemp(EType.Int,new LitExpr(t.hits[0].val.to!int));
			case "ID":
				auto assigned = Var_def.searchVar(t.hits[0].val,level);
				return new AssignStmt(assigned,new VarExpr(assigned));
			//case "Apply"://print
			}
		case 2:
			auto added1 = addExpr(t.hits[1]);
			string op = t.hits[0].val;
			final switch(op){
			case "&":
				assert (added1.var.type == EType.Int);
				return makeTemp(EType.Intptr,new AddrExpr(added1.var));
			case "*"://temp = *(added1)
				assert (added1.var.type != EType.Int);
				auto type = added1.var.type == EType.Intptr ? EType.Int: EType.Intptr;
				auto temp = Var_def.temp(type,this.level);
				vars ~= temp;
				auto read = new ReadMemStmt(temp.var,added1.var);
				stmts ~= read;
				return new AssignStmt(temp.var,new VarExpr(temp.var));
			}
		case 3:
			string op = t.hits[1].val;
			if (op == "=" && t.hits[0].hits.length == 2 && t.hits[0].hits[0].val == "*"){
				//*(a+2) = added2
				auto added2 = addExpr(t.hits[2]);
				auto ptr = addExpr(t.hits[0].hits[1]);
				auto wrote = new WriteMemStmt(ptr.var,added2.var);
				stmts ~= wrote;
				return added2;
			}
			auto added1 = addExpr(t.hits[0]);
			auto added2 = addExpr(t.hits[2]);
			final switch(op){				
			//case "||":case "&&"
			case ",":
				return added2;
			case "+":case "-":
				if(added1.var.type != EType.Int || added2.var.type != EType.Int){
					auto ptr = added1.var.type == EType.Int ? added2:added1;
					auto num = added1.var.type == EType.Int ? added1:added2;
					return makeTemp(ptr.var.type,new AopExpr(op,ptr.var,num.var));
				}
			case "*":case "/":
				return makeTemp(EType.Int, new AopExpr(op,added1.var,added2.var));
			case "==":case "!=":case "<":case ">":case "<=":case ">=":
				return makeTemp(EType.Int, new AopExpr(op,added1.var,added2.var));
			case "=":
				auto assigned = new AssignStmt(added1.var,new VarExpr(added2.var));
				stmts ~= assigned;
				return assigned;
			}
		}
	}

	void addIfStmt(SCTree expr,SCTree tStmt,SCTree fStmt){
		auto var = addExpr(expr);
		auto tlabel = LabelStmt.temp();
		auto flabel = LabelStmt.temp();
		auto finlabel = LabelStmt.temp();
		stmts ~= new IfStmt(var.var,new GotoStmt(tlabel),new GotoStmt(flabel));
		stmts ~= tlabel;
		addStmt(tStmt);
		stmts ~= new GotoStmt(finlabel);
		stmts ~= flabel;
		addStmt(fStmt);
		stmts ~= finlabel;
		return;
	}

	void addStmt(SCTree t){
		if(t.tag == "Var_def"){
			vars ~= new Var_def(Var.make(t,level));
			return;
		}
		if (t.hits.length == 0) return;
		assert(t.tag == "Stmt");
		switch(t.hits[0].val){
		case "if":
			addIfStmt(t.hits[1],t.hits[2],t.hits[3]);
			return;
		case "for":
			//for(1;2;3)a; => 1;while(2){a;3} => 1;L0;if(2 :L1:L2){L1;a;3;goto L0;};L2;
			auto loopProdLabel = LabelStmt.temp();
			auto whileMainLabel = LabelStmt.temp();
			auto loopfinishLabel = LabelStmt.temp();
			auto var1 = addExpr(t.hits[1]);
			stmts ~= loopProdLabel;
			auto var2 = addExpr(t.hits[2]);
			stmts ~= new IfStmt(
					 var2.var
					,new GotoStmt(whileMainLabel)
					,new GotoStmt(loopfinishLabel));
			stmts ~= whileMainLabel;
			addStmt(t.hits[4]);
			auto var3 = addExpr(t.hits[3]);
			stmts ~= new GotoStmt(loopProdLabel);
			stmts ~= loopfinishLabel;
			return;
		case "return":
			if(t.hits.length == 1){				 
				auto ret = makeTemp(EType.Int,new LitExpr(0));
				stmts ~= new ReturnStmt(ret.var);
			}else{
				auto ret = addExpr(t.hits[1]);
				stmts ~= new ReturnStmt(ret.var);
			}
			return;
		default:
			break;
		}
		switch(t.hits[0].tag){
		case "Expr":
			addExpr(t.hits[0]);
			return;
		case "Stmts":
			stmts ~= new CmpdStmt(t.hits[0],level+1);
			return;
		default:
			return;
		}
	}
	public this(SCTree t,int level){
		assert(t.tag == "Stmts");
		this.level = level;
		foreach(h;t.hits){addStmt(h);}
	}
	public override string toString () const {
		auto tab = "";
		foreach(i;iota(level))tab ~= "  ";
		auto res = "CmpdStmt : ";
		if (vars.length > 0)
			res ~= vars.map!(a=>"\n" ~ tab ~ a.toString()).fold!"a~b";
		if (stmts.length > 0)
			res ~= stmts.map!(a=>"\n" ~ tab ~ a.toString()).fold!"a~b";
		return res ;
	}
}
class Stmt {
	public this(){}
	public override string toString () const {
		return "Stmt";
	}
}
class AssignStmt : Stmt{ 
	public Var var;
	public Expr expr;
	public this(Var var,Expr expr){
		this.var = var;
		this.expr = expr;
	}
	public override string toString () const {
		return "AssignStmt : " ~ var.toString() ~ " <" ~ expr.toString() ~ ">";
	}
}
// *(a + 3) = b ; a:intptr ,b:int ; a:intptrtpr ,b:intptr 
class WriteMemStmt : Stmt{
	public Var dest,src;
	public this(Var dest,Var src){
		this.dest = dest;
		this.src = src;
	}
	public override string toString() const {
		return "WriteMemStmt :" ~  dest.toString() ~ " <- " ~ src.toString();
	}
}
// b = *(a + 3); 
class ReadMemStmt : Stmt{ 
	public Var dest,src;
	public this(Var dest,Var src){
		this.dest = dest;
		this.src = src;
	}
	public override string toString() const {
		return "ReadMemStmt :" ~  dest.toString() ~ " <- " ~ src.toString();
	}
}
class IfStmt : Stmt{
	public Var var;
	public GotoStmt tlabel,flabel;
	public this (Var var,GotoStmt tlabel,GotoStmt flabel){
		this.var = var;
		this.tlabel = tlabel;
		this.flabel = flabel;			
	}
	public override string toString() const {
		return "IfStmt : " ~ var.toString() ~"["~ tlabel.toString() ~ "," ~ flabel.toString()~"]";
	}
}
class GotoStmt : Stmt{ 
	public string label; 
	public this (LabelStmt label){
		this.label = label.name;
	}
	public override string toString() const{
		return "GotoStmt : " ~ label;
	}
}
class ApplyStmt : Stmt{ 
	public Var dest,target;
	public Var[] args;
	public this (){}

}
class ReturnStmt : Stmt{ 
	public Var var;
	public this (Var var){
		this.var = var;
	}
	public override string toString () const {
		return "ReturnStmt : " ~ var.toString();
	}
}
class PrintStmt : Stmt{
	public Var var;
}
class LabelStmt : Stmt{
	public string name;
	static int tempIndex = 0;
	this(string name){this.name = name;}
	public override string toString () const {
		return "LabelStmt : " ~ name;
	}
	public static LabelStmt temp(){
		tempIndex ++;
		return new LabelStmt("#label" ~ tempIndex.to!string);
	}
	public static void init(){tempIndex = 0;}
}


class Expr{
	public this(){}
	public override string toString () const {
		return "Expr";
	}
}
class VarExpr : Expr{
	public Var var;
	public this(Var var){this.var = var;}
	public override string toString () const {
		return "VarExpr " ~ var.toString();
	}
}
class LitExpr : Expr{
	public int num;
	public this (int num){this.num = num;}
	public override string toString () const {
		return "LitExpr " ~ num.to!string;
	}
}
class AopExpr : Expr{ // + - * /
	public string Op;
	public Var L,R;
	public this (string Op,Var L,Var R){
		this.Op = Op;
		this.L = L;
		this.R = R;
	}
	public override string toString () const {
		return "AopExpr " ~ L.toString() ~ " \"" ~ Op ~ "\" " ~ R.toString() ;
	}
}
class AddrExpr : Expr{ //&(a)
	public Var var;
	public this(Var var){
		this.var = var;
	}
	public override string toString() const {
		return "AddrExpr " ~ var.toString() ;
	}
}