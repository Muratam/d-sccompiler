module smallc.scsemanticanalysis;
import pegged.grammar;
import std.stdio,std.algorithm,std.math,std.range,std.string,std.conv;
import std.typecons;
import smallc.scdef,smallc.sctrim;


ref auto last(T)(ref T[] R) {return R[$-1];}
class SCType{
	public string type;//(int|void)( *)?( *)?
	public SCType[] args = [];	
	public bool isFunction = false;
	public bool isProto = false;
	public string info = "";
	public this(string type,SCType[] args = [],bool isFunction = false,bool isProto = false,string info = ""){
		this.type = type;
		this.args = args;
		this.isFunction = isFunction;
		this.isProto = isProto;
		this.info = info;
	}
	public this(SCTree t,bool isFunction = false,bool isProto = false){
		assert(t() == "Type_info");
		this.type = t.find("Type").elem;
		if (t.has("ptr")) type ~= " *";
		if (t.has("array")) {
			type ~= " *";
			info = "isArray";
		}
		this.isFunction = isFunction;
		this.isProto = isProto;
	}
	public @property bool isArray(){return info == "isArray";}
	public @property bool isNum(){return info == "isNum";}
	//public @property bool isId(){return info == "isId";}
	public override string toString() const {
		string res = "";
		if (isProto) res ~= "proto";
		if (isFunction) res ~= "fun:";
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
private SCType[string] getInitEnv(){return ["":new SCType("")].init;}

private SCType writeTypeError(SCTree t,string str){
	writeln(str ~ " [" ~ t.begin.to!string ~ "," ~t.end.to!string ~ "]");
	return null;
}
private bool addVar(ref SCType[string][] env,string id,SCType type,string info = ""){
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
private SCType op1(SCType t1,string[][] prods ...){
	foreach(prod;prods){
		auto from = prod[0];
		auto to   = prod[1];
		if (t1.type == from)
			return new SCType(to);
	}
	return null;
}
private SCType op2(SCType t1,SCType t2,string[][] prods ...){
	foreach(prod;prods){
		auto from1 = prod[0];
		auto from2 = prod[1];
		auto to = prod[2];
		if (t1.type == from1 && t2.type == from2)
			return new SCType(to);
	}
	return null;
}

private SCType checkHitsType(ref SCType[string][] env,SCTree[] hits,string whenCollectResType = "void"){
	if(hits.map!(a => env.checkType(a)).any!(a=>a is null))
		return null;
	else return new SCType(whenCollectResType);
}
private SCType checkStmtType(ref SCType[string][] env,SCTree t){
	if (t.length == 0) return new SCType("void");
	switch(t[0].elem){
	case "if": // [if,exp,stmt,stmt]
		if (env.checkType(t[1]).type != "int") return null;
		return env.checkHitsType(t[2..4]);
	case "for"://[for,exp,exp!,exp,stmt]
		if (env.checkType(t[2]).type != "int") return null;
		return env.checkHitsType(t[1..5]);
	case "return":
		auto returnType = env[0]["#returnType"];
		if(returnType.type == "void"){
			if (t.length == 1) return new SCType("void");
			else return t.writeTypeError("return type must be void !!!");
		}else{
			if (t.length == 1) return t.writeTypeError("return type must not be void !!");
			if (returnType.type == env.checkType(t[1]).type) 
				return new SCType("void");
			return t.writeTypeError("return type differs!!!");
		}
	case ";":
		return new SCType("void");
	default :break;
	}	

	final switch(t[0]()){
	case "Stmts": 
		if (!semanticAnalyze(t[0],env)) return null;
		else return new SCType("void");
	case "Expr": 
		return env.checkType(t[0]);					
	}
}
private SCType checkExprType(ref SCType[string][] env,SCTree t){
	// [Expr,"||",Expr] / ["*",Expr] / [Expr]		
	final switch(t.length){
	case 1: 
		return env.checkType(t[0]);
	case 2: 
		auto operator = t[0].elem;
		auto type1 = env.checkType(t[1]);
		if (type1 is null) return null;
		final switch (operator){
		case "&": 
			if(t[1].length == 1 && t[1][0]() == "ID"){
				return op1(type1,["int","int *"]);
			}else return t.writeTypeError("can't '&' operator not for variable");
		case "*": 
			return op1(type1,["int *","int"],["int * *","int *"]);
		}
	case 3:
		auto type1 = env.checkType(t[0]);
		auto type2 = env.checkType(t[2]);
		if (type1 is null) return null;
		if (type2 is null) return null;
		auto Operator = t[1].elem;
		final switch(Operator){
		case "+":
			return op2(type1,type2
				,["int","int","int"]
				,["int","int *","int *"]
				,["int","int * *","int * *"]
				,["int *","int","int *"]
				,["int * *","int","int * *"]);
		case "-":
			return op2(type1,type2
				,["int","int","int"]
				,["int *","int","int *"]
				,["int * *","int","int * *"]);
		case "*":case "/": case "&&":case "||":
			return op2(type1,type2,["int","int","int"]);
		case "==":case "!=":case ">": case "<": case "<=":case ">=": 
			return type1.sameType(type2) ? new SCType("int"): null;
		case ",": 
			return type2;
		case "=": 
			if(type1.isArray) return null; 
			if(type1.isNum) return null;
			return type1.sameType(type2) ? type1 : null;
		}
	}
}
private SCType checkType(ref SCType[string][] env,SCTree t){
	final switch(t()){
	case "Stmts":
		return semanticAnalyze(t,env) ? new SCType("void"):null;
	case "Stmt":
		return env.checkStmtType(t);
	case "Expr":
		return env.checkExprType(t);
	case "Apply":
		auto id = t[0].elem;
		foreach_reverse(v;env){
			if(id !in v)continue;
			auto regestered = v[id];
			if (! regestered.isFunction)
				return t.writeTypeError(id ~ " is not function!");
			if (regestered.args.length != t.length -1)
				return t.writeTypeError(id ~ ": arg size wrong !!");
			if (regestered.args.length > 0){
				auto params = t[1..$].map!(a=>env.checkType(a));
				if(params.any!(a => a is null)) 
					return t.writeTypeError(id ~ ": args illegal !!");
				if(zip(params,regestered.args).any!(a=>!a[0].sameType(a[1])))
					return t.writeTypeError(id ~ ": args type differs !!");
			}
			return new SCType(regestered.type);
		}
		return t.writeTypeError(id ~ " was not declared !!");
	case "ID":
		auto id = t.elem ;
		foreach_reverse(v;env){
			if (id !in v) continue;
			auto regestered = v[id];
			if (regestered.isFunction) 
				return t.writeTypeError(id ~ " was regestered as function !!");					
			return regestered;
		}
		return t.writeTypeError(id ~ " was not delcared !! ");
	case "NUM":	
		return new SCType("int",[],false,false,"isNum");
	}
}

bool semanticAnalyze(SCTree t){
	SCType[string][] env = [getInitEnv()];
	return semanticAnalyze(t,env);
}
bool semanticAnalyze(SCTree t,ref SCType[string][] env,string info = ""){
	switch(t()){
	case "Var_def":
		auto type = new SCType(t.find("Type_info"));
		if (type.type.startsWith("void")) 
			return t.writeError("can't declare void type!!");
		auto id = t.find("ID").elem;
		if(!env.addVar(id,type)) 
			return t.writeError(id ~ " already exists");
		return true;	
	case "Fun_proto":
	case "Fun_def":
		auto pre_lv = env.length ; 
		if(t[].any!(a => !semanticAnalyze(a,env,t()))) return false;
		env = env[0..pre_lv];
		return true;	
	case "Fun_declare":
		auto func = new SCType(t[0],true,info == "Fun_proto");
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
		if (!env.addVar(id,func))
			return t.writeError(id ~ " already exists!"); 
		env.last["#returnType"] = new SCType(func.type);
		env ~= getInitEnv();
		foreach(pid,ptype;paramEnv)
			if (!env.addVar(pid,ptype)) 
				return t.writeError("can't add param " ~ pid);
		return true;
	
	case "Stmts":
		env ~= getInitEnv();
		if(!t[].all!(a => semanticAnalyze(a,env,info)))
			return t.writeError("wrong type!");
		env = env[0..$-1];
		return true;	
	case "Stmt": 
		return env.checkType(t) !is null;
	default :
		return t[].all!(a => semanticAnalyze(a,env,info));
	}
}
