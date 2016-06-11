module smallc.scintermediate;
import pegged.grammar;
import std.stdio,std.algorithm,std.math,std.range,std.string,std.conv;
import smallc.scdef,smallc.sctrim,smallc.scsemanticanalysis;
import smallc.scmips;
import smallc.scintermediateclasses;
/+
implement withpointerfunction

+/
class LabeledBlock{
	string label;
	string[] tos;
	Stmt[] stmts;
	static bool[string] withNoPtrFunctionMap;
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
	static void analyze(Global global){
		withNoPtrFunctionMap = global.withNoPtrFunctionMap.dup;
		LabeledBlock[string] blocks;
		string current = "";
		bool skip = false;
		void registArrow(string to,string from = current){ 
			if(from !in blocks)
				blocks[from] = new LabeledBlock(from);			
			if(!blocks[from].tos.canFind(to))
				blocks[from].tos ~= to;
			if(to !in blocks)
				blocks[to] = new LabeledBlock(to);
		}
		void registStmt(Stmt stmt,string name = current){
			if (name !in blocks)
				blocks[name] = new LabeledBlock(name);
			blocks[name].stmts ~= stmt;
		}
		void genLabel(Object o){
			if (skip 
				&& (typeid(o) != typeid(LabelStmt) 
				&& typeid(o) != typeid(Fun_def))) {
				o.castSwitch!((Stmt s)=>{s.skipped = true;}());
				return ;
			}
			o.castSwitch!(
				(Global a)=>{			
					foreach(ref b;a.fun_defs){
						genLabel(b);
					}
				}(),(Fun_def a)=>{
					skip = false;
					if(a.var.name == "print") return ;
					current = a.var.name;
					registArrow(current,"BEGIN");
					genLabel(a.cmpdStmt);
					registArrow("END"); 
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
		global.usedMap =  analyze(blocks);
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
			(AssignStmt a)=>{
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
				return a.dest.name ~ " = " ~ a.target.name ~ `()\l`;
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
	static void toGraphiz(LabeledBlock[] blocks){
		if(blocks.length == 0) return;
		auto code = 
			`digraph flow{ node [shape = record];`
			~ blocks.map!(a=>a.toGraphizNode()).fold!`a~b` 
			~ `}`;
		//("# " ~ code).writeln;
		mkGraphiz(code,"flow.png");
	}
	static void mkGraphiz(string code = "digraph f{a->b}", string graphName = "graph.png"){
		import std.process;
		executeShell(
			escapeShellCommand("echo",code.replace("\n","").replace("\t","")) 
			~ "|" ~ 
			escapeShellCommand("dot","-Tpng", "-o",graphName) 
			~ ";" ~
			escapeShellCommand("open",graphName) 
			);
	}
	static string[] analyze(LabeledBlock[string] blocks){
		recursiveAnalyze(blocks["BEGIN"],blocks);
		bool[string] usedMap; 
		bool[string] varMap;
		foreach(block;blocks){
			//block.label.writeln;
			foreach(stmt;block.stmts){
				//stmt.inTable.writeln;
				foreach(key;stmt.outTable.keys){
					if(stmt.outTable[key].used){
						usedMap[key] = true;
					}
					varMap[key] = true;
				}
			}
		}
		//usedMap.keys.writeln;
		//varMap.keys.writeln;
		return usedMap.keys;
	}
	static void recursiveAnalyze(LabeledBlock block,LabeledBlock[string] blocks,Flow[string] flowTable = ["":Flow(Flow.FlowType.Any)]){
		//flowTable.writeln(": recursive");
		//block.label.writeln;
		auto outTable = block.analyzeSelf(flowTable);
		if (outTable == null) return;
		foreach(to;block.tos){
			//to.writeln(": to");
			if(to != "END")
				recursiveAnalyze(blocks[to],blocks,outTable);
		}
	}

	Flow[string]  analyzeSelf(Flow[string] flowTable){
		if(stmts.length > 0 ){
			//this.label.writeln;
			if( flowTable.values.length > 0 &&
				flowTable.values == stmts[0].inTable.values
				&& flowTable.keys == stmts[0].inTable.keys){ 
				"return same".writeln;
				return null;
			}
		}
		foreach(stmt;stmts){
			flowTable = analyzeStmt(stmt,flowTable);
			//stmt.outTable.writeln;
		}
		return flowTable;
	}

	static int calc(int l,int r,string op){
		return op.predSwitch(
			"+",l + r,
			"-",l - r,
			"*",l * r,
			"/",l / r,
			"<",l < r,
			">",l > r,
			"<=",l <= r ? 1:0,
			">=",l >= r ? 1:0,
			"==",l == r ? 1:0,
			"!=",l != r ? 1:0,
			);
	}

	static Flow[string] analyzeStmt(Stmt stmt,Flow[string] flowTable){
		stmt.inTable = flowTable.dup();
		stmt.outTable = flowTable.dup();
		void recursiveUsed(string name){
			if (name !in stmt.outTable) {
				stmt.outTable[name] = Flow(Flow.FlowType.Any);
			}
			with (stmt.outTable[name]){
				switch(flowType){
					case Flow.FlowType.Konst:
						break;
					case Flow.FlowType.OtherVar:
						used = true;				
						if(otherVar != "") recursiveUsed(otherVar);
						break;
					case Flow.FlowType.Any:
						used = true;				
						if(dependR != "") recursiveUsed(dependR);
						if(dependL != "") recursiveUsed(dependL);
						break;
					default:break;
				}
			}
		}

		stmt.castSwitch!(
			(AssignStmt s)=>{
				s.outTable[s.var.name] = 
					s.expr.castSwitch!(
						(VarExpr a)=> {
							if(a.var.name !in s.inTable)
								return Flow(Flow.FlowType.OtherVar,a.var.name);
							else {
								if(s.var.name in s.outTable ){
									if(s.outTable[s.var.name].flowType != Flow.FlowType.OtherVar
										|| s.outTable[s.var.name].otherVar != a.var.name)
										return Flow(Flow.FlowType.Any);
								}
								return s.inTable[a.var.name];						
							}
						}(),(LitExpr a)=> {
							if(s.var.name in s.outTable ){
								if(s.outTable[s.var.name].flowType != Flow.FlowType.Konst
									|| s.outTable[s.var.name].konstValue != a.num)
									return Flow(Flow.FlowType.Any);
							}
							return Flow(Flow.FlowType.Konst,a.num);
						}(),(AopExpr a)=> {
							if(a.Left.name !in s.inTable
								|| a.Right.name !in s.inTable
								|| s.inTable[a.Left.name].flowType != Flow.FlowType.Konst
								|| s.inTable[a.Right.name].flowType != Flow.FlowType.Konst)
								return Flow(Flow.FlowType.Any,a.Right.name,a.Left.name);
							else return Flow(Flow.FlowType.Konst,calc(							
									s.inTable[a.Left.name].konstValue								
									,s.inTable[a.Right.name].konstValue
									,a.Op));
						}(),(AddrExpr a)=>Flow(Flow.FlowType.Any)
						,);
			}(),(WriteMemStmt s)=>{
				foreach(key;s.outTable.keys){
					s.outTable[key].used = true;
					s.outTable[key].flowType = Flow.FlowType.Any;
				}
			}(),(ReadMemStmt s)=>{
				s.outTable[s.dest.name] = Flow(Flow.FlowType.Any);
			}(),(IfStmt s)=>{
				recursiveUsed(s.var.name);
			}(),(ApplyStmt s)=>{
				if(s.target.name !in withNoPtrFunctionMap){
					foreach(key;s.outTable.keys){
						s.outTable[key].used = true;
						s.outTable[key].flowType = Flow.FlowType.Any;
					}
				}
				s.outTable[s.dest.name] = Flow(Flow.FlowType.Any);
				foreach(arg;s.args) recursiveUsed(arg.name);

			}(),(PrintStmt s)=>{
				recursiveUsed(s.var.name);
			}(),(ReturnStmt s)=>{
				recursiveUsed(s.var.name);
			}()
			);
		return stmt.outTable.dup();
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
	string[] usedMap;

	public string toMipsCode(Global global){
		if(!global.offseted) return "call toOffset first !!! \n";
		usedMap = global.usedMap;
		usedMap.writeln;
		auto mipsCode = toMips(global);
		auto res = "";
		foreach(m;mipsCode){
			if (m[$-1] == ':') res ~= m;
			else res ~= "  " ~ m;
			res ~= "\n";
		}
		return res;
	}

	string[] toMips(Global g){
		return 	[".text",".globl main"] ~
			g.fun_defs.map!(a=>toMips(a)).join;
	}
	string[] toMips(Fun_def a){
		return 	
			a.var.name == "print" ?  null : [a.var.name ~ ":"] 
			~ startsFunc(a.maxOffset)
			~ stmtToMips(a.cmpdStmt)
			~ endsFunc;
	}


	string[] stmtToMips(Stmt s){
		s.writeln;
		s.inTable.writeln;
		s.outTable.writeln("\n");
		if(s.skipped) return null;
		return s.castSwitch!(
			(CmpdStmt a)=> 
				a.stmts.map!(a=>stmtToMips(a)).join
			,(AssignStmt a)=>{
				if(!usedMap.canFind(a.var.name)) return null;
				return exprToMips(a.expr,a.inTable) ~ ( [SW(a.var,R.t0)]);
			}(),(WriteMemStmt a)=>[ 
				loadFlow(a.src,R.t0,a.inTable),
				loadFlow(a.dest,R.t1,a.inTable),
				Mips.sw(R.t0,0,R.t1),
			],(ReadMemStmt a)=>[ 
				loadFlow(a.src,R.t0,a.inTable),
				Mips.lw(R.t0,0,R.t0),
				SW(a.dest,R.t0)
			],(IfStmt a)=>{
				if(a.var.name in a.inTable){
					auto flowed = a.inTable[a.var.name];
					if (flowed.flowType == Flow.FlowType.Konst){
						return [Mips.j(
								flowed.konstValue == 0 ? 
								a.elseLabel.label :
								a.trueLabel.label
								)];
					}else if (flowed.flowType == Flow.FlowType.OtherVar){
						//assert(false);
						return [
							loadFlow(a.var,R.t0,a.inTable),
							Mips.beqz(R.t0,a.elseLabel.label)
						];
					}
				}
				return [
					loadFlow(a.var,R.t0,a.inTable),
					Mips.beqz(R.t0,a.elseLabel.label)
				];
			}(),(GotoStmt a)=>[
				Mips.j(a.label)
			],(ApplyStmt a)=>{
				string[] res;
				if(a.args.length > 0){
					res ~= 	Mips.addiu(R.t1,R.sp,cast(int)(-4 * a.args.length));
					foreach(int i,arg;a.args){
						res ~= loadFlow(arg,R.t0,a.inTable);
						res ~= Mips.sw(R.t0,4 * i,R.t1);
					}
					res ~= Mips.move(R.sp,R.t1);
				}
				res ~= 	Mips.jal(a.target.name);
				if(a.args.length > 0) 
					res ~= Mips.addiu(R.sp,R.sp,cast(int)(4 * a.args.length));
				return res ~ SW(a.dest,R.v0);				
			}(),(ReturnStmt a)=> {
				return 
					loadFlow(a.var,R.v0,a.inTable)
					~ endsFunc;
			}(),(PrintStmt a)=>{
				return [
					loadFlow(a.var,R.a0,a.inTable),
					Mips.li(R.v0,1),
					"syscall",
				];
			}(),(LabelStmt a)=>[
				a.name ~ ":"
			]);
	}
	string loadFlow(Var var,R reg,Flow[string] inTable){
		if(var.name in inTable){
			auto flowed = inTable[var.name];
			if (flowed.flowType == Flow.FlowType.Konst){
				return Mips.li(reg,flowed.konstValue);
			}else if (flowed.flowType == Flow.FlowType.OtherVar){
				//toassert(false);
				return LW(var,reg);
			}
		}
		return LW(var,reg);
	}

	string[] exprToMips(Expr e,Flow[string] inTable){
		return e.castSwitch!(
			(VarExpr a)=>[ //$t0 = lw var
				loadFlow(a.var,R.t0,inTable)
			],(LitExpr a)=>[ //$t0 = li num
				Mips.li(R.t0,a.num)
			],(AopExpr a)=>{
				return [ //$t1,$t2 = lw var1,lw var2; $t0 = $t1 op $t2
					loadFlow(a.Left,R.t1,inTable) ,
					loadFlow(a.Right,R.t2,inTable),
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
				];
			}(),(AddrExpr a)=>[ //$t0 = sp + a.ofs
				Mips.addiu(R.t0,R.sp,a.var.ROffset)
			]);
	}

}

class ToOffset{
	string[] usedMap;

	public this(Global g){
		usedMap = g.usedMap;
		toOffset(g);
	}
	int MaxOffset = 0,offset = 0;
	void init(int startOffset = 0){
		MaxOffset = offset = startOffset;
	}
	void toOffset(Object o){
		o.castSwitch!(
			(Var a)=>{
				if(! usedMap.canFind(a.name)) return;
				a.offset = offset;
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

