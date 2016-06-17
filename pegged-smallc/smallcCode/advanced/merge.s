  .text
  .globl main
sum:
  addiu $sp,$sp,-56
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,56
  li $t0,0
  sw $t0, 16($sp)
  lw $t0, 16($sp)
  sw $t0, 12($sp)
  li $t0,0
  sw $t0, 20($sp)
  lw $t0, 20($sp)
  sw $t0, 8($sp)
_L1:
  lw $t1, 8($sp)
  lw $t2, 4($fp)
  slt $t0,$t1,$t2
  sw $t0, 24($sp)
  lw $t0, 24($sp)
  beqz $t0,_L3
_L2:
  li $t0,4
  sw $t0, 28($sp)
  lw $t1, 28($sp)
  lw $t2, 8($sp)
  mul $t0,$t1,$t2
  sw $t0, 32($sp)
  lw $t1, 0($fp)
  lw $t2, 32($sp)
  add $t0,$t1,$t2
  sw $t0, 36($sp)
  lw $t0, 36($sp)
  lw $t0, 0($t0)
  sw $t0, 40($sp)
  lw $t1, 12($sp)
  lw $t2, 40($sp)
  add $t0,$t1,$t2
  sw $t0, 44($sp)
  lw $t0, 44($sp)
  sw $t0, 12($sp)
  li $t0,1
  sw $t0, 48($sp)
  lw $t1, 8($sp)
  lw $t2, 48($sp)
  add $t0,$t1,$t2
  sw $t0, 52($sp)
  lw $t0, 52($sp)
  sw $t0, 8($sp)
  j _L1
