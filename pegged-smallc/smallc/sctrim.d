module smallc.sctrim;
import std.stdio,std.algorithm,std.math,std.range,std.string,std.conv;
import pegged.grammar;
import std.typecons;
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

class SCTree{
	static int[] newLines;
	public static void setNewLines(string code){
		newLines = [];
		foreach(int i,c;code)if (c == '\n') newLines ~= i;			
	}
	public string getLineNumberMessage(){
		string res(int i,int r){
			return "[行:" ~ i.to!string ~ ",列:"~ r.to!string  ~ "]";
		}
		for(int i = 0;i < newLines.length + 1 ; i ++){
			if(i == newLines.length || begin < newLines[i]) {
				return res(i+1,i == 0 ? 0 :begin - newLines[i-1]);
			}
		}
		return newLines.to!string ~ begin.to!string;
	}


	public int begin = 0, end = 0;
	public string elem = ""; 
	public string tag = ""; 
	protected SCTree[] hits = []; //called by []
	public bool isLeaf (){return hits.length == 0 ;}
	public SCTree opIndex(size_t i) { return hits[i];}
	public SCTree opIndexAssign(SCTree value,size_t i){return hits[i] = value;}
	public ref SCTree[] opSlice(){return hits;}
	public SCTree[] opSliceAssign(SCTree[] value){return hits = value;}
	public SCTree[] opSlice(size_t x,size_t y){return hits[x..y];}
	public size_t opDollar(){return hits.length; }
	@property public size_t length(){return hits.length;}
	public SCTree[] opOpAssign(string op)(SCTree rhs){ // ~= のみ： ~ は曖昧性のため存在しない
		static if(op == "~") {hits ~= rhs;return hits; } 
		else static assert(0,"no operator" ~ op);
	}

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
		stderr.writeln(str ~ " " ~ getLineNumberMessage());
		return false;
	}
	private SCTree makeTypeInfo(SCTree type,bool ptr = false,string arrayNum = ""){
		auto res = makeLeaf("Type_info","");
		res ~= makeLeaf(type.tag,type.elem);
		if(ptr) res ~= makeLeaf("ptr","ptr");
		if(arrayNum != "")res ~= makeLeaf("array",arrayNum);
		return res;
	}
	private SCTree makeDummyStmt(){
		auto res = makeLeaf("Stmt","");
		res.elem = "";
		res ~= makeLeaf("literal",";");
		return res;
	}
	private SCTree makeDummyExpr(){
		auto res = makeLeaf("Expr","");
		res.elem = "";
		res ~= makeLeaf("NUM","1");
		return res;
	}
	//Expr式をトリミング
	public void trimExpr(){
		const newTag = "Expr";
		const exprs = [
			"Expr","EB00","EB01","EB02","EB03","EB04","EB05","EB06", 
			"Postfix_expr","Unary_expr","Primary_expr",
		];
		if (exprs.canFind(tag)){
			tag = newTag;
			while(hits.length == 1 && exprs.canFind(this[0].tag)){
				this[] = this[0][];
			}
		}
		foreach(ref h;this[]) h.trimExpr();
	}
	private SCTree parseFor(ref int semi,string separator){
		if (this[semi].elem == separator){
			semi ++; 
			return makeDummyExpr();
		} else {
			semi += 2;
			return this[semi-2];
		}
	}	

	private void trimThis(){
		if (tag.startsWith("literal!"))tag = "literal";
		switch(tag){
		case "Stmts": 
			this[] = this[1..$];
			return;			
		case "Fun_declare":
			SCTree[] newHits;
			auto type = this[0];
			auto isPtr = this[1].hasElem("*");
			newHits ~= makeTypeInfo(type,isPtr);
			newHits ~= this[1].find("ID");
			if(length > 2){
				foreach(h;this[2..$]){
					auto newParam = h.makeLeaf();
					auto ptype = h.find("Type");
					auto pid = h.find("ID");
					auto pisPtr = h.hasElem("*");
					newParam ~= h.makeTypeInfo(ptype,pisPtr);
					newParam ~= pid;
					newHits ~= newParam;
				}		
			}
			this[] = newHits;
			return;	
		case "Stmt":
			switch(this[0].elem){
			case "if":
				if (length == 3){
					this ~= this[0].makeLeaf("Stmt","");
					this[3].elem = "";
					this[3] ~= this[0].makeLeaf("literal",";");
				}
				return;		
			case "for":
				SCTree[] newHits ;
				int semi = 1;
				newHits ~= this[0];
				newHits ~= parseFor(semi,";");
				newHits ~= parseFor(semi,";");
				newHits ~= parseFor(semi,")");
				newHits ~= this[semi];
				this[] = newHits;
				return;		
			case "while":
				SCTree[] newHits;
				newHits ~= this[0];
				newHits[0].elem = "for";
				newHits ~= makeDummyExpr();
				newHits ~= this[1];
				newHits ~= makeDummyExpr();
				newHits ~= this[2];
				this[] = newHits;
				return;		
			default : return;
			}	
		case "Expr":				
			if(length != 2) return;
			switch(this[0].elem){
			case "-":
				SCTree[] newHits;
				newHits ~= makeLeaf("Expr");
				newHits[0] ~= makeLeaf("NUM","0");
				newHits ~= this[0];
				newHits ~= this[1];
				this[] = newHits;
				return;
			default :return;
			}
		default:return;
		}
	}
	private void trimHits(){
		SCTree[] newHits;
		foreach(h;this[]){
			switch(h.tag){
			case "Var_def":
				auto type = h[0];
				foreach(hh;h[1..$]){
					auto H = h.makeLeaf();
					bool isPtr = hh.hasElem("*");
					string isArray = hh.find("NUM").elem;
					H ~= h.makeTypeInfo(type,isPtr,isArray);	
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
		this[] = newHits;
	}
	private void trimHits2(){
		SCTree[] newHits;		
		foreach(h;this[]){
			switch(h.tag){
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
		this[] = newHits;
	}

	//整形	
	private void trim(){
		trimThis();
		trimHits();
		foreach(ref h;this[])h.trim();
	}
	private void trim2(){
		trimHits2();
		foreach(ref h;this[])h.trim2();
	}
	
	public bool tryTrim(){	
		trimExpr();
		trim();
		trim2();
		return true;
	}

}


