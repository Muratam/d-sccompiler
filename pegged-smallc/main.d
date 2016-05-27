import pegged.grammar;
import std.stdio,std.algorithm,std.math,std.range,std.string,std.conv,std.file;
import smallc.scdef,smallc.sctrim;
import smallc.scsemanticanalysis,smallc.scintermediate;
import smallc.scmips;
static if (!makeModule){
	import smallc.sc;

	void analyze(string code){	
		code.writeln;
		const printproto = "";//"void print(int i){}";
		ParseTree p = SC(printproto ~ code);
		//p.writeln;
		if (!p.successful) {
			"Parse Error !!\n\n".writeln;
			return;
		}
		SCTree g = SCTree(p);
		if (!tryTrim(g)) {
			"reserved Error".writeln;
			return;
		}
		//g.writeln;
		if (!g.semanticAnalyze){
			"Using Illegal Semantics !!!".writeln;
			return;
		}
		auto glob = new Global(g);
		glob.writeln;
		
		//glob.toOffset();
		//glob.writeln("\n\n\n");
		//glob.toMipsCode().writeln;

	}
}
void main(string[] args){
	static if (makeModule) asModule("smallc.sc","smallc/sc",scdefstr);
	else {
		sandbox();
		if (args.length > 1) {
			writeln("analyze " ~ args[1]);
			analyze(readText(args[1]));
			return ;
		}
		while (true) analyze(readln());
	}
}

unittest{
	analyze("int main(){int a,b;a = b;}");
	analyze("int main(){int *a,*b;a = b;}");
	analyze("int main(){int *a,b[3];a = b;}");
	analyze("int main(){int a[2],*b;a = b;}");
	analyze("int main(){int a;a = 3;}");
	analyze("int main(){int a;3 = a;}");
	//analyze("int main(){int a;if(a);}");
	//analyze("int main(){int *a;if(a);}");
}

void sandbox(){
	/+
	class Tree{}
	class Leaf:Tree{int a;}
	class Node:Tree{Tree l,r;}
	auto suma(Tree t){
		return t.castSwitch!(
			(Leaf leaf) => leaf.a,
			(Node node) => suma(node.l) + suma(node.r),
			(Object _) => assert(false)
		)();
	}+/
	import std.typetuple,std.typecons;
	//auto tuple(x,y) = tuple(1,"h1");
	//writeln(x,y);
	auto x = 10,y = 20;
	//{x,y} = {5,6};
	//writeln(x,"  ",y);
}

