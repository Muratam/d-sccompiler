import pegged.grammar;
import std.stdio,std.algorithm,std.math,std.range,std.string,std.conv,std.file;
import smallc.scdef,smallc.sctrim,smallc.scsemanticanalysis,smallc.scintermediate;

static if (!makeModule){
	import smallc.sc;

	void analyze(string code){	
		const printproto = "";//"void print(int i){}";
		ParseTree p = SC(printproto ~ code);
		if (!p.successful) {
			"Parse Error !!\n\n".writeln;
			return;
		}
		SCTree g = SCTree(p);
		if (!tryTrim(g)) {
			"reserved Error".writeln;
			return;
		}
		g.writeln;
		if (!g.semanticAnalyze){
			"Using Illegal Semantics !!!".writeln;
			return;
		}
		auto glob = new Global(g);
		glob.writeln;
	}
}
void main(string args[]){
	static if (makeModule) asModule("smallc.sc","smallc/sc",scdefstr);
	else {
		if (args.length > 1) {
			writeln("analyze " ~ args[1]);
			analyze(readText(args[1]));
			return ;
		}
		while (true) analyze(readln());
	}
}

