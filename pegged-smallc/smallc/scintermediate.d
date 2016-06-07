module smallc.scintermediate;
import pegged.grammar;
import std.stdio,std.algorithm,std.math,std.range,std.string,std.conv;
import smallc.scdef,smallc.sctrim,smallc.scsemanticanalysis;
import smallc.scmips;

/+

## 定数畳み込み
x=3; y=x+2; print(y); 
=> x=3;y=5;print(5);
## コピー伝播
y=z;x=y;print(x);print(z);
  => y=z;x=y;print(z);print(z);
## 無駄な代入の削除
x=3;y=5;print(5);=>print(5);
x=y;y=z;print(z);print(z);=>print(z);print(z);

# データフローを解析することで可能
## 到達可能定義解析
x=3;     :x
y=x*2;   :y
x=4;     :x
print(y);
## 到達可能定義解析
## 到達コピー解析
## 生存変数解析

+/
//Global => TrimByDataFlow => ToOffset => ToMips
//int x,y; x = 3; print(x); x = 10; print(x);
// => int x;print(3);print(10);
// int main(){int x,y,z;x = 0;if(x){x = 13;} print (x);a0 = x + y;if(a0)print(z = x * y); }


class Flow {
	enum VarType{Indefine,Konst,Defined};
	bool used = false; // => 使われなければまるまる消すことができる
	public bool konst = false; //定数値なら
	public int konstvalue = 0;
	public this (){}

}
class TrimByDataFlow {
	public this(Global g){

	}


}
//`a[label="{a| fafe\l afefe\l }"];a -> b;`
void toGraphiz(Global global){
	string current = "";
	auto startEnv = () =>  current ~ `[label="{` ~ current ~ "|";
	auto endEnv   = () => `}"];`; 
	string[] registedArrows = [];
	bool skip = false;
	void registArrow(string from,string to){
		registedArrows ~= (from ~ "->" ~ to ~";");
	}
	string genCode(Object o){
		if (skip && typeid(o) != typeid(LabelStmt)) return "";
		return o.castSwitch!(
			(Var a)=>{
				return a.name.replace("#","_");
			}(),(Global a)=>{
				return a.fun_defs.map!genCode.fold!"a~b";
			}(),(Fun_def a)=>{
				if(a.var.name == "print") return "";
				current = genCode(a.var);
				registArrow("BEGIN",current);
				return startEnv() ~ genCode(a.cmpdStmt) ~ endEnv();
			}(),(CmpdStmt a)=>{
				return a.stmts.map!genCode.fold!"a~b";
			}(),(AssignStmt a)=>{
				return genCode(a.var) ~ " = " ~ genCode(a.expr) ~ `\l`;
			}(),(WriteMemStmt a)=>{
				return "";
			}(),(ReadMemStmt a)=>{
				return "";
			}(),(IfStmt a)=>{
				registArrow(current,a.trueLabel.label);
				registArrow(current,a.elseLabel.label);
				auto ifVal = genCode(a.var);
				skip = true;
				return "if "
					~ ifVal ~ " : "
					~ a.trueLabel.label ~ " : " 
					~ a.elseLabel.label ~ `\l`;
			}(),(GotoStmt a)=>{
				if(skip) return "";
				registArrow(current,a.label);
				skip = true;
				return "";
			}(),(ApplyStmt a)=>{
				return genCode(a.target) ~ `()\l`;
			}(),(PrintStmt a)=>{
				return "print " ~ genCode(a.var) ~ `\l`;
			}(),(ReturnStmt a)=>{
				registArrow(current,"END");
				auto returnVal = genCode(a.var);
				skip = true;
				return "return " ~ returnVal ~ `\l`;
			}(),(LabelStmt a)=>{
				if(!skip)registArrow(current,a.name);					
				skip = false;
				current = a.name;
				return endEnv() ~ startEnv();
			}(),(VarExpr a)=>{
				return genCode(a.var);
			}(),(LitExpr a)=>{
				return a.num.to!string;
			}(),(AopExpr a)=>{
				return "(" ~ genCode(a.Left) ~" "~ a.Op ~" "~ genCode(a.Right) ~ ")";
			}(),(AddrExpr a)=>{
				return "* " ~ genCode(a.var);
			}(),() => ""
			);
	}
	auto code = 
		"digraph flow{ node [shape = record];" 
		~ genCode(global).replace(endEnv()~endEnv(),endEnv())
		~ registedArrows.fold!"a~b"
		~ "}";
	("# " ~ code).writeln;
	mkGraphiz(code,"flow.png");
}
void mkGraphiz(string code = "digraph f{a->b}", string graphName = "graph.png"){
	import std.process;
	executeShell(
		escapeShellCommand("echo",code.replace("\n","").replace("\t","")) 
		~ "|" ~ 
		escapeShellCommand("dot","-Tpng", "-o",graphName) 
		~ ";" ~
		escapeShellCommand("open",graphName) 
		);
}


