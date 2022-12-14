extern printf
extern  atoi 
global main 
section .data 

fmti : db "%i", 10, 0
fmtli : db "%li", 10, 0
fmtlf : db "%lf", 10, 0
fmtf : db "%f", 10, 0
fmtc : db "%c", 10, 0
argc : dq 0
argv : dq 0
const0_32: dd 5.0
const0_64: dq 5.0
const1_32: dd 4.5
const1_64: dq 4.5
const2_32: dd 2.0
const2_64: dq 2.0
const3_32: dd 4.8
const3_64: dq 4.8
const4_32: dd 0.05
const4_64: dq 0.05
const5_32: dd 3.8
const5_64: dq 3.8


section .bss
ans32 : resd 1
ans64 : resq 1

book.bookId : resd 1 
book.title : resb 1 
book.rating : resd 1 
book.critRating : resq 1 
book.profit : resq 1 
getNewBook.bookId : resd 1 
getNewBook.title : resb 1 
getNewBook.rating : resd 1 
getNewBook.critRating : resq 1 
getNewBook.profit : resq 1 
newBook.bookId : resd 1 
newBook.title : resb 1 
newBook.rating : resd 1 
newBook.critRating : resq 1 
newBook.profit : resq 1 
book1.bookId : resd 1 
book1.title : resb 1 
book1.rating : resd 1 
book1.critRating : resq 1 
book1.profit : resq 1 
book2.bookId : resd 1 
book2.title : resb 1 
book2.rating : resd 1 
book2.critRating : resq 1 
book2.profit : resq 1 
i : resd 1 
c :resb 1 
f : resd 1 
l : resq 1 
myNewBook.bookId : resd 1 
myNewBook.title : resb 1 
myNewBook.rating : resd 1 
myNewBook.critRating : resq 1 
myNewBook.profit : resq 1 



section .text


printBook:
    push rbp
    mov rbp,rsp
    
        
    	mov rax, [book.bookId]

    mov rdi, fmti
    mov rsi, rax
    mov rax, 1
    call printf

    	mov rax, [book.title]

    mov rdi, fmtc
    mov rsi, rax
    mov rax, 1
    call printf

    	mov rax, [book.rating]
mov [ans32], rax

    mov rdi, fmtf
    fld	dword [ans32]
    fstp qword [ans64]
    movq xmm0, qword [ans64]
    mov rax, 1
    call printf

    	mov rax, [book.critRating]
mov [ans64], rax

    mov rdi, fmtlf
    movq xmm0, qword [ans64]
    mov rax, 1
    call printf

    	mov rax, [book.profit]

    mov rdi, fmti
    mov rsi, rax
    mov rax, 1
    call printf

        leave
        ret

getNewBook:
    push rbp
    mov rbp,rsp
    mov rax, 13
	mov [newBook.bookId], rax
mov rax, 'n'
	mov [newBook.title], rax

    mov rax, [const0_32]
    mov [ans32], rax
    mov rax, [const0_64]
    mov [ans64], rax
	mov rax, [ans32]
	mov [newBook.rating], rax

    mov rax, [const1_32]
    mov [ans32], rax
    mov rax, [const1_64]
    mov [ans64], rax
	mov rax, [ans64]
	mov [newBook.critRating], rax
mov rax, 1000000
	mov [newBook.profit], rax

    
    mov rax, [newBook.bookId]
    
    
    mov [getNewBook.bookId], rax

    mov rax, [newBook.title]
    
    
    mov [getNewBook.title], rax

    mov rax, [newBook.rating]
    mov [ans32], rax
    mov rax, [ans32]
    mov [getNewBook.rating], rax

    mov rax, [newBook.critRating]
    mov [ans64], rax
    mov rax, [ans64]
    mov [getNewBook.critRating], rax

    mov rax, [newBook.profit]
    
    
    mov [getNewBook.profit], rax

    leave
    ret

get2:
    push rbp
    mov rbp,rsp
    
    
    mov rax, [const2_32]
    mov [ans32], rax
    mov rax, [const2_64]
    mov [ans64], rax

    leave
    ret

get5:
    push rbp
    mov rbp,rsp
    
    mov rax, 5

    leave
    ret


main : 
    push rbp
    mov [argc], rdi 
    mov [argv ], rsi
     
    mov rax, 15
	mov [book1.bookId], rax
mov rax, 20
	mov [book2.bookId], rax

    	mov rax, [book2.bookId]

    push rax
    	mov rax, [book1.bookId]

    pop rbx
    add rax, rbx
	mov [i], rax

    mov rax, [i]

    mov rdi, fmti
    mov rsi, rax
    mov rax, 1
    call printf
mov rax, 'a'
	mov [c], rax

    mov rax, 3

    push rax
    mov rax, [c]

    pop rbx
    add rax, rbx
	mov [book2.title], rax

    mov rax, 4

    push rax
    mov rax, 't'

    pop rbx
    sub rax, rbx
	mov [book1.title], rax

    	mov rax, [book1.title]

    mov rdi, fmtc
    mov rsi, rax
    mov rax, 1
    call printf

    	mov rax, [book2.title]

    mov rdi, fmtc
    mov rsi, rax
    mov rax, 1
    call printf

    mov rax, [const3_32]
    mov [ans32], rax
    mov rax, [const3_64]
    mov [ans64], rax
	mov rax, [ans32]
	mov [f], rax
