module smallc.scintermediate;
import pegged.grammar;
import std.stdio,std.algorithm,std.math,std.range,std.string,std.conv;
import smallc.scdef,smallc.sctrim,smallc.scsemanticanalysis;
import smallc.scmips;
import smallc.scintermediateclasses;
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


//stmtsのflowTableを更新していくための仮想的なラベル付けブロック
//toMipsの時点でそのFlowTableを見ながら最適なものを返すようにすればよいし、
//これの上でフロー解析をしていけばよい
class LabeledBlock{
	string label;
	string[] tos;
	Stmt[] stmts;
	public override string toString() {
		return "[\n" 
			~ label ~ " : \n" 
			~ (tos.length == 0 ? "" : tos.map!`"->"~ a~ "\n"`.fold!"a~b")
			~ "\n"
			~ (stmts.length == 0 ? "" : stmts.map!(a=>a.toString()).fold!`a~"\n"~b`)
			~ "\n]\n";
	}
	public this(string label,string[] tos = []){
		this.label = label;
		this.tos = tos;
	}
	static LabeledBlock[string] make(Global global){
		LabeledBlock[string] blocks;
		string current = "";
		bool skip = false;
		void registArrow(string to,string from = current){ 
			if(from !in blocks)
				blocks[from] = new LabeledBlock(from);			
			if(!blocks[from].tos.canFind(to))
				blocks[from].tos ~= to;
		}
		void registStmt(Stmt stmt,string name = current){
			if (name !in blocks)
				blocks[name] = new LabeledBlock(name);
			blocks[name].stmts ~= stmt;
		}
		void genLabel(Object o){
			if (skip && typeid(o) != typeid(LabelStmt)) return ;
			o.castSwitch!(
				(Global a)=>{			
					foreach(b;a.fun_defs)genLabel(b);
				}(),(Fun_def a)=>{
					if(a.var.name == "print") return ;
					current = a.var.name;
					registArrow(current,"BEGIN");
					genLabel(a.cmpdStmt);
					if(current == a.var.name) registArrow("END"); 
				}(),(CmpdStmt a)=>{
					foreach(b;a.stmts) genLabel(b);
				}(),(AssignStmt a)=>{ registStmt(a);
				}(),(WriteMemStmt a)=>{ registStmt(a);
				}(),(ReadMemStmt a)=>{ registStmt(a);
				}(),(ApplyStmt a)=>{ registStmt(a);
				}(),(PrintStmt a)=>{ registStmt(a);
				}(),(IfStmt a)=>{
					registArrow(a.trueLabel.label);
					registArrow(a.elseLabel.label);
					registStmt(a);
					skip = true;
				}(),(ReturnStmt a)=>{
					registArrow("END");
					registStmt(a);
					skip = true;
				}(),(GotoStmt a)=>{
					registArrow(a.label);
					skip = true;
				}(),(LabelStmt a)=>{
					if(!skip)registArrow(a.name);					
					skip = false;
					current = a.name;
				}(),() => {}()
				);

		}
		genLabel(global);
		toGraphiz(blocks.values());
		return blocks;
	}


	string toGraphizNode(){
		return 
			label 
				~ `[label="{` ~ label ~`|` 
				~ (stmts.length == 0 ? "" : stmts.map!(a=>toGraphizNode(a)).fold!"a~b" )
				~ `}"];` 
				~ (tos.length == 0 ? ""  : tos.map!(a=>label~ "->" ~ a ~ ";").fold!`a~b`);
	}
	string toGraphizNode(Object o){
		// no goto and label stmts
		return o.castSwitch!(
			(CmpdStmt a)=>{
				return a.stmts.map!(a=>toGraphizNode(a)).fold!"a~b";
			}(),(AssignStmt a)=>{
				return a.var.name ~ " = " ~ toGraphizNode(a.expr) ~ `\l`;
			}(),(WriteMemStmt a)=>{
				return "* " ~ a.dest.name ~ " = " ~ a.src.name ~ `\l`;
			}(),(ReadMemStmt a)=>{
				return a.dest.name ~ " = &" ~ a.src.name ~ `\l`;
			}(),(IfStmt a)=>{
				return "if "
					~ a.var.name ~ " : "
					~ a.trueLabel.label ~ " : " 
					~ a.elseLabel.label ~ `\l`;
			}(),(ApplyStmt a)=>{
				return a.target.name ~ `()\l`;
			}(),(PrintStmt a)=>{
				return "print " ~ a.var.name ~ `\l`;
			}(),(ReturnStmt a)=>{
				return "return " ~ a.var.name ~ `\l`;
			}(),(VarExpr a)=>{
				return a.var.name;
			}(),(LitExpr a)=>{
				return a.num.to!string;
			}(),(AopExpr a)=>{
				auto op = a.Op.replace("<","＜").replace(">","＞");
				return "(" ~ a.Left.name ~" "~ op ~" "~ a.Right.name ~ ")";
			}(),(AddrExpr a)=>{
				return "* " ~ a.var.name;
			}(),() => ""
			);
	}
	public static void toGraphiz(LabeledBlock[] blocks){
		auto code = 
			`digraph flow{ node [shape = record];`
			~ blocks.map!(a=>a.toGraphizNode()).fold!`a~b` 
			~ `}`;
		//("# " ~ code).writeln;
		mkGraphiz(code,"flow.png");
	}
	public static void mkGraphiz(string code = "digraph f{a->b}", string graphName = "graph.png"){
		import std.process;
		executeShell(
			escapeShellCommand("echo",code.replace("\n","").replace("\t","")) 
			~ "|" ~ 
			escapeShellCommand("dot","-Tpng", "-o",graphName) 
			~ ";" ~
			escapeShellCommand("open",graphName) 
			);
	}

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

