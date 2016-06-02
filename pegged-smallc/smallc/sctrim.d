module smallc.sctrim;
import std.stdio,std.algorithm,std.math,std.range,std.string,std.conv;
import pegged.grammar;

//trimExpr         : Expr系の トリミング
//trim : 整形 =>
//      Stmts : [Var_def*,Stmt*]
//    Var_def : [Type_Info,ID]
//  Type_info : [Type:"Int"|"void",(Ptr:"ptr")?,(Array:\d)?]
//Fun_declare : [Type_Info,ID,(Param:[Type_Info,ID])*]
//       Stmt : if => ["If",Expr,Stmt,Stmt]
//            : for,while => ["for",Expr,Expr,Expr,Stmt]
//      Array : a[b] => *(a + b)
//         -a : 0 - a 

class SCTree {
	public string tag = ""; 
	public int begin = 0, end = 0;
	public string val = ""; 
	public SCTree[] hits = [];
	public bool isLeaf (){return hits.length == 0 ;}

	SCTree opIndex(size_t i) { return hits[i];}
	SCTree opIndexAssign(SCTree value,size_t i){return hits[i] = value;}
	ref SCTree[] opSlice(){return hits;}
	SCTree[] opSliceAssign(SCTree[] value){return hits = value;}
	SCTree[] opSlice(size_t x,size_t y){return hits[x..y];}
	size_t opDollar(){return hits.length; }
	@property public size_t length(){return hits.length;}
	SCTree[] opOpAssign(string op)(SCTree rhs){
		static if(op == "~") {hits ~= rhs;return hits; } 
		else static assert(0,"no operator" ~ op);
	}


	public override string toString() {return toString("");}
	public string toString(string tabs)const {
		string mayval = val == "" ? "" : "{ " ~ val ~ " }";
		string res = tag ~":" ~mayval~ " "~ to!string([begin, end])~"\n";
        string hitsString;     
        foreach(i,child; hits){
            hitsString ~= tabs ~ " +-" ~ child.toString(tabs ~ ((i<hits.length -1)?" | " : "   "));
        }
		return res ~ hitsString;
	}
	public this (string tag ,int begin = 0,int end = 0,string val = "",SCTree[] hits = cast(SCTree[])[]){
		this.tag = tag;
		this.begin = begin;
		this.end = end;			
		this.val = val;
		this.hits = hits;
	}
	public SCTree makeLeaf(string tag = null,string val = null){
		return new SCTree(tag == null ? this.tag:tag,this.begin,this.end,val == null ? this.val:val);
	}
	public SCTree searchByTag(string tag){
		assert(tag != "");
		if(tag == this.tag) return this;
		foreach(h;hits) {
			auto searched = h.searchByTag(tag);
			if(searched.tag != "") return searched;
		}
		return new SCTree("");
	}
	public SCTree searchByVal(string val){
		assert(val != "");
		if(val == this.val) return this;
		foreach(h;hits) {
			auto searched = h.searchByVal(val);
			if(searched.val != "") return searched;
		}
		return new SCTree("",0,0,"");
	}
	public bool canFindByTag(string tag){
		if (tag == this.tag)return true;
		foreach(h;hits){
			if (h.canFindByTag(tag)) return true;
		}
		return false;
	}
	public bool canFindByVal(string val){
		if (val == this.val)return true;
		foreach(h;hits){
			if (h.canFindByVal(val)) return true;
		}
		return false;
	}
	public this (ParseTree p){
		begin = cast(int)p.begin;
		end = cast(int)p.end;
		tag = p.name.startsWith("SC.") ? p.name[3..$]:p.name; //remove SC. 
		if (p.children.length == 0) val = p.matches[0];
		foreach(c;p.children)hits ~= new SCTree(c);
	}
	public bool writeError(string str){
		writeln(str ~ " [" ~ begin.to!string ~ "," ~ end.to!string ~ "]");
		return false;
	}

}
private SCTree makeTypeInfo(SCTree base,SCTree type,bool ptr = false,string arrayNum = ""){
	auto res = base.makeLeaf("Type_info","");
	res ~= base.makeLeaf(type.tag,type.val);
	if(ptr) res ~= base.makeLeaf("ptr","ptr");
	if(arrayNum != "")res ~= base.makeLeaf("array",arrayNum);
	return res;
}
private SCTree dummyStmt(SCTree base){
	auto res = base.makeLeaf("Stmt","");
	res.val = "";
	res ~= base.makeLeaf("literal",";");
	return res;
}
private SCTree dummyExpr(SCTree base){
	auto res = base.makeLeaf("Expr","");
	res.val = "";
	res ~= base.makeLeaf("NUM","1");
	return res;
}

