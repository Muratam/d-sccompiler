module smallc.scmips;
import std.stdio,std.algorithm,std.math,std.range,std.string,std.conv;
import smallc.scintermediate;
import pegged.grammar;

struct R{
	string name;
	alias name this;
	this(string name){this.name = "$" ~ name;}	
	mixin((as=>as.map!(a=>`static const R `~a~`=R("`~a~`");`).fold!"a~b")([
		"zero",  // 0
		"at",    //for Assember
		"v0","v1", //results of function
		"a0","a1","a2","a3", //arguments
		"t0","t1","t2","t3","t4","t5","t6","t7","t8","t9", // temporary
		"s0","s1","s2","s3","s4","s5","s6","s7", // perserved
		"k0","k1", //for OS kernel
		"gp", //global pointer
		"sp", //stack pointer
		"fp", //frame pointer
		"ra", //return address
	]));
}

static struct Mips{

	//Assign/////////////////////////////////////////////////////////
	//$to = $from
	static string move(R to,R from){
		return "move " ~ to ~ "," ~ from;
	}
	//$var = num
	static string li(R var,int num){
		return "li " ~ var ~ "," ~ num.to!string; 
	}


	///Load Save///////////////////////////////////////////////////////
	//$pt[num] = $var
	static string sw(R from,int offset,R ptr){
		return "sw " ~ from ~ ", "~offset.to!string ~ "("~ptr~")";
	}
	static string lw(R to,int offset,R ptr){
		return "lw " ~ to   ~ ", "~offset.to!string ~ "("~ptr~")"; 
	}
	static string[] startsFunc(int maxOffset){
		endsFunc = mkEndsFunc(maxOffset);
		return [ 
			Mips.addiu(R.sp,R.sp,-maxOffset),
			Mips.sw(R.ra,4,R.sp),
			Mips.sw(R.fp,0,R.sp),
			Mips.addiu(R.fp,R.sp, maxOffset)
		];
	}
	private static auto mkEndsFunc (int maxOffset) {
		return [ 
			Mips.lw(R.ra,4,R.sp),
			Mips.lw(R.fp,0,R.sp),
			Mips.addiu(R.sp,R.sp,maxOffset),
			Mips.jr(R.ra)
		];
	}
	static string[] endsFunc;

	//Jump//////////////////////////////////////////////////////////
	//goto $addr
	static string jr(R addr){
		return "jr "~ addr;
	}
	//goto label
	static string j (string label){
		return "j " ~ label;
	}
	//sw $ra ,goto label  
    static string jal(string label){
		return "jal " ~ label;
	}
	//if (! $R) goto label
	static string beqz(R notZero,string label){
		return "beqz " ~ notZero ~ "," ~ label;
	}


	//AOP///////////////////////////////////////////////////////////
	//$to = $from op num
	private static string IFormat (string name){
		return `
		public static string `~name~` (R to,R from,int num){
			return "`~name~`" ~ " " ~ to ~ "," ~ from ~ "," ~ num.to!string;
		}
		`;
	}
	//$to = $from1 op $from2
	private static string RFormat(string name){
		return `
		public static string `~name~` (R to,R from1,R from2){
			return "`~name~`" ~  " "~ to ~ "," ~ from1 ~ "," ~ from2;
		}`;
	}
	mixin(IFormat("addiu"));
	mixin(RFormat("add"));
	mixin(RFormat("sub"));
	mixin(RFormat("mul"));
	mixin(RFormat("div"));
	mixin(RFormat("seq"));
	mixin(RFormat("sne"));
	mixin(RFormat("sle"));
	mixin(RFormat("sge"));
	mixin(RFormat("sgt"));
	mixin(RFormat("slt"));

}
