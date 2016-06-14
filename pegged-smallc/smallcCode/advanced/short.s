  .text
  .globl main
loop:
  addiu $sp,$sp,-8
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,8
  jal loop
  li $v0,-1
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,8
  jr $ra
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,8
  jr $ra
check_and:
  addiu $sp,$sp,-16
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,16
  j _L2
_L1:
  jal loop
  sw $v0, 12($sp)
  lw $t0, 12($sp)
  beqz $t0,_L5
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
  lw $t0, 8($sp)
  beqz $t0,_L8
_L7:
  li $v0,0
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,16
  jr $ra
_L8:
_L9:
  li $v0,1
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,16
  jr $ra
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,16
  jr $ra
check_or:
  addiu $sp,$sp,-16
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,16
  j _L10
_L10:
  li $t0,1
  sw $t0, 8($sp)
  j _L12
_L11:
  jal loop
  sw $v0, 12($sp)
  lw $t0, 12($sp)
  beqz $t0,_L14
_L13:
  li $t0,1
  sw $t0, 8($sp)
  j _L15
_L14:
  li $t0,0
  sw $t0, 8($sp)
_L15:
_L12:
  lw $t0, 8($sp)
  beqz $t0,_L17
_L16:
  li $v0,1
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,16
  jr $ra
_L17:
_L18:
  li $v0,0
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,16
  jr $ra
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,16
  jr $ra
main:
  addiu $sp,$sp,-20
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,20
  jal check_and
  sw $v0, 12($sp)
  lw $t0, 12($sp)
  beqz $t0,_L20
_L19:
  jal check_or
  sw $v0, 16($sp)
  lw $t0, 16($sp)
  beqz $t0,_L23
_L22:
  li $t0,1
  sw $t0, 8($sp)
  j _L24
_L23:
  li $t0,0
  sw $t0, 8($sp)
_L24:
  j _L21
_L20:
  li $t0,0
  sw $t0, 8($sp)
_L21:
  lw $a0, 8($sp)
  li $v0,1
  syscall
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,20
  jr $ra

