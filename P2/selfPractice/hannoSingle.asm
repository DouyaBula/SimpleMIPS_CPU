### Macros
.macro goodbye
li  $v0, 10
syscall
.end_macro

.macro scanfInt(%int)
li  $v0, 5
syscall
move    %int, $v0
.end_macro

.macro getIndex(%coloum,%i,%j,%dst)
mul %dst, %coloum, %i
addi    %dst, %dst, %j
sll %dst, %dst, 2
.end_macro

.macro Space
Save($a0)
li  $v0, 11
li  $a0, ' '
syscall
Load($a0)
.end_macro

.macro Enter
Save($a0)
li  $v0, 11
li  $a0, '\n'
syscall
Load($a0)
.end_macro

.macro Save(%a)
addi    $sp, $sp, -4
sw  %a, 0($sp)
.end_macro

.macro Load(%a)
lw  %a, 0($sp)
addi    $sp, $sp, 4
.end_macro

.macro printChar(%char)
Save($a0)
li  $v0, 11
move    $a0, %char
syscall
Load($a0)
.end_macro

.macro string
Save($a0)
li  $v0, 4
la  $a0, str
syscall
Load($a0)
.end_macro
### Macros End

.data
str:    .asciiz "-->"
.text
# s0 for n
scanfInt($s0)
move    $a0, $s0
li  $a1, 'a'
li  $a2, 'b'
li  $a3, 'c'
jal hanno
goodbye

### Functions
hanno:
Save($a0)
Save($a1)
Save($a2)
Save($a3)
Save($ra)
Save($t1)
Save($t2)
Save($t3)
bne $a0, 1, else
if:
    printChar($a1)
    Space
    string
    Space
    printChar($a3)
    Enter
j   ifEnd
else:
    addi    $a0, $a0, -1
    #t1 for from, t2 for buffer, t3 for to
    move    $t1, $a1
    move    $t2, $a2
    move    $t3, $a3
    
    move    $a1, $t1
    move    $a2, $t3
    move    $a3, $t2
    jal hanno

    move    $a1, $t2
    move    $a2, $t1
    move    $a3, $t3
    jal hanno

    printChar($t1)
    Space
    string
    Space
    printChar($t2)
    Enter

    move    $a1, $t3
    move    $a2, $t1
    move    $a3, $t2
    jal hanno

    move    $a1, $t2
    move    $a2, $t3
    move    $a3, $t1
    jal hanno

    printChar($t2)
    Space
    string
    Space
    printChar($t3)
    Enter

    move    $a1, $t1
    move    $a2, $t3
    move    $a3, $t2
    jal hanno

    move    $a1, $t2
    move    $a2, $t1
    move    $a3, $t3
    jal hanno

    # addi    $a0, $a0, 1
    # move    $a1, $t1
    # move    $a2, $t2
    # move    $a3, $t3

ifEnd:
Load($t3)
Load($t2)
Load($t1)
Load($ra)
Load($a3)
Load($a2)
Load($a1)
Load($a0)
jr  $ra
### Functions End