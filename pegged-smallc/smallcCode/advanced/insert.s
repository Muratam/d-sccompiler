  .text
  .globl main
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
sum:
  addiu $sp,$sp,-40
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,40
  li $t0,0
  sw $t0, 12($sp)
  li $t0,0
  sw $t0, 8($sp)
_L1:
  lw $t1, 8($sp)
  lw $t2, 4($fp)
  slt $t0,$t1,$t2
  sw $t0, 16($sp)
  lw $t0, 16($sp)
  beqz $t0,_L3
_L2:
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
  j _L1
_L3:
  lw $v0, 12($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,40
  jr $ra
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,40
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
  addiu $sp,$sp,-60
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,60
  lw $t1, 4($fp)
  li $t2,2
  slt $t0,$t1,$t2
  sw $t0, 8($sp)
  lw $t0, 8($sp)
  beqz $t0,_L5
_L4:
  li $v0,1
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,60
  jr $ra
_L5:
  li $t0,0
  sw $t0, 12($sp)
_L7:
  lw $t1, 4($fp)
  li $t2,1
  sub $t0,$t1,$t2
  sw $t0, 16($sp)
  lw $t1, 12($sp)
  lw $t2, 16($sp)
  slt $t0,$t1,$t2
  sw $t0, 20($sp)
  lw $t0, 20($sp)
  beqz $t0,_L9
_L8:
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
  beqz $t0,_L11
_L10:
  li $v0,0
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,60
  jr $ra
_L11:
_L12:
  lw $t1, 12($sp)
  li $t2,1
  add $t0,$t1,$t2
  sw $t0, 56($sp)
  lw $t0, 56($sp)
  sw $t0, 12($sp)
  j _L7
_L9:
  li $v0,1
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,60
  jr $ra
_L6:
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,60
  jr $ra
sort:
  addiu $sp,$sp,-156
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,156
  li $t0,1
  sw $t0, 12($sp)
  li $t0,1
  sw $t0, 8($sp)
_L13:
  lw $t1, 8($sp)
  lw $t2, 4($fp)
  slt $t0,$t1,$t2
  sw $t0, 16($sp)
  lw $t0, 16($sp)
  beqz $t0,_L15
_L14:
  li $t0,4
  sw $t0, 36($sp)
  li $t1,4
  lw $t2, 8($sp)
  mul $t0,$t1,$t2
  sw $t0, 40($sp)
  lw $t1, 0($fp)
  lw $t2, 40($sp)
  add $t0,$t1,$t2
  sw $t0, 44($sp)
  lw $t0, 44($sp)
  lw $t0, 0($t0)
  sw $t0, 48($sp)
  lw $t0, 48($sp)
  sw $t0, 32($sp)
  li $t0,1
  sw $t0, 52($sp)
  lw $t1, 8($sp)
  li $t2,1
  sub $t0,$t1,$t2
  sw $t0, 56($sp)
  lw $t0, 56($sp)
  sw $t0, 28($sp)
_L16:
  li $t0,0
  sw $t0, 64($sp)
  lw $t1, 28($sp)
  li $t2,0
  sge $t0,$t1,$t2
  sw $t0, 68($sp)
  lw $t0, 68($sp)
  beqz $t0,_L20
_L19:
  li $t0,4
  sw $t0, 72($sp)
  li $t1,4
  lw $t2, 28($sp)
  mul $t0,$t1,$t2
  sw $t0, 76($sp)
  lw $t1, 0($fp)
  lw $t2, 76($sp)
  add $t0,$t1,$t2
  sw $t0, 80($sp)
  lw $t0, 80($sp)
  lw $t0, 0($t0)
  sw $t0, 84($sp)
  addiu $t1,$sp,-8
  lw $t0, 84($sp)
  sw $t0, 0($t1)
  lw $t0, 32($sp)
  sw $t0, 4($t1)
  move $sp,$t1
  jal is_greater
  addiu $sp,$sp,8
  sw $v0, 88($sp)
  lw $t0, 88($sp)
  beqz $t0,_L23
_L22:
  li $t0,1
  sw $t0, 60($sp)
  j _L24
_L23:
  li $t0,0
  sw $t0, 60($sp)
_L24:
  j _L21
_L20:
  li $t0,0
  sw $t0, 60($sp)
_L21:
  lw $t0, 60($sp)
  beqz $t0,_L18
_L17:
  li $t0,4
  sw $t0, 92($sp)
  li $t1,4
  lw $t2, 28($sp)
  mul $t0,$t1,$t2
  sw $t0, 96($sp)
  lw $t1, 0($fp)
  lw $t2, 96($sp)
  add $t0,$t1,$t2
  sw $t0, 100($sp)
  lw $t0, 100($sp)
  lw $t0, 0($t0)
  sw $t0, 104($sp)
  li $t0,1
  sw $t0, 108($sp)
  lw $t1, 28($sp)
  li $t2,1
  add $t0,$t1,$t2
  sw $t0, 112($sp)
  li $t0,4
  sw $t0, 116($sp)
  li $t1,4
  lw $t2, 112($sp)
  mul $t0,$t1,$t2
  sw $t0, 120($sp)
  lw $t1, 0($fp)
  lw $t2, 120($sp)
  add $t0,$t1,$t2
  sw $t0, 124($sp)
  lw $t0, 104($sp)
  lw $t1, 124($sp)
  sw $t0, 0($t1)
  li $t0,1
  sw $t0, 128($sp)
  lw $t1, 28($sp)
  li $t2,1
  sub $t0,$t1,$t2
  sw $t0, 132($sp)
  lw $t0, 132($sp)
  sw $t0, 28($sp)
  j _L16
_L18:
  li $t0,1
  sw $t0, 136($sp)
  lw $t1, 28($sp)
  li $t2,1
  add $t0,$t1,$t2
  sw $t0, 140($sp)
  li $t0,4
  sw $t0, 144($sp)
  li $t1,4
  lw $t2, 140($sp)
  mul $t0,$t1,$t2
  sw $t0, 148($sp)
  lw $t1, 0($fp)
  lw $t2, 148($sp)
  add $t0,$t1,$t2
  sw $t0, 152($sp)
  lw $t0, 32($sp)
  lw $t1, 152($sp)
  sw $t0, 0($t1)
  li $t0,1
  sw $t0, 20($sp)
  lw $t1, 8($sp)
  li $t2,1
  add $t0,$t1,$t2
  sw $t0, 24($sp)
  lw $t0, 24($sp)
  sw $t0, 8($sp)
  j _L13
_L15:
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,156
  jr $ra
main:
  addiu $sp,$sp,-468
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,468
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
  li $t0,0
  sw $t0, 32($sp)
  li $t0,4
  sw $t0, 36($sp)
  li $t1,4
  li $t2,0
  mul $t0,$t1,$t2
  sw $t0, 40($sp)
  addiu $t1,$gp,0
  li $t2,0
  add $t0,$t1,$t2
  sw $t0, 44($sp)
  lw $t0, 12($sp)
  lw $t1, 44($sp)
  sw $t0, 0($t1)
  li $t0,3
  sw $t0, 48($sp)
  li $t0,1
  sw $t0, 52($sp)
  li $t0,4
  sw $t0, 56($sp)
  li $t1,4
  li $t2,1
  mul $t0,$t1,$t2
  sw $t0, 60($sp)
  addiu $t1,$sp,8
  li $t2,4
  add $t0,$t1,$t2
  sw $t0, 64($sp)
  li $t0,3
  lw $t1, 64($sp)
  sw $t0, 0($t1)
  li $t0,1
  sw $t0, 68($sp)
  li $t0,4
  sw $t0, 72($sp)
  li $t1,4
  li $t2,1
  mul $t0,$t1,$t2
  sw $t0, 76($sp)
  addiu $t1,$gp,0
  li $t2,4
  add $t0,$t1,$t2
  sw $t0, 80($sp)
  lw $t0, 48($sp)
  lw $t1, 80($sp)
  sw $t0, 0($t1)
  li $t0,1
  sw $t0, 84($sp)
  li $t0,2
  sw $t0, 88($sp)
  li $t0,4
  sw $t0, 92($sp)
  li $t1,4
  li $t2,2
  mul $t0,$t1,$t2
  sw $t0, 96($sp)
  addiu $t1,$sp,8
  li $t2,8
  add $t0,$t1,$t2
  sw $t0, 100($sp)
  li $t0,1
  lw $t1, 100($sp)
  sw $t0, 0($t1)
  li $t0,2
  sw $t0, 104($sp)
  li $t0,4
  sw $t0, 108($sp)
  li $t1,4
  li $t2,2
  mul $t0,$t1,$t2
  sw $t0, 112($sp)
  addiu $t1,$gp,0
  li $t2,8
  add $t0,$t1,$t2
  sw $t0, 116($sp)
  lw $t0, 84($sp)
  lw $t1, 116($sp)
  sw $t0, 0($t1)
  li $t0,7
  sw $t0, 120($sp)
  li $t0,3
  sw $t0, 124($sp)
  li $t0,4
  sw $t0, 128($sp)
  li $t1,4
  li $t2,3
  mul $t0,$t1,$t2
  sw $t0, 132($sp)
  addiu $t1,$sp,8
  li $t2,12
  add $t0,$t1,$t2
  sw $t0, 136($sp)
  li $t0,7
  lw $t1, 136($sp)
  sw $t0, 0($t1)
  li $t0,3
  sw $t0, 140($sp)
  li $t0,4
  sw $t0, 144($sp)
  li $t1,4
  li $t2,3
  mul $t0,$t1,$t2
  sw $t0, 148($sp)
  addiu $t1,$gp,0
  li $t2,12
  add $t0,$t1,$t2
  sw $t0, 152($sp)
  lw $t0, 120($sp)
  lw $t1, 152($sp)
  sw $t0, 0($t1)
  li $t0,4
  sw $t0, 156($sp)
  li $t0,4
  sw $t0, 160($sp)
  li $t0,4
  sw $t0, 164($sp)
  li $t1,4
  li $t2,4
  mul $t0,$t1,$t2
  sw $t0, 168($sp)
  addiu $t1,$sp,8
  li $t2,16
  add $t0,$t1,$t2
  sw $t0, 172($sp)
  li $t0,4
  lw $t1, 172($sp)
  sw $t0, 0($t1)
  li $t0,4
  sw $t0, 176($sp)
  li $t0,4
  sw $t0, 180($sp)
  li $t1,4
  li $t2,4
  mul $t0,$t1,$t2
  sw $t0, 184($sp)
  addiu $t1,$gp,0
  li $t2,16
  add $t0,$t1,$t2
  sw $t0, 188($sp)
  lw $t0, 156($sp)
  lw $t1, 188($sp)
  sw $t0, 0($t1)
  li $t0,9
  sw $t0, 192($sp)
  li $t0,5
  sw $t0, 196($sp)
  li $t0,4
  sw $t0, 200($sp)
  li $t1,4
  li $t2,5
  mul $t0,$t1,$t2
  sw $t0, 204($sp)
  addiu $t1,$sp,8
  li $t2,20
  add $t0,$t1,$t2
  sw $t0, 208($sp)
  li $t0,9
  lw $t1, 208($sp)
  sw $t0, 0($t1)
  li $t0,5
  sw $t0, 212($sp)
  li $t0,4
  sw $t0, 216($sp)
  li $t1,4
  li $t2,5
  mul $t0,$t1,$t2
  sw $t0, 220($sp)
  addiu $t1,$gp,0
  li $t2,20
  add $t0,$t1,$t2
  sw $t0, 224($sp)
  lw $t0, 192($sp)
  lw $t1, 224($sp)
  sw $t0, 0($t1)
  li $t0,10
  sw $t0, 228($sp)
  li $t0,6
  sw $t0, 232($sp)
  li $t0,4
  sw $t0, 236($sp)
  li $t1,4
  li $t2,6
  mul $t0,$t1,$t2
  sw $t0, 240($sp)
  addiu $t1,$sp,8
  li $t2,24
  add $t0,$t1,$t2
  sw $t0, 244($sp)
  li $t0,10
  lw $t1, 244($sp)
  sw $t0, 0($t1)
  li $t0,6
  sw $t0, 248($sp)
  li $t0,4
  sw $t0, 252($sp)
  li $t1,4
  li $t2,6
  mul $t0,$t1,$t2
  sw $t0, 256($sp)
  addiu $t1,$gp,0
  li $t2,24
  add $t0,$t1,$t2
  sw $t0, 260($sp)
  lw $t0, 228($sp)
  lw $t1, 260($sp)
  sw $t0, 0($t1)
  li $t0,2
  sw $t0, 264($sp)
  li $t0,7
  sw $t0, 268($sp)
  li $t0,4
  sw $t0, 272($sp)
  li $t1,4
  li $t2,7
  mul $t0,$t1,$t2
  sw $t0, 276($sp)
  addiu $t1,$sp,8
  li $t2,28
  add $t0,$t1,$t2
  sw $t0, 280($sp)
  li $t0,2
  lw $t1, 280($sp)
  sw $t0, 0($t1)
  li $t0,7
  sw $t0, 284($sp)
  li $t0,4
  sw $t0, 288($sp)
  li $t1,4
  li $t2,7
  mul $t0,$t1,$t2
  sw $t0, 292($sp)
  addiu $t1,$gp,0
  li $t2,28
  add $t0,$t1,$t2
  sw $t0, 296($sp)
  lw $t0, 264($sp)
  lw $t1, 296($sp)
  sw $t0, 0($t1)
  li $t0,6
  sw $t0, 300($sp)
  li $t0,8
  sw $t0, 304($sp)
  li $t0,4
  sw $t0, 308($sp)
  li $t1,4
  li $t2,8
  mul $t0,$t1,$t2
  sw $t0, 312($sp)
  addiu $t1,$sp,8
  li $t2,32
  add $t0,$t1,$t2
  sw $t0, 316($sp)
  li $t0,6
  lw $t1, 316($sp)
  sw $t0, 0($t1)
  li $t0,8
  sw $t0, 320($sp)
  li $t0,4
  sw $t0, 324($sp)
  li $t1,4
  li $t2,8
  mul $t0,$t1,$t2
  sw $t0, 328($sp)
  addiu $t1,$gp,0
  li $t2,32
  add $t0,$t1,$t2
  sw $t0, 332($sp)
  lw $t0, 300($sp)
  lw $t1, 332($sp)
  sw $t0, 0($t1)
  li $t0,5
  sw $t0, 336($sp)
  li $t0,9
  sw $t0, 340($sp)
  li $t0,4
  sw $t0, 344($sp)
  li $t1,4
  li $t2,9
  mul $t0,$t1,$t2
  sw $t0, 348($sp)
  addiu $t1,$sp,8
  li $t2,36
  add $t0,$t1,$t2
  sw $t0, 352($sp)
  li $t0,5
  lw $t1, 352($sp)
  sw $t0, 0($t1)
  li $t0,9
  sw $t0, 356($sp)
  li $t0,4
  sw $t0, 360($sp)
  li $t1,4
  li $t2,9
  mul $t0,$t1,$t2
  sw $t0, 364($sp)
  addiu $t1,$gp,0
  li $t2,36
  add $t0,$t1,$t2
  sw $t0, 368($sp)
  lw $t0, 336($sp)
  lw $t1, 368($sp)
  sw $t0, 0($t1)
  li $t0,10
  sw $t0, 376($sp)
  addiu $t1,$sp,-8
  addiu $t0,$sp,8
  sw $t0, 0($t1)
  li $t0,10
  sw $t0, 4($t1)
  move $sp,$t1
  jal sorted
  addiu $sp,$sp,8
  sw $v0, 380($sp)
  lw $t0, 380($sp)
  sw $t0, 372($sp)
  li $t0,10
  sw $t0, 384($sp)
  addiu $t1,$sp,-8
  addiu $t0,$sp,8
  sw $t0, 0($t1)
  li $t0,10
  sw $t0, 4($t1)
  move $sp,$t1
  jal sort
  addiu $sp,$sp,8
  sw $v0, 388($sp)
  li $t0,10
  sw $t0, 408($sp)
  addiu $t1,$sp,-8
  addiu $t0,$gp,0
  sw $t0, 0($t1)
  li $t0,10
  sw $t0, 4($t1)
  move $sp,$t1
  jal sorted
  addiu $sp,$sp,8
  sw $v0, 412($sp)
  li $t0,0
  sw $t0, 416($sp)
  lw $t1, 412($sp)
  li $t2,0
  seq $t0,$t1,$t2
  sw $t0, 420($sp)
  lw $t0, 420($sp)
  beqz $t0,_L26
_L25:
  li $t0,0
  sw $t0, 424($sp)
  lw $t1, 372($sp)
  li $t2,0
  seq $t0,$t1,$t2
  sw $t0, 428($sp)
  lw $t0, 428($sp)
  beqz $t0,_L29
_L28:
  li $t0,1
  sw $t0, 404($sp)
  j _L30
_L29:
  li $t0,0
  sw $t0, 404($sp)
_L30:
  j _L27
_L26:
  li $t0,0
  sw $t0, 404($sp)
_L27:
  lw $t0, 404($sp)
  beqz $t0,_L32
_L31:
  li $t0,10
  sw $t0, 432($sp)
  addiu $t1,$sp,-8
  addiu $t0,$sp,8
  sw $t0, 0($t1)
  li $t0,10
  sw $t0, 4($t1)
  move $sp,$t1
  jal sorted
  addiu $sp,$sp,8
  sw $v0, 436($sp)
  lw $t0, 436($sp)
  beqz $t0,_L35
_L34:
  li $t0,1
  sw $t0, 400($sp)
  j _L36
_L35:
  li $t0,0
  sw $t0, 400($sp)
_L36:
  j _L33
_L32:
  li $t0,0
  sw $t0, 400($sp)
_L33:
  lw $t0, 400($sp)
  beqz $t0,_L38
_L37:
  li $t0,10
  sw $t0, 440($sp)
  addiu $t1,$sp,-8
  addiu $t0,$gp,0
  sw $t0, 0($t1)
  li $t0,10
  sw $t0, 4($t1)
  move $sp,$t1
  jal sum
  addiu $sp,$sp,8
  sw $v0, 444($sp)
  li $t0,55
  sw $t0, 448($sp)
  lw $t1, 444($sp)
  li $t2,55
  seq $t0,$t1,$t2
  sw $t0, 452($sp)
  lw $t0, 452($sp)
  beqz $t0,_L41
_L40:
  li $t0,1
  sw $t0, 396($sp)
  j _L42
_L41:
  li $t0,0
  sw $t0, 396($sp)
_L42:
  j _L39
_L38:
  li $t0,0
  sw $t0, 396($sp)
_L39:
  lw $t0, 396($sp)
  beqz $t0,_L44
_L43:
  li $t0,10
  sw $t0, 456($sp)
  addiu $t1,$sp,-8
  addiu $t0,$sp,8
  sw $t0, 0($t1)
  li $t0,10
  sw $t0, 4($t1)
  move $sp,$t1
  jal sum
  addiu $sp,$sp,8
  sw $v0, 460($sp)
  lw $t1, 460($sp)
  li $t2,55
  seq $t0,$t1,$t2
  sw $t0, 464($sp)
  lw $t0, 464($sp)
  beqz $t0,_L47
_L46:
  li $t0,1
  sw $t0, 392($sp)
  j _L48
_L47:
  li $t0,0
  sw $t0, 392($sp)
_L48:
  j _L45
_L44:
  li $t0,0
  sw $t0, 392($sp)
_L45:
  lw $a0, 392($sp)
  li $v0,1
  syscall
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,468
  jr $ra

