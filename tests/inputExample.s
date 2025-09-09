.data

txt: .asciz "Hello Class!\n"
question: .asciz "Gief number\n"
answer: .asciz "That would be: %lu\n"
ph: .asciz "%d"

number: .quad 0

.text 

.global main
main: 
    push %rbp # якорь
    mov %rsp, %rbp   # prologue
    
    mov $txt, %rdi
    call printf

    mov $question, %rdi
    call printf

    mov $ph, %rdi
    mov $number, %rsi
    call scanf

    addq $42, number
    mov $answer, %rdi
    mov number, %rsi
    call printf

    mov $0, %rdi
    call exit

    mov %rbp, %rsp # очистка стека
    pop %rbp
    ret