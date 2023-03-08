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

# 2. Get Index
.macro getIndex(%coloum,%i,%j,%dst)
mul %dst, %i, %coloum
add %dst, %dst, %j
sll %dst, %dst, 2
.end_macro

# 3. Push
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

# 4. Pop
.macro popAllTempReg
lw $t0, 0($sp)
lw $t1, 4($sp)
lw $t2, 8($sp)
lw $t3, 12($sp)
lw $t4, 16($sp)
lw $t5, 20($sp)
lw $t6, 24($sp)
lw $t7, 28($sp)
addi    $sp, $sp, 32
.end_macro

# 5. Print Integer
.macro printInt(%integer)
li  $v0, 1
move    $a0, %integer
syscall
.end_macro

# 6. Space
.macro Space
li  $v0, 11
li  $a0, ' '
syscall
.end_macro

# 7. Enter
.macro Enter
li  $v0, 11
li  $a0, '\n'
syscall
.end_macro

# === Macros End === #
.data
matrixMain: .word   0 : 121
matrixCore: .word   0 : 121

.text
# s0 for m1
scanfInt($s0)
# s1 for n1
scanfInt($s1)
# s2 for m2
scanfInt($s2)
# s3 for n2
scanfInt($s3)

# t0 for i
# === For Loop A === #
li  $t0, 0
A:
beq $t0, $s0, Aexit
    # Body
    # t1 for j
    # === For Loop B === #
    li  $t1, 0
    B:
    beq $t1, $s1, Bexit
        #Body
        # t2 for index
        getIndex($s1,$t0,$t1,$t2)
        # t4 for temp integer
        scanfInt($t4)
        sw  $t4, matrixMain($t2)
    addi    $t1, $t1, 1
    j   B
    Bexit:
    # === Loop B End === #
addi    $t0, $t0, 1
j   A
Aexit:
# === Loop A End === #

# t0 for i
# === For Loop C === #
li  $t0, 0
C:
beq $t0, $s2, Cexit
    # Body
    # t1 for j
    # === For Loop D === #
    li  $t1, 0
    D:
    beq $t1, $s3, Dexit
        #Body
        # t2 for index
        getIndex($s3,$t0,$t1,$t2)
        # t4 for temp integer
        scanfInt($t4)
        sw  $t4, matrixCore($t2)
    addi    $t1, $t1, 1
    j   D
    Dexit:
    # === Loop D End === #
addi    $t0, $t0, 1
j   C
Cexit:
# === Loop C End === #

# t2 for row
sub $t2, $s0, $s2
addi    $t2, $t2, 1
# t3 for coloum
sub $t3, $s1, $s3
addi    $t3, $t3, 1
# t0 for i
# === For Loop E === #
li  $t0, 0
E:
beq $t0, $t2, Eexit
    # Body
    # t1 for j
    # === For Loop F === #
    li  $t1, 0
    F:
    beq $t1, $t3, Fexit
        #Body
        # t4 for result
        jal convolution
        move    $t4, $v0
        printInt($t4)
        Space
    addi    $t1, $t1, 1
    j   F
    Fexit:
    Enter
    # === Loop F End === #
addi    $t0, $t0, 1
j   E
Eexit:
# === Loop E End === #
goodbye


# === Functions === #
convolution:
pushAllTempReg

# v0 for sum
li  $v0, 0
# t3 for iReg
lw  $t3, 0($sp)
# t4 for jReg
lw  $t4, 4($sp)
# t0 for i
# === For Loop X === #
li  $t0, 0
X:
beq $t0, $s2, Xexit
    # Body
    # t1 for j
    # === For Loop Y === #
    li  $t1, 0
    Y:
    beq $t1, $s3, Yexit
        #Body
        # t5 for Main value
        # s4, s5 for temp use
        add $s4, $t3, $t0
        add $s5, $t4, $t1
        getIndex($s1,$s4,$s5,$t5)
        lw  $t5, matrixMain($t5)
        # t6 for Core value
        getIndex($s3,$t0,$t1,$t6)
        lw  $t6, matrixCore($t6)
        mul $s4, $t5, $t6
        add $v0, $v0, $s4
    addi    $t1, $t1, 1
    j   Y
    Yexit:
    # === Loop Y End === #
addi    $t0, $t0, 1
j   X
Xexit:
# === Loop X End === #

popAllTempReg
jr $ra