class ToMips{
	public this(){}
	string LW(Var var,R to){
		if(var.isArray()) return Mips.addiu(to,var.ptr,var.ROffset);
		else return Mips.lw(to,var.ROffset,var.ptr);
	}
	string SW(Var var,R from){
		return Mips.sw(from,var.ROffset,var.ptr);
	}
	string[] startsFunc(int maxOffset){
		endsFunc = mkEndsFunc(maxOffset);
		return [ 
			Mips.addiu(R.sp,R.sp,-maxOffset),
			Mips.sw(R.ra,4,R.sp),
			Mips.sw(R.fp,0,R.sp),
			Mips.addiu(R.fp,R.sp, maxOffset)
		];
	}
	auto mkEndsFunc (int maxOffset) {
		return [ 
			Mips.lw(R.ra,4,R.sp),
			Mips.lw(R.fp,0,R.sp),
			Mips.addiu(R.sp,R.sp,maxOffset),
			Mips.jr(R.ra)
		];
	}
	string[] endsFunc;

	public string toMipsCode(Global global){
		if(!global.offseted) return "call toOffset first !!! \n";		
		auto mipsCode = toMips(global);
		auto res = "";
		foreach(m;mipsCode){
			if (m[$-1] == ':') res ~= m;
			else res ~= "  " ~ m;
			res ~= "\n";
		}
		return res;
	}

	string[] print(Var var){
		return [
			LW(var,R.a0),
			Mips.li(R.v0,1),
			"syscall",
		];
	}
	string[] print(int lit){
		return [
			Mips.li(R.a0,lit),
			Mips.li(R.v0,1),
			"syscall",
		];
	}

