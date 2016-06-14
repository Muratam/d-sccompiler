  .text
  .globl main
fib:
  addiu $sp,$sp,-32
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,32
  lw $t1, 0($fp)
  li $t2,2
  slt $t0,$t1,$t2
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
  li $t2,1
  sub $t0,$t1,$t2
  sw $t0, 12($sp)
  addiu $t1,$sp,-4
  lw $t0, 12($sp)
  sw $t0, 0($t1)
  move $sp,$t1
  jal fib
  addiu $sp,$sp,4
  sw $v0, 16($sp)
  lw $t1, 0($fp)
  li $t2,2
  sub $t0,$t1,$t2
  sw $t0, 20($sp)
  addiu $t1,$sp,-4
  lw $t0, 20($sp)
  sw $t0, 0($t1)
  move $sp,$t1
  jal fib
  addiu $sp,$sp,4
  sw $v0, 24($sp)
  lw $t1, 16($sp)
  lw $t2, 24($sp)
  add $t0,$t1,$t2
  sw $t0, 28($sp)
  lw $v0, 28($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,32
  jr $ra
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
  addiu $t1,$sp,-4
  li $t0,24
  sw $t0, 0($t1)
  move $sp,$t1
  jal fib
  addiu $sp,$sp,4
  sw $v0, 8($sp)
  lw $t1, 8($sp)
  li $t2,46368
  seq $t0,$t1,$t2
  sw $t0, 12($sp)
  lw $a0, 12($sp)
  li $v0,1
  syscall
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,16
  jr $ra

