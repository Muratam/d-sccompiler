  .text
  .globl main
ack:
  addiu $sp,$sp,-72
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,72
  li $t0,0
  sw $t0, 8($sp)
  lw $t1, 0($fp)
  lw $t2, 8($sp)
  seq $t0,$t1,$t2
  sw $t0, 12($sp)
  lw $t0, 12($sp)
  beqz $t0,_L2
_L1:
  li $t0,1
  sw $t0, 16($sp)
  lw $t1, 4($fp)
  lw $t2, 16($sp)
  add $t0,$t1,$t2
  sw $t0, 20($sp)
  lw $v0, 20($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,72
  jr $ra
_L2:
_L3:
  li $t0,0
  sw $t0, 24($sp)
  lw $t1, 4($fp)
  lw $t2, 24($sp)
  seq $t0,$t1,$t2
  sw $t0, 28($sp)
  lw $t0, 28($sp)
  beqz $t0,_L5
_L4:
  li $t0,1
  sw $t0, 32($sp)
  lw $t1, 0($fp)
  lw $t2, 32($sp)
  sub $t0,$t1,$t2
  sw $t0, 36($sp)
  li $t0,1
  sw $t0, 40($sp)
  addiu $t1,$sp,-8
  lw $t0, 36($sp)
  sw $t0, 0($t1)
  lw $t0, 40($sp)
  sw $t0, 4($t1)
  move $sp,$t1
  jal ack
  addiu $sp,$sp,8
  sw $v0, 44($sp)
  lw $v0, 44($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,72
  jr $ra
_L5:
_L6:
  li $t0,1
  sw $t0, 48($sp)
  lw $t1, 0($fp)
  lw $t2, 48($sp)
  sub $t0,$t1,$t2
  sw $t0, 52($sp)
  li $t0,1
  sw $t0, 56($sp)
  lw $t1, 4($fp)
  lw $t2, 56($sp)
  sub $t0,$t1,$t2
  sw $t0, 60($sp)
  addiu $t1,$sp,-8
  lw $t0, 0($fp)
  sw $t0, 0($t1)
  lw $t0, 60($sp)
  sw $t0, 4($t1)
  move $sp,$t1
  jal ack
  addiu $sp,$sp,8
  sw $v0, 64($sp)
  addiu $t1,$sp,-8
  lw $t0, 52($sp)
  sw $t0, 0($t1)
  lw $t0, 64($sp)
  sw $t0, 4($t1)
  move $sp,$t1
  jal ack
  addiu $sp,$sp,8
  sw $v0, 68($sp)
  lw $v0, 68($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,72
  jr $ra
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,72
  jr $ra
main:
  addiu $sp,$sp,-76
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,76
  li $t0,3
  sw $t0, 16($sp)
  li $t0,3
  sw $t0, 20($sp)
  addiu $t1,$sp,-8
  lw $t0, 16($sp)
  sw $t0, 0($t1)
  lw $t0, 20($sp)
  sw $t0, 4($t1)
  move $sp,$t1
  jal ack
  addiu $sp,$sp,8
  sw $v0, 24($sp)
  li $t0,61
  sw $t0, 28($sp)
  lw $t1, 24($sp)
  lw $t2, 28($sp)
  seq $t0,$t1,$t2
  sw $t0, 32($sp)
  lw $t0, 32($sp)
  beqz $t0,_L8
_L7:
  li $t0,3
  sw $t0, 36($sp)
  li $t0,4
  sw $t0, 40($sp)
  addiu $t1,$sp,-8
  lw $t0, 36($sp)
  sw $t0, 0($t1)
  lw $t0, 40($sp)
  sw $t0, 4($t1)
  move $sp,$t1
  jal ack
  addiu $sp,$sp,8
  sw $v0, 44($sp)
  li $t0,125
  sw $t0, 48($sp)
  lw $t1, 44($sp)
  lw $t2, 48($sp)
  seq $t0,$t1,$t2
  sw $t0, 52($sp)
  lw $t0, 52($sp)
  beqz $t0,_L11
_L10:
  li $t0,1
  sw $t0, 12($sp)
  j _L12
_L11:
  li $t0,0
  sw $t0, 12($sp)
_L12:
  j _L9
_L8:
  li $t0,0
  sw $t0, 12($sp)
_L9:
  lw $t0, 12($sp)
  beqz $t0,_L14
_L13:
  li $t0,3
  sw $t0, 56($sp)
  li $t0,5
  sw $t0, 60($sp)
  addiu $t1,$sp,-8
  lw $t0, 56($sp)
  sw $t0, 0($t1)
  lw $t0, 60($sp)
  sw $t0, 4($t1)
  move $sp,$t1
  jal ack
  addiu $sp,$sp,8
  sw $v0, 64($sp)
  li $t0,253
  sw $t0, 68($sp)
  lw $t1, 64($sp)
  lw $t2, 68($sp)
  seq $t0,$t1,$t2
  sw $t0, 72($sp)
  lw $t0, 72($sp)
  beqz $t0,_L17
_L16:
  li $t0,1
  sw $t0, 8($sp)
  j _L18
_L17:
  li $t0,0
  sw $t0, 8($sp)
_L18:
  j _L15
_L14:
  li $t0,0
  sw $t0, 8($sp)
_L15:
  lw $a0, 8($sp)
  li $v0,1
  syscall
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,76
  jr $ra