_L3:
  lw $v0, 12($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,56
  jr $ra
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,56
  jr $ra
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
  addiu $sp,$sp,-100
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,100
  li $t0,2
  sw $t0, 8($sp)
  lw $t1, 4($fp)
  lw $t2, 8($sp)
  slt $t0,$t1,$t2
  sw $t0, 12($sp)
  lw $t0, 12($sp)
  beqz $t0,_L5
_L4:
  li $t0,1
  sw $t0, 16($sp)
  lw $v0, 16($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,100
  jr $ra
_L5:
  li $t0,0
  sw $t0, 24($sp)
  lw $t0, 24($sp)
  sw $t0, 20($sp)
_L7:
  li $t0,1
  sw $t0, 28($sp)
  lw $t1, 4($fp)
  lw $t2, 28($sp)
  sub $t0,$t1,$t2
  sw $t0, 32($sp)
  lw $t1, 20($sp)
  lw $t2, 32($sp)
  slt $t0,$t1,$t2
  sw $t0, 36($sp)
  lw $t0, 36($sp)
  beqz $t0,_L9
_L8:
  li $t0,4
  sw $t0, 40($sp)
  lw $t1, 40($sp)
  lw $t2, 20($sp)
  mul $t0,$t1,$t2
  sw $t0, 44($sp)
  lw $t1, 0($fp)
  lw $t2, 44($sp)
  add $t0,$t1,$t2
  sw $t0, 48($sp)
  lw $t0, 48($sp)
  lw $t0, 0($t0)
  sw $t0, 52($sp)
  li $t0,1
  sw $t0, 56($sp)
  lw $t1, 20($sp)
  lw $t2, 56($sp)
  add $t0,$t1,$t2
  sw $t0, 60($sp)
  li $t0,4
  sw $t0, 64($sp)
  lw $t1, 64($sp)
  lw $t2, 60($sp)
  mul $t0,$t1,$t2
  sw $t0, 68($sp)
  lw $t1, 0($fp)
  lw $t2, 68($sp)
  add $t0,$t1,$t2
  sw $t0, 72($sp)
  lw $t0, 72($sp)
  lw $t0, 0($t0)
  sw $t0, 76($sp)
  addiu $t1,$sp,-8
  lw $t0, 52($sp)
  sw $t0, 0($t1)
  lw $t0, 76($sp)
  sw $t0, 4($t1)
  move $sp,$t1
  jal is_greater
  addiu $sp,$sp,8
  sw $v0, 80($sp)
  lw $t0, 80($sp)
  beqz $t0,_L11
_L10:
  li $t0,0
  sw $t0, 84($sp)
  lw $v0, 84($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,100
  jr $ra
_L11:
_L12:
  li $t0,1
  sw $t0, 88($sp)
  lw $t1, 20($sp)
  lw $t2, 88($sp)
  add $t0,$t1,$t2
  sw $t0, 92($sp)
  lw $t0, 92($sp)
  sw $t0, 20($sp)
  j _L7
_L9:
  li $t0,1
  sw $t0, 96($sp)
  lw $v0, 96($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,100
  jr $ra
_L6:
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,100
  jr $ra
merge:
  addiu $sp,$sp,-300
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,300
  li $t0,0
  sw $t0, 12($sp)
  lw $t0, 12($sp)
  sw $t0, 8($sp)
_L13:
  li $t0,2
  sw $t0, 16($sp)
  lw $t1, 4($fp)
  lw $t2, 16($sp)
  div $t0,$t1,$t2
  sw $t0, 20($sp)
  lw $t1, 8($sp)
  lw $t2, 20($sp)
  slt $t0,$t1,$t2
  sw $t0, 24($sp)
  lw $t0, 24($sp)
  beqz $t0,_L15
_L14:
  li $t0,4
  sw $t0, 28($sp)
  lw $t1, 28($sp)
  lw $t2, 8($sp)
  mul $t0,$t1,$t2
  sw $t0, 32($sp)
  lw $t1, 0($fp)
  lw $t2, 32($sp)
  add $t0,$t1,$t2
  sw $t0, 36($sp)
  lw $t0, 36($sp)
  lw $t0, 0($t0)
  sw $t0, 40($sp)
  li $t0,4
  sw $t0, 44($sp)
  lw $t1, 44($sp)
  lw $t2, 8($sp)
  mul $t0,$t1,$t2
  sw $t0, 48($sp)
  addiu $t1,$gp,0
  lw $t2, 48($sp)
  add $t0,$t1,$t2
  sw $t0, 52($sp)
  lw $t0, 40($sp)
  lw $t1, 52($sp)
  sw $t0, 0($t1)
  li $t0,1
  sw $t0, 56($sp)
  lw $t1, 8($sp)
  lw $t2, 56($sp)
  add $t0,$t1,$t2
  sw $t0, 60($sp)
  lw $t0, 60($sp)
  sw $t0, 8($sp)
  j _L13
_L15:
  li $t0,4
  sw $t0, 64($sp)
  lw $t1, 64($sp)
  lw $t2, 8($sp)
  mul $t0,$t1,$t2
  sw $t0, 68($sp)
  addiu $t1,$gp,0
  lw $t2, 68($sp)
  add $t0,$t1,$t2
  sw $t0, 72($sp)
  lw $t0, 8($gp)
  lw $t1, 72($sp)
  sw $t0, 0($t1)
  li $t0,2
  sw $t0, 76($sp)
  lw $t1, 4($fp)
  lw $t2, 76($sp)
  div $t0,$t1,$t2
  sw $t0, 80($sp)
  lw $t0, 80($sp)
  sw $t0, 8($sp)
_L16:
  lw $t1, 8($sp)
  lw $t2, 4($fp)
  slt $t0,$t1,$t2
  sw $t0, 84($sp)
  lw $t0, 84($sp)
  beqz $t0,_L18
_L17:
  li $t0,4
  sw $t0, 88($sp)
  lw $t1, 88($sp)
  lw $t2, 8($sp)
  mul $t0,$t1,$t2
  sw $t0, 92($sp)
  lw $t1, 0($fp)
  lw $t2, 92($sp)
  add $t0,$t1,$t2
  sw $t0, 96($sp)
  lw $t0, 96($sp)
  lw $t0, 0($t0)
  sw $t0, 100($sp)
  li $t0,2
  sw $t0, 104($sp)
  lw $t1, 4($fp)
  lw $t2, 104($sp)
  div $t0,$t1,$t2
  sw $t0, 108($sp)
  lw $t1, 8($sp)
  lw $t2, 108($sp)
  sub $t0,$t1,$t2
  sw $t0, 112($sp)
  li $t0,4
  sw $t0, 116($sp)
  lw $t1, 116($sp)
  lw $t2, 112($sp)
  mul $t0,$t1,$t2
  sw $t0, 120($sp)
  addiu $t1,$gp,4
  lw $t2, 120($sp)
  add $t0,$t1,$t2
  sw $t0, 124($sp)
  lw $t0, 100($sp)
  lw $t1, 124($sp)
  sw $t0, 0($t1)
  li $t0,1
  sw $t0, 128($sp)
  lw $t1, 8($sp)
  lw $t2, 128($sp)
  add $t0,$t1,$t2
  sw $t0, 132($sp)
  lw $t0, 132($sp)
  sw $t0, 8($sp)
  j _L16
_L18:
  li $t0,2
  sw $t0, 136($sp)
  lw $t1, 4($fp)
  lw $t2, 136($sp)
  div $t0,$t1,$t2
  sw $t0, 140($sp)
  lw $t1, 8($sp)
  lw $t2, 140($sp)
  sub $t0,$t1,$t2
  sw $t0, 144($sp)
  li $t0,4
  sw $t0, 148($sp)
  lw $t1, 148($sp)
  lw $t2, 144($sp)
  mul $t0,$t1,$t2
  sw $t0, 152($sp)
  addiu $t1,$gp,4
  lw $t2, 152($sp)
  add $t0,$t1,$t2
  sw $t0, 156($sp)
  lw $t0, 8($gp)
  lw $t1, 156($sp)
  sw $t0, 0($t1)
  li $t0,0
  sw $t0, 168($sp)
  lw $t0, 168($sp)
  sw $t0, 8($sp)
  li $t0,0
  sw $t0, 172($sp)
  lw $t0, 172($sp)
  sw $t0, 160($sp)
  li $t0,0
  sw $t0, 176($sp)
  lw $t0, 176($sp)
  sw $t0, 164($sp)
_L19:
  lw $t1, 8($sp)
  lw $t2, 4($fp)
  slt $t0,$t1,$t2
  sw $t0, 180($sp)
  lw $t0, 180($sp)
  beqz $t0,_L21
_L20:
  li $t0,4
  sw $t0, 184($sp)
  lw $t1, 184($sp)
  lw $t2, 160($sp)
  mul $t0,$t1,$t2
  sw $t0, 188($sp)
  addiu $t1,$gp,0
  lw $t2, 188($sp)
  add $t0,$t1,$t2
  sw $t0, 192($sp)
  lw $t0, 192($sp)
  lw $t0, 0($t0)
  sw $t0, 196($sp)
  li $t0,4
  sw $t0, 200($sp)
  lw $t1, 200($sp)
  lw $t2, 164($sp)
  mul $t0,$t1,$t2
  sw $t0, 204($sp)
  addiu $t1,$gp,4
  lw $t2, 204($sp)
  add $t0,$t1,$t2
  sw $t0, 208($sp)
  lw $t0, 208($sp)
  lw $t0, 0($t0)
  sw $t0, 212($sp)
  addiu $t1,$sp,-8
  lw $t0, 196($sp)
  sw $t0, 0($t1)
  lw $t0, 212($sp)
  sw $t0, 4($t1)
  move $sp,$t1
  jal is_greater
  addiu $sp,$sp,8
  sw $v0, 216($sp)
  lw $t0, 216($sp)
  beqz $t0,_L23
_L22:
  li $t0,4
  sw $t0, 228($sp)
  lw $t1, 228($sp)
  lw $t2, 164($sp)
  mul $t0,$t1,$t2
  sw $t0, 232($sp)
  addiu $t1,$gp,4
  lw $t2, 232($sp)
  add $t0,$t1,$t2
  sw $t0, 236($sp)
  lw $t0, 236($sp)
  lw $t0, 0($t0)
  sw $t0, 240($sp)
  li $t0,4
  sw $t0, 244($sp)
  lw $t1, 244($sp)
  lw $t2, 8($sp)
  mul $t0,$t1,$t2
  sw $t0, 248($sp)
  lw $t1, 0($fp)
  lw $t2, 248($sp)
  add $t0,$t1,$t2
  sw $t0, 252($sp)
  lw $t0, 240($sp)
  lw $t1, 252($sp)
  sw $t0, 0($t1)
  li $t0,1
  sw $t0, 256($sp)
  lw $t1, 164($sp)
  lw $t2, 256($sp)
  add $t0,$t1,$t2
  sw $t0, 260($sp)
  lw $t0, 260($sp)
  sw $t0, 164($sp)
  j _L24
_L23:
  li $t0,4
  sw $t0, 264($sp)
  lw $t1, 264($sp)
  lw $t2, 160($sp)
  mul $t0,$t1,$t2
  sw $t0, 268($sp)
  addiu $t1,$gp,0
  lw $t2, 268($sp)
  add $t0,$t1,$t2
  sw $t0, 272($sp)
  lw $t0, 272($sp)
  lw $t0, 0($t0)
  sw $t0, 276($sp)
  li $t0,4
  sw $t0, 280($sp)
  lw $t1, 280($sp)
  lw $t2, 8($sp)
  mul $t0,$t1,$t2
  sw $t0, 284($sp)
  lw $t1, 0($fp)
  lw $t2, 284($sp)
  add $t0,$t1,$t2
  sw $t0, 288($sp)
  lw $t0, 276($sp)
  lw $t1, 288($sp)
  sw $t0, 0($t1)
  li $t0,1
  sw $t0, 292($sp)
  lw $t1, 160($sp)
  lw $t2, 292($sp)
  add $t0,$t1,$t2
  sw $t0, 296($sp)
  lw $t0, 296($sp)
  sw $t0, 160($sp)
_L24:
  li $t0,1
  sw $t0, 220($sp)
  lw $t1, 8($sp)
  lw $t2, 220($sp)
  add $t0,$t1,$t2
  sw $t0, 224($sp)
  lw $t0, 224($sp)
  sw $t0, 8($sp)
  j _L19
_L21:
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,300
  jr $ra
sort:
  addiu $sp,$sp,-72
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,72
  li $t0,2
  sw $t0, 8($sp)
  lw $t1, 4($fp)
  lw $t2, 8($sp)
  slt $t0,$t1,$t2
  sw $t0, 12($sp)
  lw $t0, 12($sp)
  beqz $t0,_L26
_L25:
  li $t0,0
  sw $t0, 16($sp)
  lw $v0, 16($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,72
  jr $ra
_L26:
_L27:
  li $t0,2
  sw $t0, 20($sp)
  lw $t1, 4($fp)
  lw $t2, 20($sp)
  div $t0,$t1,$t2
  sw $t0, 24($sp)
  addiu $t1,$sp,-8
  lw $t0, 0($fp)
  sw $t0, 0($t1)
  lw $t0, 24($sp)
  sw $t0, 4($t1)
  move $sp,$t1
  jal sort
  addiu $sp,$sp,8
  sw $v0, 28($sp)
  li $t0,2
  sw $t0, 32($sp)
  lw $t1, 4($fp)
  lw $t2, 32($sp)
  div $t0,$t1,$t2
  sw $t0, 36($sp)
  li $t0,4
  sw $t0, 40($sp)
  lw $t1, 40($sp)
  lw $t2, 36($sp)
  mul $t0,$t1,$t2
  sw $t0, 44($sp)
  lw $t1, 0($fp)
  lw $t2, 44($sp)
  add $t0,$t1,$t2
  sw $t0, 48($sp)
  li $t0,2
  sw $t0, 52($sp)
  lw $t1, 4($fp)
  lw $t2, 52($sp)
  div $t0,$t1,$t2
  sw $t0, 56($sp)
  lw $t1, 4($fp)
  lw $t2, 56($sp)
  sub $t0,$t1,$t2
  sw $t0, 60($sp)
  addiu $t1,$sp,-8
  lw $t0, 48($sp)
  sw $t0, 0($t1)
  lw $t0, 60($sp)
  sw $t0, 4($t1)
  move $sp,$t1
  jal sort
  addiu $sp,$sp,8
  sw $v0, 64($sp)
  addiu $t1,$sp,-8
  lw $t0, 0($fp)
  sw $t0, 0($t1)
  lw $t0, 4($fp)
  sw $t0, 4($t1)
  move $sp,$t1
  jal merge
  addiu $sp,$sp,8
  sw $v0, 68($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,72
  jr $ra
main:
  addiu $sp,$sp,-276
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,276
  li $t0,11
  sw $t0, 12($sp)
  lw $t0, 12($sp)
  sw $t0, 8($gp)
  li $t0,8
  sw $t0, 16($sp)
  li $t0,0
  sw $t0, 20($sp)
  li $t0,4
  sw $t0, 24($sp)
  lw $t1, 24($sp)
  lw $t2, 20($sp)
  mul $t0,$t1,$t2
  sw $t0, 28($sp)
  addiu $t1,$sp,8
  lw $t2, 28($sp)
  add $t0,$t1,$t2
  sw $t0, 32($sp)
  lw $t0, 16($sp)
  lw $t1, 32($sp)
  sw $t0, 0($t1)
  li $t0,3
  sw $t0, 36($sp)
  li $t0,1
  sw $t0, 40($sp)
  li $t0,4
  sw $t0, 44($sp)
  lw $t1, 44($sp)
  lw $t2, 40($sp)
  mul $t0,$t1,$t2
  sw $t0, 48($sp)
  addiu $t1,$sp,8
  lw $t2, 48($sp)
  add $t0,$t1,$t2
  sw $t0, 52($sp)
  lw $t0, 36($sp)
  lw $t1, 52($sp)
  sw $t0, 0($t1)
  li $t0,1
  sw $t0, 56($sp)
  li $t0,2
  sw $t0, 60($sp)
  li $t0,4
  sw $t0, 64($sp)
  lw $t1, 64($sp)
  lw $t2, 60($sp)
  mul $t0,$t1,$t2
  sw $t0, 68($sp)
  addiu $t1,$sp,8
  lw $t2, 68($sp)
  add $t0,$t1,$t2
  sw $t0, 72($sp)
  lw $t0, 56($sp)
  lw $t1, 72($sp)
  sw $t0, 0($t1)
  li $t0,7
  sw $t0, 76($sp)
  li $t0,3
  sw $t0, 80($sp)
  li $t0,4
  sw $t0, 84($sp)
  lw $t1, 84($sp)
  lw $t2, 80($sp)
  mul $t0,$t1,$t2
  sw $t0, 88($sp)
  addiu $t1,$sp,8
  lw $t2, 88($sp)
  add $t0,$t1,$t2
  sw $t0, 92($sp)
  lw $t0, 76($sp)
  lw $t1, 92($sp)
  sw $t0, 0($t1)
  li $t0,4
  sw $t0, 96($sp)
  li $t0,4
  sw $t0, 100($sp)
  li $t0,4
  sw $t0, 104($sp)
  lw $t1, 104($sp)
  lw $t2, 100($sp)
  mul $t0,$t1,$t2
  sw $t0, 108($sp)
  addiu $t1,$sp,8
  lw $t2, 108($sp)
  add $t0,$t1,$t2
  sw $t0, 112($sp)
  lw $t0, 96($sp)
  lw $t1, 112($sp)
  sw $t0, 0($t1)
  li $t0,9
  sw $t0, 116($sp)
  li $t0,5
  sw $t0, 120($sp)
  li $t0,4
  sw $t0, 124($sp)
  lw $t1, 124($sp)
  lw $t2, 120($sp)
  mul $t0,$t1,$t2
  sw $t0, 128($sp)
  addiu $t1,$sp,8
  lw $t2, 128($sp)
  add $t0,$t1,$t2
  sw $t0, 132($sp)
  lw $t0, 116($sp)
  lw $t1, 132($sp)
  sw $t0, 0($t1)
  li $t0,10
  sw $t0, 136($sp)
  li $t0,6
  sw $t0, 140($sp)
  li $t0,4
  sw $t0, 144($sp)
  lw $t1, 144($sp)
  lw $t2, 140($sp)
  mul $t0,$t1,$t2
  sw $t0, 148($sp)
  addiu $t1,$sp,8
  lw $t2, 148($sp)
  add $t0,$t1,$t2
  sw $t0, 152($sp)
  lw $t0, 136($sp)
  lw $t1, 152($sp)
  sw $t0, 0($t1)
  li $t0,2
  sw $t0, 156($sp)
  li $t0,7
  sw $t0, 160($sp)
  li $t0,4
  sw $t0, 164($sp)
  lw $t1, 164($sp)
  lw $t2, 160($sp)
  mul $t0,$t1,$t2
  sw $t0, 168($sp)
  addiu $t1,$sp,8
  lw $t2, 168($sp)
  add $t0,$t1,$t2
  sw $t0, 172($sp)
  lw $t0, 156($sp)
  lw $t1, 172($sp)
  sw $t0, 0($t1)
  li $t0,6
  sw $t0, 176($sp)
  li $t0,8
  sw $t0, 180($sp)
  li $t0,4
  sw $t0, 184($sp)
  lw $t1, 184($sp)
  lw $t2, 180($sp)
  mul $t0,$t1,$t2
  sw $t0, 188($sp)
  addiu $t1,$sp,8
  lw $t2, 188($sp)
  add $t0,$t1,$t2
  sw $t0, 192($sp)
  lw $t0, 176($sp)
  lw $t1, 192($sp)
  sw $t0, 0($t1)
  li $t0,5
  sw $t0, 196($sp)
  li $t0,9
  sw $t0, 200($sp)
  li $t0,4
  sw $t0, 204($sp)
  lw $t1, 204($sp)
  lw $t2, 200($sp)
  mul $t0,$t1,$t2
  sw $t0, 208($sp)
  addiu $t1,$sp,8
  lw $t2, 208($sp)
  add $t0,$t1,$t2
  sw $t0, 212($sp)
  lw $t0, 196($sp)
  lw $t1, 212($sp)
  sw $t0, 0($t1)
  li $t0,10
  sw $t0, 220($sp)
  addiu $t1,$sp,-8
  addiu $t0,$sp,8
  sw $t0, 0($t1)
  lw $t0, 220($sp)
  sw $t0, 4($t1)
  move $sp,$t1
  jal sorted
  addiu $sp,$sp,8
  sw $v0, 224($sp)
  lw $t0, 224($sp)
  sw $t0, 216($sp)
  li $t0,10
  sw $t0, 228($sp)
  addiu $t1,$sp,-8
  addiu $t0,$sp,8
  sw $t0, 0($t1)
  lw $t0, 228($sp)
  sw $t0, 4($t1)
  move $sp,$t1
  jal sort
  addiu $sp,$sp,8
  sw $v0, 232($sp)
  li $t0,0
  sw $t0, 244($sp)
  lw $t1, 216($sp)
  lw $t2, 244($sp)
  seq $t0,$t1,$t2
  sw $t0, 248($sp)
  lw $t0, 248($sp)
  beqz $t0,_L29
_L28:
  li $t0,10
  sw $t0, 252($sp)
  addiu $t1,$sp,-8
  addiu $t0,$sp,8
  sw $t0, 0($t1)
  lw $t0, 252($sp)
  sw $t0, 4($t1)
  move $sp,$t1
  jal sorted
  addiu $sp,$sp,8
  sw $v0, 256($sp)
  lw $t0, 256($sp)
  beqz $t0,_L32
_L31:
  li $t0,1
  sw $t0, 240($sp)
  j _L33
_L32:
  li $t0,0
  sw $t0, 240($sp)
_L33:
  j _L30
_L29:
  li $t0,0
  sw $t0, 240($sp)
_L30:
  lw $t0, 240($sp)
  beqz $t0,_L35
_L34:
  li $t0,10
  sw $t0, 260($sp)
  addiu $t1,$sp,-8
  addiu $t0,$sp,8
  sw $t0, 0($t1)
  lw $t0, 260($sp)
  sw $t0, 4($t1)
  move $sp,$t1
  jal sum
  addiu $sp,$sp,8
  sw $v0, 264($sp)
  li $t0,55
  sw $t0, 268($sp)
  lw $t1, 264($sp)
  lw $t2, 268($sp)
  seq $t0,$t1,$t2
  sw $t0, 272($sp)
  lw $t0, 272($sp)
  beqz $t0,_L38
_L37:
  li $t0,1
  sw $t0, 236($sp)
  j _L39
_L38:
  li $t0,0
  sw $t0, 236($sp)
_L39:
  j _L36
_L35:
  li $t0,0
  sw $t0, 236($sp)
_L36:
  lw $a0, 236($sp)
  li $v0,1
  syscall
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,276
  jr $ra

