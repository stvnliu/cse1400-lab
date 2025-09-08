.data
message: 	.asciz "Factorial of: "
inputstr:	.asciz "%d"
f:		.quad 0
message2:	.asciz "Computing factorial of %d...\n"
.text
.global main
main:
	pushq	%rbp
	movq	%rsp, %rbp		# prelog complete
	
	movq	$message, %rdi
	call	printf
	movq	$inputstr, %rdi
	movq	$f, %rsi
	call	scanf
	movq	$message2, %rdi
	movq	f, %rsi
	call	printf
	movq	%rbp, %rsp
	popq	%rbp			# epilog complete
	movq	$0, %rdi
	call	exit
factorial:
	pushq	%rbp
	movq	%rsp, %rbp

	


	movq	$rbp, %rsp
	popq	%rbp
	ret
