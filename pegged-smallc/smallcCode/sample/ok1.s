  .text
  .globl main
main:
  addiu $sp,$sp,-12
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,12
  j _L1
_L1:
  j _L4
_L4:
  li $t0,1
  sw $t0, 8($sp)
  j _L6
_L5:
  li $t0,0
  sw $t0, 8($sp)
_L6:
  j _L3
_L2:
  li $t0,0
  sw $t0, 8($sp)
_L3:
  lw $a0, 8($sp)
  li $v0,1
  syscall
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,12
  jr $ra

