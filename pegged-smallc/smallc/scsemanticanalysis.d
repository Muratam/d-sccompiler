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
		switch(t.tag){
			case "Stmts":
				return semanticAnalyze(t,env) ? new SCType("void"):null;
			case "Stmt":{
				if (t.hits.length == 0) return new SCType("void");
				final switch(t.hits[0].tag){
					case "if":{
						return null;
					}
					case "for":{
						return null;
					}
					case "return":{
						return null;
					}
					case "Expr": return checkType(t.hits[0]);					
				}
			}
			case "Expr":{
				// [Expr,"||",Expr] / ["-",Expr] / [Expr]
				SCType op1(SCType t1,string[][] prods ...){
					foreach(prod;prods){
						auto from = prod[0];
						auto to   = prod[1];
						if (t1.type == from)
							return new SCType(to);
					}
					return null;
				}
				SCType op2(SCType t1,SCType t2,string[][] prods ...){
					foreach(prod;prods){
						auto from1 = prod[0];
						auto from2 = prod[1];
						auto to = prod[2];
						if (t1.type == from1 && t2.type == from2)
							return new SCType(to);
					}
					return null;
				}				
				final switch(t.hits.length){
					case 1: return checkType(t.hits[0]);
					case 2: {
						auto operator = t.hits[0].val;
						auto type1 = checkType(t.hits[1]);
						if (type1 is null) return null;
						final switch (operator){
							case "-": return op1(type1,["int","int"]);
							case "&": return op1(type1,["int","int *"]);
							case "*": return op1(type1,["int *","int"],["int * *","int *"]);
						}
						return null;
					}
					case 3:{
						auto type1 = checkType(t.hits[0]);
						auto type2 = checkType(t.hits[2]);
						if (type1 is null) return null;
						if (type2 is null) return null;
						auto Operator = t.hits[1].val;
						final switch(Operator){
							case "+":
								return op2(type1,type2,
										   ["int","int","int"]
										  ,["int","int *","int *"]
										  ,["int","int * *","int * *"]
										  ,["int *","int","int *"]
										  ,["int * *","int","int * *"]);
							case "-":
								return op2(type1,type2,
										    ["int","int","int"]
										   ,["int *","int","int *"]
										   ,["int * *","int","int * *"]);
							case "*":case "/":case "&&":case "||":
								return op2(type1,type2,["int","int","int"]);
							case "==":case "!=":case ">":case "<": case "<=":case ">=": 
								return type1.sameType(type2) ? new SCType("int"): null;
							case ",": return type2;
							case "=": return type1.sameType(type2) ? type1 : null;
						}
					}
				}
			}
			case "Apply":{
				return null;
			}
			case "ID":{
				auto id = t.val ;
				foreach_reverse(v;env){
					if (id !in v) continue;
					auto regestered = v[id];
					if (regestered.isFunction) return null;					
					return regestered;
				}
				return null;
			}
			case "NUM":	return new SCType("int");
			default : return null; 
		}
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
