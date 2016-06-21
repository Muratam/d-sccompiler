module smallc.scsemanticanalysis;
import pegged.grammar;
import std.stdio,std.algorithm,std.math,std.range,std.string,std.conv;
import std.typecons;
import smallc.scdef,smallc.sctrim;


ref auto last(T)(ref T[] R) {return R[$-1];}

enum Info{normal,func,proto,array,num,expr}; //解析用の特殊情報
class SCType{
	public string type;//(int|void)( *)?( *)? //array as ptr
	public SCType[] args = []; // for function
	private Info info = Info.normal;
	@property bool isFunction()const {return info == Info.func || info == Info.proto;}
	@property bool isProto()const {return info ==Info.proto;}
	public @property bool isArray()const {return info == Info.array;}
	public @property bool isNum()const {return info == Info.num;}

	public this(string type,Info info = Info.normal,SCType[] args = []){
		this.type = type;
		this.info = info;
		this.args = args;
	}
	public this(SCTree t,Info info = Info.normal){
		assert(t.tag == "Type_info");
		this.type = t.find("Type").elem;
		this.info = info;
		if (t.has("ptr")) this.type ~= " *";
		if (t.has("array")) {
			this.type ~= " *";
			this.info = Info.array;
		}
	}
	//public @property bool isId(){return info == "isId";}
	public override string toString() const {
		string res = "";
		if (isProto()) res ~= "proto";
		if (isFunction()) res ~= "fun:";
		res ~= type;
		if (args.length > 0) res ~= "[" ~ args.map!(a=>a.toString()).fold!"a~','~b" ~ "]";
		return res;
	}
	public bool sameType(SCType t){
		if (isFunction != t.isFunction) return false;
		if (type != t.type) return false;
		if (args.length != t.args.length) return false;
		return zip(args,t.args).all!"a[0].sameType(a[1])";
	}
}




