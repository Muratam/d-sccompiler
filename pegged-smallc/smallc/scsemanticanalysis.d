module smallc.scsemanticanalysis;
import pegged.grammar;
import std.stdio,std.algorithm,std.math,std.range,std.string,std.conv;
import std.typecons;
import smallc.scdef,smallc.sctrim;


class SCType{
	public string type;//(int|void)( *)?( *)?
	public SCType[] args = [];	
	public bool isFunction = false;
	public bool isProto = false;
	public this(string type,SCType[] args = [],bool isFunction = false,bool isProto = false){
		this.type = type;
		this.args = args;
		this.isFunction = isFunction;
		this.isProto = isProto;
	}
	public this(SCTree t,bool isFunction = false,bool isProto = false){
		assert(t.tag == "Type_info");
		this.type = t.searchByTag("Type").val;
		if (t.canFindByTag("ptr")) type ~= " *";
		if (t.canFindByTag("array")) type ~= " *";
		this.isFunction = isFunction;
		this.isProto = isProto;
	}
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
		foreach(i,a;args){
			if (!a.sameType(t.args[i])) return false;
		}
		return true;
	}
}
SCType[string] getInitEnv(){return ["":new SCType("")].init;}

bool writeError(SCTree t,string str){
	writeln(str ~ " [" ~ t.begin.to!string ~ "," ~t.end.to!string ~ "]");
	return false;
}
bool semanticAnalyze(SCTree t){
	SCType[string][] env = [getInitEnv()];
	return semanticAnalyze(t,env);
}
bool semanticAnalyze(SCTree t,ref SCType[string][] env,string info = ""){
	ref auto current(){return env[$-1];}
	SCType checkType(SCTree t){
		return null;
	}
	bool addVar(string id,SCType type,string info = ""){
		if (id in current()) {
			if (type.isFunction){
				//プロトタイプ宣言
				auto proto = current()[id];
				if(!proto.isFunction) return false;
				if(!proto.isProto) return false;
				if(!proto.sameType(type))return false;
			}else return false;
		}
		current()[id] = type;
		env.writeln;
		return true;
	}
	switch(t.tag){
		case "Var_def":{
			auto type = new SCType(t.searchByTag("Type_info"));
			if (type.type.startsWith("void")) 
				return t.writeError("can't declare void type!!");
			auto id = t.searchByTag("ID").val;
			if(!addVar(id,type)) 
				return t.writeError(id ~ " already exists");
			return true;
		}
		case "Fun_proto":
		case "Fun_def":{
			auto pre_lv = env.length ; 
			if(t.hits.any!(a => !semanticAnalyze(a,env,t.tag))) return false;
			env = env[0..pre_lv];
			return true;
		}
		case "Fun_declare":{
			auto func = new SCType(t.hits[0],true,info == "Fun_proto");
			auto id = t.hits[1].val;
			if (func.type == "void *")
				return t.writeError("void * is not allowed"); 
			SCType[string] paramEnv;
			if (t.hits.length > 2){
				foreach(param;t.hits[2..$]){
					auto ptype = new SCType(param.searchByTag("Type_info"));
					auto pid   = param.searchByTag("ID").val;
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
			current()["#returnType"] = new SCType(func.type);
			env ~= getInitEnv();
			foreach(pid,ptype;paramEnv)
				if (!addVar(pid,ptype)) return false;
			return true;
		}
		case "Stmts":{
			env ~= getInitEnv();
			if(!t.hits.all!(a => semanticAnalyze(a,env,info)))
				return false;
			env = env[0..$-1];
			return true;
		}
		case "Stmt": return checkType(t) !is null;
		default :
			return t.hits.all!(a => semanticAnalyze(a,env,info));
	}
}
