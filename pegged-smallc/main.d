import pegged.grammar;
import std.stdio,std.algorithm,std.math,std.range,std.string,std.conv;
import smallc.scdef,smallc.sctrim,smallc.scsemanticanalysis;

static if (!makeModule){
	import smallc.sc;

	void analyze(){	
		ParseTree p ;
		while(p = SC("void print(int i);" ~ readln()),true){
			if (!p.successful) "Parse Error !!\n\n".writeln;
			SCTree g = SCTree(p);
			if (!tryTrim(g)) {
				"reserved Error".writeln;
				continue;
			}
			g.writeln;
			g.semanticAnalyze.writeln;
			//auto glob = Global(g);
			//glob.writeln;
		}  
	}
}
void main(){
	static if (makeModule) asModule("smallc.sc","smallc/sc",scdefstr);
	else analyze();
}

