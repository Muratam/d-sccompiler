import pegged.grammar;
import std.stdio,std.algorithm,std.math,std.range,std.string,std.conv,std.file;
import smallc.scdef,smallc.sctrim;
import smallc.scsemanticanalysis,smallc.scintermediate;
import smallc.scmips,smallc.scintermediateclasses;
import core.sys.posix.stdlib;
//compiler options
bool optimize = true;
bool verbose  = false;
bool showflow = false;
bool showComment = true;

static if (!makeModule){
	import smallc.sc;

	void analyze(string code){
		try{
			if(showComment) ("# " ~ code.replace("\n","\n#")).writeln;
			const printproto = "void print(int i){}";
			code = printproto ~ code;
			ParseTree p = SC(code);
			if (p.end - p.begin < code.length ) {
				stderr.writeln("Parse Error !!\n\n");
				exit(1);
			}
			SCTree g = new SCTree(p);
			if (!g.tryTrim()) {
				stderr.writeln("reserved Error");
				exit(1);
			}
			 if(verbose)g.writeln;
			if (!(new SemanticAnalyze().startAnalyze(g))){
				stderr.writeln("Using Illegal Semantics !!!");
				exit(1);
			}
			auto global = new Global(g);
			if(verbose)global.writeln;
			LabeledBlock.analyze(global);
			new ToOffset(global);
			if(verbose)global.writeln;
			new ToMips().toMipsCode(global).writeln;
		}
		catch{
			stderr.writeln("illegal code!");
			exit(1);
		}
	}
}
void main(string[] args){
	static if (makeModule) asModule("smallc.sc","smallc/sc",scdefstr);
	else {
		if (args.canFind("-N"))optimize = false;
		if (args.canFind("-V"))verbose = true;
		if (args.canFind("-F"))showflow = true;
		if (args.canFind("-C"))showComment = false;
		if (["--help","-h","--h","-help"].map!(a=>args.canFind(a)).any!"a"){
			if(showComment) dlangAA.writeln;
			return;
		}
		foreach(arg;args){
			if(arg.endsWith(".sc")){
				if(showComment) writeln("#analyze " ~ arg);
				analyze(readText(arg));
				return;
			}
		}
		if(showComment) dlangAA.writeln;
		for(string rl;rl = readln(),rl != ""; ){
			analyze(rl);
		}
	}
}


unittest{
	optimize = false;
	//verbose = true;
	[
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
		"int main(){int a,b,c;a = 10;b = 20;c = b;print(a + b + c);}"
	].each!analyze;

	//[
	//	"arith.sc", //#
	//	"array.sc", //#
	//	"cmp.sc", //#
	//	"fib.sc", //#
	//	"gcd.sc", //#
	//	"global.sc", //#
	//	"logic.sc", //#
	//	"scope.sc", //#
	//	"swap.sc", //#
	//	"while.sc", //#
	//].map!(a=>"../../smallcCode/basic/" ~ a)
	//	.each!(a=>readText(a).analyze());
	/+
	[
		"ack.sc",
		"bubble.sc",
		"insert.sc",
		"loop_sum.sc", //#
		"matmul.sc",
		"merge.sc",//!
		"quick.sc",
		"recur_sum.sc",//!
		"ret_ptr.sc",//!
		"share_ints.sc",//!
		"short.sc", //#
	].map!(a=>"../../smallcCode/advanced/" ~ a)
		.tee!(a=>a.writeln)
		.each!(a=>readText(a).analyze());
	+/
}

string dlangAA = `
#   _   _    smallC->mips compiler by murata !
#  (_) (_)   written in dlang !! awesome !
# /______ \  thanks for the package PEGGED !!
# \\(O(O \/
#  | | | |   for more information,see
#  | |_| |     https://github.com/Muratam/d-sccompiler !
# /______/   usage :
#   <   >      $rdmd main.d # input smallcCode std-in or
#  (_) (_)     $rdmd main.d hoge.sc # specify filename
#            option :
#              -N : not optimize
#              -V : verbose (output intermediate process too)
#              -F : show flow graph (make flow.png in current directory)
#              -C : not show comment
#            DlangAA :thanks to https://gist.github.com/simdnyan/20e8fa2a2736c315e2c1
`;