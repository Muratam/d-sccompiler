  .text
  .globl main
gcd:
  addiu $sp,$sp,-32
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,32
  lw $t1, 0($fp)
  lw $t2, 4($fp)
  seq $t0,$t1,$t2
  sw $t0, 8($sp)
  lw $t0, 8($sp)
  beqz $t0,_L2
_L1:
  lw $v0, 0($fp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,32
  jr $ra
_L2:
  lw $t1, 0($fp)
  lw $t2, 4($fp)
  sgt $t0,$t1,$t2
  sw $t0, 12($sp)
  lw $t0, 12($sp)
  beqz $t0,_L5
_L4:
  lw $t1, 0($fp)
  lw $t2, 4($fp)
  sub $t0,$t1,$t2
  sw $t0, 16($sp)
  addiu $t1,$sp,-8
  lw $t0, 16($sp)
  sw $t0, 0($t1)
  lw $t0, 4($fp)
  sw $t0, 4($t1)
  move $sp,$t1
  jal gcd
  addiu $sp,$sp,8
  sw $v0, 20($sp)
  lw $v0, 20($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,32
  jr $ra
_L5:
  lw $t1, 4($fp)
  lw $t2, 0($fp)
  sub $t0,$t1,$t2
  sw $t0, 24($sp)
  addiu $t1,$sp,-8
  lw $t0, 0($fp)
  sw $t0, 0($t1)
  lw $t0, 24($sp)
  sw $t0, 4($t1)
  move $sp,$t1
  jal gcd
  addiu $sp,$sp,8
  sw $v0, 28($sp)
  lw $v0, 28($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,32
  jr $ra
_L6:
_L3:
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,32
  jr $ra
main:
  addiu $sp,$sp,-16
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,16
  addiu $t1,$sp,-8
  li $t0,315
  sw $t0, 0($t1)
  li $t0,189
  sw $t0, 4($t1)
  move $sp,$t1
  jal gcd
  addiu $sp,$sp,8
  sw $v0, 8($sp)
  lw $t1, 8($sp)
  li $t2,63
  seq $t0,$t1,$t2
  sw $t0, 12($sp)
  lw $a0, 12($sp)
  li $v0,1
  syscall
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,16
  jr $ra

