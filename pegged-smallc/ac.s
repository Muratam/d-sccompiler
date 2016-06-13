#analyze smallcCode/basic/scope.sc
# int s() {
#  int x;
#  x = 1;
#  {
#    int y;
#    y = 2;
#    {
#      int x;
#      x = 3;
#      y = y + x;
#    }
#    x = x + y;
#  }
#  {
#    int y;
#    y = 4;
#    return x + y;
#  }
#}
#
#int main() {
#  print(s() == 10);
#}
#
  .text
  .globl main
s:
  addiu $sp,$sp,-8
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,8
  li $v0,12
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,8
  jr $ra
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,8
  jr $ra
main:
  addiu $sp,$sp,-16
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,16
  jal s
  sw $v0, 8($sp)
  lw $t1, 8($sp)
  li $t2,10
  seq $t0,$t1,$t2
  sw $t0, 12($sp)
  lw $a0, 12($sp)
  li $v0,1
  syscall
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,16
  jr $ra

