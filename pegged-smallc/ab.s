#analyze asm/gptest.sc
# int x, y[2];
#
#int f(int x) {
#  return x + y[0] + y[1];
#}
#int g(int *y) {
#  return x + y[0] + y[1];
#}
#
#int main() {
#  int z[2];
#
#  y[0] = 2;
#  y[1] = 3;
#  z[0] = 4;
#  z[1] = 5;
#  x = f(1);
#
#  print(x + z[0] + z[1]);
#}
  .text
  .globl main
f:
  addiu $sp,$sp,-32
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,32
  addiu $t1,$gp,4
  li $t2,0
  add $t0,$t1,$t2
  sw $t0, 8($sp)
  lw $t0, 8($sp)
  lw $t0, 0($t0)
  sw $t0, 12($sp)
  lw $t1, 0($fp)
  lw $t2, 12($sp)
  add $t0,$t1,$t2
  sw $t0, 16($sp)
  addiu $t1,$gp,4
  li $t2,4
  add $t0,$t1,$t2
  sw $t0, 20($sp)
  lw $t0, 20($sp)
  lw $t0, 0($t0)
  sw $t0, 24($sp)
  lw $t1, 16($sp)
  lw $t2, 24($sp)
  add $t0,$t1,$t2
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
g:
  addiu $sp,$sp,-32
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,32
  lw $t1, 0($fp)
  li $t2,0
  add $t0,$t1,$t2
  sw $t0, 8($sp)
  lw $t0, 8($sp)
  lw $t0, 0($t0)
  sw $t0, 12($sp)
  lw $t1, 0($fp)
  lw $t2, 12($sp)
  add $t0,$t1,$t2
  sw $t0, 16($sp)
  lw $t1, 0($fp)
  li $t2,4
  add $t0,$t1,$t2
  sw $t0, 20($sp)
  lw $t0, 20($sp)
  lw $t0, 0($t0)
  sw $t0, 24($sp)
  lw $t1, 16($sp)
  lw $t2, 24($sp)
  add $t0,$t1,$t2
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
main:
  addiu $sp,$sp,-124
  sw $ra, 4($sp)
  sw $fp, 0($sp)
  addiu $fp,$sp,124
  li $t0,2
  sw $t0, 12($sp)
  li $t0,0
  sw $t0, 16($sp)
  li $t0,4
  sw $t0, 20($sp)
  li $t1,4
  li $t2,0
  mul $t0,$t1,$t2
  sw $t0, 24($sp)
  lw $t1, 0($fp)
  li $t2,0
  add $t0,$t1,$t2
  sw $t0, 28($sp)
  li $t0,2
  lw $t1, 28($sp)
  sw $t0, 0($t1)
  li $t0,3
  sw $t0, 32($sp)
  li $t0,1
  sw $t0, 36($sp)
  li $t0,4
  sw $t0, 40($sp)
  li $t1,4
  li $t2,1
  mul $t0,$t1,$t2
  sw $t0, 44($sp)
  lw $t1, 0($fp)
  li $t2,4
  add $t0,$t1,$t2
  sw $t0, 48($sp)
  li $t0,3
  lw $t1, 48($sp)
  sw $t0, 0($t1)
  li $t0,4
  sw $t0, 52($sp)
  li $t0,0
  sw $t0, 56($sp)
  li $t0,4
  sw $t0, 60($sp)
  li $t1,4
  li $t2,0
  mul $t0,$t1,$t2
  sw $t0, 64($sp)
  addiu $t1,$sp,8
  li $t2,0
  add $t0,$t1,$t2
  sw $t0, 68($sp)
  li $t0,4
  lw $t1, 68($sp)
  sw $t0, 0($t1)
  li $t0,5
  sw $t0, 72($sp)
  li $t0,1
  sw $t0, 76($sp)
  li $t0,4
  sw $t0, 80($sp)
  li $t1,4
  li $t2,1
  mul $t0,$t1,$t2
  sw $t0, 84($sp)
  addiu $t1,$sp,8
  li $t2,4
  add $t0,$t1,$t2
  sw $t0, 88($sp)
  li $t0,5
  lw $t1, 88($sp)
  sw $t0, 0($t1)
  li $t0,1
  sw $t0, 92($sp)
  addiu $t1,$sp,-4
  li $t0,1
  sw $t0, 0($t1)
  move $sp,$t1
  jal f
  addiu $sp,$sp,4
  sw $v0, 96($sp)
  lw $t0, 96($sp)
  sw $t0, 0($fp)
  addiu $t1,$sp,8
  li $t2,0
  add $t0,$t1,$t2
  sw $t0, 100($sp)
  lw $t0, 100($sp)
  lw $t0, 0($t0)
  sw $t0, 104($sp)
  lw $t1, 0($fp)
  lw $t2, 104($sp)
  add $t0,$t1,$t2
  sw $t0, 108($sp)
  addiu $t1,$sp,8
  li $t2,4
  add $t0,$t1,$t2
  sw $t0, 112($sp)
  lw $t0, 112($sp)
  lw $t0, 0($t0)
  sw $t0, 116($sp)
  lw $t1, 108($sp)
  lw $t2, 116($sp)
  add $t0,$t1,$t2
  sw $t0, 120($sp)
  lw $a0, 120($sp)
  li $v0,1
  syscall
  lw $ra, 4($sp)
  lw $fp, 0($sp)
  addiu $sp,$sp,124
  jr $ra

