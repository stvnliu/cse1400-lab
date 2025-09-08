# A COPY OF ASSIGNMENT 1. TO BE CHANGED
.data
message:    .asciz "Hi, We're Steven Liu (NetID: stevenliu) and Egor Yapparov (NetID: eyapparov). This is our submission for Assignment 1: Powers\n"
question:  .asciz "Factorial of: "
dbg_process:  .asciz "Calculating factorial of: %d\n"
answer:     .asciz "Final result: %d\n"
entry:         .asciz "%d"
fact_base:       .quad 0

.text 

.global main
main: 
    #!PROLOGUE!
	pushq	%rbp		        # push base pointer
	movq	%rsp, %rbp	        # copy stack pointer to base pointer

    movq    $message, %rdi		#moving our text into the first parameter register
    call    printf

	#!FIRST NUMBER INPUT!
	movq	$question, %rdi	#moving our text into the first parameter register
	call	printf
    mov     $entry, %rdi           #moving the format of inputed data into rdi
    mov     $fact_base, %rsi         #moving the label where the program needs to store data into rsi
    call    scanf

    #!FUNCTION CALL!	
    movq	fact_base, %rdi 	#moving base into rdi for our function
    call	factorial
    #!OUTPUT!
    mov $answer, %rdi			#moving our text into the first parameter register
    mov %rax, %rsi			#moving result into the second parameter register
    call printf

	#!EPILOGE!
	movq	%rbp, %rsp	        #pushing base pointer into stack pointer(discarding all the variables)
	popq	%rbp	            #returning to the previous stack position

	#!EXITING THE PROGHRAM!
	movq	$0, %rdi	        #moving 0 error code into the first parameter register
	call	exit

factorial:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	
	# DEBUG PRINT
	movq	%rdi, %rsi
	movq	$dbg_process, %rdi
	call	printf
	# Restoring %rdi value after print
	movq	-8(%rbp), %rdi


	cmpq	$0, -8(%rbp)
	jne	fact_recurse
fact_0:
	movq	$1, %rax
	jmp	end
fact_recurse:
	dec	%rdi
	call	factorial
	imul	-8(%rbp), %rax
end:
	addq	$16, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret



	#!OUR FUNCTION!
power_func:
    pushq   %rbp				#prolouge
    movq    %rsp, %rbp			#prolouge

    movq    %rdi, %rbx			#moving first argument(base) into rbx
    movq    $1, %rax			#moving 1 to rax, because it is anything to the power of 0
    movq    %rsi, %rcx			#moving second argument(power) into rcx

power_mul:						#start of the loop
    imul    %rbx, %rax			#multiplying rax(our result) by rbx(our base) and storing it in rax
    dec     %rcx				#rcx--
    cmp     $0, %rcx			#comparing rcx(power) to 0
    jne     power_mul			#if previous comparison is true(rcx(power) > 0) -> jump to the start of the loop

    movq	%rbp, %rsp 			#epilouge
	popq	%rbp				#epilouge
    ret							#epilouge




.section .note.GNU-stack,"",@progbits #make gcc happy
