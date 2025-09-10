.text
charline: .asciz "%c"
base_index:
	.quad 0
.include "final.s"

.global main

# ************************************************************
# Subroutine: decode                                         *
# Description: decodes message as defined in Assignment 3    *
#   - 2 byte unknown                                         *
#   - 4 byte index                                           *
#   - 1 byte amount                                          *
#   - 1 byte character                                       *
# Parameters:                                                *
#   first: the address of the message to read                *
#   return: no return value                                  *
# ************************************************************
decode_line:
	# prologue
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer
	subq	$32, %rsp
	movq	(%rdi), %rcx
	movq	%rcx, -8(%rbp)
	movq	%rcx, -16(%rbp)
	movq	%rcx, -24(%rbp)

	movq	$0xFFFFFFFF0000, %rsi
	andq	%rsi, -8(%rbp)
	shrq	$16, -8(%rbp)

	movq	$0x00000000FF00, %rsi
	andq	%rsi, -16(%rbp)
	shrq	$8, -16(%rbp)

	movq	$0x0000000000FF, %rsi
	andq	%rsi, -24(%rbp)
	# no shift right
	
	// movq	$dbg_mask, %rdi
	// movq	-8(%rbp), %rsi
	// call	printf

	# amount
	// movq	$dbg_mask, %rdi
	// movq	-16(%rbp), %rsi
	// call	printf

putchar:
	movq	$charline, %rdi
	movq	-24(%rbp), %rsi
	call	printf
	decq	-16(%rbp)			# amount decrease by 1
	cmpq	$0, -16(%rbp)
	jne		putchar
dec_end:
	# epilogue
	movq	-8(%rbp), %rax
	addq	$32, %rsp
	movq	%rbp, %rsp		# clear local variables from stack
	popq	%rbp			# restore base pointer location 
	ret
decode:
	# prologue
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer
	subq	$16, %rsp
	movq	%rdi, -16(%rbp)
	movq	%rdi, -8(%rbp)
dec_loop:
	movq	-8(%rbp), %rdi
	call	decode_line
	imul	$8, %rax
	movq	-16(%rbp), %rdx
	addq	%rax, %rdx
	movq	%rdx, -8(%rbp)
	// movq	-8(%rbp), %rdx
	// addq	%rax, %rdx
	// movq	%rdx, -8(%rbp)
	cmpq	$0, %rax
	jne 	dec_loop
decode_end:
	# epilogue
	addq	$16, %rsp
	movq	%rbp, %rsp		# clear local variables from stack
	popq	%rbp			# restore base pointer location 
	ret

main:
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer

	movq	$MESSAGE, %rdi	# first parameter: address of the message
	call	decode			# call decode

	popq	%rbp			# restore base pointer location 
	movq	$0, %rdi		# load program exit code
	call	exit			# exit the program

