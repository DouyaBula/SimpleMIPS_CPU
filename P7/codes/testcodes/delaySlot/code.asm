.data
.globl TC0_BASE TC1_BASE cnt0 cnt1 cnt0_double cnt1_double
TC0_BASE: .word 0x7f00
TC1_BASE: .word 0x7f10
cnt0: .word 5
cnt1: .word 5
cnt0_double: .word 0
cnt1_double: .word 0
	
.text 
	ori	$28, $0, 0x0000
	ori	$29, $0, 0x0f00
	mtc0	$0, $12
	
	#save start address 
	ori 	$t0, $0, 0x7f00
	sw 	$t0, 0($0)
	ori 	$t1, $0, 0x7f10
	sw 	$t1, 4($0)
	
	#set SR included IM, IE, EXL
	ori 	$t0,$0, 0x0c01
	mtc0 	$t0,$12
	
	#set Timer0
	la 	$t1, TC0_BASE
	lw 	$t1, 0($t1)
	sw 	$0, 0($t1)		# disable Timer0.CTRL
	
	addi 	$t0, $0, 0x80		# set Timer0.PRESET
	sw 	$t0, 4($t1)
	addi 	$t0, $0, 9		# set Timer0.CTRL
	sw 	$t0, 0($t1)
	
	#set Timer1
	la 	$t1, TC1_BASE
	lw 	$t1, 0($t1)
	sw 	$0, 0($t1)		# disable Timer1.CTRL
	
	addi 	$t0, $0, 0x40		# set Timer1.PRESET
	sw 	$t0, 4($t1)
	addi 	$t0, $0, 9		# set Timer1.CTRL
	sw 	$t0, 0($t1)
	
	lui	$8, 0x7fff
	lui	$9, 0x7fff
	ori	$8, $8, 0xffff
	beq $zero, $zero, slot_ov1
	add	$10, $8, $9	        # �����ӳٲ��� add ���Ͻ����
slot_ov1:
	lui     $t0,0x8000
	jal	slot_ov2
	addi	$10, $8, -1     # �����ӳٲ��� addi ���½����
slot_ov2:
	ori	$t1, $0, 0x0ba0
	lui	$8, 0x8000
	lui	$9, 0x1000
	beq $zero, $zero, slot_ov3
	sub	$10, $8, $9			# �����ӳٲ��� sub ���½����
slot_ov3:
	ori	$t2, $0, 0x93ac
	lui	$8, 0x7fff
	lui	$9, 0x7fff
	beq $zero, $zero, slot_ov4
	add     $10, $8, $9		# �����ӳٲ��� add ���½����
slot_ov4:
	ori     $t2, $0, 0x5daa
	lui	$8, 0x7fff
	lui	$9, 0x8000
	sub	$10, $8, $9			# �����ӳٲ��� sub ���Ͻ����
	lui	$8, 0x8111
	lui	$9, 0x8111
	add     $10, $8, $9
	addi    $10, $8,-2
	beq     $0,$0,slot_adel1
	addi    $10, $8,-3
	add     $10, $8, $9
	sub	$10, $8, $9
slot_adel1:	
slot_adel2:
	addi $8, $zero, 0x801
	addi $9, $zero, 0x800
	sw      $9,0($9)
	lh      $9,0($8)         # ����lh��ַ�쳣��������λΪ1
	beq $zero, $zero, slot_adel3
	nop
	
slot_adel3:
	addi $8, $zero, 0x802
	lw      $9,0($8)         # ����lw��ַ�쳣��������λΪ2
	beq $zero, $zero, slot_adel4
	nop
	
slot_adel4:
	addi $8, $zero, 0x803
	lh      $9,0($8)        # ����lhu��ַ�쳣��������λΪ3
                            # �Ѹ�Ϊlh
	beq $zero, $zero, slot_adel5
	nop
	
slot_adel5:
	addi $8, $zero, 0x803
	lw      $9,0($8)         # ����lw��ַ�쳣��������λΪ3
	beq $zero, $zero, slot_ades1
	nop
	
slot_ades1:
	addi $8, $zero, 0x801
	sh      $9,0($8)         # ����sh��ַ�쳣��������λΪ1
	beq $zero, $zero, slot_ades2
	nop
	
