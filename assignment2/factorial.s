# A COPY OF ASSIGNMENT 1. TO BE CHANGED
.data
message:    .asciz "Hi, We're Steven Liu (NetID: stevenliu) and Egor Yapparov (NetID: eyapparov). This is our submission for Assignment 1: Powers\n"
question1:  .asciz "Enter base number: "
question2:  .asciz "Enter power number: "
answer:     .asciz "That would be: %lu\n"
ph:         .asciz "%d"

base:       .quad 0
power:      .quad 0
result:     .quad 0

.text 

.global main
main: 
    #!PROLOGUE!
	pushq	%rbp		        # push base pointer
	movq	%rsp, %rbp	        # copy stack pointer to base pointer

    movq    $message, %rdi		#moving our text into the first parameter register
    call    printf

	#!FIRST NUMBER INPUT!
	movq	$question1, %rdi	#moving our text into the first parameter register
	call	printf
    mov     $ph, %rdi           #moving the format of inputed data into rdi
    mov     $base, %rsi         #moving the label where the program needs to store data into rsi
    call    scanf

    #!SECOND NUMBER INPUT!	
	movq	$question2, %rdi	#moving our text into the first parameter register
	call	printf
    mov     $ph, %rdi			#moving the format of inputed data into rdi
    mov     $power, %rsi		#moving the label where the program needs to store data into rsi
    call    scanf

    #!FUNCTION CALL!	
    movq	base, %rdi          #moving base into rdi for our function
    movq    power, %rsi         #moving power into rsi for our function
	call	power_func			#calling our function
    movq    %rax, result		#moving our answer from rax into the label

    #!OUTPUT!
    mov $answer, %rdi			#moving our text into the first parameter register
    mov result, %rsi			#moving result into the second parameter register
    call printf

	#!EPILOGE!
	movq	%rbp, %rsp	        #pushing base pointer into stack pointer(discarding all the variables)
	popq	%rbp	            #returning to the previous stack position

	#!EXITING THE PROGHRAM!
	movq	$0, %rdi	        #moving 0 error code into the first parameter register
	call	exit


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
