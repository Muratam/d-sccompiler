  .text
  .globl main
init_v:
  addiu $sp,$sp,-52
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,52
  li $t0,0
  sw $t0, 12($sp)
  lw $t0, 12($sp)
  sw $t0, 8($sp)
_L1:
  li $t0,10
  sw $t0, 16($sp)
  lw $t1, 8($sp)
  lw $t2, 16($sp)
  slt $t0,$t1,$t2
  sw $t0, 20($sp)
  lw $t0, 20($sp)
  beqz $t0,_L3
_L2:
  li $t0,1
  sw $t0, 24($sp)
  lw $t1, 8($sp)
  lw $t2, 24($sp)
  add $t0,$t1,$t2
  sw $t0, 28($sp)
  li $t0,4
  sw $t0, 32($sp)
  lw $t1, 32($sp)
  lw $t2, 8($sp)
  mul $t0,$t1,$t2
  sw $t0, 36($sp)
  lw $t1, 0($fp)
  lw $t2, 36($sp)
  add $t0,$t1,$t2
  sw $t0, 40($sp)
  lw $t0, 28($sp)
  lw $t1, 40($sp)
  sw $t0, 0($t1)
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
  lw $v0, 8($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,52
  jr $ra
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,52
  jr $ra
main:
  addiu $sp,$sp,-420
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,420
  addiu $t1,$sp,-4
  addiu $t0,$sp,32
  sw $t0, 0($t1)
  move $sp,$t1
  jal init_v
  addiu $sp,$sp,4
  sw $v0, 44($sp)
  lw $t0, 44($sp)
  sw $t0, 16($sp)
  li $t0,0
  sw $t0, 48($sp)
  lw $t0, 48($sp)
  sw $t0, 8($sp)
_L4:
  lw $t1, 8($sp)
  lw $t2, 16($sp)
  slt $t0,$t1,$t2
  sw $t0, 52($sp)
  lw $t0, 52($sp)
  beqz $t0,_L6
_L5:
  li $t0,4
  sw $t0, 56($sp)
  lw $t1, 56($sp)
  lw $t2, 8($sp)
  mul $t0,$t1,$t2
  sw $t0, 60($sp)
  addiu $t1,$sp,32
  lw $t2, 60($sp)
  add $t0,$t1,$t2
  sw $t0, 64($sp)
  li $t0,4
  sw $t0, 68($sp)
  lw $t1, 68($sp)
  lw $t2, 8($sp)
  mul $t0,$t1,$t2
  sw $t0, 72($sp)
  addiu $t1,$sp,36
  lw $t2, 72($sp)
  add $t0,$t1,$t2
  sw $t0, 76($sp)
  lw $t0, 64($sp)
  lw $t1, 76($sp)
  sw $t0, 0($t1)
  li $t0,1
  sw $t0, 80($sp)
  lw $t1, 8($sp)
  lw $t2, 80($sp)
  add $t0,$t1,$t2
  sw $t0, 84($sp)
  lw $t0, 84($sp)
  sw $t0, 8($sp)
  j _L4
_L6:
  addiu $t0,$sp,20
  sw $t0, 88($sp)
  li $t0,4
  sw $t0, 92($sp)
  lw $t1, 92($sp)
  lw $t2, 8($sp)
  mul $t0,$t1,$t2
  sw $t0, 96($sp)
  addiu $t1,$sp,36
  lw $t2, 96($sp)
  add $t0,$t1,$t2
  sw $t0, 100($sp)
  lw $t0, 88($sp)
  lw $t1, 100($sp)
  sw $t0, 0($t1)
  li $t0,0
  sw $t0, 104($sp)
  lw $t0, 104($sp)
  sw $t0, 8($sp)
  li $t0,0
  sw $t0, 108($sp)
  lw $t0, 108($sp)
  sw $t0, 24($sp)
_L7:
  li $t0,4
  sw $t0, 112($sp)
  lw $t1, 112($sp)
  lw $t2, 8($sp)
  mul $t0,$t1,$t2
  sw $t0, 116($sp)
  addiu $t1,$sp,36
  lw $t2, 116($sp)
  add $t0,$t1,$t2
  sw $t0, 120($sp)
  lw $t0, 120($sp)
  lw $t0, 0($t0)
  sw $t0, 124($sp)
  addiu $t0,$sp,20
  sw $t0, 128($sp)
  lw $t1, 124($sp)
  lw $t2, 128($sp)
  sne $t0,$t1,$t2
  sw $t0, 132($sp)
  lw $t0, 132($sp)
  beqz $t0,_L9
_L8:
  li $t0,4
  sw $t0, 136($sp)
  lw $t1, 136($sp)
  lw $t2, 8($sp)
  mul $t0,$t1,$t2
  sw $t0, 140($sp)
  addiu $t1,$sp,36
  lw $t2, 140($sp)
  add $t0,$t1,$t2
  sw $t0, 144($sp)
  lw $t0, 144($sp)
  lw $t0, 0($t0)
  sw $t0, 148($sp)
  lw $t0, 148($sp)
  lw $t0, 0($t0)
  sw $t0, 152($sp)
  lw $t1, 24($sp)
  lw $t2, 152($sp)
  add $t0,$t1,$t2
  sw $t0, 156($sp)
  lw $t0, 156($sp)
  sw $t0, 24($sp)
  li $t0,1
  sw $t0, 160($sp)
  lw $t1, 8($sp)
  lw $t2, 160($sp)
  add $t0,$t1,$t2
  sw $t0, 164($sp)
  lw $t0, 164($sp)
  sw $t0, 8($sp)
  j _L7
_L9:
  li $t0,0
  sw $t0, 168($sp)
  lw $t0, 168($sp)
  sw $t0, 8($sp)
  li $t0,0
  sw $t0, 172($sp)
  lw $t0, 172($sp)
  sw $t0, 12($sp)
_L10:
  lw $t1, 8($sp)
  lw $t2, 16($sp)
  slt $t0,$t1,$t2
  sw $t0, 176($sp)
  lw $t0, 176($sp)
  beqz $t0,_L12
_L11:
  li $t0,4
  sw $t0, 180($sp)
  lw $t1, 180($sp)
  lw $t2, 8($sp)
  mul $t0,$t1,$t2
  sw $t0, 184($sp)
  addiu $t1,$sp,36
  lw $t2, 184($sp)
  add $t0,$t1,$t2
  sw $t0, 188($sp)
  lw $t0, 188($sp)
  lw $t0, 0($t0)
  sw $t0, 192($sp)
  li $t0,4
  sw $t0, 196($sp)
  lw $t1, 196($sp)
  lw $t2, 12($sp)
  mul $t0,$t1,$t2
  sw $t0, 200($sp)
  addiu $t1,$sp,40
  lw $t2, 200($sp)
  add $t0,$t1,$t2
  sw $t0, 204($sp)
  lw $t0, 192($sp)
  lw $t1, 204($sp)
  sw $t0, 0($t1)
  li $t0,2
  sw $t0, 208($sp)
  lw $t1, 8($sp)
  lw $t2, 208($sp)
  add $t0,$t1,$t2
  sw $t0, 212($sp)
  lw $t0, 212($sp)
  sw $t0, 8($sp)
  li $t0,1
  sw $t0, 216($sp)
  lw $t1, 12($sp)
  lw $t2, 216($sp)
  add $t0,$t1,$t2
  sw $t0, 220($sp)
  lw $t0, 220($sp)
  sw $t0, 12($sp)
  j _L10
_L12:
  addiu $t0,$sp,20
  sw $t0, 224($sp)
  li $t0,4
  sw $t0, 228($sp)
  lw $t1, 228($sp)
  lw $t2, 12($sp)
  mul $t0,$t1,$t2
  sw $t0, 232($sp)
  addiu $t1,$sp,40
  lw $t2, 232($sp)
  add $t0,$t1,$t2
  sw $t0, 236($sp)
  lw $t0, 224($sp)
  lw $t1, 236($sp)
  sw $t0, 0($t1)
  li $t0,0
  sw $t0, 240($sp)
  lw $t0, 240($sp)
  sw $t0, 12($sp)
_L13:
  li $t0,4
  sw $t0, 244($sp)
  lw $t1, 244($sp)
  lw $t2, 12($sp)
  mul $t0,$t1,$t2
  sw $t0, 248($sp)
  addiu $t1,$sp,40
  lw $t2, 248($sp)
  add $t0,$t1,$t2
  sw $t0, 252($sp)
  lw $t0, 252($sp)
  lw $t0, 0($t0)
  sw $t0, 256($sp)
  addiu $t0,$sp,20
  sw $t0, 260($sp)
  lw $t1, 256($sp)
  lw $t2, 260($sp)
  sne $t0,$t1,$t2
  sw $t0, 264($sp)
  lw $t0, 264($sp)
  beqz $t0,_L15
_L14:
  li $t0,4
  sw $t0, 268($sp)
  lw $t1, 268($sp)
  lw $t2, 12($sp)
  mul $t0,$t1,$t2
  sw $t0, 272($sp)
  addiu $t1,$sp,40
  lw $t2, 272($sp)
  add $t0,$t1,$t2
  sw $t0, 276($sp)
  lw $t0, 276($sp)
  lw $t0, 0($t0)
  sw $t0, 280($sp)
  lw $t0, 280($sp)
  lw $t0, 0($t0)
  sw $t0, 284($sp)
  li $t0,4
  sw $t0, 288($sp)
  lw $t1, 288($sp)
  lw $t2, 12($sp)
  mul $t0,$t1,$t2
  sw $t0, 292($sp)
  addiu $t1,$sp,40
  lw $t2, 292($sp)
  add $t0,$t1,$t2
  sw $t0, 296($sp)
  lw $t0, 296($sp)
  lw $t0, 0($t0)
  sw $t0, 300($sp)
  lw $t0, 300($sp)
  lw $t0, 0($t0)
  sw $t0, 304($sp)
  lw $t1, 284($sp)
  lw $t2, 304($sp)
  mul $t0,$t1,$t2
  sw $t0, 308($sp)
  li $t0,4
  sw $t0, 312($sp)
  lw $t1, 312($sp)
  lw $t2, 12($sp)
  mul $t0,$t1,$t2
  sw $t0, 316($sp)
  addiu $t1,$sp,40
  lw $t2, 316($sp)
  add $t0,$t1,$t2
  sw $t0, 320($sp)
  lw $t0, 320($sp)
  lw $t0, 0($t0)
  sw $t0, 324($sp)
  lw $t0, 308($sp)
  lw $t1, 324($sp)
  sw $t0, 0($t1)
  li $t0,1
  sw $t0, 328($sp)
  lw $t1, 12($sp)
  lw $t2, 328($sp)
  add $t0,$t1,$t2
  sw $t0, 332($sp)
  lw $t0, 332($sp)
  sw $t0, 12($sp)
  j _L13
_L15:
  li $t0,0
  sw $t0, 336($sp)
  lw $t0, 336($sp)
  sw $t0, 8($sp)
  li $t0,0
  sw $t0, 340($sp)
  lw $t0, 340($sp)
  sw $t0, 28($sp)
_L16:
  li $t0,4
  sw $t0, 344($sp)
  lw $t1, 344($sp)
  lw $t2, 8($sp)
  mul $t0,$t1,$t2
  sw $t0, 348($sp)
  addiu $t1,$sp,36
  lw $t2, 348($sp)
  add $t0,$t1,$t2
  sw $t0, 352($sp)
  lw $t0, 352($sp)
  lw $t0, 0($t0)
  sw $t0, 356($sp)
  addiu $t0,$sp,20
  sw $t0, 360($sp)
  lw $t1, 356($sp)
  lw $t2, 360($sp)
  sne $t0,$t1,$t2
  sw $t0, 364($sp)
  lw $t0, 364($sp)
  beqz $t0,_L18
_L17:
  li $t0,4
  sw $t0, 368($sp)
  lw $t1, 368($sp)
  lw $t2, 8($sp)
  mul $t0,$t1,$t2
  sw $t0, 372($sp)
  addiu $t1,$sp,36
  lw $t2, 372($sp)
  add $t0,$t1,$t2
  sw $t0, 376($sp)
  lw $t0, 376($sp)
  lw $t0, 0($t0)
  sw $t0, 380($sp)
  lw $t0, 380($sp)
  lw $t0, 0($t0)
  sw $t0, 384($sp)
  lw $t1, 28($sp)
  lw $t2, 384($sp)
  add $t0,$t1,$t2
  sw $t0, 388($sp)
  lw $t0, 388($sp)
  sw $t0, 28($sp)
  li $t0,1
  sw $t0, 392($sp)
  lw $t1, 8($sp)
  lw $t2, 392($sp)
  add $t0,$t1,$t2
  sw $t0, 396($sp)
  lw $t0, 396($sp)
  sw $t0, 8($sp)
  j _L16
_L18:
  li $t0,55
  sw $t0, 404($sp)
  lw $t1, 24($sp)
  lw $t2, 404($sp)
  seq $t0,$t1,$t2
  sw $t0, 408($sp)
  lw $t0, 408($sp)
  beqz $t0,_L20
_L19:
  li $t0,195
  sw $t0, 412($sp)
  lw $t1, 28($sp)
  lw $t2, 412($sp)
  seq $t0,$t1,$t2
  sw $t0, 416($sp)
  lw $t0, 416($sp)
  beqz $t0,_L23
_L22:
  li $t0,1
  sw $t0, 400($sp)
  j _L24
_L23:
  li $t0,0
  sw $t0, 400($sp)
_L24:
  j _L21
_L20:
  li $t0,0
  sw $t0, 400($sp)
_L21:
  lw $a0, 400($sp)
  li $v0,1
  syscall
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,420
  jr $ra

