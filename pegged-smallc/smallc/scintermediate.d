module smallc.scintermediate;
import pegged.grammar;
import std.stdio,std.algorithm,std.math,std.range,std.string,std.conv;
import smallc.scdef,smallc.sctrim,smallc.scsemanticanalysis;

private enum EType {Int,Intptr,Intptrptr,Void,Offset}
private struct Var {
	string name;
	EType type;
	int level;
	int arrayNum = 0;
	bool isArray(){return arrayNum > 0;}
	static Var make(SCTree t,int level){
		auto id = t.searchByTag("ID");
		auto type = new SCType( t.searchByTag("Type_info"));
		EType res = EType.Int;
		if (type.type == "int *") res = EType.Intptr;
		if (type.type == "int * *") res = EType.Intptrptr;
		if (type.type == "void") res = EType.Void;
		int arrayNum = 0;
		if (t.canFindByTag("array"))
			arrayNum = t.searchByTag("array").val.to!int;
		return Var(id.val,res,level,arrayNum);
	}
	public string toString() const {
		return "("
			~ name ~ ":"
			~ type.to!string 
			~ (type == EType.Offset ? "": "," ~ level.to!string)
			~ (arrayNum > 0 ?",[" ~ arrayNum.to!string ~ "]": "") ~ ")";
	}

	static int fp = 0;
	struct OffsetLevel {int offset,level;};
	static OffsetLevel[][string] fpNameTable;
	public static void initFp(){
		fp = 0;
		fpNameTable.clear();
	}
	public void toOffset(){
		fpNameTable[name] ~= OffsetLevel(fp,level);		
		name = "$" ~ fp.to!string;
		type = EType.Offset;
		if(! isArray()) fp -= 4;
		else fp -= 4 * arrayNum;
		Fun_def.MaxOffset = Fun_def.MaxOffset.min(fp);
	}
	public void searchToOffset(){
		foreach_reverse(var;fpNameTable[name]){
			if (var.level == level){
				name = "$" ~ var.offset.to!string;
				type = EType.Offset;
				return;
			}
		}
	}
	public int getReversedOffset(){
		assert(name.startsWith("$"));
		return -1 * name[1..$].to!int;
	}

}

class Global{
	Var_def[] var_defs = [];
	Fun_def[] fun_defs = [];
	public this (SCTree t){
		Var_def.init();
		Fun_def.init();
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
	public void toOffset(){
		foreach (ref fun_def;fun_defs){
			Var.initFp();
			fun_def.toOffset();
		}
		offseted = true;
	}
	bool offseted = false;
	string[] toMips(){
		auto res = [".text",".globl main"];
		foreach(fun_def;fun_defs){
			res ~= fun_def.toMips();
		}
		return res;
	}
	public string toMipsCode(){
		if(!offseted) return "call toOffset first !!! \n";		
		auto mipsCode = toMips();
		auto res = "";
		foreach(m;mipsCode){
			if (m[$-1] == ':') res ~= m;
			else res ~= "  " ~ m;
			res ~= "\n";
		}
		return res;
	}
}
private class Var_def {
	public Var var;
	static int tempIndex = 0; 
	public this(Var var){
		this.var = var;
		varList ~= this.var;
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
		assert(0);
	}
	public static void init(){
		tempIndex = 0;
		varList = [];
	}
}
private class Fun_def{
	public Var var;
	public Var[] params = [];
	public CmpdStmt cmpdStmt;

