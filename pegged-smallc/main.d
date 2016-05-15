import pegged.grammar;
import std.stdio,std.algorithm,std.math,std.range,std.string,std.conv;
import smallc.scdef,smallc.sctrim,smallc.scsemanticanalysis,smallc.scintermediate;

static if (!makeModule){
	import smallc.sc;

	void analyze(){	
		ParseTree p ;
		const printproto = "void print(int i){}";
		while(p = SC(printproto ~ readln()),true){
			if (!p.successful) "Parse Error !!\n\n".writeln;
			SCTree g = SCTree(p);
			if (!tryTrim(g)) {
				"reserved Error".writeln;
				continue;
			}
			g.writeln;
			if (!g.semanticAnalyze){
				"Using Illegal Semantics !!!".writeln;
				continue;
			}
			auto glob = new Global(g);
			glob.writeln;
		}  
	}
}
void main(){
	static if (makeModule) asModule("smallc.sc","smallc/sc",scdefstr);
	else analyze();
}