slot_ades2:
	addi $8, $zero, 0x802
	sw      $9,0($8)         # ����sw��ַ�쳣��������λΪ2
	beq $zero, $zero, slot_ades3
	nop
slot_ades3:
	addi $8, $zero, 0x801
	sw      $9,0($8)         # ����sw��ַ�쳣��������λΪ1
	beq $zero, $zero, slot_combination
	nop
	
slot_combination:
	lui      $s0,0x8000 # �쳣��ϲ��ԣ������������쳣�в�ӳ˳�ָ����漰���ӳٲ��е��쳣���漰���ĳ�ͻ�С���add ���½����,addi���Ͻ����,sub���½����,sw�ĵ�ַ�쳣,sh�ĵ�ַ�쳣,lw�ĵ�ַ�쳣,lh�ĵ�ַ�쳣,lhu�ĵ�ַ�쳣.
	lui      $s1,0x7fff
	ori      $s1,$s1,0xffff
	add     $10,$s0,$s0
	sub     $10,$s0,$s1
	addi    $10,$s1,10
	sw      $10,0x1002($0)
	sh      $10,0x1001($0)
	mult    $10,$10
	lw      $10,0x1002($0)
	lh      $10,0x1001($0)
	mult    $10,$10
	lh      $10,0x1001($0)
	sub     $10,$s0,$s1
	addi    $10,$s1,10
	sw      $10,0x1002($0)
	sh      $10,0x1001($0)
	mult    $10,$10
	sw      $10,0x1002($0)
	sh      $10,0x1001($0)
	lw      $10,0x1002($0)
	lh      $10,0x1001($0)
	mult    $10,$10
	sh      $10,0x1001($0)
	add     $10,$s0,$s0
	sub     $10,$s0,$s1
	mult    $10,$10
	add     $10,$s0,$s0
	sub     $10,$s0,$s1
	beq $zero, $zero, label_1
	add     $10,$s0,$s0
	sub     $10,$s0,$s1
label_1:
	mult    $10,$10
	add     $10,$s0,$s0
	sub     $10,$s0,$s1
	mult    $10,$10
	sh      $10,0x1001($0)
	lw      $10,0x1002($0)
	add     $10,$s0,$s0
	bne     $0,$10,label_2
	lw      $10,0x1002($0)
	sh      $10,0x1001($0)
label_2:
	sub     $10,$s0,$s1
	mult    $10,$10
	sh      $10,0x1001($0)
	lw      $10,0x1002($0)
	nop
	
	ori	$t0, $0, 0x0005
wait:						# ����ÿ���������Ƿ�ǡ���ж� 5 ��
	lw	$k0, 8($0)
	lw	$k1,12($0)
	bne	$k0, $t0, wait
	nop
	bne	$k1, $t0, wait
	nop
	ori	$t0, $0, 0xffff
	ori	$t1, $0, 0xffff	

dead_loop:
	beq $zero, $zero, dead_loop
	nop

.ktext 0x4180
	
_entry:	
	mfc0	$1, $13                 # ���cause
	ori	$k0, $0, 0x1000
	sw	$sp, -4($k0)
	
	addi	$k0, $k0, -256
	add $sp, $zero, $k0
	
	beq $zero, $zero, _save_context
	nop
	
_main_handler:
	mfc0	$k0, $13
	# andi	$k0, $k0, 0x00ff
	# srl	$k0, $k0, 2         
	andi    $k0, $k0, 0x007C    # ����ûsrl��, ��һ��

	ori	$k1, $0, 0x0000         # 0000(00)
	beq	$k0, $k1, int_handler
	nop
	ori	$k1, $0, 0x0010         # 0100(00)
	beq	$k0, $k1, adel_handler
	nop
	ori	$k1, $0, 0x0014         # 0101(00)
	beq	$k0, $k1, ades_handler
	nop
	ori	$k1, $0, 0x0028         # 1010(00)
	beq	$k0, $k1, ri_handler
	nop
	ori	$k1, $0, 0x0030         # 1100(00)
	beq	$k0, $k1, ov_handler
	nop
	
