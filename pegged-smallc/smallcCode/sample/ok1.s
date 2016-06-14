#analyze smallcCode/sample/ok1.sc
# void main() {
#  int x, y;
#  x = 2;
#  y = 3;
#  print(x + y == 5 && x * y == 6);
#}
#
  .text
  .globl main
main:
  addiu $sp,$sp,-8
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,8
  beqz $t0,_L2
_L1:
  beqz $t0,_L5
_L4:
  j _L6
_L5:
_L6:
  j _L3
_L2:
_L3:
  li $v0,1
  syscall
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,8
  jr $ra

