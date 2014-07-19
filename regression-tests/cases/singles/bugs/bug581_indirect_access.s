	#  /home/sidjana/opt/openuh/lib/gcc-lib/x86_64-open64-linux/4.2/be::4.2

	#-----------------------------------------------------------
	# Compiling bug581_indirect_access.caf (bug581_indirect_access.I)
	#-----------------------------------------------------------

	#-----------------------------------------------------------
	# Options:
	#-----------------------------------------------------------
	#  Target:Barcelona, ISA:ISA_1, Endian:little, Pointer Size:64
	#  -O2	(Optimization level)
	#  -g0	(Debug level)
	#  -m2	(Report advisories)
	#-----------------------------------------------------------

	.file	1	"bug581_indirect_access.caf"


	.text
	.align	2

	.data

	.section .rodata, "a",@progbits
	.section .text
	.p2align 5,,

	# Program Unit: TEST1.in.TESTS
.globl	TEST1.in.TESTS
	.type	TEST1.in.TESTS, @function
TEST1.in.TESTS:	# 0x0
	# .frame	%rsp, 440, %rsp
	# T = 8
	# _temp_LCB0 = 0
	# _cray_clist = 16
	# _temp_stack_space_type1 = 192
	# _cray_iolist_1 = 112
	# _temp_gra_spill2 = 400
	.loc	1	15	0
 #  11              end type 
 #  12  
 #  13              contains
 #  14  
 #  15              subroutine test1(my_grid)
.LBB1_TEST1.in.TESTS:
	addq $-440,%rsp               	# [0] 
	.loc	1	20	0
 #  16  
 #  17              type(grid_t) :: my_grid[*]
 #  18              integer :: t
 #  19  
 #  20              if (this_image() == 1) then
	.globl	_this_image
	cmpl $1,_this_image(%rip)     	# [0] 
	.loc	1	15	0
	movq %rdi,400(%rsp)           	# [4] _temp_gra_spill2
	.loc	1	20	0
	je .LBB2_TEST1.in.TESTS       	# [4] 
.Lt_0_1026:
	.loc	1	25	0
 #  21                t = my_grid[2]%d(1)
 #  22                print *, "t = ", t
 #  23              end if 
 #  24  
 #  25              end subroutine
	addq $440,%rsp                	# [0] 
	ret                           	# [0] 
	.p2align 5,,31
.LBB2_TEST1.in.TESTS:
	xorl %eax,%eax                	# [0] 
	.loc	1	20	0
	movq %rsp,%rsi                	# [1] 
	movq $4,%rdi                  	# [1] 
	.globl	acquire_lcb_
	call acquire_lcb_             	# [1] acquire_lcb_
.LBB3_TEST1.in.TESTS:
	movq 0(%rsp),%rdx             	# [0] _temp_LCB0
	movq $2,%rdi                  	# [0] 
	movq 400(%rsp),%rsi           	# [0] _temp_gra_spill2
	movq $80,%rcx                 	# [1] 
	xorl %eax,%eax                	# [1] 
	.globl	coarray_read_
	call coarray_read_            	# [1] coarray_read_
.LBB4_TEST1.in.TESTS:
	.loc	1	21	0
	movq 400(%rsp),%rcx           	# [0] _temp_gra_spill2
	movq 0(%rsp),%rsi             	# [3] _temp_LCB0
	movq 136(%rcx),%rdx           	# [7] id:34 parm:MY_GRID
	movq 152(%rcx),%rcx           	# [9] id:33 parm:MY_GRID
	movq 8(%rsi),%rsi             	# [10] id:32
	decq %rdx                     	# [10] 
	negq %rdx                     	# [11] 
	imulq %rcx,%rdx               	# [12] 
	movl 0(%rsi,%rdx,4), %esi     	# [17] id:35
	movq %rsp,%rdi                	# [19] 
	xorl %eax,%eax                	# [20] 
	movl %esi,8(%rsp)             	# [20] T
	.globl	release_lcb_
	call release_lcb_             	# [20] release_lcb_
.LBB5_TEST1.in.TESTS:
	.loc	1	22	0
	movq $562958543355904,%rsi    	# [0] 
	leaq 8(%rsp),%rdx             	# [0] T
	movq $504430646056190209,%rcx 	# [0] 
	movq $(.rodata),%r10          	# [1] .rodata
	movq $1125899906842625,%r8    	# [1] 
	movq %rcx,16(%rsp)            	# [1] _cray_clist
	movq $140763258159104,%r9     	# [2] 
	movq %r8,120(%rsp)            	# [2] _cray_iolist_1+8
	movq %r8,152(%rsp)            	# [2] _cray_iolist_1+40
	movl $4,%r11d                 	# [3] 
	movq %r9,128(%rsp)            	# [3] _cray_iolist_1+16
	movq %r10,136(%rsp)           	# [3] _cray_iolist_1+24
	movq %r11,144(%rsp)           	# [4] _cray_iolist_1+32
	movq %rdx,168(%rsp)           	# [4] _cray_iolist_1+56
	movq $2533286601555969,%rax   	# [4] 
	movq %rsi,160(%rsp)           	# [5] _cray_iolist_1+48
	movq %rax,112(%rsp)           	# [5] _cray_iolist_1
	xorl %eax,%eax                	# [5] 
	movq %rax,24(%rsp)            	# [6] _cray_clist+8
	movq %rax,32(%rsp)            	# [6] _cray_clist+16
	leaq 16(%rsp),%rdi            	# [7] _cray_clist
	movq %rax,40(%rsp)            	# [7] _cray_clist+24
	movq %rax,48(%rsp)            	# [7] _cray_clist+32
	leaq 112(%rsp),%rsi           	# [8] _cray_iolist_1
	movq %rax,56(%rsp)            	# [8] _cray_clist+40
	movq %rax,64(%rsp)            	# [8] _cray_clist+48
	leaq 192(%rsp),%rdx           	# [9] _temp_stack_space_type1
	movq %rax,72(%rsp)            	# [9] _cray_clist+56
	movq %rax,80(%rsp)            	# [9] _cray_clist+64
	movq %rax,88(%rsp)            	# [10] _cray_clist+72
	movq %rax,96(%rsp)            	# [10] _cray_clist+80
	.globl	_FWF
	call _FWF                     	# [10] _FWF
.LBB7_TEST1.in.TESTS:
	jmp .Lt_0_1026                	# [0] 
.LDWend_TEST1.in.TESTS:
	.size TEST1.in.TESTS, .LDWend_TEST1.in.TESTS-TEST1.in.TESTS

	.section .data
	.org 0x0
	.align	0
.globl	__pathscale_compiler
	.type	__pathscale_compiler, @object
	.size	__pathscale_compiler, 37
__pathscale_compiler:	# 0x0
	# offset 0
	.string "/home/sidjana/opt/openuh//bin/opencc"
	# end of initialization for __pathscale_compiler

	.section .rodata
	.org 0x0
	.align	0
	# offset 0
	.byte	0x74, 0x20, 0x3d, 0x20	# t = 
	.section .text
	.p2align 5,,

	# Program Unit: tests_
.globl	tests_
	.type	tests_, @function
tests_:	# 0xf8
	# .frame	%rsp, 8, %rsp
	.loc	1	4	0
.LBB1_tests_:
	ret                           	# [0] 
.LDWend_tests_:
	.size tests_, .LDWend_tests_-tests_