	public static int MaxOffset = 0;
	private int maxOffset = 0;
	public this (SCTree t){
		assert (t.tag == "Fun_def");
		auto declare = t.searchByTag("Fun_declare");
		var = Var.make(declare,0);
		if(declare.hits.length > 2){
			foreach(h;declare.hits[2..$]){
				params ~= (new Var_def(Var.make(h,1))).var;
			}
		}
		funlist ~= this;
		cmpdStmt = new CmpdStmt(t.hits[1],2);
	}
	static Fun_def[] funlist ;
	public static Fun_def searchFun(string id){
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
	public static void init(){
		funlist = [];
	}
	public void toOffset(){
		MaxOffset = 0;
		cmpdStmt.toOffset();	
		this.maxOffset = MaxOffset;
	}
	public string[] toMips(){
		if (var.name == "print") return null;
		auto res = [var.name ~ ":"];
		res ~= "addiu $sp,$sp," ~ maxOffset.to!string;
		res ~= cmpdStmt.toMips();
		res ~= "addiu $sp,$sp," ~ (-maxOffset).to!string;
		res ~= "jr $ra";
		return res;
	}

}
private class CmpdStmt : Stmt{
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
			case "Apply":
				if(t.hits[0].hits[0].val == "print"){
					auto printed = addExpr(t.hits[0].hits[1]);
					auto printstmt = new PrintStmt(printed.var);
					stmts ~= printstmt;
					return printed;
				}else {
					auto target = Fun_def.searchFun(t.searchByTag("ID").val);
					Var[] args = [];
					if(t.hits[0].hits.length > 1){
						foreach(h;t.hits[0].hits[1..$]){
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
			switch(op){
			case "=":
				if(t.hits[0].hits.length == 2 && t.hits[0].hits[0].val == "*"){
					//*(a+2) = assign
					auto assign = addExpr(t.hits[2]);
					auto ptr = addExpr(t.hits[0].hits[1]);
					auto wrote = new WriteMemStmt(ptr.var,assign.var);
					stmts ~= wrote;
					return assign;
				}
				break;
			case "||":
				auto temp = Var_def.temp(EType.Int,this.level);
				vars ~= temp;
				auto added1 = addExpr(t.hits[0]);
				addIfStmt(added1,{
					stmts ~= new AssignStmt(temp.var,new LitExpr(1));
				},{
					auto added2 = addExpr(t.hits[2]);
					addIfStmt(added2,{
						stmts ~= new AssignStmt(temp.var,new LitExpr(1));
					},{
						stmts ~= new AssignStmt(temp.var,new LitExpr(0));
					});
				});
				return new AssignStmt(temp.var,new VarExpr(temp.var));
				break;
			case "&&":
				auto temp = Var_def.temp(EType.Int,this.level);
				vars ~= temp;
				auto added1 = addExpr(t.hits[0]);
				addIfStmt(added1,{
					auto added2 = addExpr(t.hits[2]);
					addIfStmt(added2,{
						stmts ~= new AssignStmt(temp.var,new LitExpr(1));
					},{
						stmts ~= new AssignStmt(temp.var,new LitExpr(0));
					});
				},{
					stmts ~= new AssignStmt(temp.var,new LitExpr(0));
				});
				return new AssignStmt(temp.var,new VarExpr(temp.var));
				break;
			default :break;
			}
			auto added1 = addExpr(t.hits[0]);
			auto added2 = addExpr(t.hits[2]);
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
		auto tlabel = LabelStmt.temp();
		auto flabel = LabelStmt.temp();
		auto finlabel = LabelStmt.temp();
		stmts ~= new IfStmt(expr.var,new GotoStmt(tlabel),new GotoStmt(flabel));
		stmts ~= tlabel;
		tStmt();
		stmts ~= new GotoStmt(finlabel);
		stmts ~= flabel;
		fStmt();
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
			addIfStmt(addExpr(t.hits[1]),{addStmt(t.hits[2]);},{addStmt(t.hits[3]);});
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
	public override void toOffset(){
		foreach(ref v;vars) v.var.toOffset();
		foreach(ref s;stmts) s.toOffset();				
	}
	public override string[] toMips(){
		string[] res;
		foreach(stmt;stmts) res ~= stmt.toMips();
		return res;
	}
}
private class Stmt {
	public void toOffset(){}
	public string[] toMips(){return null;}
	public override string toString() const{return null;}
}
private class AssignStmt : Stmt{ 
	public Var var;
	public Expr expr;
	public this(Var var,Expr expr){
		this.var = var;
		this.expr = expr;
	}
	public override string toString () const {
		return "AssignStmt : " ~ var.toString() ~ " <" ~ expr.toString() ~ ">";
	}
	public override void toOffset() {
		var.searchToOffset();
		expr.toOffset();
	}	
	//"li $t0,5",
	//"sw $t0, 4($sp)",
	//"lw $t1, 4($sp)",

	public override string[] toMips(){
		//とりあえずt0
		//off:-4 = Lit:0
		string offset = var.getReversedOffset().to!string;
		string[] res;
		res ~= expr.toMips();
		res ~= "sw $t0, "~offset~"($sp)";
		return res;
	}
}
private class WriteMemStmt : Stmt{
	public Var dest,src;
	public this(Var dest,Var src){
		this.dest = dest;
		this.src = src;
	}
	public override string toString() const {
		return "WriteMemStmt :" ~  dest.toString() ~ " <- " ~ src.toString();
	}
	public override void toOffset() {
		dest.searchToOffset();
		src.searchToOffset();
	}
}
private class ReadMemStmt : Stmt{ 
	public Var dest,src;
	public this(Var dest,Var src){
		this.dest = dest;
		this.src = src;
	}
	public override string toString() const {
		return "ReadMemStmt :" ~  dest.toString() ~ " <- " ~ src.toString();
	}
	public override void toOffset() {
		dest.searchToOffset();
		src.searchToOffset();
	}
}
private class IfStmt : Stmt{
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
	public override void toOffset() {
		var.searchToOffset();
	}
}
private class GotoStmt : Stmt{ 
	public string label; 
	public this (LabelStmt label){
		this.label = label.name;
	}
	public override string toString() const{
		return "GotoStmt : " ~ label;
	}
}
private class ApplyStmt : Stmt{ 
	public Var dest,target;
	public Var[] args;
	public this (Var dest,Var target,Var[] args){
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
	public override void toOffset() {
		dest.searchToOffset();
		foreach(arg;args) arg.searchToOffset();
	}
}
private class ReturnStmt : Stmt{ 
	public Var var;
	public this (Var var){
		this.var = var;
	}
	public override string toString () const {
		return "ReturnStmt : " ~ var.toString();
	}
	public override void toOffset() {
		var.searchToOffset();
	}
}
private class PrintStmt : Stmt{
	public Var var;
	public this (Var var){this.var = var;}
	public override string toString() const {
		return "PrintStmt : " ~ var.toString();
	}
	public override void toOffset() {
		var.searchToOffset();
	}
	public override string[] toMips(){
		return [
			"move $a0,$t0",
			"li $v0,1",
			"syscall",
		];
	}
}
private class LabelStmt : Stmt{
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
private class Expr{
	public this(){}
	public void toOffset(){}
	public string[] toMips(){return null;}
	public override string toString () const {
		return "Expr";
	}
}
private class VarExpr : Expr{
	public Var var;
	public this(Var var){this.var = var;}
	public override string toString () const {
		return "VarExpr " ~ var.toString();
	}
	public override void toOffset() {
		var.searchToOffset();
	}
}
private class LitExpr : Expr{
	public int num;
	public this (int num){this.num = num;}
	public override string toString () const {
		return "LitExpr " ~ num.to!string;
	}
	public override string[] toMips(){
		return ["li $t0,"~ num.to!string];
	}
}
private class AopExpr : Expr{ // + - * /
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
	public override void toOffset() {
		L.searchToOffset();
		R.searchToOffset();
	}
}
private class AddrExpr : Expr{ //&(a)
	public Var var;
	public this(Var var){
		this.var = var;
	}
	public override string toString() const {
		return "AddrExpr " ~ var.toString() ;
	}
	public override void toOffset() {
		var.searchToOffset();
	}
}