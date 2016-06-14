  .text
  .globl main
cmp1:
  addiu $sp,$sp,-16
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,16
  lw $t1, 0($fp)
  li $t2,1
  add $t0,$t1,$t2
  sw $t0, 8($sp)
  lw $t1, 8($sp)
  lw $t2, 4($fp)
  sgt $t0,$t1,$t2
  sw $t0, 12($sp)
  lw $v0, 12($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,16
  jr $ra
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,16
  jr $ra
cmp2:
  addiu $sp,$sp,-16
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,16
  lw $t1, 4($fp)
  li $t2,1
  add $t0,$t1,$t2
  sw $t0, 8($sp)
  lw $t1, 0($fp)
  lw $t2, 8($sp)
  sge $t0,$t1,$t2
  sw $t0, 12($sp)
  lw $v0, 12($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,16
  jr $ra
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,16
  jr $ra
cmp3:
  addiu $sp,$sp,-16
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,16
  lw $t1, 4($fp)
  li $t2,1
  add $t0,$t1,$t2
  sw $t0, 8($sp)
  lw $t1, 0($fp)
  lw $t2, 8($sp)
  sgt $t0,$t1,$t2
  sw $t0, 12($sp)
  lw $v0, 12($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,16
  jr $ra
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,16
  jr $ra
main:
  addiu $sp,$sp,-40
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,40
  addiu $t1,$sp,-8
  li $t0,2
  sw $t0, 0($t1)
  li $t0,3
  sw $t0, 4($t1)
  move $sp,$t1
  jal cmp1
  addiu $sp,$sp,8
  sw $v0, 16($sp)
  lw $t1, 16($sp)
  li $t2,0
  seq $t0,$t1,$t2
  sw $t0, 20($sp)
  lw $t0, 20($sp)
  beqz $t0,_L2
_L1:
  addiu $t1,$sp,-8
  li $t0,4
  sw $t0, 0($t1)
  li $t0,3
  sw $t0, 4($t1)
  move $sp,$t1
  jal cmp2
  addiu $sp,$sp,8
  sw $v0, 24($sp)
  lw $t1, 24($sp)
  li $t2,1
  seq $t0,$t1,$t2
  sw $t0, 28($sp)
  lw $t0, 28($sp)
  beqz $t0,_L5
_L4:
  li $t0,1
  sw $t0, 12($sp)
  j _L6
_L5:
  li $t0,0
  sw $t0, 12($sp)
_L6:
  j _L3
_L2:
  li $t0,0
  sw $t0, 12($sp)
_L3:
  lw $t0, 12($sp)
  beqz $t0,_L8
_L7:
  addiu $t1,$sp,-8
  li $t0,4
  sw $t0, 0($t1)
  li $t0,3
  sw $t0, 4($t1)
  move $sp,$t1
  jal cmp3
  addiu $sp,$sp,8
  sw $v0, 32($sp)
  lw $t1, 32($sp)
  li $t2,0
  seq $t0,$t1,$t2
  sw $t0, 36($sp)
  lw $t0, 36($sp)
  beqz $t0,_L11
_L10:
  li $t0,1
  sw $t0, 8($sp)
  j _L12
_L11:
  li $t0,0
  sw $t0, 8($sp)
_L12:
  j _L9
_L8:
  li $t0,0
  sw $t0, 8($sp)
_L9:
  lw $a0, 8($sp)
  li $v0,1
  syscall
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,40
  jr $ra

