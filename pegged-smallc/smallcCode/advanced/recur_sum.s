  .text
  .globl main
init_val:
  addiu $sp,$sp,-52
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,52
  li $t0,0
  sw $t0, 12($sp)
  lw $t0, 12($sp)
  sw $t0, 8($sp)
_L1:
  li $t0,200
  sw $t0, 16($sp)
  lw $t1, 8($sp)
  lw $t2, 16($sp)
  sle $t0,$t1,$t2
  sw $t0, 20($sp)
  lw $t0, 20($sp)
  beqz $t0,_L3
_L2:
  li $t0,200
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
  addiu $t1,$gp,0
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
  lw $t0, 0($fp)
  lw $t0, 0($t0)
  sw $t0, 12($sp)
  lw $t0, 12($sp)
  sw $t0, 8($sp)
  li $t0,0
  sw $t0, 16($sp)
  lw $t1, 8($sp)
  lw $t2, 16($sp)
  sne $t0,$t1,$t2
  sw $t0, 20($sp)
  lw $t0, 20($sp)
  beqz $t0,_L5
_L4:
  li $t0,1
  sw $t0, 24($sp)
  li $t0,4
  sw $t0, 28($sp)
  lw $t1, 28($sp)
  lw $t2, 24($sp)
  mul $t0,$t1,$t2
  sw $t0, 32($sp)
  lw $t1, 0($fp)
  lw $t2, 32($sp)
  add $t0,$t1,$t2
  sw $t0, 36($sp)
  addiu $t1,$sp,-4
  lw $t0, 36($sp)
  sw $t0, 0($t1)
  move $sp,$t1
  jal sum
  addiu $sp,$sp,4
  sw $v0, 40($sp)
  lw $t1, 8($sp)
  lw $t2, 40($sp)
  add $t0,$t1,$t2
  sw $t0, 44($sp)
  lw $v0, 44($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,52
  jr $ra
_L5:
  li $t0,0
  sw $t0, 48($sp)
  lw $v0, 48($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,52
  jr $ra
_L6:
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,52
  jr $ra
sum2:
  addiu $sp,$sp,-48
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,48
  lw $t0, 0($fp)
  lw $t0, 0($t0)
  sw $t0, 12($sp)
  lw $t0, 12($sp)
  sw $t0, 8($sp)
  li $t0,0
  sw $t0, 16($sp)
  lw $t1, 8($sp)
  lw $t2, 16($sp)
  sne $t0,$t1,$t2
  sw $t0, 20($sp)
  lw $t0, 20($sp)
  beqz $t0,_L8
_L7:
  li $t0,1
  sw $t0, 24($sp)
  li $t0,4
  sw $t0, 28($sp)
  lw $t1, 28($sp)
  lw $t2, 24($sp)
  mul $t0,$t1,$t2
  sw $t0, 32($sp)
  lw $t1, 0($fp)
  lw $t2, 32($sp)
  add $t0,$t1,$t2
  sw $t0, 36($sp)
  lw $t1, 4($fp)
  lw $t2, 8($sp)
  add $t0,$t1,$t2
  sw $t0, 40($sp)
  addiu $t1,$sp,-8
  lw $t0, 36($sp)
  sw $t0, 0($t1)
  lw $t0, 40($sp)
  sw $t0, 4($t1)
  move $sp,$t1
  jal sum2
  addiu $sp,$sp,8
  sw $v0, 44($sp)
  lw $v0, 44($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,48
  jr $ra
_L8:
  lw $v0, 4($fp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,48
  jr $ra
_L9:
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,48
  jr $ra
main:
  addiu $sp,$sp,-44
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,44
  jal init_val
  sw $v0, 8($sp)
  addiu $t1,$sp,-4
  addiu $t0,$gp,0
  sw $t0, 0($t1)
  move $sp,$t1
  jal sum
  addiu $sp,$sp,4
  sw $v0, 16($sp)
  li $t0,20100
  sw $t0, 20($sp)
  lw $t1, 16($sp)
  lw $t2, 20($sp)
  seq $t0,$t1,$t2
  sw $t0, 24($sp)
  lw $t0, 24($sp)
  beqz $t0,_L11
_L10:
  li $t0,0
  sw $t0, 28($sp)
  addiu $t1,$sp,-8
  addiu $t0,$gp,0
  sw $t0, 0($t1)
  lw $t0, 28($sp)
  sw $t0, 4($t1)
  move $sp,$t1
  jal sum2
  addiu $sp,$sp,8
  sw $v0, 32($sp)
  li $t0,20100
  sw $t0, 36($sp)
  lw $t1, 32($sp)
  lw $t2, 36($sp)
  seq $t0,$t1,$t2
  sw $t0, 40($sp)
  lw $t0, 40($sp)
  beqz $t0,_L14
_L13:
  li $t0,1
  sw $t0, 12($sp)
  j _L15
_L14:
  li $t0,0
  sw $t0, 12($sp)
_L15:
  j _L12
_L11:
  li $t0,0
  sw $t0, 12($sp)
_L12:
  lw $a0, 12($sp)
  li $v0,1
  syscall
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,44
  jr $ra