	string[] toMips(Object o){
		return o.castSwitch!(
			(Global a)=>
				[".text",".globl main"] ~
				a.fun_defs.map!(a=>toMips(a)).join
			,(Fun_def a)=>
				a.var.name == "print" ?  null :
				[a.var.name ~ ":"] 
					~ startsFunc(a.maxOffset)
					~ toMips(a.cmpdStmt)
					~ endsFunc
			,(CmpdStmt a)=> 
				a.stmts.map!(a=>toMips(a)).join
			,(AssignStmt a)=>
				toMips(a.expr) ~ [SW(a.var,R.t0)]
			,(WriteMemStmt a)=>[ 
				LW(a.src,R.t0),
				LW(a.dest,R.t1),
				Mips.sw(R.t0,0,R.t1),
			],(ReadMemStmt a)=>[
				LW(a.src,R.t0),
				Mips.lw(R.t0,0,R.t0),
				SW(a.dest,R.t0)
			],(IfStmt a)=>[
				LW(a.var,R.t0),
				Mips.beqz(R.t0,a.elseLabel.label)
			],(GotoStmt a)=>[
				Mips.j(a.label)
			],(ApplyStmt a)=>{
				string[] res;
				if(a.args.length > 0){
					res ~= 	Mips.addiu(R.t1,R.sp,cast(int)(-4 * a.args.length));
					foreach(int i,arg;a.args){
						res ~= LW(arg,R.t0);
						res ~= Mips.sw(R.t0,4 * i,R.t1);
					}
					res ~= Mips.move(R.sp,R.t1);
				}
				res ~= 	Mips.jal(a.target.name);
				if(a.args.length > 0) 
					res ~= Mips.addiu(R.sp,R.sp,cast(int)(4 * a.args.length));
				return res ~ SW(a.dest,R.v0);				
			}(),(ReturnStmt a)=> //
				LW(a.var,R.v0) ~ endsFunc
			,(PrintStmt a)=>[ //print $t0
				LW(a.var,R.a0),
				Mips.li(R.v0,1),
				"syscall",
			],(LabelStmt a)=>[
				a.name ~ ":"
			],(VarExpr a)=>[ //$t0 = lw var
				LW(a.var,R.t0)
			],(LitExpr a)=>[ //$t0 = li num
				Mips.li(R.t0,a.num)
			],(AopExpr a)=>[ //$t1,$t2 = lw var1,lw var2; $t0 = $t1 op $t2
				LW(a.Left,R.t1) ,
				LW(a.Right,R.t2),
				a.Op.predSwitch(
					"+",Mips.add(R.t0,R.t1,R.t2),
					"-",Mips.sub(R.t0,R.t1,R.t2),
					"*",Mips.mul(R.t0,R.t1,R.t2),
					"/",Mips.div(R.t0,R.t1,R.t2),
					"==",Mips.seq(R.t0,R.t1,R.t2),
					"!=",Mips.sne(R.t0,R.t1,R.t2),
					"<=",Mips.sle(R.t0,R.t1,R.t2),
					">=",Mips.sge(R.t0,R.t1,R.t2),
					">" ,Mips.sgt(R.t0,R.t1,R.t2),
					"<" ,Mips.slt(R.t0,R.t1,R.t2))
			],(AddrExpr a)=>[ //$t0 = sp + a.ofs
				Mips.addiu(R.t0,R.sp,a.var.ROffset)
			])();
	}
}
class ToOffset{
	public this(Global g){toOffset(g);}
	int MaxOffset = 0,offset = 0;
	void init(int startOffset = 0){
		MaxOffset = offset = startOffset;
	}
	void toOffset(Object o){
		o.castSwitch!(
			(Var a)=>{
				a.name = "$" ~ offset.to!string;
				a.type = EType.Offset;
				offset += 4;
				MaxOffset = MaxOffset.max(offset);
			}(),(Global a)=>{
				init(0);
				foreach(ref v;a.var_defs) toOffset(v.var);
				foreach(ref f;a.fun_defs) toOffset(f);
				a.offseted = true;
			}(),(Fun_def a)=>{
				init(0);
				foreach(ref p;a.params) toOffset(p);
				init(8);
				toOffset(a.cmpdStmt);	
				a.maxOffset = MaxOffset;
			}(),(CmpdStmt a)=>{
				foreach(ref v;a.vars)  toOffset(v.var);
				foreach(ref s;a.stmts) toOffset(s);
			}(),(Object o)=>{}())();
	}
}

private enum EType {Int,Intptr,Intptrptr,Void,Offset}
private class Var {
	public string name;
	public EType type;
	public int level;
	public int arrayNum = 0;
	public R ptr = R.sp;
	public Flow flow = null;
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
	Var_def[] var_defs = [];
	Fun_def[] fun_defs = [];
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
private class Var_def {
	public Var var;
	static int tempIndex = 0; 
	public this(Var var){
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
	public this(SCTree t,int level){
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
private class Stmt {
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
}

private class IfStmt : Stmt{
	public Var var;
	public GotoStmt trueLabel;
	public GotoStmt elseLabel;
	public this (Var var,GotoStmt trueLabel,GotoStmt elseLabel){
		this.var = var;
		this.trueLabel = trueLabel;
		this.elseLabel = elseLabel;			
	}
	public override string toString() const {
		return "IfStmt : " ~ var.toString() ~"[" ~ trueLabel.toString() ~ "|"~ elseLabel.toString()~"]";
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
}
private class ReturnStmt : Stmt{ 
	public Var var;
	public this (Var var){
		this.var = var;
	}
	public override string toString () const {
		return "ReturnStmt : " ~ var.toString();
	}
}

private class PrintStmt : Stmt{
	public Var var;
	public this (Var var){this.var = var;}
	public override string toString() const {
		return "PrintStmt : " ~ var.toString();
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
		return new LabelStmt("_L" ~ tempIndex.to!string);
	}
	public static void init(){tempIndex = 0;}
}
//$t0 に値を格納してみる

private class Expr{
	public this(){}
	public override string toString () const { return null;}
}

private class VarExpr : Expr{
	Var var;
	public this(Var var){this.var = var;}
	public override string toString () const {
		return "VarExpr " ~ var.toString();
	}
}

private class LitExpr : Expr{
	int num;
	public this (int num){this.num = num;}
	public override string toString () const {
		return "LitExpr " ~ num.to!string;
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
}
private class AddrExpr : Expr{ //&(a)
	Var var;
	public this(Var var){
		this.var = var;
	}
	public override string toString() const {
		return "AddrExpr " ~ var.toString() ;
	}
}
