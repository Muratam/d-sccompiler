#analyze smallcCode/sample/ok0.sc
# void main() {
#  print(1 + 2 == 3);
#}
#
  .text
  .globl main
main:
  addiu $sp,$sp,-8
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,8
  li $v0,1
  syscall
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,8
  jr $ra

