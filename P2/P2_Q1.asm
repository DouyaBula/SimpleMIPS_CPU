# ------ Macros Begin ------ #

# 0. goodbye~
.macro goodbye
li		$v0, 10
syscall
.end_macro

# 1. Read Interger to a
.macro scanfInt(%a)
li		    $v0, 5
syscall
move		%a, $v0
.end_macro 

# 2. Print Interger a
.macro printInt(%a)
li		$v0, 1
move	$a0, %a
syscall
.end_macro

# 3. (!! using t7) Get Address to a According to i, j and rank 
.macro getAddress(%i, %j, %rank, %a)
mult	%i, %rank			# %i * %rank = Hi and Lo registers
mflo	$t7					# copy Lo to $t7
add		%a, $t7, %j		# %a = $t7 + %j
sll		%a, %a, 2			# %a = %a << 2
.end_macro

# 4. Print Space
.macro printSpace
li		$v0, 11
li		$a0, ' '
syscall
.end_macro

# 5. Print Enter
.macro printEnter
li		$v0, 11
li		$a0, '\n'
syscall
.end_macro

# ------ Macros End ------ #

.data
rank:       .space  4
product:    .space  4
matrixA:    .word   0 : 64
matrixB:    .word   0 : 64
space:      .ascii  " "
enter:      .ascii  "\n"

.text
# s0 for rank
scanfInt($s0)

#------Loop1------#
# s1 for i
li		$s1, 0		# $s1 = 0
for1:
beq		$s1, $s0, for1Out	# if $s1 == $s0 then for1Out

# s2 for j
li		$s2, 0		# $s2 = 0
for1Inner:
beq		$s2, $s0, for1InnerOut	# if $s2 == $s0 then for1InnerOut
    scanfInt($t0)
    # s3 for address
    getAddress($s1, $s2, $s0, $s3)
    sw		$t0, matrixA($s3)		# 
addi	$s2, $s2, 1			# $s2 = $s2 + 1
j		for1Inner				# jump to for1Inner
for1InnerOut:

addi	$s1, $s1, 1			# $s1 = $s1 + 1
j		for1				# jump to for1
for1Out:
#------Loop1 End------#

#------Loop2------#
# s1 for i
li		$s1, 0		# $s1 = 0
for2:
beq		$s1, $s0, for2Out	# if $s1 == $s0 then for2Out

# s2 for j
li		$s2, 0		# $s2 = 0
for2Inner:
beq		$s2, $s0, for2InnerOut	# if $s2 == $s0 then for2InnerOut
    scanfInt($t0)
    # s3 for address
    getAddress($s1, $s2, $s0, $s3)
    sw		$t0, matrixB($s3)		# 
addi	$s2, $s2, 1			# $s2 = $s2 + 1
j		for2Inner				# jump to for2Inner
for2InnerOut:

addi	$s1, $s1, 1			# $s1 = $s1 + 1
j		for2				# jump to for2
for2Out:
#------Loop2 End------#

#------Loop3------#
# s1 for i
li		$s1, 0		# $s1 = 0
for3:
beq		$s1, $s0, for3Out	# if $s1 == $s0 then for3Out

# s2 for j
li		$s2, 0		# $s2 = 0
for3Inner:
beq		$s2, $s0, for3InnerOut	# if $s2 == $s0 then for3InnerOut
    
    # s6 for product
    li		$s6, 0		# $s6 = 0
    # s3 for k
    li		$s3, 0		# $s3 = 0
    for3InnerInner:
    beq		$s3, $s0, for3InnerInnerOut	# if $s3 == $s0 then for3InnerInnerOut

        # s4 for addressA
        getAddress($s1, $s3, $s0, $s4)
        lw		$t1, matrixA($s4)		# 
        # s5 for addressB
        getAddress($s3, $s2, $s0, $s5)
        lw		$t2, matrixB($s5)		# 
        # s6 for product
        mult	$t1, $t2			# $t1 * $t2 = Hi and Lo registers
        mflo	$t3					# copy Lo to $t3
        add		$s6, $s6, $t3		# $s6 = $s6 + $t3
    addi	$s3, $s3, 1			# $s3 = $s3 + 1
    j		for3InnerInner				# jump to for3InnerInner
    for3InnerInnerOut:
    printInt($s6)
    printSpace

addi	$s2, $s2, 1			# $s2 = $s2 + 1
j		for3Inner				# jump to for3Inner
for3InnerOut:

printEnter
addi	$s1, $s1, 1			# $s1 = $s1 + 1
j		for3				# jump to for3
for3Out:
#------Loop3 End------#
goodbye
