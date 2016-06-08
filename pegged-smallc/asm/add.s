  .text
  .globl main
main:
  addiu $sp,$sp,-64
  li $t0,3
  sw $t0, 8($sp)
  li $t0,1
  sw $t0, 12($sp)
  li $t0,4
  sw $t0, 16($sp)
  lw $t1, 16($sp)
  lw $t2, 12($sp)
  mul $t0,$t1,$t2
  sw $t0, 20($sp)
  addiu $t1,$sp,0
  lw $t2, 20($sp)
  add $t0,$t1,$t2
  sw $t0, 24($sp)
  lw $t0, 8($sp)
  lw $t1, 24($sp)
  sw $t0, 0($t1)
  li $t0,0
  sw $t0, 28($sp)
  li $t0,4
  sw $t0, 32($sp)
  lw $t1, 32($sp)
  lw $t2, 28($sp)
  mul $t0,$t1,$t2
  sw $t0, 36($sp)
  addiu $t1,$sp,0
  lw $t2, 36($sp)
  add $t0,$t1,$t2
  sw $t0, 40($sp)
  lw $t0, 8($sp)
  lw $t1, 40($sp)
  sw $t0, 0($t1)
  li $t0,0
  sw $t0, 44($sp)
  li $t0,4
  sw $t0, 48($sp)
  lw $t1, 48($sp)
  lw $t2, 44($sp)
  mul $t0,$t1,$t2
  sw $t0, 52($sp)
  addiu $t1,$sp,0
  lw $t2, 52($sp)
  add $t0,$t1,$t2
  sw $t0, 56($sp)
  lw $t0, 56($sp)
  lw $t0, 0($t0)
  sw $t0, 60($sp)
  move $a0,$t0
  li $v0,1
  syscall
  addiu $sp,$sp,64
  jr $ra