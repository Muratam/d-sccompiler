module smallc.sctrim;
import std.stdio,std.algorithm,std.math,std.range,std.string,std.conv;
import pegged.grammar;

//includesReserved : ID の 予約語チェック
//trimExpr         : Expr系の トリミング
//trim : 整形 =>
//      Stmts : [Var_def*,Stmt*]
//    Var_def : [Type_Info,ID]
//  Type_info : [Type:"Int"|"void",(Ptr:"ptr")?,(Array:\d)?]
//Fun_declare : [Type_Info,ID,(Param:[Type_Info,ID])*]
//       Stmt : if => ["If",Expr,Stmt,Stmt]
//            : for,while => ["for",Expr,Expr,Expr,Stmt]
//      Array : a[b] => *(a + b)


struct SCTree {
	string tag = ""; 
	int begin = 0, end = 0;
	string val = ""; 
	SCTree[] hits = [];
	bool isLeaf (){return hits.length == 0 ;}
	bool isDummyLeaf(){return tag == "#dummy";}
	static SCTree dummyLeaf (){ return SCTree("#dummy");}
	string toString(string tabs = "")const {
		string mayval = val == "" ? "" : "{ " ~ val ~ " }";
		string res = tag ~":" ~mayval~ " "~ to!string([begin, end])~"\n";
        string hitsString;     
        foreach(i,child; hits){
            hitsString ~= tabs ~ " +-" ~ child.toString(tabs ~ ((i<hits.length -1)?" | " : "   "));
        }
		return res ~ hitsString;
	}
	this (string tag ,int begin = 0,int end = 0,string val = "",SCTree[] hits = cast(SCTree[])[]){
		this.tag = tag;
		this.begin = begin;
		this.end = end;			
		this.val = val;
		this.hits = hits;
	}
	SCTree makeLeaf(string tag = null,string val = null){
		return SCTree(tag == null ? this.tag:tag,this.begin,this.end,val == null ? this.val:val);
	}
	SCTree searchByTag(string tag){
		assert(tag != "");
		if(tag == this.tag) return this;
		foreach(h;hits) {
			auto searched = h.searchByTag(tag);
			if(searched.tag != "") return searched;
		}
		return SCTree("");
	}
	SCTree searchByVal(string val){
		assert(val != "");
		if(val == this.val) return this;
		foreach(h;hits) {
			auto searched = h.searchByVal(val);
			if(searched.val != "") return searched;
		}
		return SCTree("",0,0,"");
	}
	bool canFindByTag(string tag){
		if (tag == this.tag)return true;
		foreach(h;hits){
			if (h.canFindByTag(tag)) return true;
		}
		return false;
	}
	bool canFindByVal(string val){
		if (val == this.val)return true;
		foreach(h;hits){
			if (h.canFindByVal(val)) return true;
		}
		return false;
	}
	this (ParseTree p){
		begin = p.begin;
		end = p.end;
		tag = p.name.startsWith("SC.") ? p.name[3..$]:p.name; //remove SC. 
		if (p.children.length == 0) val = p.matches[0];
		foreach(c;p.children)hits ~= SCTree(c);
	}

}
SCTree makeTypeInfo(SCTree base,SCTree type,bool ptr = false,string arrayNum = ""){
	auto res = base.makeLeaf("Type_info","");
	res.hits ~= base.makeLeaf(type.tag,type.val);
	if(ptr) res.hits ~= base.makeLeaf("ptr","ptr");
	if(arrayNum != "")res.hits ~= base.makeLeaf("array",arrayNum);
	return res;
}
SCTree dummyStmt(SCTree base){
	auto res = base.makeLeaf("Stmt","");
	res.val = "";
	res.hits ~= base.makeLeaf("literal",";");
	return res;
}
SCTree dummyExpr(SCTree base){
	auto res = base.makeLeaf("Expr","");
	res.val = "";
	res.hits ~= base.makeLeaf("NUM","1");
	return res;
}

