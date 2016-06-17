  .text
  .globl main
get:
  addiu $sp,$sp,-32
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,32
  lw $t1, 4($fp)
  lw $t2, 0($gp)
  mul $t0,$t1,$t2
  sw $t0, 8($sp)
  lw $t1, 8($sp)
  lw $t2, 8($fp)
  add $t0,$t1,$t2
  sw $t0, 12($sp)
  li $t0,4
  sw $t0, 16($sp)
  lw $t1, 16($sp)
  lw $t2, 12($sp)
  mul $t0,$t1,$t2
  sw $t0, 20($sp)
  lw $t1, 0($fp)
  lw $t2, 20($sp)
  add $t0,$t1,$t2
  sw $t0, 24($sp)
  lw $t0, 24($sp)
  lw $t0, 0($t0)
  sw $t0, 28($sp)
  lw $v0, 28($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,32
  jr $ra
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,32
  jr $ra
set:
  addiu $sp,$sp,-28
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,28
  lw $t1, 4($fp)
  lw $t2, 0($gp)
  mul $t0,$t1,$t2
  sw $t0, 8($sp)
  lw $t1, 8($sp)
  lw $t2, 8($fp)
  add $t0,$t1,$t2
  sw $t0, 12($sp)
  li $t0,4
  sw $t0, 16($sp)
  lw $t1, 16($sp)
  lw $t2, 12($sp)
  mul $t0,$t1,$t2
  sw $t0, 20($sp)
  lw $t1, 0($fp)
  lw $t2, 20($sp)
  add $t0,$t1,$t2
  sw $t0, 24($sp)
  lw $t0, 12($fp)
  lw $t1, 24($sp)
  sw $t0, 0($t1)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,28
  jr $ra
matmul:
  addiu $sp,$sp,-96
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,96
  li $t0,0
  sw $t0, 20($sp)
  lw $t0, 20($sp)
  sw $t0, 8($sp)
_L1:
  lw $t1, 8($sp)
  lw $t2, 0($gp)
  slt $t0,$t1,$t2
  sw $t0, 24($sp)
  lw $t0, 24($sp)
  beqz $t0,_L3
_L2:
  li $t0,0
  sw $t0, 28($sp)
  lw $t0, 28($sp)
  sw $t0, 12($sp)
_L4:
  lw $t1, 12($sp)
  lw $t2, 0($gp)
  slt $t0,$t1,$t2
  sw $t0, 32($sp)
  lw $t0, 32($sp)
  beqz $t0,_L6
_L5:
  li $t0,0
  sw $t0, 56($sp)
  lw $t0, 56($sp)
  sw $t0, 52($sp)
  li $t0,0
  sw $t0, 60($sp)
  lw $t0, 60($sp)
  sw $t0, 16($sp)
_L7:
  lw $t1, 16($sp)
  lw $t2, 0($gp)
  slt $t0,$t1,$t2
  sw $t0, 64($sp)
  lw $t0, 64($sp)
  beqz $t0,_L9
_L8:
  addiu $t1,$sp,-12
  lw $t0, 0($fp)
  sw $t0, 0($t1)
  lw $t0, 8($sp)
  sw $t0, 4($t1)
  lw $t0, 16($sp)
  sw $t0, 8($t1)
  move $sp,$t1
  jal get
  addiu $sp,$sp,12
  sw $v0, 68($sp)
  addiu $t1,$sp,-12
  lw $t0, 4($fp)
  sw $t0, 0($t1)
  lw $t0, 16($sp)
  sw $t0, 4($t1)
  lw $t0, 12($sp)
  sw $t0, 8($t1)
  move $sp,$t1
  jal get
  addiu $sp,$sp,12
  sw $v0, 72($sp)
  lw $t1, 68($sp)
  lw $t2, 72($sp)
  mul $t0,$t1,$t2
  sw $t0, 76($sp)
  lw $t1, 52($sp)
  lw $t2, 76($sp)
  add $t0,$t1,$t2
  sw $t0, 80($sp)
  lw $t0, 80($sp)
  sw $t0, 52($sp)
  li $t0,1
  sw $t0, 84($sp)
  lw $t1, 16($sp)
  lw $t2, 84($sp)
  add $t0,$t1,$t2
  sw $t0, 88($sp)
  lw $t0, 88($sp)
  sw $t0, 16($sp)
  j _L7
_L9:
  addiu $t1,$sp,-16
  lw $t0, 8($fp)
  sw $t0, 0($t1)
  lw $t0, 8($sp)
  sw $t0, 4($t1)
  lw $t0, 12($sp)
  sw $t0, 8($t1)
  lw $t0, 52($sp)
  sw $t0, 12($t1)
  move $sp,$t1
  jal set
  addiu $sp,$sp,16
  sw $v0, 92($sp)
  li $t0,1
  sw $t0, 36($sp)
  lw $t1, 12($sp)
  lw $t2, 36($sp)
  add $t0,$t1,$t2
  sw $t0, 40($sp)
  lw $t0, 40($sp)
  sw $t0, 12($sp)
  j _L4
_L6:
  li $t0,1
  sw $t0, 44($sp)
  lw $t1, 8($sp)
  lw $t2, 44($sp)
  add $t0,$t1,$t2
  sw $t0, 48($sp)
  lw $t0, 48($sp)
  sw $t0, 8($sp)
  j _L1
_L3:
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,96
  jr $ra
main:
  addiu $sp,$sp,-632
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,632
  li $t0,3
  sw $t0, 20($sp)
  lw $t0, 20($sp)
  sw $t0, 0($gp)
  li $t0,0
  sw $t0, 24($sp)
  li $t0,0
  sw $t0, 28($sp)
  li $t0,2
  sw $t0, 32($sp)
  addiu $t1,$sp,-16
  addiu $t0,$sp,8
  sw $t0, 0($t1)
  lw $t0, 24($sp)
  sw $t0, 4($t1)
  lw $t0, 28($sp)
  sw $t0, 8($t1)
  lw $t0, 32($sp)
  sw $t0, 12($t1)
  move $sp,$t1
  jal set
  addiu $sp,$sp,16
  sw $v0, 36($sp)
  li $t0,0
  sw $t0, 40($sp)
  li $t0,1
  sw $t0, 44($sp)
  li $t0,3
  sw $t0, 48($sp)
  addiu $t1,$sp,-16
  addiu $t0,$sp,8
  sw $t0, 0($t1)
  lw $t0, 40($sp)
  sw $t0, 4($t1)
  lw $t0, 44($sp)
  sw $t0, 8($t1)
  lw $t0, 48($sp)
  sw $t0, 12($t1)
  move $sp,$t1
  jal set
  addiu $sp,$sp,16
  sw $v0, 52($sp)
  li $t0,0
  sw $t0, 56($sp)
  li $t0,2
  sw $t0, 60($sp)
  li $t0,2
  sw $t0, 64($sp)
  addiu $t1,$sp,-16
  addiu $t0,$sp,8
  sw $t0, 0($t1)
  lw $t0, 56($sp)
  sw $t0, 4($t1)
  lw $t0, 60($sp)
  sw $t0, 8($t1)
  lw $t0, 64($sp)
  sw $t0, 12($t1)
  move $sp,$t1
  jal set
  addiu $sp,$sp,16
  sw $v0, 68($sp)
  li $t0,1
  sw $t0, 72($sp)
  li $t0,0
  sw $t0, 76($sp)
  li $t0,1
  sw $t0, 80($sp)
  addiu $t1,$sp,-16
  addiu $t0,$sp,8
  sw $t0, 0($t1)
  lw $t0, 72($sp)
  sw $t0, 4($t1)
  lw $t0, 76($sp)
  sw $t0, 8($t1)
  lw $t0, 80($sp)
  sw $t0, 12($t1)
  move $sp,$t1
  jal set
  addiu $sp,$sp,16
  sw $v0, 84($sp)
  li $t0,1
  sw $t0, 88($sp)
  li $t0,1
  sw $t0, 92($sp)
  li $t0,4
  sw $t0, 96($sp)
  addiu $t1,$sp,-16
  addiu $t0,$sp,8
  sw $t0, 0($t1)
  lw $t0, 88($sp)
  sw $t0, 4($t1)
  lw $t0, 92($sp)
  sw $t0, 8($t1)
  lw $t0, 96($sp)
  sw $t0, 12($t1)
  move $sp,$t1
  jal set
  addiu $sp,$sp,16
  sw $v0, 100($sp)
  li $t0,1
  sw $t0, 104($sp)
  li $t0,2
  sw $t0, 108($sp)
  li $t0,0
  sw $t0, 112($sp)
  li $t0,1
  sw $t0, 116($sp)
  lw $t1, 112($sp)
  lw $t2, 116($sp)
  sub $t0,$t1,$t2
  sw $t0, 120($sp)
  addiu $t1,$sp,-16
  addiu $t0,$sp,8
  sw $t0, 0($t1)
  lw $t0, 104($sp)
  sw $t0, 4($t1)
  lw $t0, 108($sp)
  sw $t0, 8($t1)
  lw $t0, 120($sp)
  sw $t0, 12($t1)
  move $sp,$t1
  jal set
  addiu $sp,$sp,16
  sw $v0, 124($sp)
  li $t0,2
  sw $t0, 128($sp)
  li $t0,0
  sw $t0, 132($sp)
  li $t0,0
  sw $t0, 136($sp)
  li $t0,2
  sw $t0, 140($sp)
  lw $t1, 136($sp)
  lw $t2, 140($sp)
  sub $t0,$t1,$t2
  sw $t0, 144($sp)
  addiu $t1,$sp,-16
  addiu $t0,$sp,8
  sw $t0, 0($t1)
  lw $t0, 128($sp)
  sw $t0, 4($t1)
  lw $t0, 132($sp)
  sw $t0, 8($t1)
  lw $t0, 144($sp)
  sw $t0, 12($t1)
  move $sp,$t1
  jal set
  addiu $sp,$sp,16
  sw $v0, 148($sp)
  li $t0,2
  sw $t0, 152($sp)
  li $t0,1
  sw $t0, 156($sp)
  li $t0,1
  sw $t0, 160($sp)
  addiu $t1,$sp,-16
  addiu $t0,$sp,8
  sw $t0, 0($t1)
  lw $t0, 152($sp)
  sw $t0, 4($t1)
  lw $t0, 156($sp)
  sw $t0, 8($t1)
  lw $t0, 160($sp)
  sw $t0, 12($t1)
  move $sp,$t1
  jal set
  addiu $sp,$sp,16
  sw $v0, 164($sp)
  li $t0,2
  sw $t0, 168($sp)
  li $t0,2
  sw $t0, 172($sp)
  li $t0,0
  sw $t0, 176($sp)
  li $t0,3
  sw $t0, 180($sp)
  lw $t1, 176($sp)
  lw $t2, 180($sp)
  sub $t0,$t1,$t2
  sw $t0, 184($sp)
  addiu $t1,$sp,-16
  addiu $t0,$sp,8
  sw $t0, 0($t1)
  lw $t0, 168($sp)
  sw $t0, 4($t1)
  lw $t0, 172($sp)
  sw $t0, 8($t1)
  lw $t0, 184($sp)
  sw $t0, 12($t1)
  move $sp,$t1
  jal set
  addiu $sp,$sp,16
  sw $v0, 188($sp)
  li $t0,0
  sw $t0, 192($sp)
  li $t0,0
  sw $t0, 196($sp)
  li $t0,0
  sw $t0, 200($sp)
  li $t0,3
  sw $t0, 204($sp)
  lw $t1, 200($sp)
  lw $t2, 204($sp)
  sub $t0,$t1,$t2
  sw $t0, 208($sp)
  addiu $t1,$sp,-16
  addiu $t0,$sp,12
  sw $t0, 0($t1)
  lw $t0, 192($sp)
  sw $t0, 4($t1)
  lw $t0, 196($sp)
  sw $t0, 8($t1)
  lw $t0, 208($sp)
  sw $t0, 12($t1)
  move $sp,$t1
  jal set
  addiu $sp,$sp,16
  sw $v0, 212($sp)
  li $t0,0
  sw $t0, 216($sp)
  li $t0,1
  sw $t0, 220($sp)
  li $t0,1
  sw $t0, 224($sp)
  addiu $t1,$sp,-16
  addiu $t0,$sp,12
  sw $t0, 0($t1)
  lw $t0, 216($sp)
  sw $t0, 4($t1)
  lw $t0, 220($sp)
  sw $t0, 8($t1)
  lw $t0, 224($sp)
  sw $t0, 12($t1)
  move $sp,$t1
  jal set
  addiu $sp,$sp,16
  sw $v0, 228($sp)
  li $t0,0
  sw $t0, 232($sp)
  li $t0,2
  sw $t0, 236($sp)
  li $t0,2
  sw $t0, 240($sp)
  addiu $t1,$sp,-16
  addiu $t0,$sp,12
  sw $t0, 0($t1)
  lw $t0, 232($sp)
  sw $t0, 4($t1)
  lw $t0, 236($sp)
  sw $t0, 8($t1)
  lw $t0, 240($sp)
  sw $t0, 12($t1)
  move $sp,$t1
  jal set
  addiu $sp,$sp,16
  sw $v0, 244($sp)
  li $t0,1
  sw $t0, 248($sp)
  li $t0,0
  sw $t0, 252($sp)
  li $t0,0
  sw $t0, 256($sp)
  li $t0,2
  sw $t0, 260($sp)
  lw $t1, 256($sp)
  lw $t2, 260($sp)
  sub $t0,$t1,$t2
  sw $t0, 264($sp)
  addiu $t1,$sp,-16
  addiu $t0,$sp,12
  sw $t0, 0($t1)
  lw $t0, 248($sp)
  sw $t0, 4($t1)
  lw $t0, 252($sp)
  sw $t0, 8($t1)
  lw $t0, 264($sp)
  sw $t0, 12($t1)
  move $sp,$t1
  jal set
  addiu $sp,$sp,16
  sw $v0, 268($sp)
  li $t0,1
  sw $t0, 272($sp)
  li $t0,1
  sw $t0, 276($sp)
  li $t0,0
  sw $t0, 280($sp)
  li $t0,4
  sw $t0, 284($sp)
  lw $t1, 280($sp)
  lw $t2, 284($sp)
  sub $t0,$t1,$t2
  sw $t0, 288($sp)
  addiu $t1,$sp,-16
  addiu $t0,$sp,12
  sw $t0, 0($t1)
  lw $t0, 272($sp)
  sw $t0, 4($t1)
  lw $t0, 276($sp)
  sw $t0, 8($t1)
  lw $t0, 288($sp)
  sw $t0, 12($t1)
  move $sp,$t1
  jal set
  addiu $sp,$sp,16
  sw $v0, 292($sp)
  li $t0,1
  sw $t0, 296($sp)
  li $t0,2
  sw $t0, 300($sp)
  li $t0,2
  sw $t0, 304($sp)
  addiu $t1,$sp,-16
  addiu $t0,$sp,12
  sw $t0, 0($t1)
  lw $t0, 296($sp)
  sw $t0, 4($t1)
  lw $t0, 300($sp)
  sw $t0, 8($t1)
  lw $t0, 304($sp)
  sw $t0, 12($t1)
  move $sp,$t1
  jal set
  addiu $sp,$sp,16
  sw $v0, 308($sp)
  li $t0,2
  sw $t0, 312($sp)
  li $t0,0
  sw $t0, 316($sp)
  li $t0,4
  sw $t0, 320($sp)
  addiu $t1,$sp,-16
  addiu $t0,$sp,12
  sw $t0, 0($t1)
  lw $t0, 312($sp)
  sw $t0, 4($t1)
  lw $t0, 316($sp)
  sw $t0, 8($t1)
  lw $t0, 320($sp)
  sw $t0, 12($t1)
  move $sp,$t1
  jal set
  addiu $sp,$sp,16
  sw $v0, 324($sp)
  li $t0,2
  sw $t0, 328($sp)
  li $t0,1
  sw $t0, 332($sp)
  li $t0,3
  sw $t0, 336($sp)
  addiu $t1,$sp,-16
  addiu $t0,$sp,12
  sw $t0, 0($t1)
  lw $t0, 328($sp)
  sw $t0, 4($t1)
  lw $t0, 332($sp)
  sw $t0, 8($t1)
  lw $t0, 336($sp)
  sw $t0, 12($t1)
  move $sp,$t1
  jal set
  addiu $sp,$sp,16
  sw $v0, 340($sp)
  li $t0,2
  sw $t0, 344($sp)
  li $t0,2
  sw $t0, 348($sp)
  li $t0,1
  sw $t0, 352($sp)
  addiu $t1,$sp,-16
  addiu $t0,$sp,12
  sw $t0, 0($t1)
  lw $t0, 344($sp)
  sw $t0, 4($t1)
  lw $t0, 348($sp)
  sw $t0, 8($t1)
  lw $t0, 352($sp)
  sw $t0, 12($t1)
  move $sp,$t1
  jal set
  addiu $sp,$sp,16
  sw $v0, 356($sp)
  addiu $t1,$sp,-12
  addiu $t0,$sp,8
  sw $t0, 0($t1)
  addiu $t0,$sp,12
  sw $t0, 4($t1)
  addiu $t0,$sp,16
  sw $t0, 8($t1)
  move $sp,$t1
  jal matmul
  addiu $sp,$sp,12
  sw $v0, 360($sp)
  li $t0,0
  sw $t0, 396($sp)
  li $t0,0
  sw $t0, 400($sp)
  addiu $t1,$sp,-12
  addiu $t0,$sp,16
  sw $t0, 0($t1)
  lw $t0, 396($sp)
  sw $t0, 4($t1)
  lw $t0, 400($sp)
  sw $t0, 8($t1)
  move $sp,$t1
  jal get
  addiu $sp,$sp,12
  sw $v0, 404($sp)
  li $t0,0
  sw $t0, 408($sp)
  li $t0,4
  sw $t0, 412($sp)
  lw $t1, 408($sp)
  lw $t2, 412($sp)
  sub $t0,$t1,$t2
  sw $t0, 416($sp)
  lw $t1, 404($sp)
  lw $t2, 416($sp)
  seq $t0,$t1,$t2
  sw $t0, 420($sp)
  lw $t0, 420($sp)
  beqz $t0,_L11
_L10:
  li $t0,0
  sw $t0, 424($sp)
  li $t0,1
  sw $t0, 428($sp)
  addiu $t1,$sp,-12
  addiu $t0,$sp,16
  sw $t0, 0($t1)
  lw $t0, 424($sp)
  sw $t0, 4($t1)
  lw $t0, 428($sp)
  sw $t0, 8($t1)
  move $sp,$t1
  jal get
  addiu $sp,$sp,12
  sw $v0, 432($sp)
  li $t0,0
  sw $t0, 436($sp)
  li $t0,4
  sw $t0, 440($sp)
  lw $t1, 436($sp)
  lw $t2, 440($sp)
  sub $t0,$t1,$t2
  sw $t0, 444($sp)
  lw $t1, 432($sp)
  lw $t2, 444($sp)
  seq $t0,$t1,$t2
  sw $t0, 448($sp)
  lw $t0, 448($sp)
  beqz $t0,_L14
_L13:
  li $t0,1
  sw $t0, 392($sp)
  j _L15
_L14:
  li $t0,0
  sw $t0, 392($sp)
_L15:
  j _L12
_L11:
  li $t0,0
  sw $t0, 392($sp)
_L12:
  lw $t0, 392($sp)
  beqz $t0,_L17
_L16:
  li $t0,0
  sw $t0, 452($sp)
  li $t0,2
  sw $t0, 456($sp)
  addiu $t1,$sp,-12
  addiu $t0,$sp,16
  sw $t0, 0($t1)
  lw $t0, 452($sp)
  sw $t0, 4($t1)
  lw $t0, 456($sp)
  sw $t0, 8($t1)
  move $sp,$t1
  jal get
  addiu $sp,$sp,12
  sw $v0, 460($sp)
  li $t0,12
  sw $t0, 464($sp)
  lw $t1, 460($sp)
  lw $t2, 464($sp)
  seq $t0,$t1,$t2
  sw $t0, 468($sp)
  lw $t0, 468($sp)
  beqz $t0,_L20
_L19:
  li $t0,1
  sw $t0, 388($sp)
  j _L21
_L20:
  li $t0,0
  sw $t0, 388($sp)
_L21:
  j _L18
_L17:
  li $t0,0
  sw $t0, 388($sp)
_L18:
  lw $t0, 388($sp)
  beqz $t0,_L23
_L22:
  li $t0,1
  sw $t0, 472($sp)
  li $t0,0
  sw $t0, 476($sp)
  addiu $t1,$sp,-12
  addiu $t0,$sp,16
  sw $t0, 0($t1)
  lw $t0, 472($sp)
  sw $t0, 4($t1)
  lw $t0, 476($sp)
  sw $t0, 8($t1)
  move $sp,$t1
  jal get
  addiu $sp,$sp,12
  sw $v0, 480($sp)
  li $t0,0
  sw $t0, 484($sp)
  li $t0,15
  sw $t0, 488($sp)
  lw $t1, 484($sp)
  lw $t2, 488($sp)
  sub $t0,$t1,$t2
  sw $t0, 492($sp)
  lw $t1, 480($sp)
  lw $t2, 492($sp)
  seq $t0,$t1,$t2
  sw $t0, 496($sp)
  lw $t0, 496($sp)
  beqz $t0,_L26
_L25:
  li $t0,1
  sw $t0, 384($sp)
  j _L27
_L26:
  li $t0,0
  sw $t0, 384($sp)
_L27:
  j _L24
_L23:
  li $t0,0
  sw $t0, 384($sp)
_L24:
  lw $t0, 384($sp)
  beqz $t0,_L29
_L28:
  li $t0,1
  sw $t0, 500($sp)
  li $t0,1
  sw $t0, 504($sp)
  addiu $t1,$sp,-12
  addiu $t0,$sp,16
  sw $t0, 0($t1)
  lw $t0, 500($sp)
  sw $t0, 4($t1)
  lw $t0, 504($sp)
  sw $t0, 8($t1)
  move $sp,$t1
  jal get
  addiu $sp,$sp,12
  sw $v0, 508($sp)
  li $t0,0
  sw $t0, 512($sp)
  li $t0,18
  sw $t0, 516($sp)
  lw $t1, 512($sp)
  lw $t2, 516($sp)
  sub $t0,$t1,$t2
  sw $t0, 520($sp)
  lw $t1, 508($sp)
  lw $t2, 520($sp)
  seq $t0,$t1,$t2
  sw $t0, 524($sp)
  lw $t0, 524($sp)
  beqz $t0,_L32
_L31:
  li $t0,1
  sw $t0, 380($sp)
  j _L33
_L32:
  li $t0,0
  sw $t0, 380($sp)
_L33:
  j _L30
_L29:
  li $t0,0
  sw $t0, 380($sp)
_L30:
  lw $t0, 380($sp)
  beqz $t0,_L35
_L34:
  li $t0,1
  sw $t0, 528($sp)
  li $t0,2
  sw $t0, 532($sp)
  addiu $t1,$sp,-12
  addiu $t0,$sp,16
  sw $t0, 0($t1)
  lw $t0, 528($sp)
  sw $t0, 4($t1)
  lw $t0, 532($sp)
  sw $t0, 8($t1)
  move $sp,$t1
  jal get
  addiu $sp,$sp,12
  sw $v0, 536($sp)
  li $t0,9
  sw $t0, 540($sp)
  lw $t1, 536($sp)
  lw $t2, 540($sp)
  seq $t0,$t1,$t2
  sw $t0, 544($sp)
  lw $t0, 544($sp)
  beqz $t0,_L38
_L37:
  li $t0,1
  sw $t0, 376($sp)
  j _L39
_L38:
  li $t0,0
  sw $t0, 376($sp)
_L39:
  j _L36
_L35:
  li $t0,0
  sw $t0, 376($sp)
_L36:
  lw $t0, 376($sp)
  beqz $t0,_L41
_L40:
  li $t0,2
  sw $t0, 548($sp)
  li $t0,0
  sw $t0, 552($sp)
  addiu $t1,$sp,-12
  addiu $t0,$sp,16
  sw $t0, 0($t1)
  lw $t0, 548($sp)
  sw $t0, 4($t1)
  lw $t0, 552($sp)
  sw $t0, 8($t1)
  move $sp,$t1
  jal get
  addiu $sp,$sp,12
  sw $v0, 556($sp)
  li $t0,0
  sw $t0, 560($sp)
  li $t0,8
  sw $t0, 564($sp)
  lw $t1, 560($sp)
  lw $t2, 564($sp)
  sub $t0,$t1,$t2
  sw $t0, 568($sp)
  lw $t1, 556($sp)
  lw $t2, 568($sp)
  seq $t0,$t1,$t2
  sw $t0, 572($sp)
  lw $t0, 572($sp)
  beqz $t0,_L44
_L43:
  li $t0,1
  sw $t0, 372($sp)
  j _L45
_L44:
  li $t0,0
  sw $t0, 372($sp)
_L45:
  j _L42
_L41:
  li $t0,0
  sw $t0, 372($sp)
_L42:
  lw $t0, 372($sp)
  beqz $t0,_L47
_L46:
  li $t0,2
  sw $t0, 576($sp)
  li $t0,1
  sw $t0, 580($sp)
  addiu $t1,$sp,-12
  addiu $t0,$sp,16
  sw $t0, 0($t1)
  lw $t0, 576($sp)
  sw $t0, 4($t1)
  lw $t0, 580($sp)
  sw $t0, 8($t1)
  move $sp,$t1
  jal get
  addiu $sp,$sp,12
  sw $v0, 584($sp)
  li $t0,0
  sw $t0, 588($sp)
  li $t0,15
  sw $t0, 592($sp)
  lw $t1, 588($sp)
  lw $t2, 592($sp)
  sub $t0,$t1,$t2
  sw $t0, 596($sp)
  lw $t1, 584($sp)
  lw $t2, 596($sp)
  seq $t0,$t1,$t2
  sw $t0, 600($sp)
  lw $t0, 600($sp)
  beqz $t0,_L50
_L49:
  li $t0,1
  sw $t0, 368($sp)
  j _L51
_L50:
  li $t0,0
  sw $t0, 368($sp)
_L51:
  j _L48
_L47:
  li $t0,0
  sw $t0, 368($sp)
_L48:
  lw $t0, 368($sp)
  beqz $t0,_L53
_L52:
  li $t0,2
  sw $t0, 604($sp)
  li $t0,2
  sw $t0, 608($sp)
  addiu $t1,$sp,-12
  addiu $t0,$sp,16
  sw $t0, 0($t1)
  lw $t0, 604($sp)
  sw $t0, 4($t1)
  lw $t0, 608($sp)
  sw $t0, 8($t1)
  move $sp,$t1
  jal get
  addiu $sp,$sp,12
  sw $v0, 612($sp)
  li $t0,0
  sw $t0, 616($sp)
  li $t0,5
  sw $t0, 620($sp)
  lw $t1, 616($sp)
  lw $t2, 620($sp)
  sub $t0,$t1,$t2
  sw $t0, 624($sp)
  lw $t1, 612($sp)
  lw $t2, 624($sp)
  seq $t0,$t1,$t2
  sw $t0, 628($sp)
  lw $t0, 628($sp)
  beqz $t0,_L56
_L55:
  li $t0,1
  sw $t0, 364($sp)
  j _L57
_L56:
  li $t0,0
  sw $t0, 364($sp)
_L57:
  j _L54
_L53:
  li $t0,0
  sw $t0, 364($sp)
_L54:
  lw $a0, 364($sp)
  li $v0,1
  syscall
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,632
  jr $ra

