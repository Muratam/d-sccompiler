module smallc.scintermediateclasses;
import pegged.grammar;
import std.stdio,std.algorithm,std.math,std.range,std.string,std.conv;
import smallc.scdef,smallc.sctrim,smallc.scsemanticanalysis;
import smallc.scmips;


enum EType {Int,Intptr,Intptrptr,Void,Offset}
class Var {
	public string name;
	public EType type;
	public int level;
	public int arrayNum = 0;
	public R ptr = R.sp;
	public bool isArray(){return arrayNum > 0;}
	public this (string name,EType type,int level,int arrayNum = 0,R ptr = R.sp){
		this.name = name;
		this.level = level;
		this.arrayNum = arrayNum;
		this.type = type;
		this,ptr = ptr;
	}
	public this (SCTree t,int level,R ptr = R.sp){
		this.type = 
			new SCType(t.find("Type_info")).type.predSwitch(
				"int *",EType.Intptr,
				"int * *",EType.Intptrptr,
				"void", EType.Void,
				EType.Int);
		this.name = t.find("ID").elem;
		this.level = level;
		if (t.has("array")) 
			this.arrayNum = t.find("array").elem.to!int;
		this.ptr = ptr;
	}
	public override string toString() const {
		return "("
			~ name ~ ":"
				~ (ptr == R.sp ? "": ptr == R.fp ? "fp:":ptr == R.gp ? "gp:" : "!?")
				~ type.to!string 
				~ (type == EType.Offset ? "": "," ~ level.to!string)			
				~ (arrayNum > 0 ?",[" ~ arrayNum.to!string ~ "]": "") ~ ")";
	}
	//["a":[(),(),()]]
	@property public int ROffset(){
		assert(name.startsWith("$"));
		return name[1..$].to!int;
	} 
}


