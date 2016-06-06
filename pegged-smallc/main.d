import pegged.grammar;
import std.stdio,std.algorithm,std.math,std.range,std.string,std.conv,std.file;
import smallc.scdef,smallc.sctrim;
import smallc.scsemanticanalysis,smallc.scintermediate;
import smallc.scmips;

//le3soft-staff@fos.kuis.kyoto-u.ac.jp / 最終報告 => 最終報告
//sample ng1
//basic gcd global 
//err shape02:isNum=>isIDで代入文 type09 type10
//advance bubble insert ret_ptr:prototype宣言
//木構造を簡単に扱える機構が欲しい
static if (!makeModule){
	import smallc.sc;

	void analyze(string code){	
		("# " ~ code).writeln;
		const printproto = "void print(int i){}";
		ParseTree p = SC(printproto ~ code);
		//p.writeln;
		if (!p.successful) {
			"Parse Error !!\n\n".writeln;
			return;
		}
		SCTree g = new SCTree(p);
		if (!g.tryTrim()) {
			"reserved Error".writeln;
			return;
		}
		//g.writeln;
		if (!new SemanticAnalyze().startAnalyze(g)){
			"Using Illegal Semantics !!!".writeln;
			return;
		}
		auto glob = new Global(g);
		glob.writeln;
		new ToOffset(glob);
		new ToMips().toMipsCode(glob).writeln;
	}
}
void main(string[] args){
	static if (makeModule) asModule("smallc.sc","smallc/sc",scdefstr);
	else {

		if (args.length > 1) {
			writeln("#analyze " ~ args[1]);
			analyze(readText(args[1]));
			return ;
		}
		while (true) analyze(readln());
	}
}

unittest{
	[
		//"int main(){print(111);print(444);}",
		//"int d(){}int main(){print(111);d();print(444);}",
		//"int d(){print(112);}int main(){d();d();d();d();}",
		//"int d(){print(112);}int main(){int i;for(i=0;i<10;i = i+1)d();}",
		//"int d(){print(112);}int main(){int i;for(i=0;i<10;i = i+1){print(i);d();}}",
		//"int d(){if(0)return 72;return 11;}int main(){print(d());}",
		//"int d(int n){return n;}int main(){print(d(12));}",
		//"int sum(int a,int b,int c,int d){return a+b+c+d; } int main(){print(sum(1,2,3,4));}"
		//"int fa(int n){	if(n == 0)return 1;else return n * fa(n-1);}int main(){ print(fa(4));}",
		"int a;int main(){a = 72;print(a);}",
	].each!analyze;
}

void sandbox(){
	mixin(`
	def SUM(a,b): a + b
	`
		.replace("def","auto")
		.replace("SUM","SUM(T1,T2)")
		.replace("(a,b)","(T1 a,T2 b)")
		.replace(": a + b","{return a + b;}")
	);
	int a = SUM(0,10);
	/+
	mixin(d-py(`
	def sum (a,b):
		c = a + b
		c = c + 0
		c
	def fact(n):
		if n == 0 : return 1
		return n * n - 1	
	));
	auto sum(T1,T2)(T1 a,T2 b):
		auto c = a + b;
		c = c + 0;
		return c;
	auto fact(T1)(T1 n):
		if (n == 0) {return 1;}
		return n * n - 1
	+/

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

