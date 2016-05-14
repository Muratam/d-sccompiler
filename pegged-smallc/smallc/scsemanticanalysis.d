module smallc.scsemanticanalysis;
import pegged.grammar;
import std.stdio,std.algorithm,std.math,std.range,std.string,std.conv;
import smallc.scdef,smallc.sctrim;

bool writeError(SCTree t,string str){
	writeln(str ~ " [" ~ t.begin.to!string ~ "," ~t.end.to!string ~ "]");
	return false;
}
//"int","int *","void","int * *"
bool semanticAnalyze (SCTree t){
	string[string][] env = [["":""].init];
	return semanticAnalyze(t,env);
}
string typeID(SCTree t){
	assert(t.tag == "Type_info");
	string type = t.searchByTag("Type").val;
	if (t.canFindByTag("ptr")) type ~= " *";
	if (t.canFindByTag("array")) type ~= " *";
	return type;
}

bool semanticAnalyze(SCTree t,ref string[string][] env,string info = ""){
	ref auto current (){return env[$-1];}
	bool addVar(string id,string type,string info = ""){
		if (id in current()) return false;
		current()[id] = type;
		env.writeln;
		return true;
	}
	switch(t.tag){
		case "Var_def":{
			auto type = t.searchByTag("Type_info").typeID;
			if (type.startsWith("void")) return t.writeError("can't declare void type!!");
			auto id = t.searchByTag("ID").val;
			if(!addVar(id,type)) return t.writeError(id ~ "already exists");
			break;
		}
		case "Fun_proto":
		case "Fun_def":{
			auto pre_lv = env.length ; 
			if(t.hits.any!(a => !semanticAnalyze(a,env,info))) return false;
			env = env[0..pre_lv];
			break;
		}
		case "Fun_declare":{
			auto type = t.hits[0].typeID;
			auto id = t.hits[1].val;
			
			break;
		}

		default :break;
	}
	if(t.hits.any!(a => !semanticAnalyze(a,env,info))) return false;
	return true;
}
