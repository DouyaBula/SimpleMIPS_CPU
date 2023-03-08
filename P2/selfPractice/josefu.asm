### Macros
.macro scanfInt(%a)
li  $v0, 5
syscall
move    %a, $v0
.end_macro

.macro getIndex(%coloum,%i,%j,%dst)
mul %dst, %i, %coloum
add %dst, %dst, %j
sll %dst, %dst, 2
.end_macro

.macro printInt(%a)
li  $v0, 1
move  $a0, %a
syscall
.end_macro

.macro Space
li  $v0, 11
li  $a0, ' '
syscall
.end_macro

.macro goodbye
li  $v0, 10
syscall
.end_macro
### Macros End

.data
flag:   .word   0 : 20
str:    .asciiz "Please Enter n and m\n"
.text
li  $v0, 4
la  $a0, str
syscall
# s0 for n
# s1 for m
scanfInt($s0)
scanfInt($s1)
# t0 for i
li  $t0, -1
# t1 for cnt
li  $t1, 0
# t2 for number
li  $t2, 0
## While Loop A
whileA:
beq $t2, $s0, endA
    li  $t1, 0
    ## While Loop B
    whileB:
    beq $t1, $s1, endB
        # t3 for temp
        addi    $t3, $t0, 1
        div $t3, $s0
        mfhi    $t3

        # t4 for flag[temp]
        getIndex($s0,$zero,$t3,$t4)
        lw  $t4, flag($t4)
        bne $t4, $zero, else
        move    $t0, $t3
        addi    $t1, $t1, 1
        j   if_end
        else:
        addi    $t0, $t0, 1
        if_end:
    j   whileB
    endB:
    ## Loop End
    addi    $t2, $t2, 1
    # t4 for flag[i]
    getIndex($s0,$zero,$t0,$t4)
    li  $t5, 1
    sw  $t5, flag($t4)
    addi    $t5, $t0, 1
    printInt($t5)
    Space
    
j   whileA
endA:
## Loop End