class SemanticAnalyze{
	SCType[string][] env ;
	SCType[string] getInitEnv(){return ["":new SCType("")].init;}
	SCType writeTypeError(SCTree t,string str){
		stderr.writeln(str ~" " ~  t.getLineNumberMessage());
		errored = true;
		return null;
	}
	public bool errored = false;
	public this(){}
	public bool startAnalyze(SCTree t){
		env = [getInitEnv()];
		auto res = analyze(t);
		return res && !errored;

	}
	private bool analyze(SCTree t,string info = ""){
		switch(t.tag){
		case "Var_def":
			auto type = new SCType(t.find("Type_info"));
			if (type.type.startsWith("void"))
				return t.writeError("can't declare void type!!");
			auto id = t.find("ID").elem;
			if(!addVar(id,type))
				return t.writeError(id ~ " already exists");
			return true;
		case "Fun_proto":
		case "Fun_def":
			auto pre_lv = env.length ;
			if(t[].any!(a => !analyze(a,t.tag))) return false;
			env = env[0..pre_lv];
			return true;
		case "Fun_declare":
			auto func = new SCType(t[0],info == "Fun_proto" ? Info.proto : Info.func);
			auto id = t[1].elem;
			if (func.type == "void *")
				return t.writeError("void * is not allowed");
			SCType[string] paramEnv;
			if (t.length > 2){
				foreach(param;t[2..$]){
					auto ptype = new SCType(param.find("Type_info"));
					auto pid   = param.find("ID").elem;
					if(ptype.type.startsWith("void"))
						return param.writeError("void type does not allowed");
					if(pid in paramEnv)
						return param.writeError("parameter " ~ pid ~ " already exists.");
					paramEnv[pid] = ptype;
					func.args ~= ptype;
				}
			}
			if (!addVar(id,func))
				return t.writeError(id ~ " already exists!");
			env.last["#returnType"] = new SCType(func.type);
			env ~= getInitEnv();
			foreach(pid,ptype;paramEnv)
				if (!addVar(pid,ptype))
					return t.writeError("can't add param " ~ pid);
			return true;

		case "Stmts":
			env ~= getInitEnv();
			if(!t[].all!(a => analyze(a,info)))
				return t.writeError("wrong type!");
			env = env[0..$-1];
			return true;
		case "Stmt":
			return checkType(t) !is null;
		default :
			return t[].all!(a => analyze(a,info));
		}
	}
	private bool addVar(string id,SCType type,string info = ""){
		if (id in env.last) {
			if (type.isFunction){
				//プロトタイプ宣言
				auto proto = env.last[id];
				if(!proto.isFunction) return false;
				if(!proto.isProto) return false;
				if(!proto.sameType(type))return false;
			}else return false;
		}
		env.last[id] = type;
		//env.writeln;
		return true;
	}
	private SCType checkType(SCTree t){
		final switch(t.tag){
		case "Stmts":
			return analyze(t) ? new SCType("void"):null;
		case "Stmt":
			return checkStmtType(t);
		case "Expr":
			return checkExprType(t);
		case "Apply":
			auto id = t[0].elem;
			foreach_reverse(v;env){
				if(id !in v)continue;
				auto regestered = v[id];
				if (! regestered.isFunction)
					return writeTypeError(t,id ~ " is not function!");
				if (regestered.args.length != t.length -1)
					return writeTypeError(t,id ~ ": arg size wrong !!");
				if (regestered.args.length > 0){
					auto params = t[1..$].map!(a => checkType(a));
					if(params.any!(a => a is null))
						return writeTypeError(t,id ~ ": args illegal !!");
					if(zip(params,regestered.args).any!(a=>!a[0].sameType(a[1])))
						return writeTypeError(t,id ~ ": args type differs !!");
				}
				return new SCType(regestered.type);
			}
			return writeTypeError(t,id ~ " was not declared !!");
		case "ID":
			auto id = t.elem ;
			foreach_reverse(v;env){
				if (id !in v) continue;
				auto regestered = v[id];
				if (regestered.isFunction)
					return writeTypeError(t,id ~ " was regestered as function !!");
				return regestered;
			}
			return writeTypeError(t,id ~ " was not delcared !! ");
		case "NUM":
			return new SCType("int",Info.num);
		}
	}
	private SCType checkHitsType(SCTree[] hits,string whenCollectResType = "void"){
		if(hits.map!(a => checkType(a)).any!(a=>a is null))
			return null;
		else return new SCType(whenCollectResType);
	}
	private SCType checkStmtType(SCTree t){
		if (t.length == 0) return new SCType("void");
		switch(t[0].elem){
		case "if": // [if,exp,stmt,stmt]
			if (checkType(t[1]).type != "int") return null;
			return checkHitsType(t[2..4]);
		case "for"://[for,exp,exp!,exp,stmt]
			if (checkType(t[2]).type != "int") return null;
			return checkHitsType(t[1..5]);
		case "return":
			auto returnType = env[0]["#returnType"];
			if(returnType.type == "void"){
				if (t.length == 1) return new SCType("void");
				else return writeTypeError(t,"return type must be void !!!");
			}else{
				if (t.length == 1) return writeTypeError(t,"return type must not be void !!");
				auto returnval = checkType(t[1]);
				if(returnval is null) return null;
				if (returnType.type == returnval.type)
					return new SCType("void");
				return writeTypeError(t,"return type differs!!!");
			}
		case ";":
			return new SCType("void");
		default :break;
		}

		final switch(t[0].tag){
		case "Stmts":
			if (!analyze(t[0])) return null;
			else return new SCType("void");
		case "Expr":
			return checkType(t[0]);
		}
	}
	private SCType checkExprType(SCTree t){
		final switch(t.length){
		case 1:
			return checkType(t[0]);
		case 2:
			auto operator = t[0].elem;
			auto type1 = checkType(t[1]);
			if (type1 is null) return null;
			final switch (operator){
			case "&":
				if(t[1].length == 1 && t[1][0].tag == "ID"){
					return op1(t,type1,["int","int *"]);
				}else return writeTypeError(t,"can't '&' operator not for variable");
			case "*":
				return op1(t,type1,["int *","int"],["int * *","int *"]);
			}
		case 3:
			auto type1 = checkType(t[0]);
			auto type2 = checkType(t[2]);
			if (type1 is null) return null;
			if (type2 is null) return null;
			auto Operator = t[1].elem;
			final switch(Operator){
			case "+":
				return op2(t,type1,type2
					,["int","int","int"]
					,["int","int *","int *"]
					,["int","int * *","int * *"]
					,["int *","int","int *"]
					,["int * *","int","int * *"]);
			case "-":
				return op2(t,type1,type2
					,["int","int","int"]
					,["int *","int","int *"]
					,["int * *","int","int * *"]);
			case "*":case "/": case "&&":case "||":
				return op2(t,type1,type2,["int","int","int"]);
			case "==":case "!=":case ">": case "<": case "<=":case ">=":
				return type1.sameType(type2) ? new SCType("int"): null;
			case ",":
				return type2;
			case "=":
				if(type1.isArray) return null;
				if(type1.isNum) return null;
				if(type1.type == "int" && type1.info == Info.expr) return null;
				return type1.sameType(type2) ? type1 : null;
			}
		}
	}
	private SCType op1(SCTree t,SCType t1,string[][] prods ...){
		foreach(prod;prods){
			auto from = prod[0];
			auto to   = prod[1];
			if (t1.type == from)
				return new SCType(to,Info.normal);
		}
		return writeTypeError(t,"type error !!");
	}
	private SCType op2(SCTree t,SCType t1,SCType t2,string[][] prods ...){
		foreach(prod;prods){
			auto from1 = prod[0];
			auto from2 = prod[1];
			auto to = prod[2];
			if (t1.type == from1 && t2.type == from2)
				return new SCType(to,Info.expr);
		}
		return writeTypeError(t,"type error !!");
	}


}