//Expr式をトリミング
private void trimExpr(ref SCTree t){
	const newTag = "Expr";
	const exprs = [
		"Expr","EB00","EB01","EB02","EB03","EB04","EB05","EB06", 
		"Postfix_expr","Unary_expr","Primary_expr",
	];
	if (exprs.canFind(t.tag)){
		t.tag = newTag;
		while(t.length == 1 && exprs.canFind(t[0].tag)){
			t[] = t[0][];
		}
	}
	foreach(ref h;t) trimExpr(h);
}
private SCTree parseFor(SCTree t,ref int semi,string separator){
	if (t[semi].val == separator){
		semi ++; 
		return dummyExpr(t);
	} else {
		semi += 2;
		return t[semi-2];
	}
}	

private void trimThis(ref SCTree t){
	if (t.tag.startsWith("literal!"))t.tag = "literal";
	switch(t.tag){
	case "Stmts": 
		t[] = t[1..$];
		return;			
	case "Fun_declare":
		SCTree[] newHits;
		auto type = t[0];
		auto isPtr = t[1].canFindByVal("*");
		newHits ~= makeTypeInfo(t,type,isPtr);
		newHits ~= t[1].searchByTag("ID");
		if(t.length > 2){
			foreach(h;t[2..$]){
				auto newParam = h.makeLeaf();
				auto ptype = h.searchByTag("Type");
				auto pid = h.searchByTag("ID");
				auto pisPtr = h.canFindByVal("*");
				newParam ~= makeTypeInfo(h,ptype,pisPtr);
				newParam ~= pid;
				newHits ~= newParam;
			}		
		}
		t[] = newHits;
		return;	
	case "Stmt":
		switch(t[0].val){
		case "if":
			if (t.length == 3){
				t ~= t[0].makeLeaf("Stmt","");
				t[3].val = "";
				t[3] ~= t[0].makeLeaf("literal",";");
			}
			return;		
		case "for":
			SCTree[] newHits ;
			int semi = 1;
			newHits ~= t[0];
			newHits ~= t.parseFor(semi,";");
			newHits ~= t.parseFor(semi,";");
			newHits ~= t.parseFor(semi,")");
			newHits ~= t[semi];
			t[] = newHits;
			return;		
		case "while":
			SCTree[] newHits;
			newHits ~= t[0];
			newHits[0].val = "for";
			newHits ~= dummyExpr(t);
			newHits ~= t[1];
			newHits ~= dummyExpr(t);
			newHits ~= t[2];
			t[] = newHits;
			return;		
		default : return;
		}	
	case "Expr":
		
		if(t.length != 2) return;
		switch(t[0].val){
		case "-":
			SCTree[] newHits;
			newHits ~= t.makeLeaf("Expr");
			newHits[0] ~= t.makeLeaf("NUM","0");
			newHits ~= t[0];
			newHits ~= t[1];
			t[] = newHits;
			return;
		default :return;
		}
	default:return;
	}
}
private void trimHits(ref SCTree t){
	SCTree[] newHits;
	foreach(h;t){
		switch(h.tag){
		case "Var_def":
			auto type = h[0];
			foreach(hh;h[1..$]){
				auto H = h.makeLeaf();
				bool isPtr = hh.canFindByVal("*");
				string isArray = hh.searchByTag("NUM").val;
				H ~= makeTypeInfo(h,type,isPtr,isArray);	
				H ~= hh.searchByTag("ID");
				newHits ~= H;
			}
			break;		
		case "Array":
			newHits ~= h.makeLeaf("literal","*");
			auto expr = h.makeLeaf("Expr", "");
			expr.val = "";
			expr ~= h[0];
			expr ~= h.makeLeaf("literal","+");
			expr ~= h[1];
			newHits ~= expr;
			break;	
		default: 
			newHits ~= h;
			break;
		}
	}
	t[] = newHits;
}
private void trimHits2(ref SCTree t){
	SCTree[] newHits;

	foreach(h;t){
		switch(h.tag){
			case "Expr":
			if(h.length == 2 
				&& h[0].val == "&"
				&& h[1].length == 2 
				&& h[1][0].val == "*"){
					newHits ~= h[1][1];
					break;
			}
			goto default;
		default: 
			newHits ~= h;
			break;
		}
	}
	t[] = newHits;
}
//整形
private void trim(ref SCTree t){
	trimThis(t);
	trimHits(t);
	foreach(ref h;t){trim(h);}
}
private void trim2(ref SCTree t){
	trimHits2(t);
	foreach(ref h;t){trim2(h);}
}

bool tryTrim(ref SCTree t){	
	trimExpr(t);
	trim(t);
	trim2(t);
	return true;
}
