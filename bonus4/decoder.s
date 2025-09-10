.text
// dbg_mask: .asciz "Masked: %x\n"
// dbg_addr: .asciz "using address %x\n"
// dbg_offset: .asciz "next offset: %d\n"
// dbg_orig: .asciz "whereas message start is %x\n"
charline: 
	.asciz "\033[38;5;%dm\033[48;5;%dm%c"
effectline:
	.asciz "\033[%dm%c"
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
effect:
reset:
	.quad 0
	.quad 0
blinkstop: 
	.quad 37
	.quad 25
bold: 
	.quad 42
	.quad 1
faint:
	.quad 66
	.quad 2
conceal:
	.quad 105
	.quad 8
reveal:
	.quad 153
	.quad 28
blink:
	.quad 182
	.quad 5

effect_match:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	$6, %rax
try_match_effect:
	leaq	effect(, %rax, 8), %rsi
	movq	(%rsi), %rsi
	movq	%rsi, -8(%rbp)
	cmpq	%rdi, -8(%rbp)	# match the effect code
	je	to_ansi
	decq	%rax
	cmpq	$0, %rax
	jne	try_match_effect
to_ansi:
	addq	$8, %rax
	movq	effect(%rax), %rax
	jmp	effect_match_end
effect_match_end:
	addq	$8, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
decode_line:
	# prologue
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer
	subq	$48, %rsp
	movq	(%rdi), %rcx
	movq	%rcx, -8(%rbp)		# next memory block selector mask
	movq	%rcx, -16(%rbp)		# amount selector mask
	movq	%rcx, -24(%rbp)		# character code selector mask
	movq	%rcx, -32(%rbp)		# ANSI escape code mask - bg
	movq	%rcx, -40(%rbp)		# ANSI escape code mask - fg
	
	movq	$0xFF00000000000000, %rsi
	andq	%rsi, -32(%rbp)
	shrq	$56, -32(%rbp)

	movq	$0x00FF000000000000, %rsi
	andq	%rsi, -40(%rbp)
	shrq	$48, -40(%rbp)
	movq	$0x0000FFFFFFFF0000, %rsi
	andq	%rsi, -8(%rbp)
	shrq	$16, -8(%rbp)

	movq	$0x000000000000FF00, %rsi
	andq	%rsi, -16(%rbp)
	shrq	$8, -16(%rbp)

	movq	$0x000000000000FF, %rsi
	andq	%rsi, -24(%rbp)
	# no shift right
	// movq	$dbg_mask, %rdi
	// movq	-40(%rbp), %rsi
	// call	printf

	# amount
	// movq	$dbg_mask, %rdi
	// movq	-32(%rbp), %rsi
	// call	printf

putchar:
	movq	-40(%rbp), %rax
	cmpq	%rax, -32(%rbp)
	jne	put_color
put_effect:
	movq	%rax, %rdi
	call	effect_match

	movq	$effectline, %rdi
	movq	%rax, %rsi
	movq	-24(%rbp), %rdx
	call	printf
	jmp	put_finish
put_color:
	movq	$charline, %rdi
	movq	-40(%rbp), %rsi
	movq	-32(%rbp), %rdx
	movq	-24(%rbp), %rcx
	call	printf
put_finish:
	decq	-16(%rbp)			# amount decrease by 1
	cmpq	$0, -16(%rbp)
	jne	putchar
dec_end:
	# epilogue
	movq	-8(%rbp), %rax
	addq	$48, %rsp
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

