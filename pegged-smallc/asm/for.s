  .text
  .globl main
main:
  addiu $sp,$sp,-24
  li $t0,0
  sw $t0, 4($sp)
  lw $t0, 4($sp)
  sw $t0, 0($sp)
LABEL1:
  li $t0,100000
  sw $t0, 8($sp)
  lw $t1, 0($sp)
  lw $t2, 8($sp)
  slt $t0,$t1,$t2
  sw $t0, 12($sp)
  lw $t0, 12($sp)
  beqz $t0,LABEL2
  lw $a0, 0($sp)
  li $v0,1
  syscall
  li $t0,1
  sw $t0, 16($sp)
  lw $t1, 0($sp)
  lw $t2, 16($sp)
  add $t0,$t1,$t2
  sw $t0, 20($sp)
  lw $t0, 20($sp)
  sw $t0, 0($sp)
  j LABEL1
LABEL2:
  addiu $sp,$sp,24
  jr $ra