module smallc.scdef;
const makeModule = false;
static if(false){
	//怪しい
	// * & ptrptr 
	// & : id,id[num],*num
	// = : L: *id , id(type != array)
	struct Type{
		string type = "";        // "int"
		string generic = "";     // "ptr"
		bool isFunction = false; 
		Type[] params = [];      //
		bool isProto = false;
		bool equal(Type t){
			if (type != t.type) return false;
			if (generic != t.generic) return false;
			if (isFunction != t.isFunction) return false;
			if (isFunction){
				if (params.length != t.params.length) return false;
				foreach(i;0..params.length){
				    if (!params[i].equal(t.params[i]))return false;					
				}
			}
			return true;
		}
		static Type ill(){return Type("");}
		bool isIll(){return type == "" ;}
		string typeID(){return type ~ generic ;}
		bool isPureType(){return generic == "" ;}
		bool opCast(T)() if (is(T == bool)){return !isIll();}
	}	
	struct RawInfo{string generic,val;}
	RawInfo raw(ParseTree p){
		switch(p.name){
			case "SC.Ptr_ID"   :return RawInfo("ptr" ,p.matches[0]);
			case "SC.Array_ID" :return RawInfo("array",p.matches[0]);
			case "SC.Type"     :return RawInfo(""  ,p.matches[0]);
			case "SC.ID"       :return RawInfo(""  ,p.matches[0]);
			case "SC.NUM"      :return RawInfo(""  ,p.matches[0]);
			default            :return raw(p.children[0]);
		}
	}

	bool checkAST(ParseTree p,ref Type[string][] env,string info = ""){
		bool checkAllChildren(string info = ""){
			foreach(c;p.children) if(!checkAST(c,env,info))return false;
			return true;
		}
		bool addtype(string id,Type type,string info = ""){
			bool checkFunction(){
				if (id in env[$-1]) {
					auto proto = env[$-1][id];
					if (! proto.isFunction) return false;
					if (! proto.isProto) return false;
					if (! proto.equal(type)) return false;
				}
				return true;
			}
			if (info == "SC.Fun_def"){
				if (!checkFunction()) return false;				
				type.isProto = false;
			}else if(info == "SC.Fun_proto"){
				if (!checkFunction()) return false;				
				type.isProto = true;
			}else{
				if (id in env[$-1]) return false;
			}
			env[$-1][id] = type;
			return true;
		}
		Type checkType(ParseTree p){
			switch(p.name){
				case "SC.Stmts": 
					if(checkAST(p,env)) return Type("void");
					else return Type.ill();
				case "SC.Stmt"     : {
					string Op = p.children[0].matches[0];
					switch(Op){
					case "if":{
						if (checkType(p.children[1]).typeID != "int") return Type.ill(); 
						if (checkType(p.children[2]).isIll())return Type.ill();
						if (p.children.length == 4){
							if(checkType(p.children[3]).isIll())return Type.ill();
						}
						return Type("void");
					}
					case "while":{
						if (checkType(p.children[1]).typeID != "int") return Type.ill();
						if (checkType(p.children[2]).isIll())return Type.ill();
						return Type("void");
					}
					case "for":{
						Type[] fors ;
						int semi = 1;
						Type parseFor(ref int semi,string separator){
							if (p.children[semi].matches[0] == separator){semi ++; return checkType(p.children[semi-1]);
							}else {semi += 2;return checkType(p.children[semi-2]);}
						}
						foreach(f;fors)if(f.isIll())return Type.ill();
						return Type("void");
					}
					case "return":{
						foreach_reverse(v;env){
							if (!("#returnType" in v)) continue;
							auto regestered = v["#returnType"] ;
							if (regestered.typeID == "void") {
								if (p.children.length == 1) return Type("void");
							}else{
								if (p.children.length == 1) return Type.ill();
								auto searching = checkType(p.children[1]);
								if (searching.typeID == regestered.typeID) return Type("void");
								else return Type.ill();
							}
						}
						return Type.ill();
					}
					default :
					}
				}break;
				case "SC.Expr"     : 
				case "SC.Bin_expr" : 
				case "SC.B00_expr" : 
				case "SC.B01_expr" : 
				case "SC.B02_expr" : 
				case "SC.B03_expr" : 
				case "SC.B04_expr" : 
				case "SC.B05_expr" :
				case "SC.Postfix_expr" :
				case "SC.Unary_expr"   :
				case "SC.Primary_expr" :{ 		   
					if(p.children.length == 1) return checkType(p.children[0]);
					else if(p.children.length == 2) {			
						string Op = p.children[0].matches[0];
						Type t1 = checkType(p.children[1]);
						//# Type
 						final switch(Op){
							case "-": if (t1.typeID == "int") return Type("int");break;
							case "&": if (t1.typeID == "int") return Type("int","ptr");break;					
							case "*": if (t1.typeID == "intptr") return Type("int");
								      if (t1.typeID == "intptrptr") return Type("int","ptr");break;					
						}
					}else if(p.children.length == 3){
						string Op = p.children[1].matches[0];
						Type t1 = checkType(p.children[0]);
						Type t2 = checkType(p.children[2]);
						if (t1.isIll() || t2.isIll()) return Type.ill();
						switch(Op){
						case "+":case "-": 
							if (!t1.equal(t2)){
								if (Op == "+"){
									if (t1.typeID == "int" && t2.typeID == "intptr") return Type("int","ptr");
									if (t1.typeID == "int" && t2.typeID == "intptrptr") return Type ("int","ptrptr");
								}								
								if (t1.typeID == "intptr" && t2.typeID == "int") return Type("int","ptr");									
								if (t1.typeID == "intptrptr" && t2.typeID == "int")return Type("int","ptrptr");
							}
						case "*":case "/": 
							if (t1.equal(t2) && t1.typeID == "int")	return Type("int");break;
						case "==":case "!=":case ">":case "<": case "<=":case ">=": 
							if (t1.equal(t2)) return Type("int");break;
						case "&&" :
							if (t1.equal(t2) && t1.typeID == "int") return Type("int");break;							
						case ",": return t2;
						case "=": 
							if (t1.equal(t2)) return t1; break;							
						default:
						}
					}
					return Type.ill();
				}
				case "SC.Apply"    :{
					auto id = p.children[0].matches[0];
					foreach_reverse(v;env){
						if(!(id in v)) continue;
						auto t = v[id];
						if (p.children.length > 1){
							foreach(ref i,c;p.children[1..$]){
								if(!t.params[i].equal(checkType(c))) 
									return Type.ill();
							}
						}
						return Type(t.type,t.generic);
					}
				}
				case "SC.Array"    :{//#
					//int a[3]; =>
					
					break;
				}
				case "SC.ID": {
					auto id = raw(p).val ;
					foreach_reverse(v;env){ 
						if (!(id in v)) continue;
						auto t = v[id];
						if (t.isFunction) return Type.ill();
						auto res = t;
						if (res.generic == "array")res.generic = "ptr";
						return res;
					}
					return Type.ill();
				}
				case "SC.NUM" : return Type("int");
				default: return Type.ill();
			}
			foreach(c;p.children)if(checkType(c).isIll())return Type.ill();
			return Type("void");
		}
		switch(p.name){
			case "SC.Var_def" : {
				string type = raw(p.children[0]).val;
				if (type == "void") return false;
				foreach(c;p.children[1..$])
					if (!addtype(raw(c).val,Type(type ,raw(c).generic))) return false;				
				return true;
			}
			case "SC.Fun_proto": 
			case "SC.Fun_def"  : {
				auto pre_lv = env.length ; 
				if(!checkAllChildren(p.name))return false;
				env = env[0..pre_lv];
				return true;
			}
			case "SC.Fun_declare":{
				//return type
				auto returnType = raw(p.children[0]).val;
				auto returnTypeGeneric = raw(p.children[1]).generic;
				auto id = raw(p.children[1]).val;
				auto newAdded = Type(returnType ,returnTypeGeneric,true);
				//params type
				Type[string] params ;
				if (p.children.length > 2) {
					foreach(param;p.children[2..$]){
						auto envtr = raw(param.children[0]).val;
						auto pid  = raw(param.children[1]).val;
						if(envtr == "void") return false;
						auto ptype = Type(envtr,raw(param.children[1]).generic);
						if (pid in params) return false;
						params[pid] = ptype;
					}
					foreach(id,type;params) newAdded.params ~= type;				
				}
				if(!addtype(id,newAdded,info)) return false;								
				addtype("#returnType",newAdded) ;					
				env ~= ["":Type()].init;
				foreach(id,type;params) 
					if (!addtype(id,type)) return false;				
				return true;
			}
			case "SC.Stmts" : { 
				env ~= ["":Type()].init;
				if (!checkAllChildren()) return false;
				env = env[0..$-1];
				return true;
			}
			case "SC.Stmt": return !checkType(p).isIll();							
			default :break;
		}
		return checkAllChildren();
	}
	bool checkAST(ParseTree p){
		auto env = [["":Type()].init];
		return checkAST(p,env);
	}

}
const scdefstr = `SC:
	Global   <- (Var_def / Fun_proto / Fun_def)+
	Var_def  < Type Declare (:',' Declare)* :';'
	Fun_proto < Fun_declare ';'
	Fun_def  < Fun_declare Stmts
	Fun_declare < Type Def_ID :'(' Param? (:',' Param)* :')'
	Param    < Type Def_ID
	Stmts    < ^'{' Var_def* Stmt* :'}' 
	Stmt     < ^';' 
             / ^'if' :'(' Expr :')' Stmt (:'else' Stmt)?
             / ^'while' :'(' Expr :')' Stmt               
             / ^'for' :'(' Expr? ^';' Expr? ^';' Expr? ^')' Stmt
             / ^'return' Expr? :';'
             / Stmts / Expr :';'
	Expr < Expr ^','  EB00 / EB00
	EB00 < EB01 ^'='  EB00 / EB01 
	EB01 < EB01 ^'||' EB02 / EB02
	EB02 < EB02 ^'&&' EB03 / EB03
	EB03 < EB03 (^'==' / ^'!=') EB04 / EB04
	EB04 < EB04 (^'<=' / ^'>=' / ^'<' / ^'>') EB05 / EB05
	EB05 < EB05 (^'+' / ^'-') EB06 / EB06
	EB06 < EB06 (^'*' / ^'/') Postfix_expr / Postfix_expr
	Postfix_expr < (^'-' / ^'&' / ^'*') Postfix_expr / Unary_expr
	Unary_expr   < Apply / Array / Primary_expr
	Primary_expr < ID / NUM / :'(' Expr :')'	
	Apply    < ID :'(' EB00? (:',' EB00)* :')'
	Array    < Primary_expr (:'[' Expr :']' )+
	Type     < 'int' / 'void'
	Declare  < Def_ID (:'[' NUM ']')? 
	Def_ID   < (^'*')? ID
	ID       < identifier
	NUM      < ~([0-9]+)
`;
