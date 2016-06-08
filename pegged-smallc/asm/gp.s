  .text
  .globl main
main:
  addiu $sp,$sp,-12
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,12
  li $t0,72
  sw $t0, 8($sp)
  lw $t0, 8($sp)
  sw $t0, 0($gp)
  lw $a0, 0($gp)
  li $v0,1
  syscall
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,12
  jr $ra