class Global{
	public Var_def[] var_defs = [];
	public Fun_def[] fun_defs = [];
	public this (SCTree t){
		Var_def.init();
		Fun_def.init();
		LabelStmt.init();
		if (t.tag == "SC")t = t[0];
		assert (t.tag  == "Global");
		foreach(h;t){
			switch(h.tag ){
				case "Var_def":
					var_defs ~= new Var_def(new Var(h,0,R.gp));	
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
	bool offseted = false;
	
}
class Var_def {
	public Var var;
	static int tempIndex = 0; 
	this(Var var){
		this.var = var;
		varList ~= this.var;
	}
	static Var_def temp(EType type,int level){
		tempIndex ++;			
		return new Var_def(new Var("#x" ~ tempIndex.to!string,type,level));
	}
	public override string toString() const {
		return "Var_def " ~ var.toString() ~ " ";
	}
	static Var[] varList = [];
	static Var searchVar(string id,int level){
		foreach_reverse(v;varList){
			if (v.name != id) continue;
			if (v.level > level) continue;
			return v;
		}
		assert(0);
	}
	static void init(){
		tempIndex = 0;
		varList = [];
	}
}
class Fun_def{
	public Var var;
	public Var[] params = [];
	public CmpdStmt cmpdStmt;
	public int maxOffset = 0;
	this (SCTree t){
		assert (t.tag  == "Fun_def");
		auto declare = t.find("Fun_declare");
		var = new Var(declare,0);
		if(declare.length > 2){
			foreach(h;declare[2..$]){
				params ~= (new Var_def(new Var(h,1,R.fp))).var;
			}
		}
		funlist ~= this;
		cmpdStmt = new CmpdStmt(t[1],2);
	}
	static Fun_def[] funlist ;
	static Fun_def searchFun(string id){
		foreach(f;funlist){
			if (f.var.name == id) return f;
		}
		assert(0);
	}
	public override string toString () const {
		string res = "func " ~ var.toString() ~ "\n  : params[";
		if (params.length > 0)
			res ~= params.map!"a.toString()".fold!"a~','~b";
		res ~= "]\n  : " ~ cmpdStmt.toString() ;
		return res;
	}
	static void init(){
		funlist = [];
	}
}
class CmpdStmt : Stmt{
	public Var_def[] vars;
	public Stmt[] stmts;
	public const int level;
	AssignStmt makeTemp(EType type,Expr expr){
		auto temp = Var_def.temp(type,this.level);
		vars ~= temp;
		auto assigned = new AssignStmt(temp.var,expr);
		stmts ~= assigned;
		return assigned;
	}
	AssignStmt addExpr(SCTree t){
		assert(t.tag  == "Expr");		
		final switch(t.length){
			case 1:
				final switch(t[0].tag ){
					case "NUM":
						return makeTemp(EType.Int,new LitExpr(t[0].elem.to!int));
					case "ID":
						auto assigned = Var_def.searchVar(t[0].elem,level);
						return new AssignStmt(assigned,new VarExpr(assigned));
					case "Apply":
						if(t[0][0].elem == "print"){
							auto printed = addExpr(t[0][1]);
							auto printstmt = new PrintStmt(printed.var);
							stmts ~= printstmt;
							return printed;
						}else {
							auto target = Fun_def.searchFun(t.find("ID").elem);
							Var[] args = [];
							if(t[0].length > 1){
								foreach(h;t[0][1..$]){
									args ~= addExpr(h).var;
								}
							}
							auto returnType = target.var.type == EType.Void ? EType.Int : target.var.type;
							auto dest = Var_def.temp(returnType,this.level);
							vars ~= dest;
							auto apply = new ApplyStmt(dest.var,target.var,args);
							stmts ~= apply;
							return new AssignStmt(dest.var,new VarExpr(dest.var));
						}
				}
			case 2:
				auto added1 = addExpr(t[1]);
				string op = t[0].elem;
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
				string op = t[1].elem;
				switch(op){
					case "=":
						if(t[0].length == 2 && t[0][0].elem == "*"){
							//*(a+2) = assign
							auto assign = addExpr(t[2]);
							auto ptr = addExpr(t[0][1]);
							auto wrote = new WriteMemStmt(ptr.var,assign.var);
							stmts ~= wrote;
							return assign;
						}
						break;
					case "||":
						auto temp = Var_def.temp(EType.Int,this.level);
						vars ~= temp;
						auto added1 = addExpr(t[0]);
						addIfStmt(added1,{
								stmts ~= new AssignStmt(temp.var,new LitExpr(1));
							},{
								auto added2 = addExpr(t[2]);
								addIfStmt(added2,{
										stmts ~= new AssignStmt(temp.var,new LitExpr(1));
									},{
										stmts ~= new AssignStmt(temp.var,new LitExpr(0));
									});
							});
						return new AssignStmt(temp.var,new VarExpr(temp.var));
					case "&&":
						auto temp = Var_def.temp(EType.Int,this.level);
						vars ~= temp;
						auto added1 = addExpr(t[0]);
						addIfStmt(added1,{
								auto added2 = addExpr(t[2]);
								addIfStmt(added2,{
										stmts ~= new AssignStmt(temp.var,new LitExpr(1));
									},{
										stmts ~= new AssignStmt(temp.var,new LitExpr(0));
									});
							},{
								stmts ~= new AssignStmt(temp.var,new LitExpr(0));
							});
						return new AssignStmt(temp.var,new VarExpr(temp.var));
					default :break;
				}
				auto added1 = addExpr(t[0]);
				auto added2 = addExpr(t[2]);
				final switch(op){
					case ",":
						return added2;
					case "+":case "-":
						if(added1.var.type != EType.Int || added2.var.type != EType.Int){
							auto ptr = added1.var.type == EType.Int ? added2:added1;
							auto num = added1.var.type == EType.Int ? added1:added2;
							auto num4 = makeTemp(EType.Int,new LitExpr(4));
							auto mul4 = makeTemp(EType.Int,new AopExpr("*",num4.var,num.var)); 
							return makeTemp(ptr.var.type,new AopExpr(op,ptr.var,mul4.var));
						}
						goto case;
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
	
	void addIfStmt(AssignStmt expr,void delegate() tStmt,void delegate()fStmt){
		auto trueLabel = LabelStmt.temp();
		auto elseLabel = LabelStmt.temp();
		auto finlabel = LabelStmt.temp();
		stmts ~= new IfStmt(expr.var,new GotoStmt(trueLabel),new GotoStmt(elseLabel));
		stmts ~= trueLabel;
		tStmt();
		stmts ~= new GotoStmt(finlabel);
		stmts ~= elseLabel;
		fStmt();
		stmts ~= finlabel;
		return;
	}
	
	void addStmt(SCTree t){
		if(t.tag  == "Var_def"){
			vars ~= new Var_def(new Var(t,level));
			return;
		}
		if (t.length == 0) return;
		assert(t.tag  == "Stmt");
		switch(t[0].elem){
			case "if":
				addIfStmt(addExpr(t[1]),{addStmt(t[2]);},{addStmt(t[3]);});
				return;
			case "for":
				//for(1;2;3)a;  =>  1;while(2){a;3}  =>  1;L0;if(2:L2){a;3;goto L0;};L2;
				auto loopProdLabel = LabelStmt.temp();
				auto loopStartLabel = LabelStmt.temp();
				auto loopfinishLabel = LabelStmt.temp();
				auto var1 = addExpr(t[1]);
				stmts ~= loopProdLabel;
				auto var2 = addExpr(t[2]);
				stmts ~= new IfStmt(
					var2.var
					,new GotoStmt(loopStartLabel)
					,new GotoStmt(loopfinishLabel));
				stmts ~= loopStartLabel;
				addStmt(t[4]);
				auto var3 = addExpr(t[3]);
				stmts ~= new GotoStmt(loopProdLabel);
				stmts ~= loopfinishLabel;
				return;
			case "return":
				if(t.length == 1){				 
					auto ret = makeTemp(EType.Int,new LitExpr(0));
					stmts ~= new ReturnStmt(ret.var);
				}else{
					auto ret = addExpr(t[1]);
					stmts ~= new ReturnStmt(ret.var);
				}
				return;
			default:
				break;
		}
		switch(t[0].tag ){
			case "Expr":
				addExpr(t[0]);
				return;
			case "Stmts":
				stmts ~= new CmpdStmt(t[0],level+1);
				return;
			default:
				return;
		}
	}
	this(SCTree t,int level){
		assert(t.tag  == "Stmts");
		this.level = level;
		foreach(h;t){addStmt(h);}
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
	public override string toString() const {return "";}
	public struct Flow {
		bool used = false; // => 不要代入文除去
		enum FlowType{
			Undefined,
			Konst, //定数値畳み込み
			OtherVar, // コピー伝播
			Any,
		};
		FlowType flowType = FlowType.Undefined;
		
		void toKonst(int lit){
			if(this.flowType == FlowType.Undefined){
				this.flowType = flowType.Konst;
				konstValue = lit;
				return;
			}else{
				
			}
		}
		int konstValue = 0;
		Var otherVar = null;
		string toString() {
			return flowType.predSwitch(
				FlowType.Undefined,"?",
				FlowType.Konst,konstValue.to!string,
				FlowType.OtherVar,otherVar.name,
				FlowType.Any,"Any"
				);
		}
	}
	public Flow[string] flowTable;
}
class AssignStmt : Stmt{ 
	public Var var;
	public Expr expr;
	this(Var var,Expr expr){
		this.var = var;
		this.expr = expr;
	}
	public override string toString () const {
		return "AssignStmt : " ~ var.toString() ~ " <" ~ expr.toString() ~ ">";
	}
}
//*pa = 12;
class WriteMemStmt : Stmt{
	public Var dest,src;
	this(Var dest,Var src){
		this.dest = dest;
		this.src = src;
	}
	public override string toString() const {
		return "WriteMemStmt :" ~  dest.toString() ~ " <- " ~ src.toString();
	}
}

//pa = &a;
class ReadMemStmt : Stmt{ 
	public Var dest,src;
	this(Var dest,Var src){
		this.dest = dest;
		this.src = src;
	}
	public override string toString() const {
		return "ReadMemStmt :" ~  dest.toString() ~ " <- " ~ src.toString();
	}
}

class IfStmt : Stmt{
	public Var var;
	public GotoStmt trueLabel;
	public GotoStmt elseLabel;
	this (Var var,GotoStmt trueLabel,GotoStmt elseLabel){
		this.var = var;
		this.trueLabel = trueLabel;
		this.elseLabel = elseLabel;			
	}
	public override string toString() const {
		return "IfStmt : " ~ var.toString() ~"[" ~ trueLabel.toString() ~ "|"~ elseLabel.toString()~"]";
	}
}
class GotoStmt : Stmt{ 
	public const string label; 
	this (LabelStmt label){
		this.label = label.name;
	}
	public override string toString() const{
		return "GotoStmt : " ~ label;
	}	
}
class ApplyStmt : Stmt{ 
	public Var dest,target; //dest = target(args...)
	public Var[] args;
	this (Var dest,Var target,Var[] args){
		this.dest = dest;
		this.target = target;
		this.args = args;
	}
	//dest = target(args ...)
	public override string toString() const{
		string argstring = "";
		if(args.length > 0) argstring = args.map!"a.toString()".fold!"a~','~b";
		return "ApplyStmt : " 
			~ dest.toString() ~ " = "
				~ target.toString() ~ "(" ~ argstring ~ ")"	;
	}
}
class ReturnStmt : Stmt{ 
	public Var var;
	this (Var var){
		this.var = var;
	}
	public override string toString () const {
		return "ReturnStmt : " ~ var.toString();
	}
}

class PrintStmt : Stmt{
	public Var var;
	this (Var var){this.var = var;}
	public override string toString() const {
		return "PrintStmt : " ~ var.toString();
	}
}

class LabelStmt : Stmt{
	public const string name;
	static int tempIndex = 0;
	this(string name){this.name = name;}
	public override string toString () const {
		return "LabelStmt : " ~ name;
	}
	static LabelStmt temp(){
		tempIndex ++;
		return new LabelStmt("_L" ~ tempIndex.to!string);
	}
	static void init(){tempIndex = 0;}
}
//$t0 に値を格納してみる

class Expr{
	this(){}
	public override string toString () const { return null;}
}

class VarExpr : Expr{
	public Var var;
	this(Var var){this.var = var;}
	public override string toString () const {
		return "VarExpr " ~ var.toString();
	}
}

class LitExpr : Expr{
	public const int num;
	this (int num){this.num = num;}
	public override string toString () const {
		return "LitExpr " ~ num.to!string;
	}
}

class AopExpr : Expr{ // + - * /
	public const string Op;
	public Var Left,Right;
	this (string Op,Var Left,Var Right){
		this.Op = Op;
		this.Left = Left;
		this.Right = Right;
	}
	public override string toString () const {
		return "AopExpr " ~ Left.toString() ~ " \"" ~ Op ~ "\" " ~ Right.toString() ;
	}
}
class AddrExpr : Expr{ //&(a)
	public Var var;
	this(Var var){
		this.var = var;
	}
	public override string toString() const {
		return "AddrExpr " ~ var.toString() ;
	}
}