int_handler:
	sw	$ra, 0($sp)
	addi	$sp, $sp, -16
	mfc0	$v0, $12
	sw	$v0, 0($sp)
	mfc0	$v0, $13
	sw	$v0, 4($sp)
	
	
	# check INT[3]
	lw	$v0, 0($sp)
	lw	$v1, 4($sp)
	and	$v0, $v1, $v0
	andi	$v0, $v0, 0x800
	bne	$v0, $0, timer1_handler
	nop
	
	# check INT[2]
	lw	$v0, 0($sp)
	lw	$v1, 4($sp)
	and	$v0, $v1, $v0
	andi	$v0, $v0, 0x400
	bne	$v0, $0, timer0_handler
	nop

timer0_handler:
	# first we load the global variable cnt0:
	# ++cnt0, then save to global variable cnt0
	addi 	$fp, $zero, 0x8
	lw	$t0, 0($fp)			# get cnt0
	addi    $s6, $0 , 5
	beq	$t0, $s6, skip0
	nop
	
	addi 	$t0, $t0, 1			# add cnt0
skip0:	sw 	$t0, 0($fp)			# update cnt0
	jal	restart_timer
	nop
	
	# mask INT[2]
	mfc0 	$t0, $12
	andi 	$t0, $t0, 0x03ff
	ori 	$t0, $t0, 0x800
	mtc0 	$t0, $12
	
	beq	$zero, $zero, _restore_context
	nop
	
timer1_handler:
	# first we load the global variable cnt1:
	# ++cnt1, then save to global variable cnt1
	addi 	$fp, $zero, 0xc
	lw 	$t0, 0($fp)			# get cnt1
	addi    $s6, $0 , 5
	beq	$t0, $s6, skip1
	nop
	
	addi 	$t0, $t0, 1			# add cnt1
skip1:	sw 	$t0, 0($fp)			# update cnt1
	jal	restart_timer
	nop
	
	# mask INT[3]
	mfc0 	$t0, $12
	andi 	$t0, $t0, 0x03ff
	ori 	$t0, $t0, 0x400
	mtc0 	$t0, $12
	
	beq	$zero, $zero, _restore_context
	nop
	
restart_timer:
	# swap two PRESET
	addi	$t0, $zero, 0x0
	lw	$t0, 0($t0)
	lw	$t5, 4($t0)
	addi	$t2, $zero, 0x4
	lw	$t2, 0($t2)
	lw	$t6, 4($t2)
	
	


	# restart Timer 0
	addi 	$t1, $zero, 0x0
	lw 	$t1, 0($t1)
	lw 	$t0, 0($t1)		# $t0 is the CTRL Reg of Timer 0
	sw 	$0, 0($t1)		# disable Timer 0
	
	
	addi 	$t2, $zero, 0x8
	lw	$t2, 0($t2)
	
	addi    $s6, $0 , 5
	beq	$t2, $s6, f0		# check Timer0 pause times
	nop
	
	sw	$t6, 4($t1)		# refill the count number
	addi 	$t0, $0, 9		# set Timer0.CTRL
	sw 	$t0, 0($t1)		# Timer 0 restart count
	f0:	
	# restart Timer 1
	addi 	$t1, $zero, 0x4
	lw 	$t1, 0($t1)
	lw 	$t0, 0($t1)		# $t0 is the CTRL Reg of Timer 1
	sw 	$0, 0($t1)		# disable Timer 1
	
		
	addi 	$t2, $zero, 0xc
	lw	$t2, 0($t2)
	
	addi    $s6, $0 , 5
	beq	$t2, $s6, f1		# check Timer1 pause times
	nop

	sw	$t5, 4($t1)		# refill the count number
	addi 	$t0, $0, 9		# set Timer1.CTRL
	sw 	$t0, 0($t1)		# Timer 0 restart count
	f1:	
	jr 	$ra
	nop	

adel_handler:
	mfc0	$t0, $14
	mfc0	$k0, $13
	lui	$t2, 0x8000
	and	$t3, $k0, $t2
	addi	$t0, $t0, 4
	bne	$t3, $t2, adel_nxt
	nop
	addi	$t0, $t0, 4
	adel_nxt:
	mtc0	$t0, $14
	beq	$zero, $zero, _restore_context
	nop

