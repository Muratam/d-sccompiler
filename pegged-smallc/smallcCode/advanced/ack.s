  .text
  .globl main
ack:
  addiu $sp,$sp,-44
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,44
  lw $t1, 0($fp)
  li $t2,0
  seq $t0,$t1,$t2
  sw $t0, 8($sp)
  lw $t0, 8($sp)
  beqz $t0,_L2
_L1:
  lw $t1, 4($fp)
  li $t2,1
  add $t0,$t1,$t2
  sw $t0, 12($sp)
  lw $v0, 12($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,44
  jr $ra
_L2:
_L3:
  lw $t1, 4($fp)
  li $t2,0
  seq $t0,$t1,$t2
  sw $t0, 16($sp)
  lw $t0, 16($sp)
  beqz $t0,_L5
_L4:
  lw $t1, 0($fp)
  li $t2,1
  sub $t0,$t1,$t2
  sw $t0, 20($sp)
  addiu $t1,$sp,-8
  lw $t0, 20($sp)
  sw $t0, 0($t1)
  li $t0,1
  sw $t0, 4($t1)
  move $sp,$t1
  jal ack
  addiu $sp,$sp,8
  sw $v0, 24($sp)
  lw $v0, 24($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,44
  jr $ra
_L5:
_L6:
  lw $t1, 0($fp)
  li $t2,1
  sub $t0,$t1,$t2
  sw $t0, 28($sp)
  lw $t1, 4($fp)
  li $t2,1
  sub $t0,$t1,$t2
  sw $t0, 32($sp)
  addiu $t1,$sp,-8
  lw $t0, 0($fp)
  sw $t0, 0($t1)
  lw $t0, 32($sp)
  sw $t0, 4($t1)
  move $sp,$t1
  jal ack
  addiu $sp,$sp,8
  sw $v0, 36($sp)
  addiu $t1,$sp,-8
  lw $t0, 28($sp)
  sw $t0, 0($t1)
  lw $t0, 36($sp)
  sw $t0, 4($t1)
  move $sp,$t1
  jal ack
  addiu $sp,$sp,8
  sw $v0, 40($sp)
  lw $v0, 40($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,44
  jr $ra
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,44
  jr $ra
main:
  addiu $sp,$sp,-40
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,40
  addiu $t1,$sp,-8
  li $t0,3
  sw $t0, 0($t1)
  li $t0,3
  sw $t0, 4($t1)
  move $sp,$t1
  jal ack
  addiu $sp,$sp,8
  sw $v0, 16($sp)
  lw $t1, 16($sp)
  li $t2,61
  seq $t0,$t1,$t2
  sw $t0, 20($sp)
  lw $t0, 20($sp)
  beqz $t0,_L8
_L7:
  addiu $t1,$sp,-8
  li $t0,3
  sw $t0, 0($t1)
  li $t0,4
  sw $t0, 4($t1)
  move $sp,$t1
  jal ack
  addiu $sp,$sp,8
  sw $v0, 24($sp)
  lw $t1, 24($sp)
  li $t2,125
  seq $t0,$t1,$t2
  sw $t0, 28($sp)
  lw $t0, 28($sp)
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
  addiu $t1,$sp,-8
  li $t0,3
  sw $t0, 0($t1)
  li $t0,5
  sw $t0, 4($t1)
  move $sp,$t1
  jal ack
  addiu $sp,$sp,8
  sw $v0, 32($sp)
  lw $t1, 32($sp)
  li $t2,253
  seq $t0,$t1,$t2
  sw $t0, 36($sp)
  lw $t0, 36($sp)
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
  addiu $sp,$sp,40
  jr $ra

