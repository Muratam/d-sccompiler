  .text
  .globl main
is_odd:
  addiu $sp,$sp,-24
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,24
  lw $t1, 0($fp)
  li $t2,0
  seq $t0,$t1,$t2
  sw $t0, 8($sp)
  lw $t0, 8($sp)
  beqz $t0,_L8
_L7:
  li $v0,0
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,24
  jr $ra
_L8:
_L9:
  lw $t1, 0($fp)
  li $t2,1
  seq $t0,$t1,$t2
  sw $t0, 12($sp)
  lw $t0, 12($sp)
  beqz $t0,_L11
_L10:
  li $v0,1
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,24
  jr $ra
_L11:
_L12:
  lw $t1, 0($fp)
  li $t2,1
  sub $t0,$t1,$t2
  sw $t0, 16($sp)
  addiu $t1,$sp,-4
  lw $t0, 16($sp)
  sw $t0, 0($t1)
  move $sp,$t1
  jal is_even
  addiu $sp,$sp,4
  sw $v0, 20($sp)
  lw $v0, 20($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,24
  jr $ra
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,24
  jr $ra
is_even:
  addiu $sp,$sp,-24
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,24
  lw $t1, 0($fp)
  li $t2,0
  seq $t0,$t1,$t2
  sw $t0, 8($sp)
  lw $t0, 8($sp)
  beqz $t0,_L2
_L1:
  li $v0,1
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,24
  jr $ra
_L2:
_L3:
  lw $t1, 0($fp)
  li $t2,1
  seq $t0,$t1,$t2
  sw $t0, 12($sp)
  lw $t0, 12($sp)
  beqz $t0,_L5
_L4:
  li $v0,0
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,24
  jr $ra
_L5:
_L6:
  lw $t1, 0($fp)
  li $t2,1
  sub $t0,$t1,$t2
  sw $t0, 16($sp)
  addiu $t1,$sp,-4
  lw $t0, 16($sp)
  sw $t0, 0($t1)
  move $sp,$t1
  jal is_odd
  addiu $sp,$sp,4
  sw $v0, 20($sp)
  lw $v0, 20($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,24
  jr $ra
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,24
  jr $ra
all_even:
  addiu $sp,$sp,-52
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,52
  lw $t0, 0($fp)
  lw $t0, 0($t0)
  sw $t0, 8($sp)
  li $t0,0
  sw $t0, 12($sp)
  lw $t1, 8($sp)
  li $t2,0
  slt $t0,$t1,$t2
  sw $t0, 16($sp)
  lw $t0, 16($sp)
  beqz $t0,_L14
_L13:
  li $v0,1
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,52
  jr $ra
_L14:
  lw $t0, 0($fp)
  lw $t0, 0($t0)
  sw $t0, 24($sp)
  addiu $t1,$sp,-4
  lw $t0, 24($sp)
  sw $t0, 0($t1)
  move $sp,$t1
  jal is_even
  addiu $sp,$sp,4
  sw $v0, 28($sp)
  lw $t0, 28($sp)
  beqz $t0,_L17
_L16:
  li $t0,1
  sw $t0, 32($sp)
  li $t0,4
  sw $t0, 36($sp)
  li $t1,4
  li $t2,1
  mul $t0,$t1,$t2
  sw $t0, 40($sp)
  lw $t1, 0($fp)
  li $t2,4
  add $t0,$t1,$t2
  sw $t0, 44($sp)
  addiu $t1,$sp,-4
  lw $t0, 44($sp)
  sw $t0, 0($t1)
  move $sp,$t1
  jal all_even
  addiu $sp,$sp,4
  sw $v0, 48($sp)
  lw $t0, 48($sp)
  beqz $t0,_L20
_L19:
  li $t0,1
  sw $t0, 20($sp)
  j _L21
_L20:
  li $t0,0
  sw $t0, 20($sp)
_L21:
  j _L18
_L17:
  li $t0,0
  sw $t0, 20($sp)
_L18:
  lw $v0, 20($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,52
  jr $ra
_L15:
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,52
  jr $ra
find_odd:
  addiu $sp,$sp,-32
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,32
_L22:
  j _L23
_L23:
  lw $t0, 0($fp)
  lw $t0, 0($t0)
  sw $t0, 8($sp)
  lw $t1, 8($sp)
  li $t2,0
  slt $t0,$t1,$t2
  sw $t0, 12($sp)
  lw $t0, 12($sp)
  beqz $t0,_L26
_L25:
  addiu $t0,$gp,0
  sw $t0, 16($sp)
  lw $v0, 16($sp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,32
  jr $ra
_L26:
_L27:
  lw $t0, 0($fp)
  lw $t0, 0($t0)
  sw $t0, 20($sp)
  addiu $t1,$sp,-4
  lw $t0, 20($sp)
  sw $t0, 0($t1)
  move $sp,$t1
  jal is_odd
  addiu $sp,$sp,4
  sw $v0, 24($sp)
  lw $t0, 24($sp)
  beqz $t0,_L29
_L28:
  lw $v0, 0($fp)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,32
  jr $ra
_L29:
_L30:
  lw $t1, 0($fp)
  li $t2,4
  add $t0,$t1,$t2
  sw $t0, 28($sp)
  lw $t0, 28($sp)
  sw $t0, 0($fp)
  j _L22
_L24:
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,32
  jr $ra
odd_to_even:
  addiu $sp,$sp,-44
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,44
  li $t0,1
  sw $t0, 12($sp)
_L31:
  addiu $t1,$sp,-4
  lw $t0, 0($fp)
  sw $t0, 0($t1)
  move $sp,$t1
  jal find_odd
  addiu $sp,$sp,4
  sw $v0, 16($sp)
  lw $t0, 16($sp)
  sw $t0, 8($sp)
  addiu $t0,$gp,0
  sw $t0, 20($sp)
  lw $t1, 8($sp)
  lw $t2, 20($sp)
  sne $t0,$t1,$t2
  sw $t0, 24($sp)
  lw $t0, 24($sp)
  beqz $t0,_L33
_L32:
  lw $t0, 8($sp)
  lw $t0, 0($t0)
  sw $t0, 28($sp)
  li $t0,1
  sw $t0, 32($sp)
  lw $t1, 28($sp)
  li $t2,1
  add $t0,$t1,$t2
  sw $t0, 36($sp)
  lw $t0, 36($sp)
  lw $t1, 8($sp)
  sw $t0, 0($t1)
  li $t0,1
  sw $t0, 40($sp)
  j _L31
_L33:
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,44
  jr $ra
init:
  addiu $sp,$sp,-60
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,60
  li $t0,1
  sw $t0, 12($sp)
  li $t0,1
  sw $t0, 8($sp)
_L34:
  li $t0,10
  sw $t0, 16($sp)
  lw $t1, 8($sp)
  li $t2,10
  sle $t0,$t1,$t2
  sw $t0, 20($sp)
  lw $t0, 20($sp)
  beqz $t0,_L36
_L35:
  lw $t0, 8($sp)
  lw $t1, 0($fp)
  sw $t0, 0($t1)
  li $t0,1
  sw $t0, 24($sp)
  lw $t1, 8($sp)
  li $t2,1
  add $t0,$t1,$t2
  sw $t0, 28($sp)
  lw $t0, 28($sp)
  sw $t0, 8($sp)
  li $t0,1
  sw $t0, 32($sp)
  li $t0,4
  sw $t0, 36($sp)
  li $t1,4
  li $t2,1
  mul $t0,$t1,$t2
  sw $t0, 40($sp)
  lw $t1, 0($fp)
  li $t2,4
  add $t0,$t1,$t2
  sw $t0, 44($sp)
  lw $t0, 44($sp)
  sw $t0, 0($fp)
  j _L34
_L36:
  li $t0,0
  sw $t0, 48($sp)
  li $t0,1
  sw $t0, 52($sp)
  li $t1,0
  li $t2,1
  sub $t0,$t1,$t2
  sw $t0, 56($sp)
  li $t0,-1
  lw $t1, 0($fp)
  sw $t0, 0($t1)
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,60
  jr $ra
main:
  addiu $sp,$sp,-44
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,44
  addiu $t1,$sp,-4
  addiu $t0,$sp,8
  sw $t0, 0($t1)
  move $sp,$t1
  jal init
  addiu $sp,$sp,4
  sw $v0, 16($sp)
  addiu $t1,$sp,-4
  addiu $t0,$sp,8
  sw $t0, 0($t1)
  move $sp,$t1
  jal all_even
  addiu $sp,$sp,4
  sw $v0, 20($sp)
  lw $t0, 20($sp)
  sw $t0, 12($sp)
  addiu $t1,$sp,-4
  addiu $t0,$sp,8
  sw $t0, 0($t1)
  move $sp,$t1
  jal odd_to_even
  addiu $sp,$sp,4
  sw $v0, 24($sp)
  li $t0,0
  sw $t0, 32($sp)
  lw $t1, 12($sp)
  li $t2,0
  seq $t0,$t1,$t2
  sw $t0, 36($sp)
  lw $t0, 36($sp)
  beqz $t0,_L38
_L37:
  addiu $t1,$sp,-4
  addiu $t0,$sp,8
  sw $t0, 0($t1)
  move $sp,$t1
  jal all_even
  addiu $sp,$sp,4
  sw $v0, 40($sp)
  lw $t0, 40($sp)
  beqz $t0,_L41
_L40:
  li $t0,1
  sw $t0, 28($sp)
  j _L42
_L41:
  li $t0,0
  sw $t0, 28($sp)
_L42:
  j _L39
_L38:
  li $t0,0
  sw $t0, 28($sp)
_L39:
  lw $a0, 28($sp)
  li $v0,1
  syscall
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,44
  jr $ra

