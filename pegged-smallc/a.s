#analyze smallcCode/basic/arith.sc
# int ff(int x, int y, int z) {
#  return x + y + z;
#}
#
#int gg(int x) {
#  return x * ff(1, 2, 3);
#}
#
#int hh(int x) {
#  return x / ff(1, 2, 3);
#}
#
#int ii() {
#  return ff(1, 2, 3) - gg(4);
#}
#
#int jj(int x, int y) {
#  int i;
#
#  i = 10;
#  x = x - y;
#  i = i - x - 1;
#
#  return x + i;
#}
#
#void main() {
#  print(ff(1, 2, 3) ==   6 &&
#        gg(10)      ==  60 &&
#        hh(40)      ==   6 &&
#        ii()        == -18 &&
#        jj(2, 4)    ==   9);
#}
#
  .text
  .globl main
ff:
  addiu $sp,$sp,-8
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,8
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,8
  jr $ra
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,8
  jr $ra
gg:
  addiu $sp,$sp,-8
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,8
  addiu $t1,$sp,-12
  sw $t0, 0($t1)
  sw $t0, 4($t1)
  sw $t0, 8($t1)
  move $sp,$t1
  jal ff
  addiu $sp,$sp,12
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,8
  jr $ra
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,8
  jr $ra
hh:
  addiu $sp,$sp,-8
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,8
  addiu $t1,$sp,-12
  sw $t0, 0($t1)
  sw $t0, 4($t1)
  sw $t0, 8($t1)
  move $sp,$t1
  jal ff
  addiu $sp,$sp,12
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,8
  jr $ra
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,8
  jr $ra
ii:
  addiu $sp,$sp,-8
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,8
  addiu $t1,$sp,-12
  sw $t0, 0($t1)
  sw $t0, 4($t1)
  sw $t0, 8($t1)
  move $sp,$t1
  jal ff
  addiu $sp,$sp,12
  addiu $t1,$sp,-4
  sw $t0, 0($t1)
  move $sp,$t1
  jal gg
  addiu $sp,$sp,4
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,8
  jr $ra
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,8
  jr $ra
jj:
  addiu $sp,$sp,-8
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,8
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,8
  jr $ra
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,8
  jr $ra
main:
  addiu $sp,$sp,-8
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,8
  addiu $t1,$sp,-12
  sw $t0, 0($t1)
  sw $t0, 4($t1)
  sw $t0, 8($t1)
  move $sp,$t1
  jal ff
  addiu $sp,$sp,12
  beqz $t0,_L2
_L1:
  addiu $t1,$sp,-4
  sw $t0, 0($t1)
  move $sp,$t1
  jal gg
  addiu $sp,$sp,4
  beqz $t0,_L5
_L4:
  j _L6
_L5:
_L6:
  j _L3
_L2:
_L3:
  beqz $t0,_L8
_L7:
  addiu $t1,$sp,-4
  sw $t0, 0($t1)
  move $sp,$t1
  jal hh
  addiu $sp,$sp,4
  beqz $t0,_L11
_L10:
  j _L12
_L11:
_L12:
  j _L9
_L8:
_L9:
  beqz $t0,_L14
_L13:
  jal ii
  beqz $t0,_L17
_L16:
  j _L18
_L17:
_L18:
  j _L15
_L14:
_L15:
  beqz $t0,_L20
_L19:
  addiu $t1,$sp,-8
  sw $t0, 0($t1)
  sw $t0, 4($t1)
  move $sp,$t1
  jal jj
  addiu $sp,$sp,8
  beqz $t0,_L23
_L22:
  j _L24
_L23:
_L24:
  j _L21
_L20:
_L21:
  li $v0,1
  syscall
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,8
  jr $ra

