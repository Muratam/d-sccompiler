module smallc.scmips;
import std.stdio,std.algorithm,std.math,std.range,std.string,std.conv;
import smallc.scintermediate;
import pegged.grammar;
//zero 
///////at     : for Assember
//v0..v1 : results of function
//a0..a3 : arguments
//t0..t9 : not preserved
//////s0..s7 : preserved 
/////////k0..k1 : for OS kernel 
//////gp     : global pointer
//sp     : stack pointer
/////////fp     : frame pointer
//ra     : return address


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
