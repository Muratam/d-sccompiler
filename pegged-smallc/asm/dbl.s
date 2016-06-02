  .text
  .globl main
fa:
  addiu $sp,$sp,-36
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,36
  li $t0,0
  sw $t0, 8($sp)
  lw $t1, 0($fp)
  lw $t2, 8($sp)
  seq $t0,$t1,$t2
  sw $t0, 12($sp)
  lw $t0, 12($sp)
  beqz $t0,LABEL1
  li $t0,1
  sw $t0, 16($sp)
  lw $v0, 16($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,36
  jr $ra
  j LABEL2
LABEL1:
  li $t0,1
  sw $t0, 20($sp)
  lw $t1, 0($fp)
  lw $t2, 20($sp)
  sub $t0,$t1,$t2
  sw $t0, 24($sp)
  addiu $t1,$sp,-4
  lw $t0, 24($sp)
  sw $t0, 0($t1)
  move $sp,$t1
  jal fa
  addiu $sp,$sp,4
  sw $v0, 28($sp)
  lw $t1, 0($fp)
  lw $t2, 28($sp)
  mul $t0,$t1,$t2
  sw $t0, 32($sp)
  lw $v0, 32($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,36
  jr $ra
LABEL2:
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,36
  jr $ra
main:
  addiu $sp,$sp,-16
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,16
  li $t0,4
  sw $t0, 8($sp)
  addiu $t1,$sp,-4
  lw $t0, 8($sp)
  sw $t0, 0($t1)
  move $sp,$t1
  jal fa
  addiu $sp,$sp,4
  sw $v0, 12($sp)
  lw $a0, 12($sp)
  li $v0,1
  syscall
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,16
  jr $ra

