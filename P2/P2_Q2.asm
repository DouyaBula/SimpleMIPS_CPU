# ---Macros---

# 0. goodbye~
.macro goodbye
li      $v0, 10
syscall
.end_macro

# 1. Read Integer to %a
.macro scanfInt(%a)
li      $v0, 5
syscall
move    %a, $v0
.end_macro

# 2. For Loops (for reference)
.macro forA(%integer,%origin,%border,%op,%body)
add     %integer, $zero, %origin 
A:
beq     %integer, %border, Aexit
%body
addi    %integer, %integer, %op
j       A
Aexit:
.end_macro

# 3. Get the Address of an Element in an Array
.macro getAddress(%coloum,%i,%j,%dst)
mult        %i, %coloum
mflo        %dst
add         %dst, %dst, %j
sll         %dst, %dst, 2
.end_macro

# 4. Print Integer
.macro printInteger(%integer)
li      $v0, 1
move    $a0, %integer
syscall
.end_macro

# 5. Read Character
.macro scanfChar(%char)
li      $v0, 12
syscall
move    %char, $v0
.end_macro
# ---Macros End---

.data
string:     .word   0 : 21
.text
# s0 for number
scanfInt($s0)
# s1 for i
li      $s1, 0
# s2 for flag
li      $s2, 1
# s3 for number/2
div		$s3, $s0, 2

### For Loop A #######
add     $s1, $zero, $zero 
A:
beq     $s1, $s0, Aexit
        ### Body ###
        getAddress($s0, $zero, $s1, $t0)
        scanfChar($t1)
        sw      $t1, string($t0)
addi    $s1, $s1, 1
j       A
Aexit:
### For Loop A END ###

### For Loop B #######
add     $s1, $zero, $zero 
B:
beq     $s1, $s3, Bexit
        ### Body ###
        getAddress($s0, $zero, $s1, $t0)
        addi        $t1, $s0, -1
        sub         $t1, $t1, $s1
        getAddress($s0, $zero, $t1, $t2)
        lw          $t3, string($t0)
        lw          $t4, string($t2)
        beq         $t3, $t4, if_end
        li          $s2, 0
        j           Bexit
        if_end:         
addi    $s1, $s1, 1
j       B
Bexit:
### For Loop B END ###
printInteger($s2)
goodbye
