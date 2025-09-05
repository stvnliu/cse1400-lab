.text
message:	.asciz "Hi, We're Steven Liu (NetID: stevenliu) and Egor Yapparov (NetID: eyapparov). This is our submission for Assignment 1: Powers\n"
.global main
main:
	#!PROLOGUE!
	pushq	%rbp			#push base pointer
	movq	%rsp, %rbp		#copy stack pointer to base pointer

	#!ACTUAL PRINTNG!
	movq	$0, %rax		#not always necessary, sets the ammount of extra arguments for printf(not sure about this one)
	movq	$message, %rdi	#moving our text into the first parameter register
	call	printf

	#!EPILOGE!
	movq	%rbp, %rsp		#pushing base pointer into stack pointer(discarding all the variables)
	popq	%rbp			#returning to the previous stack position

	#!EXITING THE PROGHRAM!
	movq	$0, %rdi		#moving 0 error code into the first parameter register
	call	exit
