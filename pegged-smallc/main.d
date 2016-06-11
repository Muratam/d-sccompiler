import pegged.grammar;
import std.stdio,std.algorithm,std.math,std.range,std.string,std.conv,std.file;
import smallc.scdef,smallc.sctrim;
import smallc.scsemanticanalysis,smallc.scintermediate;

import smallc.scmips,smallc.scintermediateclasses;

//le3soft-staff@fos.kuis.kyoto-u.ac.jp / 最終報告 => 最終報告
//sample ng1
//basic gcd global 
//err shape02:isNum=>isIDで代入文 type09 type10
//advance bubble insert ret_ptr:prototype宣言
//木構造を簡単に扱える機構が欲しい
static if (!makeModule){
	import smallc.sc;

	void analyze(string code){
		//try{
			("# " ~ code.replace("\n","\n#")).writeln;
			const printproto = "void print(int i){}";
			code = printproto ~ code;
			ParseTree p = SC(code);
			if (p.end - p.begin < code.length) {
				"Parse Error !!\n\n".writeln;
				return;
			}
			SCTree g = new SCTree(p);
			if (!g.tryTrim()) {
				"reserved Error".writeln;
				return;
			}
			//g.writeln;
			if (!(new SemanticAnalyze().startAnalyze(g))){
				"Using Illegal Semantics !!!".writeln;
				return;
			}
			auto global = new Global(g);
			global.writeln;
			LabeledBlock.analyze(global);
			new ToOffset(global);
			new ToMips().toMipsCode(global).writeln;
		//}catch{"illegal code!".writeln;}
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
	//[
		//"int main(){print(111);print(444);}",
		//"int d(){}int main(){print(111);d();print(444);}",
		//"int d(){print(112);}int main(){d();d();}",
		//"void d(){print(123);}int main(){int a,b;a=b=12;d();if(a == 0){print(a == 0 && 0);return a;}else {int i;for(i=0;i<10;i = i + 1)print(i);} return b;}",
		//"int d(){print(112);}int main(){int i;for(i=0;i<10;i = i+1)d();}",
		//"int d(){print(112);}int main(){int i;for(i=0;i<10;i = i+1){print(i);d();}}",
		//"int d(){if(0)return 72;return 11;}int main(){print(d());}",
		//"int d(int n){return n;}int main(){print(d(12));}",
		//"int sum(int a,int b,int c,int d){return a+b+c+d; } int main(){print(sum(1,2,3,4));}",
		//"int main(){print(112 + 4434 * 3 >=  555 + 5542 / 22 );}",
		//"int main(){int a,b,c;a = 112 ;b = 4434 * 3;c = 10;if(a)print(a + b >=  555 + a / 22 );}",
		//"int fa(int n){	if(n == 0)return 1;else return n * fa(n-1);}int main(){ print(fa(4));}",
		//"int a;int main(){a = 72;print(a);}",
	//].each!analyze;
	[ 
	//  "arith.sc",
	//	"array.sc",
	//	"cmp.sc", //#
	//	"fib.sc", //#
		"gcd.sc",
	//	"global.sc",
	//  "logic.sc",	
	//	"scope.sc",
	//	"swap.sc",
	//	"while.sc",
	].map!(a=>"../../smallcCode/basic/" ~ a)
		.each!(a=>readText(a).analyze());
}