mov rax, [f]
	mov [ans32], rax
	mov rax, [ans32]
	mov [book1.rating], rax

    mov rax, [f]
	mov [ans32], rax

    fld dword [ans32]
    
    mov rax, [const4_32]
    mov [ans32], rax
    mov rax, [const4_64]
    mov [ans64], rax

    fsub qword [ans64]
    fst dword [ans32]
    fstp qword [ans64]
	mov rax, [ans64]
	mov [book1.critRating], rax
	mov rax, [book1.critRating]
mov [ans64], rax
	mov rax, [ans64]
	mov [book2.critRating], rax

    mov rax, [const5_32]
    mov [ans32], rax
    mov rax, [const5_64]
    mov [ans64], rax
	mov rax, [ans32]
	mov [book2.rating], rax

    	mov rax, [book1.rating]
mov [ans32], rax

    mov rdi, fmtf
    fld	dword [ans32]
    fstp qword [ans64]
    movq xmm0, qword [ans64]
    mov rax, 1
    call printf

    	mov rax, [book1.critRating]
mov [ans64], rax

    mov rdi, fmtlf
    movq xmm0, qword [ans64]
    mov rax, 1
    call printf

    	mov rax, [book2.rating]
mov [ans32], rax

    mov rdi, fmtf
    fld	dword [ans32]
    fstp qword [ans64]
    movq xmm0, qword [ans64]
    mov rax, 1
    call printf

    	mov rax, [book2.critRating]
mov [ans64], rax

    mov rdi, fmtlf
    movq xmm0, qword [ans64]
    mov rax, 1
    call printf

    mov rax, 12345667

    push rax
    mov rax, [i]

    pop rbx
    add rax, rbx
	mov [l], rax

    	mov rax, [book1.bookId]

    push rax
    mov rax, [l]

    pop rbx
    sub rax, rbx
	mov [book1.profit], rax

    mov rax, 100000

    push rax
    	mov rax, [book1.profit]

    pop rbx
    sub rax, rbx
	mov [book2.profit], rax

    mov rax, [l]

    mov rdi, fmti
    mov rsi, rax
    mov rax, 1
    call printf

    	mov rax, [book1.profit]

    mov rdi, fmti
    mov rsi, rax
    mov rax, 1
    call printf

    	mov rax, [book2.profit]

    mov rdi, fmti
    mov rsi, rax
    mov rax, 1
    call printf

    mov rax, [book1.bookId]
    
    
    mov [book.bookId], rax

    mov rax, [book1.title]
    
    
    mov [book.title], rax

    mov rax, [book1.rating]
    mov [ans32], rax
    mov rax, [ans32]
    mov [book.rating], rax

    mov rax, [book1.critRating]
    mov [ans64], rax
    mov rax, [ans64]
    mov [book.critRating], rax

    mov rax, [book1.profit]
    
    
    mov [book.profit], rax
call printBook

    mov rax, [book2.bookId]
    
    
    mov [book1.bookId], rax

    mov rax, [book2.title]
    
    
    mov [book1.title], rax

    mov rax, [book2.rating]
    mov [ans32], rax
    mov rax, [ans32]
    mov [book1.rating], rax

    mov rax, [book2.critRating]
    mov [ans64], rax
    mov rax, [ans64]
    mov [book1.critRating], rax

    mov rax, [book2.profit]
    
    
    mov [book1.profit], rax

    mov rax, [book1.bookId]
    
    
    mov [book.bookId], rax

    mov rax, [book1.title]
    
    
    mov [book.title], rax

    mov rax, [book1.rating]
    mov [ans32], rax
    mov rax, [ans32]
    mov [book.rating], rax

    mov rax, [book1.critRating]
    mov [ans64], rax
    mov rax, [ans64]
    mov [book.critRating], rax

    mov rax, [book1.profit]
    
    
    mov [book.profit], rax
call printBook

    call get2

    mov rdi, fmtlf
    movq xmm0, qword [ans64]
    mov rax, 1
    call printf

    call get5

    mov rdi, fmti
    mov rsi, rax
    mov rax, 1
    call printf
call getNewBook

    mov rax, [getNewBook.bookId]
    
    
    mov [myNewBook.bookId], rax

    mov rax, [getNewBook.title]
    
    
    mov [myNewBook.title], rax

    mov rax, [getNewBook.rating]
    mov [ans32], rax
    mov rax, [ans32]
    mov [myNewBook.rating], rax

    mov rax, [getNewBook.critRating]
    mov [ans64], rax
    mov rax, [ans64]
    mov [myNewBook.critRating], rax

    mov rax, [getNewBook.profit]
    
    
    mov [myNewBook.profit], rax

    mov rax, [myNewBook.bookId]
    
    
    mov [book.bookId], rax

    mov rax, [myNewBook.title]
    
    
    mov [book.title], rax

    mov rax, [myNewBook.rating]
    mov [ans32], rax
    mov rax, [ans32]
    mov [book.rating], rax

    mov rax, [myNewBook.critRating]
    mov [ans64], rax
    mov rax, [ans64]
    mov [book.critRating], rax

    mov rax, [myNewBook.profit]
    
    
    mov [book.profit], rax
call printBook
 
    mov rax, 0
 
    mov rdi , fmti 
    mov rsi , rax
    call printf 
    pop rbp 
    ret 