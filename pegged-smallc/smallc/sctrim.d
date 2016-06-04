module smallc.sctrim;
import std.stdio,std.algorithm,std.math,std.range,std.string,std.conv;
import pegged.grammar;

//base class : STree にして、SCTreeをextends にして、処理を見やすくする
//envなどを含むクラスにする

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
	public int begin = 0, end = 0;
	public string elem = ""; 
	private string tag = ""; 
	private SCTree[] hits = [];
	public bool isLeaf (){return hits.length == 0 ;}

	SCTree opIndex(size_t i) { return hits[i];}
	SCTree opIndexAssign(SCTree value,size_t i){return hits[i] = value;}
	ref SCTree[] opSlice(){return hits;}
	SCTree[] opSliceAssign(SCTree[] value){return hits = value;}
	SCTree[] opSlice(size_t x,size_t y){return hits[x..y];}
	size_t opDollar(){return hits.length; }
	@property public size_t length(){return hits.length;}
	SCTree[] opOpAssign(string op)(SCTree rhs){ // ~= のみ： ~ は曖昧性のため存在しない
		static if(op == "~") {hits ~= rhs;return hits; } 
		else static assert(0,"no operator" ~ op);
	}
	ref string opCall(){ return tag;}

	public override string toString() {return toString("");}
	public string toString(string tabs)const {
		string mayelem = elem == "" ? "" : "{ " ~ elem ~ " }";
		string res = tag ~":" ~mayelem~ " "~ to!string([begin, end])~"\n";
        string hitsString;     
        foreach(i,child; hits){
            hitsString ~= tabs ~ " +-" ~ child.toString(tabs ~ ((i<hits.length -1)?" | " : "   "));
        }
		return res ~ hitsString;
	}
	public this (string tag ,int begin = 0,int end = 0,string elem = "",SCTree[] hits = cast(SCTree[])[]){
		this.tag = tag;
		this.begin = begin;
		this.end = end;			
		this.elem = elem;
		this.hits = hits;
	}
	public SCTree makeLeaf(string tag = null,string elem = null){
		return new SCTree(tag == null ? this.tag:tag,this.begin,this.end,elem == null ? this.elem:elem);
	}
	public SCTree find(string tag){
		assert(tag != "");
		if(tag == this.tag) return this;
		foreach(h;hits) {
			auto searched = h.find(tag);
			if(searched.tag != "") return searched;
		}
		return new SCTree("");
	}
	public SCTree findElem(string elem){
		assert(elem != "");
		if(elem == this.elem) return this;
		foreach(h;hits) {
			auto searched = h.findElem(elem);
			if(searched.elem != "") return searched;
		}
		return new SCTree("",0,0,"");
	}
	public bool has(string tag){
		if (tag == this.tag)return true;
		foreach(h;hits){
			if (h.has(tag)) return true;
		}
		return false;
	}
	public bool hasElem(string elem){
		if (elem == this.elem)return true;
		foreach(h;hits){
			if (h.hasElem(elem)) return true;
		}
		return false;
	}
	public this (ParseTree p){
		begin = cast(int)p.begin;
		end = cast(int)p.end;
		tag = p.name.startsWith("SC.") ? p.name[3..$]:p.name; //remove SC. 
		if (p.children.length == 0) elem = p.matches[0];
		foreach(c;p.children)hits ~= new SCTree(c);
	}
	public bool writeError(string str){
		writeln(str ~ " [" ~ begin.to!string ~ "," ~ end.to!string ~ "]");
		return false;
	}
}
private SCTree makeTypeInfo(SCTree base,SCTree type,bool ptr = false,string arrayNum = ""){
	auto res = base.makeLeaf("Type_info","");
	res ~= base.makeLeaf(type(),type.elem);
	if(ptr) res ~= base.makeLeaf("ptr","ptr");
	if(arrayNum != "")res ~= base.makeLeaf("array",arrayNum);
	return res;
}
private SCTree dummyStmt(SCTree base){
	auto res = base.makeLeaf("Stmt","");
	res.elem = "";
	res ~= base.makeLeaf("literal",";");
	return res;
}
private SCTree dummyExpr(SCTree base){
	auto res = base.makeLeaf("Expr","");
	res.elem = "";
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
	if (exprs.canFind(t())){
		t() = newTag;
		while(t.length == 1 && exprs.canFind(t[0]())){
			t[] = t[0][];
		}
	}
	foreach(ref h;t) trimExpr(h);
}
private SCTree parseFor(SCTree t,ref int semi,string separator){
	if (t[semi].elem == separator){
		semi ++; 
		return dummyExpr(t);
	} else {
		semi += 2;
		return t[semi-2];
	}
}	

private void trimThis(ref SCTree t){
	if (t().startsWith("literal!"))t() = "literal";
	switch(t()){
	case "Stmts": 
		t[] = t[1..$];
		return;			
	case "Fun_declare":
		SCTree[] newHits;
		auto type = t[0];
		auto isPtr = t[1].hasElem("*");
		newHits ~= makeTypeInfo(t,type,isPtr);
		newHits ~= t[1].find("ID");
		if(t.length > 2){
			foreach(h;t[2..$]){
				auto newParam = h.makeLeaf();
				auto ptype = h.find("Type");
				auto pid = h.find("ID");
				auto pisPtr = h.hasElem("*");
				newParam ~= makeTypeInfo(h,ptype,pisPtr);
				newParam ~= pid;
				newHits ~= newParam;
			}		
		}
		t[] = newHits;
		return;	
	case "Stmt":
		switch(t[0].elem){
		case "if":
			if (t.length == 3){
				t ~= t[0].makeLeaf("Stmt","");
				t[3].elem = "";
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
			newHits[0].elem = "for";
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
		switch(t[0].elem){
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
		switch(h()){
		case "Var_def":
			auto type = h[0];
			foreach(hh;h[1..$]){
				auto H = h.makeLeaf();
				bool isPtr = hh.hasElem("*");
				string isArray = hh.find("NUM").elem;
				H ~= makeTypeInfo(h,type,isPtr,isArray);	
				H ~= hh.find("ID");
				newHits ~= H;
			}
			break;		
		case "Array":
			newHits ~= h.makeLeaf("literal","*");
			auto expr = h.makeLeaf("Expr", "");
			expr.elem = "";
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
		switch(h()){
			case "Expr":
			if(h.length == 2
					&& h[0].elem == "&" 
					&& h[1].length == 2
					&& h[1][0].elem == "*"){
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
