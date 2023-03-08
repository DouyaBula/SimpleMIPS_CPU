# === Macros === #
# 0. Goodbye~
.macro goodbye
li  $v0, 10
syscall
.end_macro

# 1. Read Integer
.macro scanfInt(%integer)
li  $v0, 5
syscall
move    %integer, $v0
.end_macro

# 2. Push All Temp Registers
.macro pushAllTempReg
addi    $sp, $sp, -32
sw  $t0, 0($sp)
sw  $t1, 4($sp)
sw  $t2, 8($sp)
sw  $t3, 12($sp)
sw  $t4, 16($sp)
sw  $t5, 20($sp)
sw  $t6, 24($sp)
sw  $t7, 28($sp)
.end_macro

# 3. Pop All Temp Registers
.macro popAllTempReg
lw  $t0, 0($sp)
lw  $t1, 4($sp)
lw  $t2, 8($sp)
lw  $t3, 12($sp)
lw  $t4, 16($sp)
lw  $t5, 20($sp)
lw  $t6, 24($sp)
lw  $t7, 28($sp)
addi    $sp, $sp, 32
.end_macro

# 4. Push Return Address
.macro pushReturnAddress
addi    $sp, $sp, -4
sw  $ra, 0($sp)
.end_macro

# 5. Pop Return Address
.macro popReturnAddress
lw  $ra, 0($sp)
addi    $sp, $sp, 4
.end_macro

# 6. Push Arguments
.macro pushArg
addi    $sp, $sp, -4
sw  $a0, 0($sp)
.end_macro

# 7. Pop Arguments
.macro popArg
lw  $a0, 0($sp)
addi    $sp, $sp, 4
.end_macro

# 8. Print Integer
.macro  printInteger(%integer)
pushArg
li  $v0, 1
move    $a0, %integer
syscall
popArg
.end_macro

# 9. Get Index
.macro getIndex(%coloum,%i,%j,%dst)
mul %dst, %i, %coloum
add %dst, %dst, %j
sll %dst, %dst, 2
.end_macro

# 10. Print Space
.macro Space
pushArg
li  $v0, 11
li  $a0, ' '
syscall
popArg
.end_macro

# 11. Print Enter
.macro Enter
pushArg
li  $v0, 11
li  $a0, '\n'
syscall
popArg
.end_macro
# === Macros End === #

.data
symbol: .word   0 : 10
array:  .word   0 : 10
.text
# s0 for n
scanfInt($s0)
# a0 for index
li  $a0, 0
jal FullArray
goodbye

# Function 
FullArray:
pushAllTempReg
pushReturnAddress
pushArg
# if:
# t0 for if condition
slt $t0, $a0, $s0
bne $t0, $zero, ifEndA
# t0 for i
# === For Loop A === #
li  $t0, 0
A:
beq $t0, $s0, Aexit
    # Body
    # t1 for element
    getIndex($s0, $zero, $t0, $t1)
    lw  $t1, array($t1)
    printInteger($t1)
    Space
addi    $t0, $t0, 1
j   A
Aexit:
# === Loop A End === #
Enter
popArg
popReturnAddress
popAllTempReg
jr  $ra
ifEndA:

# t0 for i
# === For Loop B === #
li  $t0, 0
B:
beq $t0, $s0, Bexit
    # Body
    # t1 for Index: i
    # t2 for symbol[i]
    getIndex($s0, $zero, $t0, $t1)
    lw  $t2, symbol($t1)
    bne $t2, $zero, ifEndB
    # t3 for Index: index 
    # t4 for array[index]
    addi    $t4, $t0, 1
    getIndex($s0, $zero, $a0, $t3)
    sw  $t4, array($t3)
    li  $t2, 1
    sw  $t2, symbol($t1)
    # a0 for index+1
    addi    $a0, $a0, 1
    jal FullArray
    addi    $a0, $a0, -1
    li  $t2, 0
    sw  $t2, symbol($t1)
    ifEndB:
addi    $t0, $t0, 1
j   B
Bexit:
# === Loop B End === #
popArg
popReturnAddress
popAllTempReg
jr  $ra