  .text
  .globl main
is_greater:
  addiu $sp,$sp,-12
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,12
  lw $t1, 0($fp)
  lw $t2, 4($fp)
  sgt $t0,$t1,$t2
  sw $t0, 8($sp)
  lw $v0, 8($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,12
  jr $ra
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,12
  jr $ra
sorted:
  addiu $sp,$sp,-60
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,60
  lw $t1, 4($fp)
  li $t2,2
  slt $t0,$t1,$t2
  sw $t0, 8($sp)
  lw $t0, 8($sp)
  beqz $t0,_L2
_L1:
  li $v0,1
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,60
  jr $ra
_L2:
  li $t0,0
  sw $t0, 12($sp)
_L4:
  lw $t1, 4($fp)
  li $t2,1
  sub $t0,$t1,$t2
  sw $t0, 16($sp)
  lw $t1, 12($sp)
  lw $t2, 16($sp)
  slt $t0,$t1,$t2
  sw $t0, 20($sp)
  lw $t0, 20($sp)
  beqz $t0,_L6
_L5:
  li $t1,4
  lw $t2, 12($sp)
  mul $t0,$t1,$t2
  sw $t0, 24($sp)
  lw $t1, 0($fp)
  lw $t2, 24($sp)
  add $t0,$t1,$t2
  sw $t0, 28($sp)
  lw $t0, 28($sp)
  lw $t0, 0($t0)
  sw $t0, 32($sp)
  lw $t1, 12($sp)
  li $t2,1
  add $t0,$t1,$t2
  sw $t0, 36($sp)
  li $t1,4
  lw $t2, 36($sp)
  mul $t0,$t1,$t2
  sw $t0, 40($sp)
  lw $t1, 0($fp)
  lw $t2, 40($sp)
  add $t0,$t1,$t2
  sw $t0, 44($sp)
  lw $t0, 44($sp)
  lw $t0, 0($t0)
  sw $t0, 48($sp)
  addiu $t1,$sp,-8
  lw $t0, 32($sp)
  sw $t0, 0($t1)
  lw $t0, 48($sp)
  sw $t0, 4($t1)
  move $sp,$t1
  jal is_greater
  addiu $sp,$sp,8
  sw $v0, 52($sp)
  lw $t0, 52($sp)
  beqz $t0,_L8
_L7:
  li $v0,0
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,60
  jr $ra
_L8:
_L9:
  lw $t1, 12($sp)
  li $t2,1
  add $t0,$t1,$t2
  sw $t0, 56($sp)
  lw $t0, 56($sp)
  sw $t0, 12($sp)
  j _L4
_L6:
  li $v0,1
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,60
  jr $ra
_L3:
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,60
  jr $ra
sum:
  addiu $sp,$sp,-40
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,40
  li $t0,0
  sw $t0, 12($sp)
  li $t0,0
  sw $t0, 8($sp)
_L10:
  lw $t1, 8($sp)
  lw $t2, 4($fp)
  slt $t0,$t1,$t2
  sw $t0, 16($sp)
  lw $t0, 16($sp)
  beqz $t0,_L12
_L11:
  li $t1,4
  lw $t2, 8($sp)
  mul $t0,$t1,$t2
  sw $t0, 20($sp)
  lw $t1, 0($fp)
  lw $t2, 20($sp)
  add $t0,$t1,$t2
  sw $t0, 24($sp)
  lw $t0, 24($sp)
  lw $t0, 0($t0)
  sw $t0, 28($sp)
  lw $t1, 12($sp)
  lw $t2, 28($sp)
  add $t0,$t1,$t2
  sw $t0, 32($sp)
  lw $t0, 32($sp)
  sw $t0, 12($sp)
  lw $t1, 8($sp)
  li $t2,1
  add $t0,$t1,$t2
  sw $t0, 36($sp)
  lw $t0, 36($sp)
  sw $t0, 8($sp)
  j _L10
_L12:
  lw $v0, 12($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,40
  jr $ra
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,40
  jr $ra
swap:
  addiu $sp,$sp,-20
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,20
  lw $t0, 0($fp)
  lw $t0, 0($t0)
  sw $t0, 12($sp)
  lw $t0, 12($sp)
  sw $t0, 8($sp)
  lw $t0, 4($fp)
  lw $t0, 0($t0)
  sw $t0, 16($sp)
  lw $t0, 16($sp)
  lw $t1, 0($fp)
  sw $t0, 0($t1)
  lw $t0, 8($sp)
  lw $t1, 4($fp)
  sw $t0, 0($t1)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,20
  jr $ra
sort:
  addiu $sp,$sp,-208
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,208
  lw $t1, 4($fp)
  lw $t2, 8($fp)
  sge $t0,$t1,$t2
  sw $t0, 16($sp)
  lw $t0, 16($sp)
  beqz $t0,_L14
_L13:
  li $v0,0
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,208
  jr $ra
_L14:
_L15:
  li $t0,4
  sw $t0, 20($sp)
  li $t1,4
  lw $t2, 4($fp)
  mul $t0,$t1,$t2
  sw $t0, 24($sp)
  lw $t1, 0($fp)
  lw $t2, 24($sp)
  add $t0,$t1,$t2
  sw $t0, 28($sp)
  lw $t1, 4($fp)
  lw $t2, 8($fp)
  add $t0,$t1,$t2
  sw $t0, 32($sp)
  li $t0,2
  sw $t0, 36($sp)
  lw $t1, 32($sp)
  li $t2,2
  div $t0,$t1,$t2
  sw $t0, 40($sp)
  li $t0,4
  sw $t0, 44($sp)
  li $t1,4
  lw $t2, 40($sp)
  mul $t0,$t1,$t2
  sw $t0, 48($sp)
  lw $t1, 0($fp)
  lw $t2, 48($sp)
  add $t0,$t1,$t2
  sw $t0, 52($sp)
  addiu $t1,$sp,-8
  lw $t0, 28($sp)
  sw $t0, 0($t1)
  lw $t0, 52($sp)
  sw $t0, 4($t1)
  move $sp,$t1
  jal swap
  addiu $sp,$sp,8
  sw $v0, 56($sp)
  lw $t0, 4($fp)
  sw $t0, 12($sp)
  li $t0,1
  sw $t0, 60($sp)
  lw $t1, 4($fp)
  li $t2,1
  add $t0,$t1,$t2
  sw $t0, 64($sp)
  lw $t0, 64($sp)
  sw $t0, 8($sp)
  li $t0,1
  sw $t0, 68($sp)
_L16:
  lw $t1, 8($sp)
  lw $t2, 8($fp)
  sle $t0,$t1,$t2
  sw $t0, 72($sp)
  lw $t0, 72($sp)
  beqz $t0,_L18
_L17:
  li $t0,4
  sw $t0, 128($sp)
  li $t1,4
  lw $t2, 4($fp)
  mul $t0,$t1,$t2
  sw $t0, 132($sp)
  lw $t1, 0($fp)
  lw $t2, 132($sp)
  add $t0,$t1,$t2
  sw $t0, 136($sp)
  lw $t0, 136($sp)
  lw $t0, 0($t0)
  sw $t0, 140($sp)
  li $t0,4
  sw $t0, 144($sp)
  li $t1,4
  lw $t2, 8($sp)
  mul $t0,$t1,$t2
  sw $t0, 148($sp)
  lw $t1, 0($fp)
  lw $t2, 148($sp)
  add $t0,$t1,$t2
  sw $t0, 152($sp)
  lw $t0, 152($sp)
  lw $t0, 0($t0)
  sw $t0, 156($sp)
  addiu $t1,$sp,-8
  lw $t0, 140($sp)
  sw $t0, 0($t1)
  lw $t0, 156($sp)
  sw $t0, 4($t1)
  move $sp,$t1
  jal is_greater
  addiu $sp,$sp,8
  sw $v0, 160($sp)
  lw $t0, 160($sp)
  beqz $t0,_L20
_L19:
  li $t0,1
  sw $t0, 172($sp)
  lw $t1, 12($sp)
  li $t2,1
  add $t0,$t1,$t2
  sw $t0, 176($sp)
  lw $t0, 176($sp)
  sw $t0, 12($sp)
  li $t0,4
  sw $t0, 180($sp)
  li $t1,4
  lw $t2, 12($sp)
  mul $t0,$t1,$t2
  sw $t0, 184($sp)
  lw $t1, 0($fp)
  lw $t2, 184($sp)
  add $t0,$t1,$t2
  sw $t0, 188($sp)
  li $t0,4
  sw $t0, 192($sp)
  li $t1,4
  lw $t2, 8($sp)
  mul $t0,$t1,$t2
  sw $t0, 196($sp)
  lw $t1, 0($fp)
  lw $t2, 196($sp)
  add $t0,$t1,$t2
  sw $t0, 200($sp)
  addiu $t1,$sp,-8
  lw $t0, 188($sp)
  sw $t0, 0($t1)
  lw $t0, 200($sp)
  sw $t0, 4($t1)
  move $sp,$t1
  jal swap
  addiu $sp,$sp,8
  sw $v0, 204($sp)
  j _L21
_L20:
_L21:
  li $t0,1
  sw $t0, 164($sp)
  lw $t1, 8($sp)
  li $t2,1
  add $t0,$t1,$t2
  sw $t0, 168($sp)
  lw $t0, 168($sp)
  sw $t0, 8($sp)
  li $t0,1
  sw $t0, 76($sp)
  j _L16
_L18:
  li $t0,4
  sw $t0, 80($sp)
  li $t1,4
  lw $t2, 4($fp)
  mul $t0,$t1,$t2
  sw $t0, 84($sp)
  lw $t1, 0($fp)
  lw $t2, 84($sp)
  add $t0,$t1,$t2
  sw $t0, 88($sp)
  li $t0,4
  sw $t0, 92($sp)
  li $t1,4
  lw $t2, 12($sp)
  mul $t0,$t1,$t2
  sw $t0, 96($sp)
  lw $t1, 0($fp)
  lw $t2, 96($sp)
  add $t0,$t1,$t2
  sw $t0, 100($sp)
  addiu $t1,$sp,-8
  lw $t0, 88($sp)
  sw $t0, 0($t1)
  lw $t0, 100($sp)
  sw $t0, 4($t1)
  move $sp,$t1
  jal swap
  addiu $sp,$sp,8
  sw $v0, 104($sp)
  li $t0,1
  sw $t0, 108($sp)
  lw $t1, 12($sp)
  li $t2,1
  sub $t0,$t1,$t2
  sw $t0, 112($sp)
  addiu $t1,$sp,-12
  lw $t0, 0($fp)
  sw $t0, 0($t1)
  lw $t0, 4($fp)
  sw $t0, 4($t1)
  lw $t0, 112($sp)
  sw $t0, 8($t1)
  move $sp,$t1
  jal sort
  addiu $sp,$sp,12
  sw $v0, 116($sp)
  li $t0,1
  sw $t0, 120($sp)
  lw $t1, 12($sp)
  li $t2,1
  add $t0,$t1,$t2
  sw $t0, 124($sp)
  addiu $t1,$sp,-12
  lw $t0, 0($fp)
  sw $t0, 0($t1)
  lw $t0, 124($sp)
  sw $t0, 4($t1)
  lw $t0, 8($fp)
  sw $t0, 8($t1)
  move $sp,$t1
  jal sort
  addiu $sp,$sp,12
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,208
  jr $ra
main:
  addiu $sp,$sp,-264
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,264
  li $t0,8
  sw $t0, 12($sp)
  li $t0,0
  sw $t0, 16($sp)
  li $t0,4
  sw $t0, 20($sp)
  li $t1,4
  li $t2,0
  mul $t0,$t1,$t2
  sw $t0, 24($sp)
  addiu $t1,$sp,8
  li $t2,0
  add $t0,$t1,$t2
  sw $t0, 28($sp)
  li $t0,8
  lw $t1, 28($sp)
  sw $t0, 0($t1)
  li $t0,3
  sw $t0, 32($sp)
  li $t0,1
  sw $t0, 36($sp)
  li $t0,4
  sw $t0, 40($sp)
  li $t1,4
  li $t2,1
  mul $t0,$t1,$t2
  sw $t0, 44($sp)
  addiu $t1,$sp,8
  li $t2,4
  add $t0,$t1,$t2
  sw $t0, 48($sp)
  li $t0,3
  lw $t1, 48($sp)
  sw $t0, 0($t1)
  li $t0,1
  sw $t0, 52($sp)
  li $t0,2
  sw $t0, 56($sp)
  li $t0,4
  sw $t0, 60($sp)
  li $t1,4
  li $t2,2
  mul $t0,$t1,$t2
  sw $t0, 64($sp)
  addiu $t1,$sp,8
  li $t2,8
  add $t0,$t1,$t2
  sw $t0, 68($sp)
  li $t0,1
  lw $t1, 68($sp)
  sw $t0, 0($t1)
  li $t0,7
  sw $t0, 72($sp)
  li $t0,3
  sw $t0, 76($sp)
  li $t0,4
  sw $t0, 80($sp)
  li $t1,4
  li $t2,3
  mul $t0,$t1,$t2
  sw $t0, 84($sp)
  addiu $t1,$sp,8
  li $t2,12
  add $t0,$t1,$t2
  sw $t0, 88($sp)
  li $t0,7
  lw $t1, 88($sp)
  sw $t0, 0($t1)
  li $t0,4
  sw $t0, 92($sp)
  li $t0,4
  sw $t0, 96($sp)
  li $t0,4
  sw $t0, 100($sp)
  li $t1,4
  li $t2,4
  mul $t0,$t1,$t2
  sw $t0, 104($sp)
  addiu $t1,$sp,8
  li $t2,16
  add $t0,$t1,$t2
  sw $t0, 108($sp)
  li $t0,4
  lw $t1, 108($sp)
  sw $t0, 0($t1)
  li $t0,9
  sw $t0, 112($sp)
  li $t0,5
  sw $t0, 116($sp)
  li $t0,4
  sw $t0, 120($sp)
  li $t1,4
  li $t2,5
  mul $t0,$t1,$t2
  sw $t0, 124($sp)
  addiu $t1,$sp,8
  li $t2,20
  add $t0,$t1,$t2
  sw $t0, 128($sp)
  li $t0,9
  lw $t1, 128($sp)
  sw $t0, 0($t1)
  li $t0,10
  sw $t0, 132($sp)
  li $t0,6
  sw $t0, 136($sp)
  li $t0,4
  sw $t0, 140($sp)
  li $t1,4
  li $t2,6
  mul $t0,$t1,$t2
  sw $t0, 144($sp)
  addiu $t1,$sp,8
  li $t2,24
  add $t0,$t1,$t2
  sw $t0, 148($sp)
  li $t0,10
  lw $t1, 148($sp)
  sw $t0, 0($t1)
  li $t0,2
  sw $t0, 152($sp)
  li $t0,7
  sw $t0, 156($sp)
  li $t0,4
  sw $t0, 160($sp)
  li $t1,4
  li $t2,7
  mul $t0,$t1,$t2
  sw $t0, 164($sp)
  addiu $t1,$sp,8
  li $t2,28
  add $t0,$t1,$t2
  sw $t0, 168($sp)
  li $t0,2
  lw $t1, 168($sp)
  sw $t0, 0($t1)
  li $t0,6
  sw $t0, 172($sp)
  li $t0,8
  sw $t0, 176($sp)
  li $t0,4
  sw $t0, 180($sp)
  li $t1,4
  li $t2,8
  mul $t0,$t1,$t2
  sw $t0, 184($sp)
  addiu $t1,$sp,8
  li $t2,32
  add $t0,$t1,$t2
  sw $t0, 188($sp)
  li $t0,6
  lw $t1, 188($sp)
  sw $t0, 0($t1)
  li $t0,5
  sw $t0, 192($sp)
  li $t0,9
  sw $t0, 196($sp)
  li $t0,4
  sw $t0, 200($sp)
  li $t1,4
  li $t2,9
  mul $t0,$t1,$t2
  sw $t0, 204($sp)
  addiu $t1,$sp,8
  li $t2,36
  add $t0,$t1,$t2
  sw $t0, 208($sp)
  li $t0,5
  lw $t1, 208($sp)
  sw $t0, 0($t1)
  li $t0,10
  sw $t0, 216($sp)
  addiu $t1,$sp,-8
  addiu $t0,$sp,8
  sw $t0, 0($t1)
  li $t0,10
  sw $t0, 4($t1)
  move $sp,$t1
  jal sorted
  addiu $sp,$sp,8
  sw $v0, 220($sp)
  lw $t0, 220($sp)
  sw $t0, 212($sp)
  li $t0,0
  sw $t0, 224($sp)
  li $t0,9
  sw $t0, 228($sp)
  addiu $t1,$sp,-12
  addiu $t0,$sp,8
  sw $t0, 0($t1)
  li $t0,0
  sw $t0, 4($t1)
  li $t0,9
  sw $t0, 8($t1)
  move $sp,$t1
  jal sort
  addiu $sp,$sp,12
  sw $v0, 232($sp)
  li $t0,0
  sw $t0, 236($sp)
  lw $t1, 212($sp)
  li $t2,0
  seq $t0,$t1,$t2
  sw $t0, 240($sp)
  lw $a0, 240($sp)
  li $v0,1
  syscall
  li $t0,10
  sw $t0, 244($sp)
  addiu $t1,$sp,-8
  addiu $t0,$sp,8
  sw $t0, 0($t1)
  li $t0,10
  sw $t0, 4($t1)
  move $sp,$t1
  jal sorted
  addiu $sp,$sp,8
  sw $v0, 248($sp)
  lw $a0, 248($sp)
  li $v0,1
  syscall
  li $t0,10
  sw $t0, 252($sp)
  addiu $t1,$sp,-8
  addiu $t0,$sp,8
  sw $t0, 0($t1)
  li $t0,10
  sw $t0, 4($t1)
  move $sp,$t1
  jal sum
  addiu $sp,$sp,8
  sw $v0, 256($sp)
  lw $t1, 256($sp)
  li $t2,55
  seq $t0,$t1,$t2
  sw $t0, 260($sp)
  lw $a0, 260($sp)
  li $v0,1
  syscall
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,264
  jr $ra

