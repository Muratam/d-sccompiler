  .text
  .globl main
swap:
  addiu $sp,$sp,-20
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,20
  lw $t0, 0($fp)
  lw $t0, 0($t0)
  sw $t0, 12($sp)
  lw $t0, 12($sp)
  sw $t0, 8($sp)
  lw $t0, 4($fp)
  lw $t0, 0($t0)
  sw $t0, 16($sp)
  lw $t0, 16($sp)
  lw $t1, 0($fp)
  sw $t0, 0($t1)
  lw $t0, 8($sp)
  lw $t1, 4($fp)
  sw $t0, 0($t1)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,20
  jr $ra
main:
  addiu $sp,$sp,-44
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,44
  li $t0,1
  sw $t0, 16($sp)
  li $t0,1
  sw $t0, 8($sp)
  li $t0,2
  sw $t0, 20($sp)
  li $t0,2
  sw $t0, 12($sp)
  addiu $t0,$sp,8
  sw $t0, 24($sp)
  addiu $t0,$sp,12
  sw $t0, 28($sp)
  addiu $t1,$sp,-8
  lw $t0, 24($sp)
  sw $t0, 0($t1)
  lw $t0, 28($sp)
  sw $t0, 4($t1)
  move $sp,$t1
  jal swap
  addiu $sp,$sp,8
  lw $t1, 8($sp)
  li $t2,2
  seq $t0,$t1,$t2
  sw $t0, 36($sp)
  lw $t0, 36($sp)
  beqz $t0,_L2
_L1:
  lw $t1, 12($sp)
  li $t2,1
  seq $t0,$t1,$t2
  sw $t0, 40($sp)
  lw $t0, 40($sp)
  beqz $t0,_L5
_L4:
  li $t0,1
  sw $t0, 32($sp)
  j _L6
_L5:
  li $t0,0
  sw $t0, 32($sp)
_L6:
  j _L3
_L2:
  li $t0,0
  sw $t0, 32($sp)
_L3:
  lw $a0, 32($sp)
  li $v0,1
  syscall
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,44
  jr $ra