ades_handler:
	mfc0	$t0, $14
	mfc0	$k0, $13
	lui	$t2, 0x8000
	and	$t3, $k0, $t2
	addi	$t0, $t0, 4
	bne	$t3, $t2, ades_nxt
	nop
	addi	$t0, $t0, 4
	ades_nxt:
	mtc0	$t0, $14
	beq	$zero, $zero, _restore_context
	nop
	

ri_handler:
	mfc0	$t0, $14
	mfc0	$k0, $13
	lui	$t2, 0x8000
	and	$t3, $k0, $t2
	addi	$t0, $t0, 4
	bne	$t3, $t2, ri_nxt
	nop
	addi	$t0, $t0, 4
	ri_nxt:
	mtc0	$t0, $14
	beq	$zero, $zero, _restore_context
	nop
	
ov_handler:
	mfc0	$t0, $14
	mfc0	$k0, $13
	lui	$t2, 0x8000
	and	$t3, $k0, $t2
	addi	$t0, $t0, 4
	bne	$t3, $t2, ov_nxt
	nop
	addi	$t0, $t0, 4
	ov_nxt:
	mtc0	$t0, $14
	beq	$zero, $zero, _restore_context
	nop

_restore:
	eret
	
_save_context:
    	sw  	$2, 8($sp)    
    	sw  	$3, 12($sp)    
    	sw  	$4, 16($sp)    
    	sw  	$5, 20($sp)    
    	sw  	$6, 24($sp)    
    	sw  	$7, 28($sp)    
    	sw  	$8, 32($sp)    
    	sw  	$9, 36($sp)    
    	sw  	$10, 40($sp)    
    	sw  	$11, 44($sp)    
    	sw  	$12, 48($sp)    
    	sw  	$13, 52($sp)    
    	sw  	$14, 56($sp)    
    	sw  	$15, 60($sp)    
    	sw  	$16, 64($sp)    
    	sw  	$17, 68($sp)    
    	sw  	$18, 72($sp)    
    	sw  	$19, 76($sp)    
    	sw  	$20, 80($sp)    
    	sw  	$21, 84($sp)    
    	sw  	$22, 88($sp)    
    	sw  	$23, 92($sp)    
    	sw  	$24, 96($sp)    
    	sw  	$25, 100($sp)    
    	sw  	$28, 112($sp)    
    	sw  	$29, 116($sp)    
    	sw  	$30, 120($sp)    
    	sw  	$31, 124($sp)
	mfhi 	$k0
	sw 	$k0, 128($sp)
	mflo 	$k0
	sw 	$k0, 132($sp)
	beq $zero, $zero, _main_handler
	nop
	


_restore_context:
	addi	$sp, $zero, 0x1000
	addi	$sp, $sp, -256
    	lw  	$2, 8($sp)    
    	lw  	$3, 12($sp)    
    	lw  	$4, 16($sp)    
    	lw  	$5, 20($sp)    
    	lw  	$6, 24($sp)    
    	lw  	$7, 28($sp)    
    	lw  	$8, 32($sp)    
    	lw  	$9, 36($sp)    
    	lw  	$10, 40($sp)    
    	lw  	$11, 44($sp)    
    	lw  	$12, 48($sp)    
    	lw  	$13, 52($sp)    
    	lw  	$14, 56($sp)    
    	lw  	$15, 60($sp)    
    	lw  	$16, 64($sp)    
    	lw  	$17, 68($sp)    
    	lw  	$18, 72($sp)    
    	lw  	$19, 76($sp)    
    	lw  	$20, 80($sp)    
    	lw  	$21, 84($sp)    
    	lw  	$22, 88($sp)    
    	lw  	$23, 92($sp)    
    	lw  	$24, 96($sp)    
    	lw  	$25, 100($sp)    
    	lw  	$28, 112($sp)   
    	lw  	$30, 120($sp)    
    	lw  	$31, 124($sp)    
	lw 	$k0, 128($sp)
	mthi 	$k0
	lw 	$k0, 132($sp)
	mtlo 	$k0
    	lw  	$29, 116($sp) 
	ori     $1,$0,1
    	beq 	$zero, $zero, _restore	
	nop	