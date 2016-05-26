module smallc.scmips;
import std.stdio,std.algorithm,std.math,std.range,std.string,std.conv;
import smallc.scintermediate;
import pegged.grammar;

//todo : 3 = 10;
//todo : int a[3],d[2];a = d;

class MipsTestFuns{
	string[] mips1(){
		//print(20);
		return [
			"li $v0,1",
			"li $a0,20",
			"syscall",
		];	
	}
	string[] mips2(){
		//print(t1 = sp[4] = t0 = 5);
		return [
			"li $t0,5",
			"sw $t0, 4($sp)",
			"lw $t1, 4($sp)",
			"move $a0,$t1",
			"li $v0,1",
			"syscall",
		];	
	}
	string[] mips34(){ //F call test
		//print(v0 = f(a0 = 10));
		//sp[0] = ra; v0 = f(); ra = sp[0];
		return [
			"li $a0,5",
			"sw $ra,0($sp)",
			"jal f",
			"lw $ra,0($sp)"
				"move $a0,$v0",
			"li $v0,1",
			"syscall",
		];	
	}
	string[] f3(){
		//return v0 = a0 + 2
		return [
			"addiu $sp,$sp,-4",
			"addiu $v0,$a0,2",
			"addiu $sp,$sp,4",
		];
	}
	string[] f4(){//再帰
		//return v0 = (a0 <= 0 ? 0 :
		//    sp[8]=a0, a0-=1, v0 + a0)
		//sp[4] = ra; f();ra = sp[4];a0 = sp[8];
		//v0 = v0 + a0 
		return [
			"addiu $sp,$sp,-12",
			"ble $a0,0,end",
			"sw $a0,8($sp)",
			"addiu $a0,$a0,-1",
			"addiu $v0,$a0,2",
			"addiu $sp,$sp,4",
			"jr $ra",
			"end:",
			"li $v0,0",
			"addiu $sp,$sp,12",
			"jr $ra"
		];

	}
	void test3(){/+
		int f(int x){
			while(x > 1)x = x-2;
			return x;
		}
		//sp -=24
		//sp[1] = ra;sp[0] = fp;
		//fp = sp + 20
		//ra = sp[1];fp = sp[0]
		void main(){int x;print(f(9));}
	+/}



	//sp -----増えていく
	//fp = sp + locals * ra 
	//gp,sp,fp,ra ? 
	//temp   : t0..t9 t100 ?
	//params : a0..a3 a100 ?  
	//return : v0..v1 v100 ?


	//
	//add    : rd rs rt
	//    and
	//addi   : rt rs imm
	//    andi 
	// lw sw
}
struct MipsTestCase{
	static string case1 = r"
		int main(){print(72);}
		int andr(){int *a,b;a=&b;}
		int addr(){int a[3],b[2];a[1] = b[2] = 3;print (a[1]);}
		int aop(){
			int a,b;
			a = 1,b = 2;
			b = a + 1;
			a = 10 - b;
			a = b * 10;
			b = a / b;
			a = -a;						
		}
		int lop(){
			int a,b;
			a = 1,b = 2;
			a = a > b;
			a = a >= b;
			b = a == b;
			a = a < b;
			b = a <= b;
			a = a != b;
		}
		int func(int i){
			if (i == 1) return 1;
			else return i * func(i - 1);
		}
		int ifs(){
			int a,b;
			a = 0 || b || 10;
			b = 0 && b || 3;
		}
		int WHILE(int i){
			int res;
			res = 1;
			while(i){res = res * i;i = i - 1;}
			return res;
		}
	";

}

//微妙 :: sp のはグローバルを考慮するべき
//  : VarExpr : t0 = sp[?] 
//  : LitExpr : t0 = n 
//  : AopExpr : t1 = sp[?];t2 = sp[?];t0 = t1 op t2 
//  : AddrExpr: t0 = sp + Offset 
//  : PrintStmt : print(t0)
//  : AssignStmt : sp[?] = t0 
//  : WriteMemStmt: *a = b
//  : == ReadMemStmt: a = *b
//  : IfStmt    : beqz
//  : GotoStmt  : j


//まだ
//t4,s5 とかは 最適化するときに使うのだろう
//at,zero,k0,k1 は今は使わないだろう

//function : return v0,v1;
//         : arg(a0,a1,a2,a3)
//         : ra (return address)
//gp  :: global
//fp  :: frame pointer


//  : ApplyStmt : a0...a4 (他はあとで)に値をいれて、
//                jal して 
//                fp[0] = v0
//  : ReturnStmt 
struct R{
	string name;
	alias name this;
	this(string name){this.name = "$" ~ name;}	
	mixin((as=>as.map!(a=>`static R `~a~`=R("`~a~`");`).fold!"a~b")([
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
