  .text
  .globl main
ff:
  addiu $sp,$sp,-16
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,16
  lw $t1, 0($fp)
  lw $t2, 4($fp)
  add $t0,$t1,$t2
  sw $t0, 8($sp)
  lw $t1, 8($sp)
  lw $t2, 8($fp)
  add $t0,$t1,$t2
  sw $t0, 12($sp)
  lw $v0, 12($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,16
  jr $ra
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,16
  jr $ra
gg:
  addiu $sp,$sp,-16
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,16
  addiu $t1,$sp,-12
  li $t0,1
  sw $t0, 0($t1)
  li $t0,2
  sw $t0, 4($t1)
  li $t0,3
  sw $t0, 8($t1)
  move $sp,$t1
  jal ff
  addiu $sp,$sp,12
  sw $v0, 8($sp)
  lw $t1, 0($fp)
  lw $t2, 8($sp)
  mul $t0,$t1,$t2
  sw $t0, 12($sp)
  lw $v0, 12($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,16
  jr $ra
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,16
  jr $ra
hh:
  addiu $sp,$sp,-16
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,16
  addiu $t1,$sp,-12
  li $t0,1
  sw $t0, 0($t1)
  li $t0,2
  sw $t0, 4($t1)
  li $t0,3
  sw $t0, 8($t1)
  move $sp,$t1
  jal ff
  addiu $sp,$sp,12
  sw $v0, 8($sp)
  lw $t1, 0($fp)
  lw $t2, 8($sp)
  div $t0,$t1,$t2
  sw $t0, 12($sp)
  lw $v0, 12($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,16
  jr $ra
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,16
  jr $ra
ii:
  addiu $sp,$sp,-20
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,20
  addiu $t1,$sp,-12
  li $t0,1
  sw $t0, 0($t1)
  li $t0,2
  sw $t0, 4($t1)
  li $t0,3
  sw $t0, 8($t1)
  move $sp,$t1
  jal ff
  addiu $sp,$sp,12
  sw $v0, 8($sp)
  addiu $t1,$sp,-4
  li $t0,4
  sw $t0, 0($t1)
  move $sp,$t1
  jal gg
  addiu $sp,$sp,4
  sw $v0, 12($sp)
  lw $t1, 8($sp)
  lw $t2, 12($sp)
  sub $t0,$t1,$t2
  sw $t0, 16($sp)
  lw $v0, 16($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,20
  jr $ra
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,20
  jr $ra
jj:
  addiu $sp,$sp,-28
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,28
  li $t0,10
  sw $t0, 8($sp)
  lw $t1, 0($fp)
  lw $t2, 4($fp)
  sub $t0,$t1,$t2
  sw $t0, 12($sp)
  lw $t0, 12($sp)
  sw $t0, 0($fp)
  li $t1,10
  lw $t2, 0($fp)
  sub $t0,$t1,$t2
  sw $t0, 16($sp)
  lw $t1, 16($sp)
  li $t2,1
  sub $t0,$t1,$t2
  sw $t0, 20($sp)
  lw $t0, 20($sp)
  sw $t0, 8($sp)
  lw $t1, 0($fp)
  lw $t2, 8($sp)
  add $t0,$t1,$t2
  sw $t0, 24($sp)
  lw $v0, 24($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,28
  jr $ra
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,28
  jr $ra
main:
  addiu $sp,$sp,-64
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,64
  addiu $t1,$sp,-12
  li $t0,1
  sw $t0, 0($t1)
  li $t0,2
  sw $t0, 4($t1)
  li $t0,3
  sw $t0, 8($t1)
  move $sp,$t1
  jal ff
  addiu $sp,$sp,12
  sw $v0, 24($sp)
  lw $t1, 24($sp)
  li $t2,6
  seq $t0,$t1,$t2
  sw $t0, 28($sp)
  lw $t0, 28($sp)
  beqz $t0,_L2
_L1:
  addiu $t1,$sp,-4
  li $t0,10
  sw $t0, 0($t1)
  move $sp,$t1
  jal gg
  addiu $sp,$sp,4
  sw $v0, 32($sp)
  lw $t1, 32($sp)
  li $t2,60
  seq $t0,$t1,$t2
  sw $t0, 36($sp)
  lw $t0, 36($sp)
  beqz $t0,_L5
_L4:
  li $t0,1
  sw $t0, 20($sp)
  j _L6
_L5:
  li $t0,0
  sw $t0, 20($sp)
_L6:
  j _L3
_L2:
  li $t0,0
  sw $t0, 20($sp)
_L3:
  lw $t0, 20($sp)
  beqz $t0,_L8
_L7:
  addiu $t1,$sp,-4
  li $t0,40
  sw $t0, 0($t1)
  move $sp,$t1
  jal hh
  addiu $sp,$sp,4
  sw $v0, 40($sp)
  lw $t1, 40($sp)
  li $t2,6
  seq $t0,$t1,$t2
  sw $t0, 44($sp)
  lw $t0, 44($sp)
  beqz $t0,_L11
_L10:
  li $t0,1
  sw $t0, 16($sp)
  j _L12
_L11:
  li $t0,0
  sw $t0, 16($sp)
_L12:
  j _L9
_L8:
  li $t0,0
  sw $t0, 16($sp)
_L9:
  lw $t0, 16($sp)
  beqz $t0,_L14
_L13:
  jal ii
  sw $v0, 48($sp)
  lw $t1, 48($sp)
  li $t2,-18
  seq $t0,$t1,$t2
  sw $t0, 52($sp)
  lw $t0, 52($sp)
  beqz $t0,_L17
_L16:
  li $t0,1
  sw $t0, 12($sp)
  j _L18
_L17:
  li $t0,0
  sw $t0, 12($sp)
_L18:
  j _L15
_L14:
  li $t0,0
  sw $t0, 12($sp)
_L15:
  lw $t0, 12($sp)
  beqz $t0,_L20
_L19:
  addiu $t1,$sp,-8
  li $t0,2
  sw $t0, 0($t1)
  li $t0,4
  sw $t0, 4($t1)
  move $sp,$t1
  jal jj
  addiu $sp,$sp,8
  sw $v0, 56($sp)
  lw $t1, 56($sp)
  li $t2,9
  seq $t0,$t1,$t2
  sw $t0, 60($sp)
  lw $t0, 60($sp)
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
  addiu $sp,$sp,64
  jr $ra

