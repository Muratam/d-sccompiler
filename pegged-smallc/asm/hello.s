  .text
  .globl main
main:
  addiu $sp,$sp,-4
  li $t0,9
  sw $t0, 0($sp)
  move $a0,$t0
  li $v0,1
  syscall
  addiu $sp,$sp,4
  jr $ra