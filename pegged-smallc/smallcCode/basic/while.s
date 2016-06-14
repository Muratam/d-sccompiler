  .text
  .globl main
w:
  addiu $sp,$sp,-24
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,24
  li $t0,0
  sw $t0, 8($sp)
_L1:
  lw $t1, 0($fp)
  li $t2,0
  sgt $t0,$t1,$t2
  sw $t0, 12($sp)
  lw $t0, 12($sp)
  beqz $t0,_L3
_L2:
  lw $t1, 8($sp)
  lw $t2, 0($fp)
  add $t0,$t1,$t2
  sw $t0, 16($sp)
  lw $t0, 16($sp)
  sw $t0, 8($sp)
  lw $t1, 0($fp)
  li $t2,1
  sub $t0,$t1,$t2
  sw $t0, 20($sp)
  lw $t0, 20($sp)
  sw $t0, 0($fp)
  j _L1
_L3:
  lw $v0, 8($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,24
  jr $ra
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,24
  jr $ra
main:
  addiu $sp,$sp,-16
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,16
  addiu $t1,$sp,-4
  li $t0,10
  sw $t0, 0($t1)
  move $sp,$t1
  jal w
  addiu $sp,$sp,4
  sw $v0, 8($sp)
  lw $t1, 8($sp)
  li $t2,55
  seq $t0,$t1,$t2
  sw $t0, 12($sp)
  lw $a0, 12($sp)
  li $v0,1
  syscall
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,16
  jr $ra

