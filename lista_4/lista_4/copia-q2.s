	.file	"copia-q2.c"
	.text
	.globl	myread
	.type	myread, @function
myread:
.LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	subl	$4, %esp
	pushl	$128
	pushl	12(%ebp)
	pushl	8(%ebp)
	call	read
	addl	$16, %esp
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	myread, .-myread
	.globl	mywrite
	.type	mywrite, @function
mywrite:
.LFB1:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	subl	$4, %esp
	pushl	16(%ebp)
	pushl	12(%ebp)
	pushl	8(%ebp)
	call	write
	addl	$16, %esp
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	mywrite, .-mywrite
	.globl	myclose
	.type	myclose, @function
myclose:
.LFB2:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	subl	$12, %esp
	pushl	8(%ebp)
	call	close
	addl	$16, %esp
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE2:
	.size	myclose, .-myclose
	.section	.rodata
	.align 4
.LC0:
	.string	"forma correta: %s <nomearquivo>\n"
.LC1:
	.string	"abertura de arquivo"
.LC2:
	.string	"escrita:"
	.text
	.globl	main
	.type	main, @function
main:
.LFB3:
	.cfi_startproc
	leal	4(%esp), %ecx
	.cfi_def_cfa 1, 0
	andl	$-16, %esp
	pushl	-4(%ecx)
	pushl	%ebp
	.cfi_escape 0x10,0x5,0x2,0x75,0
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	pushl	%ecx
	.cfi_escape 0xf,0x3,0x75,0x70,0x6
	.cfi_escape 0x10,0x7,0x2,0x75,0x7c
	.cfi_escape 0x10,0x6,0x2,0x75,0x78
	.cfi_escape 0x10,0x3,0x2,0x75,0x74
	subl	$168, %esp
	movl	%ecx, %eax
	movl	4(%eax), %edx
	movl	%edx, -172(%ebp)
	movl	%gs:20, %ebx
	movl	%ebx, -28(%ebp)
	xorl	%ebx, %ebx
	cmpl	$2, (%eax)
	je	.L8
	movl	-172(%ebp), %eax
	movl	(%eax), %edx
	movl	stderr, %eax
	subl	$4, %esp
	pushl	%edx
	pushl	$.LC0
	pushl	%eax
	call	fprintf
	addl	$16, %esp
	movl	$1, %eax
	jmp	.L13
.L8:
	movl	-172(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, -168(%ebp)
	call	__errno_location
	movl	%eax, %edx
	movl	-168(%ebp), %esi
	movl	$0, %edi
#APP
# 29 "copia-q2.c" 1
	movl $5, %eax
	movl %esi, %ebx
	movl %edi, %ecx
	int $0x80
	cmpl $0, %eax
	jge 1f
	movl $2, %esi
	1:
	movl %eax, %edi 
	
# 0 "" 2
#NO_APP
	movl	%edi, -164(%ebp)
	movl	%esi, (%edx)
	cmpl	$0, -164(%ebp)
	jns	.L11
	subl	$12, %esp
	pushl	$.LC1
	call	perror
	addl	$16, %esp
	movl	$1, %eax
	jmp	.L13
.L12:
	movl	-160(%ebp), %eax
	subl	$4, %esp
	pushl	%eax
	leal	-156(%ebp), %eax
	pushl	%eax
	pushl	$1
	call	mywrite
	addl	$16, %esp
	cmpl	%eax, -160(%ebp)
	je	.L11
	subl	$12, %esp
	pushl	$.LC2
	call	perror
	addl	$16, %esp
	movl	$1, %eax
	jmp	.L13
.L11:
	subl	$8, %esp
	leal	-156(%ebp), %eax
	pushl	%eax
	pushl	-164(%ebp)
	call	myread
	addl	$16, %esp
	movl	%eax, -160(%ebp)
	cmpl	$0, -160(%ebp)
	jg	.L12
	subl	$12, %esp
	pushl	-164(%ebp)
	call	myclose
	addl	$16, %esp
	movl	$0, %eax
.L13:
	movl	-28(%ebp), %ecx
	subl	%gs:20, %ecx
	je	.L14
	call	__stack_chk_fail
.L14:
	leal	-16(%ebp), %esp
	popl	%ecx
	.cfi_restore 1
	.cfi_def_cfa 1, 0
	popl	%ebx
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%edi
	.cfi_restore 7
	popl	%ebp
	.cfi_restore 5
	leal	-4(%ecx), %esp
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE3:
	.size	main, .-main
	.ident	"GCC: (GNU) 10.2.0"
	.section	.note.GNU-stack,"",@progbits
