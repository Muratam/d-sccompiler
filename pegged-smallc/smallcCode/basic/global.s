  .text
  .globl main
f:
  addiu $sp,$sp,-32
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,32
  addiu $t1,$gp,4
  li $t2,0
  add $t0,$t1,$t2
  sw $t0, 8($sp)
  lw $t0, 8($sp)
  lw $t0, 0($t0)
  sw $t0, 12($sp)
  lw $t1, 0($fp)
  lw $t2, 12($sp)
  add $t0,$t1,$t2
  sw $t0, 16($sp)
  addiu $t1,$gp,4
  li $t2,4
  add $t0,$t1,$t2
  sw $t0, 20($sp)
  lw $t0, 20($sp)
  lw $t0, 0($t0)
  sw $t0, 24($sp)
  lw $t1, 16($sp)
  lw $t2, 24($sp)
  add $t0,$t1,$t2
  sw $t0, 28($sp)
  lw $v0, 28($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,32
  jr $ra
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,32
  jr $ra
g:
  addiu $sp,$sp,-32
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,32
  lw $t1, 0($fp)
  li $t2,0
  add $t0,$t1,$t2
  sw $t0, 8($sp)
  lw $t0, 8($sp)
  lw $t0, 0($t0)
  sw $t0, 12($sp)
  lw $t1, 0($gp)
  lw $t2, 12($sp)
  add $t0,$t1,$t2
  sw $t0, 16($sp)
  lw $t1, 0($fp)
  li $t2,4
  add $t0,$t1,$t2
  sw $t0, 20($sp)
  lw $t0, 20($sp)
  lw $t0, 0($t0)
  sw $t0, 24($sp)
  lw $t1, 16($sp)
  lw $t2, 24($sp)
  add $t0,$t1,$t2
  sw $t0, 28($sp)
  lw $v0, 28($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,32
  jr $ra
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,32
  jr $ra
main:
  addiu $sp,$sp,-124
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,124
  li $t0,1
  sw $t0, 12($sp)
  li $t0,1
  sw $t0, 0($gp)
  li $t0,2
  sw $t0, 16($sp)
  li $t0,0
  sw $t0, 20($sp)
  li $t0,4
  sw $t0, 24($sp)
  li $t1,4
  li $t2,0
  mul $t0,$t1,$t2
  sw $t0, 28($sp)
  addiu $t1,$gp,4
  li $t2,0
  add $t0,$t1,$t2
  sw $t0, 32($sp)
  li $t0,2
  lw $t1, 32($sp)
  sw $t0, 0($t1)
  li $t0,3
  sw $t0, 36($sp)
  li $t0,1
  sw $t0, 40($sp)
  li $t0,4
  sw $t0, 44($sp)
  li $t1,4
  li $t2,1
  mul $t0,$t1,$t2
  sw $t0, 48($sp)
  addiu $t1,$gp,4
  li $t2,4
  add $t0,$t1,$t2
  sw $t0, 52($sp)
  li $t0,3
  lw $t1, 52($sp)
  sw $t0, 0($t1)
  li $t0,4
  sw $t0, 56($sp)
  li $t0,0
  sw $t0, 60($sp)
  li $t0,4
  sw $t0, 64($sp)
  li $t1,4
  li $t2,0
  mul $t0,$t1,$t2
  sw $t0, 68($sp)
  addiu $t1,$sp,8
  li $t2,0
  add $t0,$t1,$t2
  sw $t0, 72($sp)
  li $t0,4
  lw $t1, 72($sp)
  sw $t0, 0($t1)
  li $t0,5
  sw $t0, 76($sp)
  li $t0,1
  sw $t0, 80($sp)
  li $t0,4
  sw $t0, 84($sp)
  li $t1,4
  li $t2,1
  mul $t0,$t1,$t2
  sw $t0, 88($sp)
  addiu $t1,$sp,8
  li $t2,4
  add $t0,$t1,$t2
  sw $t0, 92($sp)
  li $t0,5
  lw $t1, 92($sp)
  sw $t0, 0($t1)
  li $t0,6
  sw $t0, 100($sp)
  addiu $t1,$sp,-4
  li $t0,6
  sw $t0, 0($t1)
  move $sp,$t1
  jal f
  addiu $sp,$sp,4
  sw $v0, 104($sp)
  li $t0,11
  sw $t0, 108($sp)
  lw $t1, 104($sp)
  li $t2,11
  seq $t0,$t1,$t2
  sw $t0, 112($sp)
  lw $t0, 112($sp)
  beqz $t0,_L2
_L1:
  addiu $t1,$sp,-4
  addiu $t0,$sp,8
  sw $t0, 0($t1)
  move $sp,$t1
  jal g
  addiu $sp,$sp,4
  sw $v0, 116($sp)
  lw $t1, 116($sp)
  li $t2,10
  seq $t0,$t1,$t2
  sw $t0, 120($sp)
  lw $t0, 120($sp)
  beqz $t0,_L5
_L4:
  li $t0,1
  sw $t0, 96($sp)
  j _L6
_L5:
  li $t0,0
  sw $t0, 96($sp)
_L6:
  j _L3
_L2:
  li $t0,0
  sw $t0, 96($sp)
_L3:
  lw $a0, 96($sp)
  li $v0,1
  syscall
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,124
  jr $ra

