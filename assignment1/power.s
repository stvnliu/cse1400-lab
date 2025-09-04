.text
message:	
	.asciz "Hi, We're Steven Liu (NetID: stevenliu) and Egor Yapparov (NetID: eyapparov). This is our submission for Assignment 1: Powers\n"
result:
	.asciz "The result of the power calculation is: %d\n";
.global main
main:
	pushq	%rbp		# push base pointer
	movq	%rsp, %rbp	# copy stack pointer to base pointer ??
	movq	$0, %rax
	movq	$message, %rdi
	call	printf
	movq	%rbp, %rsp	# ??
	movq	$2, %rdi
	movq	$10, %rsi
	call	power
	movq	$result, %rdi
	movq	%rax, %rsi
	call	printf

end:
	popq	%rbp
	movq	$0, %rdi
	call	exit
power:
	pushq	%rbp
	movq	%rdi, %rbx	# first parameter into rbx
	movq	$1, %rax	# 1 (n^0) stored in rax
	movq	%rsi, %rcx	# exponent into rcx
power_1:imul	%rbx, %rax	# integer multiply
	dec	%rcx
	cmp	$0, %rcx
	jne	power_1
	popq	%rbp
	ret

