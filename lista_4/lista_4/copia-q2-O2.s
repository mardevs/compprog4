	.file	"copia-q2.c"
	.text
	.p2align 4
	.globl	myread
	.type	myread, @function
myread:
.LFB11:
	.cfi_startproc
	subl	$16, %esp
	.cfi_def_cfa_offset 20
	pushl	$128
	.cfi_def_cfa_offset 24
	pushl	28(%esp)
	.cfi_def_cfa_offset 28
	pushl	28(%esp)
	.cfi_def_cfa_offset 32
	call	read
	addl	$28, %esp
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
.LFE11:
	.size	myread, .-myread
	.p2align 4
	.globl	mywrite
	.type	mywrite, @function
mywrite:
.LFB12:
	.cfi_startproc
	jmp	write
	.cfi_endproc
.LFE12:
	.size	mywrite, .-mywrite
	.p2align 4
	.globl	myclose
	.type	myclose, @function
myclose:
.LFB13:
	.cfi_startproc
	jmp	close
	.cfi_endproc
.LFE13:
	.size	myclose, .-myclose
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align 4
.LC0:
	.string	"forma correta: %s <nomearquivo>\n"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC1:
	.string	"abertura de arquivo"
.LC2:
	.string	"escrita:"
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB14:
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
	subl	$152, %esp
	movl	4(%ecx), %ebx
	movl	%gs:20, %eax
	movl	%eax, -28(%ebp)
	xorl	%eax, %eax
	cmpl	$2, (%ecx)
	jne	.L16
	call	__errno_location
	xorl	%esi, %esi
	movl	4(%ebx), %edx
	movl	%eax, %edi
#APP
# 29 "copia-q2.c" 1
	movl $5, %eax
	movl %edx, %ebx
	movl %esi, %ecx
	int $0x80
	cmpl $0, %eax
	jge 1f
	movl $2, %edx
	1:
	movl %eax, %esi 
	
# 0 "" 2
#NO_APP
	movl	%edx, (%edi)
	leal	-156(%ebp), %edi
	testl	%esi, %esi
	jns	.L9
	jmp	.L17
	.p2align 4,,10
	.p2align 3
.L10:
	subl	$4, %esp
	pushl	%ebx
	pushl	%edi
	pushl	$1
	call	write
	addl	$16, %esp
	cmpl	%ebx, %eax
	jne	.L18
.L9:
	subl	$4, %esp
	pushl	$128
	pushl	%edi
	pushl	%esi
	call	read
	addl	$16, %esp
	movl	%eax, %ebx
	testl	%eax, %eax
	jg	.L10
	subl	$12, %esp
	pushl	%esi
	call	close
	addl	$16, %esp
	xorl	%eax, %eax
.L6:
	movl	-28(%ebp), %edx
	subl	%gs:20, %edx
	jne	.L19
	leal	-16(%ebp), %esp
	popl	%ecx
	.cfi_remember_state
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
.L16:
	.cfi_restore_state
	pushl	%eax
	pushl	(%ebx)
	pushl	$.LC0
	pushl	stderr
	call	fprintf
	addl	$16, %esp
	movl	$1, %eax
	jmp	.L6
.L18:
	subl	$12, %esp
	pushl	$.LC2
	call	perror
	addl	$16, %esp
	movl	$1, %eax
	jmp	.L6
.L17:
	subl	$12, %esp
	pushl	$.LC1
	call	perror
	addl	$16, %esp
	movl	$1, %eax
	jmp	.L6
.L19:
	call	__stack_chk_fail
	.cfi_endproc
.LFE14:
	.size	main, .-main
	.ident	"GCC: (GNU) 10.2.0"
	.section	.note.GNU-stack,"",@progbits
