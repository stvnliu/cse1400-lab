# A COPY OF ASSIGNMENT 1. TO BE CHANGED
.data
message:
	.asciz "Hi, We're Steven Liu (NetID: stevenliu) and Egor Yapparov (NetID: eyapparov). This is our submission for Assignment 1: Powers\n"
question:
	.asciz "Factorial of: "
dbg_process:
	.asciz "Calculating factorial of: %d\n"
answer:
	.asciz "Final result: %d\n"
entry:
	.asciz "%d"
fact_base:
	.quad 0
.text
.global main
main: 
	#!PROLOGUE!
	pushq	%rbp		        # push base pointer
	movq	%rsp, %rbp	        # copy stack pointer to base pointer

	movq    $message, %rdi		#moving our text into the first parameter register
	call    printf

	#!FIRST NUMBER INPUT!
	movq	$question, %rdi		# moving our text into the first parameter register
	call	printf
	mov     $entry, %rdi		# moving the format of inputed data into rdi
	mov     $fact_base, %rsi	# moving the label where the program needs to store data into rsi
	call    scanf

	#!FUNCTION CALL!	
	movq	fact_base, %rdi		# moving base into rdi for our function
	call	factorial
	#!OUTPUT!
	mov $answer, %rdi		# moving our text into the first parameter register
	mov %rax, %rsi			# moving result into the second parameter register
	call printf

	#!EPILOGE!
	movq	%rbp, %rsp		# pushing base pointer into stack pointer(discarding all the variables)
	popq	%rbp			# returning to the previous stack position

	#!EXITING THE PROGHRAM!
	movq	$0, %rdi		# moving 0 error code into the first parameter register
	call	exit

factorial:
	pushq	%rbp
	movq	%rsp, %rbp		# --- function prelog done
	subq	$16, %rsp		# we subtract the rsp by 2 * quadword = 16, even though we only need 1qw, because it needs to be 16-bit aligned
	movq	%rdi, -8(%rbp)		# "stash" the param in -8 mem location

	# DEBUG PRINT
	movq	%rdi, %rsi		# --- DEBUG Printing each step of factorial --- copying rdi as the second printf param
	movq	$dbg_process, %rdi	# copy message string
	call	printf			# debug printf
	movq	-8(%rbp), %rdi		# Restoring %rdi value after print
	
	# If current "factorial base number" is 0, we reach base condition
	cmpq	$0, -8(%rbp)
	jne	fact_recurse
fact_0:
	# Base condition
	movq	$1, %rax		# copy 1 into return register %rax, such that 0! = 1
	jmp	end			# skip to epilog
fact_recurse:
	# Recurse condition
	dec	%rdi			# we manipulate the param to decrement, such that n! = n * (n-1)!
	call	factorial		# compute (n-1)!
	imul	-8(%rbp), %rax		# compute n * (n-1)! where (n-1)! -> %rax, n -> -8(%rbp)
end:
	# -- Function EPILOG --
	addq	$16, %rsp		# drop local variables
	movq	%rbp, %rsp		# restore stack pointer
	popq	%rbp			# pop base pointer
	ret				# break out of function & return to caller
.section .note.GNU-stack,"",@progbits	# random command to make gcc happy
