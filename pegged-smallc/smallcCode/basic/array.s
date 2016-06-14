  .text
  .globl main
main:
  addiu $sp,$sp,-332
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,332
  li $t0,1
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
  li $t0,1
  lw $t1, 28($sp)
  sw $t0, 0($t1)
  li $t0,2
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
  li $t0,2
  lw $t1, 48($sp)
  sw $t0, 0($t1)
  li $t0,3
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
  li $t0,3
  lw $t1, 68($sp)
  sw $t0, 0($t1)
  li $t0,4
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
  li $t0,4
  lw $t1, 88($sp)
  sw $t0, 0($t1)
  li $t0,5
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
  li $t0,5
  lw $t1, 108($sp)
  sw $t0, 0($t1)
  li $t0,6
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
  li $t0,6
  lw $t1, 128($sp)
  sw $t0, 0($t1)
  li $t0,7
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
  li $t0,7
  lw $t1, 148($sp)
  sw $t0, 0($t1)
  li $t0,8
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
  li $t0,8
  lw $t1, 168($sp)
  sw $t0, 0($t1)
  li $t0,9
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
  li $t0,9
  lw $t1, 188($sp)
  sw $t0, 0($t1)
  li $t0,10
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
  li $t0,10
  lw $t1, 208($sp)
  sw $t0, 0($t1)
  addiu $t1,$sp,8
  li $t2,0
  add $t0,$t1,$t2
  sw $t0, 212($sp)
  lw $t0, 212($sp)
  lw $t0, 0($t0)
  sw $t0, 216($sp)
  addiu $t1,$sp,8
  li $t2,4
  add $t0,$t1,$t2
  sw $t0, 220($sp)
  lw $t0, 220($sp)
  lw $t0, 0($t0)
  sw $t0, 224($sp)
  lw $t1, 216($sp)
  lw $t2, 224($sp)
  add $t0,$t1,$t2
  sw $t0, 228($sp)
  addiu $t1,$sp,8
  li $t2,8
  add $t0,$t1,$t2
  sw $t0, 232($sp)
  lw $t0, 232($sp)
  lw $t0, 0($t0)
  sw $t0, 236($sp)
  lw $t1, 228($sp)
  lw $t2, 236($sp)
  add $t0,$t1,$t2
  sw $t0, 240($sp)
  addiu $t1,$sp,8
  li $t2,12
  add $t0,$t1,$t2
  sw $t0, 244($sp)
  lw $t0, 244($sp)
  lw $t0, 0($t0)
  sw $t0, 248($sp)
  lw $t1, 240($sp)
  lw $t2, 248($sp)
  add $t0,$t1,$t2
  sw $t0, 252($sp)
  addiu $t1,$sp,8
  li $t2,16
  add $t0,$t1,$t2
  sw $t0, 256($sp)
  lw $t0, 256($sp)
  lw $t0, 0($t0)
  sw $t0, 260($sp)
  lw $t1, 252($sp)
  lw $t2, 260($sp)
  add $t0,$t1,$t2
  sw $t0, 264($sp)
  addiu $t1,$sp,8
  li $t2,20
  add $t0,$t1,$t2
  sw $t0, 268($sp)
  lw $t0, 268($sp)
  lw $t0, 0($t0)
  sw $t0, 272($sp)
  lw $t1, 264($sp)
  lw $t2, 272($sp)
  add $t0,$t1,$t2
  sw $t0, 276($sp)
  addiu $t1,$sp,8
  li $t2,24
  add $t0,$t1,$t2
  sw $t0, 280($sp)
  lw $t0, 280($sp)
  lw $t0, 0($t0)
  sw $t0, 284($sp)
  lw $t1, 276($sp)
  lw $t2, 284($sp)
  add $t0,$t1,$t2
  sw $t0, 288($sp)
  addiu $t1,$sp,8
  li $t2,28
  add $t0,$t1,$t2
  sw $t0, 292($sp)
  lw $t0, 292($sp)
  lw $t0, 0($t0)
  sw $t0, 296($sp)
  lw $t1, 288($sp)
  lw $t2, 296($sp)
  add $t0,$t1,$t2
  sw $t0, 300($sp)
  addiu $t1,$sp,8
  li $t2,32
  add $t0,$t1,$t2
  sw $t0, 304($sp)
  lw $t0, 304($sp)
  lw $t0, 0($t0)
  sw $t0, 308($sp)
  lw $t1, 300($sp)
  lw $t2, 308($sp)
  add $t0,$t1,$t2
  sw $t0, 312($sp)
  addiu $t1,$sp,8
  li $t2,36
  add $t0,$t1,$t2
  sw $t0, 316($sp)
  lw $t0, 316($sp)
  lw $t0, 0($t0)
  sw $t0, 320($sp)
  lw $t1, 312($sp)
  lw $t2, 320($sp)
  add $t0,$t1,$t2
  sw $t0, 324($sp)
  lw $t1, 324($sp)
  li $t2,55
  seq $t0,$t1,$t2
  sw $t0, 328($sp)
  lw $a0, 328($sp)
  li $v0,1
  syscall
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,332
  jr $ra

