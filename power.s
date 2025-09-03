.text
message:	.asciz "Hi, We're Steven Liu (NetID: stevenliu) and Egor Yapparov (NetID: eyapparov). This is our submission for Assignment 1: Powers\n"
.global main
main:
	pushq	%rbp		# push base pointer
	movq	%rsp, %rbp	# copy stack pointer to base pointer
	movq	$0, %rax
	movq	$message, %rdi
	call	printf
	movq	%rbp, %rsp
	popq	%rbp
	movq	$0, %rdi
	call	exit

pow:
	popq	
