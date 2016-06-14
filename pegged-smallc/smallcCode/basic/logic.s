  .text
  .globl main
logi1:
  addiu $sp,$sp,-36
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,36
  lw $t1, 4($fp)
  li $t2,1
  add $t0,$t1,$t2
  sw $t0, 16($sp)
  lw $t1, 0($fp)
  lw $t2, 16($sp)
  slt $t0,$t1,$t2
  sw $t0, 20($sp)
  lw $t0, 20($sp)
  beqz $t0,_L2
_L1:
  lw $t1, 4($fp)
  li $t2,1
  add $t0,$t1,$t2
  sw $t0, 24($sp)
  lw $t1, 24($sp)
  lw $t2, 8($fp)
  slt $t0,$t1,$t2
  sw $t0, 28($sp)
  lw $t0, 28($sp)
  beqz $t0,_L5
_L4:
  li $t0,1
  sw $t0, 12($sp)
  j _L6
_L5:
  li $t0,0
  sw $t0, 12($sp)
_L6:
  j _L3
_L2:
  li $t0,0
  sw $t0, 12($sp)
_L3:
  lw $t0, 12($sp)
  beqz $t0,_L8
_L7:
  li $t0,1
  sw $t0, 8($sp)
  j _L9
_L8:
  lw $t1, 4($fp)
  li $t2,0
  seq $t0,$t1,$t2
  sw $t0, 32($sp)
  lw $t0, 32($sp)
  beqz $t0,_L11
_L10:
  li $t0,1
  sw $t0, 8($sp)
  j _L12
_L11:
  li $t0,0
  sw $t0, 8($sp)
_L12:
_L9:
  lw $t0, 8($sp)
  beqz $t0,_L14
_L13:
  li $v0,1
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,36
  jr $ra
_L14:
  li $v0,0
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,36
  jr $ra
_L15:
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,36
  jr $ra
logi2:
  addiu $sp,$sp,-24
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,24
  lw $t1, 0($fp)
  lw $t2, 4($fp)
  slt $t0,$t1,$t2
  sw $t0, 16($sp)
  lw $t0, 16($sp)
  beqz $t0,_L17
_L16:
  lw $t1, 4($fp)
  lw $t2, 8($fp)
  slt $t0,$t1,$t2
  sw $t0, 20($sp)
  lw $t0, 20($sp)
  beqz $t0,_L20
_L19:
  li $t0,1
  sw $t0, 12($sp)
  j _L21
_L20:
  li $t0,0
  sw $t0, 12($sp)
_L21:
  j _L18
_L17:
  li $t0,0
  sw $t0, 12($sp)
_L18:
  lw $t0, 12($sp)
  beqz $t0,_L23
_L22:
  li $t0,1
  sw $t0, 8($sp)
  j _L24
_L23:
  lw $t0, 12($fp)
  beqz $t0,_L26
_L25:
  li $t0,1
  sw $t0, 8($sp)
  j _L27
_L26:
  li $t0,0
  sw $t0, 8($sp)
_L27:
_L24:
  lw $t0, 8($sp)
  beqz $t0,_L29
_L28:
  li $v0,1
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,24
  jr $ra
_L29:
  li $v0,0
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,24
  jr $ra
_L30:
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,24
  jr $ra
logi3:
  addiu $sp,$sp,-40
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,40
  lw $t1, 4($fp)
  li $t2,3
  seq $t0,$t1,$t2
  sw $t0, 12($sp)
  lw $t0, 12($sp)
  beqz $t0,_L32
_L31:
  lw $t1, 4($fp)
  lw $t2, 0($fp)
  sub $t0,$t1,$t2
  sw $t0, 16($sp)
  lw $t0, 16($sp)
  beqz $t0,_L35
_L34:
  li $t0,1
  sw $t0, 8($sp)
  j _L36
_L35:
  li $t0,0
  sw $t0, 8($sp)
_L36:
  j _L33
_L32:
  li $t0,0
  sw $t0, 8($sp)
_L33:
  lw $t0, 8($sp)
  beqz $t0,_L38
_L37:
  lw $t1, 0($fp)
  li $t2,0
  seq $t0,$t1,$t2
  sw $t0, 24($sp)
  lw $t0, 24($sp)
  beqz $t0,_L41
_L40:
  li $t0,1
  sw $t0, 20($sp)
  j _L42
_L41:
  lw $t1, 0($fp)
  lw $t2, 4($fp)
  add $t0,$t1,$t2
  sw $t0, 28($sp)
  lw $t1, 0($fp)
  lw $t2, 4($fp)
  mul $t0,$t1,$t2
  sw $t0, 32($sp)
  lw $t1, 28($sp)
  lw $t2, 32($sp)
  slt $t0,$t1,$t2
  sw $t0, 36($sp)
  lw $t0, 36($sp)
  beqz $t0,_L44
_L43:
  li $t0,1
  sw $t0, 20($sp)
  j _L45
_L44:
  li $t0,0
  sw $t0, 20($sp)
_L45:
_L42:
  lw $t0, 20($sp)
  beqz $t0,_L47
_L46:
  li $v0,1
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,40
  jr $ra
_L47:
  li $v0,0
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,40
  jr $ra
_L48:
  j _L39
_L38:
  li $v0,0
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,40
  jr $ra
_L39:
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,40
  jr $ra
main:
  addiu $sp,$sp,-28
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,28
  addiu $t1,$sp,-16
  li $t0,1
  sw $t0, 0($t1)
  li $t0,2
  sw $t0, 4($t1)
  li $t0,4
  sw $t0, 8($t1)
  li $t0,3
  sw $t0, 12($t1)
  move $sp,$t1
  jal logi1
  addiu $sp,$sp,16
  sw $v0, 16($sp)
  lw $t0, 16($sp)
  beqz $t0,_L50
_L49:
  addiu $t1,$sp,-16
  li $t0,1
  sw $t0, 0($t1)
  li $t0,2
  sw $t0, 4($t1)
  li $t0,3
  sw $t0, 8($t1)
  li $t0,0
  sw $t0, 12($t1)
  move $sp,$t1
  jal logi2
  addiu $sp,$sp,16
  sw $v0, 20($sp)
  lw $t0, 20($sp)
  beqz $t0,_L53
_L52:
  li $t0,1
  sw $t0, 12($sp)
  j _L54
_L53:
  li $t0,0
  sw $t0, 12($sp)
_L54:
  j _L51
_L50:
  li $t0,0
  sw $t0, 12($sp)
_L51:
  lw $t0, 12($sp)
  beqz $t0,_L56
_L55:
  addiu $t1,$sp,-8
  li $t0,2
  sw $t0, 0($t1)
  li $t0,3
  sw $t0, 4($t1)
  move $sp,$t1
  jal logi3
  addiu $sp,$sp,8
  sw $v0, 24($sp)
  lw $t0, 24($sp)
  beqz $t0,_L59
_L58:
  li $t0,1
  sw $t0, 8($sp)
  j _L60
_L59:
  li $t0,0
  sw $t0, 8($sp)
_L60:
  j _L57
_L56:
  li $t0,0
  sw $t0, 8($sp)
_L57:
  lw $a0, 8($sp)
  li $v0,1
  syscall
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,28
  jr $ra

