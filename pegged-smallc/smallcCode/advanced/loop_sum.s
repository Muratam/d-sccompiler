  .text
  .globl main
init_v:
  addiu $sp,$sp,-52
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,52
  li $t0,0
  sw $t0, 12($sp)
  lw $t0, 12($sp)
  sw $t0, 8($sp)
_L1:
  li $t0,100
  sw $t0, 16($sp)
  lw $t1, 8($sp)
  lw $t2, 16($sp)
  sle $t0,$t1,$t2
  sw $t0, 20($sp)
  lw $t0, 20($sp)
  beqz $t0,_L3
_L2:
  li $t0,100
  sw $t0, 24($sp)
  lw $t1, 24($sp)
  lw $t2, 8($sp)
  sub $t0,$t1,$t2
  sw $t0, 28($sp)
  li $t0,4
  sw $t0, 32($sp)
  lw $t1, 32($sp)
  lw $t2, 8($sp)
  mul $t0,$t1,$t2
  sw $t0, 36($sp)
  lw $t1, 0($fp)
  lw $t2, 36($sp)
  add $t0,$t1,$t2
  sw $t0, 40($sp)
  lw $t0, 28($sp)
  lw $t1, 40($sp)
  sw $t0, 0($t1)
  li $t0,1
  sw $t0, 44($sp)
  lw $t1, 8($sp)
  lw $t2, 44($sp)
  add $t0,$t1,$t2
  sw $t0, 48($sp)
  lw $t0, 48($sp)
  sw $t0, 8($sp)
  j _L1
_L3:
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,52
  jr $ra
sum:
  addiu $sp,$sp,-52
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,52
  li $t0,0
  sw $t0, 16($sp)
  lw $t0, 16($sp)
  sw $t0, 8($sp)
  li $t0,1
  sw $t0, 20($sp)
_L4:
  lw $t0, 0($fp)
  lw $t0, 0($t0)
  sw $t0, 24($sp)
  lw $t0, 24($sp)
  sw $t0, 12($sp)
  lw $t0, 12($sp)
  beqz $t0,_L6
_L5:
  lw $t1, 8($sp)
  lw $t2, 12($sp)
  add $t0,$t1,$t2
  sw $t0, 32($sp)
  lw $t0, 32($sp)
  sw $t0, 8($sp)
  li $t0,1
  sw $t0, 36($sp)
  li $t0,4
  sw $t0, 40($sp)
  lw $t1, 40($sp)
  lw $t2, 36($sp)
  mul $t0,$t1,$t2
  sw $t0, 44($sp)
  lw $t1, 0($fp)
  lw $t2, 44($sp)
  add $t0,$t1,$t2
  sw $t0, 48($sp)
  lw $t0, 48($sp)
  sw $t0, 0($fp)
  li $t0,1
  sw $t0, 28($sp)
  j _L4
_L6:
  lw $v0, 8($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,52
  jr $ra
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,52
  jr $ra
main:
  addiu $sp,$sp,-28
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,28
  addiu $t1,$sp,-4
  addiu $t0,$sp,8
  sw $t0, 0($t1)
  move $sp,$t1
  jal init_v
  addiu $sp,$sp,4
  sw $v0, 12($sp)
  addiu $t1,$sp,-4
  addiu $t0,$sp,8
  sw $t0, 0($t1)
  move $sp,$t1
  jal sum
  addiu $sp,$sp,4
  sw $v0, 16($sp)
  li $t0,5050
  sw $t0, 20($sp)
  lw $t1, 16($sp)
  lw $t2, 20($sp)
  seq $t0,$t1,$t2
  sw $t0, 24($sp)
  lw $a0, 24($sp)
  li $v0,1
  syscall
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,28
  jr $ra