bool tryTrim(ref SCTree t){

	bool includesReserved(SCTree t){
		const reserved = ["int","void","if","while","for","return"];
		if(t.tag == "ID") return reserved.canFind(t.val);		
		else return t.hits.any!(a => includesReserved(a));
	}
	void trimExpr(ref SCTree t){
		const newTag = "Expr";
		const exprs = [
			"Expr","EB00","EB01","EB02","EB03","EB04","EB05","EB06", 
			"Postfix_expr","Unary_expr","Primary_expr",
		];
		if (exprs.canFind(t.tag)){
			t.tag = newTag;
			while(t.hits.length == 1 && exprs.canFind(t.hits[0].tag)){
				t.hits = t.hits[0].hits;
			}
		}
		foreach(ref h;t.hits) trimExpr(h);
	}
	void trim(ref SCTree t){
		if (t.tag.startsWith("literal!"))t.tag = "literal";
		//単純な整形
		switch(t.tag){
			case "Stmts": t.hits = t.hits[1..$];break;			
			case "Fun_declare":{
				SCTree[] newHits;
				auto type = t.hits[0];
				auto isPtr = t.hits[1].canFindByVal("*");
				newHits ~= makeTypeInfo(t,type,isPtr);
				newHits ~= t.hits[1].searchByTag("ID");
				if(t.hits.length > 2){
					foreach(h;t.hits[2..$]){
						auto newParam = h.makeLeaf();
						auto ptype = h.searchByTag("Type");
						auto pid = h.searchByTag("ID");
						auto pisPtr = h.canFindByVal("*");
						newParam.hits ~= makeTypeInfo(h,ptype,pisPtr);
						newParam.hits ~= pid;
						newHits ~= newParam;
					}
				}
				t.hits = newHits;
				break;
			}
			case "Stmt":{
				switch(t.hits[0].val){
					case "if":{
						if (t.hits.length == 3){
							t.hits ~= t.hits[0].makeLeaf("Stmt","");
							t.hits[3].val = "";
							t.hits[3].hits ~= t.hits[0].makeLeaf("literal",";");
						}
						break;
					}
					case "for":{
						SCTree[] newHits ;
						int semi = 1;
						SCTree parseFor(ref int semi,string separator){
							if (t.hits[semi].val == separator){
								semi ++; 
								return dummyExpr(t);
							} else {
								semi += 2;
								return t.hits[semi-2];
							}
						}	
						newHits ~= t.hits[0];
						newHits ~= parseFor(semi,";");
						newHits ~= parseFor(semi,";");
						newHits ~= parseFor(semi,")");
						newHits ~= t.hits[semi];
						t.hits = newHits;
						break;
					}
					case "while":{
						SCTree[] newHits;
						newHits ~= t.hits[0];
						newHits[0].val = "for";
						newHits ~= dummyExpr(t);
						newHits ~= t.hits[1];
						newHits ~= dummyExpr(t);
						newHits ~= t.hits[2];
						t.hits = newHits;
						break;
					}
					default : break;
				}
				break;
			}
			default:break;
		}
		//同階層で増えたり減ったりしうる整形
		SCTree[] newHits;
		foreach(h;t.hits){
			switch(h.tag){
				case "Var_def":{
					auto type = h.hits[0];
					foreach(hh;h.hits[1..$]){
						auto H = h.makeLeaf();
						bool isPtr = hh.canFindByVal("*");
						string isArray = hh.searchByTag("NUM").val;
						H.hits ~= makeTypeInfo(h,type,isPtr,isArray);	
						H.hits ~= hh.searchByTag("ID");
						newHits ~= H;
					}
					break;
				}		
				case "Array":{
					newHits ~= h.makeLeaf("literal","*");
					auto expr = h.makeLeaf("Expr", "");
					expr.val = "";
					expr.hits ~= h.hits[0];
					expr.hits ~= h.makeLeaf("literal","+");
					expr.hits ~= h.hits[1];
					newHits ~= expr;
					break;
				}
				default: newHits ~= h;break;
			}
		}
		t.hits = newHits;
		foreach(ref h;t.hits){trim(h);}
	}
	//予約語チェック
	if(includesReserved(t)) return false;
	//Expr式をトリミング
	trimExpr(t);
	//整形
	trim(t);
	return true;
}
