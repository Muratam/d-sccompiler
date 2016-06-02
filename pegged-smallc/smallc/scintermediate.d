module smallc.scintermediate;
import pegged.grammar;
import std.stdio,std.algorithm,std.math,std.range,std.string,std.conv;
import smallc.scdef,smallc.sctrim,smallc.scsemanticanalysis;
import smallc.scmips;


private enum EType {Int,Intptr,Intptrptr,Void,Offset}
private struct Var {
	string name;
	EType type;
	int level;
	int arrayNum = 0;
	R ptr = R.sp;
	bool isArray(){return arrayNum > 0;}
	static Var make(SCTree t,int level,R ptr = R.sp){
		auto id = t.searchByTag("ID");
		auto type = new SCType( t.searchByTag("Type_info"));
		EType res = EType.Int;
		if (type.type == "int *") res = EType.Intptr;
		if (type.type == "int * *") res = EType.Intptrptr;
		if (type.type == "void") res = EType.Void;
		int arrayNum = 0;
		if (t.canFindByTag("array"))
			arrayNum = t.searchByTag("array").val.to!int;
		return Var(id.val,res,level,arrayNum,ptr);
	}
	public string toString() const {
		return "("
			~ name ~ ":"
			~ (ptr == R.sp ? "": ptr == R.fp ? "fp:":ptr == R.gp ? "gp:" : "!?")
			~ type.to!string 
			~ (type == EType.Offset ? "": "," ~ level.to!string)			
			~ (arrayNum > 0 ?",[" ~ arrayNum.to!string ~ "]": "") ~ ")";
	}
	public  static int MaxOffset = 0;
	private static int ofs = 0;
	private static int gpofs = 0;
	struct OffsetLevel {int offset,level;};
	static OffsetLevel[][string] ofsNameTable;
	static OffsetLevel[string] gpNameTable;
	//["a":[(),(),()]]
	public static void initOfs(int startOffset = 0,bool clearOfsNameTable = true,bool clearGpNameTable = true){
		MaxOffset = ofs = startOffset;
		if (clearOfsNameTable) ofsNameTable.clear();
		if (clearGpNameTable) gpNameTable.clear();
	}
	public void toOffset(){
		if (ptr == R.gp){
			gpNameTable[name] = OffsetLevel(gpofs,level);
			name = "$" ~ gpofs.to!string;
			type = EType.Offset;
			if(! isArray()) gpofs += 4;
			else gpofs += 4 * arrayNum;
		}else{
			ofsNameTable[name] ~= OffsetLevel(ofs,level);		
			name = "$" ~ ofs.to!string;
			type = EType.Offset;
			if(! isArray()) ofs += 4;
			else ofs += 4 * arrayNum;
			MaxOffset = MaxOffset.max(ofs);
		}
	}
	public void searchToOffset(){
		if(name !in ofsNameTable){
			//search gp
			name = "$" ~ gpNameTable[name].offset.to!string;
			type = EType.Offset;
			return;
		}
		foreach_reverse(var;ofsNameTable[name]){
			if (var.level == level){
				name = "$" ~ var.offset.to!string;
				type = EType.Offset;
				return;
			}
		}
	}
	@property public int ROffset(){
		assert(name.startsWith("$"));
		return name[1..$].to!int;
	} 
	public string LW(R to){
		if(isArray()) return Mips.addiu(to,ptr,ROffset);
		else return Mips.lw(to,ROffset,ptr);
	}
	public string SW(R from){
		return Mips.sw(from,ROffset,ptr);
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
				var_defs ~= new Var_def(Var.make(h,0,R.gp));	
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
		Var.initOfs(0,true,true);
		foreach(ref var_def;var_defs){
			var_def.var.toOffset();
		}
		foreach (ref fun_def;fun_defs){
			fun_def.toOffset();
		}
		offseted = true;
	}
	bool offseted = false;
	string[] toMips(){
		auto res = [".text",".globl main"];
		//ditto : No Var_def !!!!
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

	private int maxOffset = 0;
	public this (SCTree t){
		assert (t.tag == "Fun_def");
		auto declare = t.searchByTag("Fun_declare");
		var = Var.make(declare,0);
		if(declare.hits.length > 2){
			foreach(h;declare.hits[2..$]){
				params ~= (new Var_def(Var.make(h,1,R.fp))).var;
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
		Var.initOfs(0,true,false);
		foreach (ref p;params) p.toOffset();
		Var.initOfs(8,false,false);
		cmpdStmt.toOffset();	
		maxOffset = Var.MaxOffset;
	}
	public string[] toMips(){
		if (var.name == "print") return null;
		string[] res = [var.name ~ ":"];
		return res ~ Mips.startsFunc(maxOffset)
		    ~ cmpdStmt.toMips()
			~ Mips.endsFunc;
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
		auto elseLabel = LabelStmt.temp();
		auto finlabel = LabelStmt.temp();
		stmts ~= new IfStmt(expr.var,new GotoStmt(elseLabel));
		tStmt();
		stmts ~= new GotoStmt(finlabel);
		stmts ~= elseLabel;
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
			//for(1;2;3)a;  =>  1;while(2){a;3}  =>  1;L0;if(2:L2){a;3;goto L0;};L2;
			auto loopProdLabel = LabelStmt.temp();
			auto loopfinishLabel = LabelStmt.temp();
			auto var1 = addExpr(t.hits[1]);
			stmts ~= loopProdLabel;
			auto var2 = addExpr(t.hits[2]);
			stmts ~= new IfStmt(
					 var2.var
					,new GotoStmt(loopfinishLabel));
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
	public string[] toMips(){return ["No Stmt"];}
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
	public override string[] toMips(){
		return expr.toMips() ~ [
			var.SW(R.t0)
		];
	}
}
//*pa = 12;
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
	public override string[] toMips(){
		return [
			src.LW(R.t0),
			dest.LW(R.t1),
			Mips.sw(R.t0,0,R.t1),
		];
	}
}
//pa = &a;
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
	public override string[] toMips(){
		return [
			src.LW(R.t0),
			Mips.lw(R.t0,0,R.t0),
			dest.SW(R.t0)
		];
	}
}
private class IfStmt : Stmt{
	public Var var;
	public GotoStmt elseLabel;
	public this (Var var,GotoStmt elseLabel){
		this.var = var;
		this.elseLabel = elseLabel;			
	}
	public override string toString() const {
		return "IfStmt : " ~ var.toString() ~"[" ~ elseLabel.toString()~"]";
	}
	public override void toOffset() {
		var.searchToOffset();
	}
	public override string[] toMips(){
		return [
			var.LW(R.t0),
			Mips.beqz(R.t0,elseLabel.label)
		];
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
	public override string[] toMips(){
		return [Mips.j(label)];
	}
}
private class ApplyStmt : Stmt{ 
	public Var dest,target; //dest = target(args...)
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
		foreach(ref arg;args) arg.searchToOffset();
	}
	public override string[] toMips(){
		string[] res;
		res ~= 	Mips.addiu(R.t1,R.sp,cast(int)(-4 * args.length));
		foreach(int i,arg;args){
			res ~= arg.LW(R.t0);
			res ~= Mips.sw(R.t0,4 * i,R.t1);
		}
		return res ~= [ 
			Mips.move(R.sp,R.t1),
			Mips.jal(target.name),
			Mips.addiu(R.sp,R.sp,cast(int)(4 * args.length)),
			dest.SW(R.v0),
		];
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
	public override string[] toMips(){
		return var.LW(R.v0) ~ Mips.endsFunc;
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
			var.LW(R.a0),
			Mips.li(R.v0,1),
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
		return new LabelStmt("LABEL" ~ tempIndex.to!string);
	}
	public static void init(){tempIndex = 0;}
	public override string[] toMips(){
		return [ name ~ ":"];
	}
}
//$t0 に値を格納してみる
private class Expr{
	public this(){}
	public void toOffset(){}
	public string[] toMips(){return ["No Expr"];}
	public override string toString () const { return null;}
}
private class VarExpr : Expr{
	Var var;
	public this(Var var){this.var = var;}
	public override string toString () const {
		return "VarExpr " ~ var.toString();
	}
	public override void toOffset() {
		var.searchToOffset();
	}
	public override string[] toMips(){		
		return [var.LW(R.t0)];		
	}
}
private class LitExpr : Expr{
	int num;
	public this (int num){this.num = num;}
	public override string toString () const {
		return "LitExpr " ~ num.to!string;
	}
	public override string[] toMips(){
		return [Mips.li(R.t0,num)];
	}
}
private class AopExpr : Expr{ // + - * /
	string Op;
	Var Left,Right;
	public this (string Op,Var Left,Var Right){
		this.Op = Op;
		this.Left = Left;
		this.Right = Right;
	}
	public override string toString () const {
		return "AopExpr " ~ Left.toString() ~ " \"" ~ Op ~ "\" " ~ Right.toString() ;
	}
	public override void toOffset() {
		Left.searchToOffset();
		Right.searchToOffset();
	}
	public override string[] toMips(){
		string[] res = [
			Left.LW(R.t1) ,
			Right.LW(R.t2) 
		];
		final switch(Op){
			case "+": return res ~ Mips.add(R.t0,R.t1,R.t2);			
			case "-": return res ~ Mips.sub(R.t0,R.t1,R.t2);
			case "*": return res ~ Mips.mul(R.t0,R.t1,R.t2);
			case "/": return res ~ Mips.div(R.t0,R.t1,R.t2);
			case "==":return res ~ Mips.seq(R.t0,R.t1,R.t2);
			case "!=":return res ~ Mips.sne(R.t0,R.t1,R.t2);
			case "<=":return res ~ Mips.sle(R.t0,R.t1,R.t2);
			case ">=":return res ~ Mips.sge(R.t0,R.t1,R.t2);
			case ">" :return res ~ Mips.sgt(R.t0,R.t1,R.t2);
			case "<" :return res ~ Mips.slt(R.t0,R.t1,R.t2);
		}
	}
}
private class AddrExpr : Expr{ //&(a)
	Var var;
	public this(Var var){
		this.var = var;
	}
	public override string toString() const {
		return "AddrExpr " ~ var.toString() ;
	}
	public override void toOffset() {
		var.searchToOffset();
	}
	public override string[] toMips(){
		return [
			Mips.addiu(R.t0,R.sp,var.ROffset),
		];
	}
}
