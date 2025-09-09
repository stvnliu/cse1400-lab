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


.text
# debug strings
// dbg_mask: .asciz "Masked: %.16x\n"
// dbg_addr: .asciz "using address %.16x\n"
// dbg_offset: .asciz "next offset: %d\n"
// dbg_orig: .asciz "whereas message start is %.16x\n" 

charline: .asciz "%c"
base_index:
	.quad 0
.include "final.s"


########
#!MAIN!#
########
.global main
main:
	pushq	%rbp 					# push the base pointer (and align the stack)
	movq	%rsp, %rbp				# copy stack pointer value to base pointer

	movq	$MESSAGE, %rdi			# first parameter: address of the message
	call	decode					# call our function

	popq	%rbp					# restore base pointer location 
	movq	$0, %rdi				# load program exit code
	call	exit					# exit the program


################
#!OUR FUNCTION!#
################
decode:
	#prologue
	pushq	%rbp 					# push the base pointer (and align the stack)
	movq	%rsp, %rbp				# copy stack pointer value to base pointer
	subq	$16, %rsp				# giving space for 2 8 bit values in stack
	movq	%rdi, -8(%rbp)			# copying the message adress into stack as first adress that we need to decode
	movq	%rdi, -16(%rbp)			# copying the message adress into stack to remember it
dec_loop:
	#the loop that calls decode_line until there are no more lines to decode
	movq	-8(%rbp), %rdi			# copying the adress of the line we want to decode into first parameter register
	call	decode_line
	imul	$8, %rax				# calculating the displacement from the starting adress for the next decode_line call(8 bytes*the next adress)
	movq	-16(%rbp), %rdx			# copying the message adress into the rdx
	addq	%rax, %rdx				# calculating the final adress for the next decode_line call(the starting adress + displacement)
	movq	%rdx, -8(%rbp)			# moving the final adress for the next decode_line call into stack
	cmpq	$0, %rax				# comparing the displacement with 0
	jne 	dec_loop				# if dispacment is 0 start the epilouge, otherwise start decoding the next line
decode_end:
	# epilogue
	addq	$16, %rsp				# freeing the stack space
	movq	%rbp, %rsp				# clear local variables from stack
	popq	%rbp					# restore base pointer location 
	ret


######################################
#!A FUNCTION TO DECODE A SINGLE LINE!#
######################################
decode_line:
	# prologue
	pushq	%rbp 					# push the base pointer (and align the stack)
	movq	%rsp, %rbp				# copy stack pointer value to base pointer

	# preparing 3 values for masking
	subq	$32, %rsp				# giving space for 3 8 bit values in stack(3x8 = 24 + 8 to be 16 byte alligned)
	movq	(%rdi), %rcx			# moving the binary value into rcx
	movq	%rcx, -8(%rbp)			# copying it to stack 3 times
	movq	%rcx, -16(%rbp)
	movq	%rcx, -24(%rbp)

	# masking and shifting the values
	movq	$0xFFFFFFFF0000, %rsi	# the next adress(relative to the starting one)
	andq	%rsi, -8(%rbp)
	shrq	$16, -8(%rbp)

	movq	$0x00000000FF00, %rsi	# amount
	andq	%rsi, -16(%rbp)
	shrq	$8, -16(%rbp)

	movq	$0x0000000000FF, %rsi	# character (its ASCII code)
	andq	%rsi, -24(%rbp)
	# no shift right
putchar:
	#printing a character a single time
	movq	$charline, %rdi			# moving our text(which is a single character specified in the next row) into the first parameter register
	movq	-24(%rbp), %rsi			# moving our character into the second parameter register
	call	printf

	#looping logic
	decq	-16(%rbp)				# amount decrease by 1
	cmpq	$0, -16(%rbp)			# compare zero and amount
	jne		putchar					# if amount > 0 repeat the putchar
decode_line_end:
	#epilogue
	movq	-8(%rbp), %rax			# moving the next adress into rax register to return it
	addq	$32, %rsp				# freeing the stack space
	movq	%rbp, %rsp				# clear local variables from stack
	popq	%rbp					# restore base pointer location 
	ret

.section .note.GNU-stack,"",@progbits	# random command to make gcc happy
