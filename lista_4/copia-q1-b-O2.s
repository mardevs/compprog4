	.file	"copia-q1-b.c"
	.text
	.p2align 4
	.globl	myopen
	.type	myopen, @function
myopen:
.LFB11:
	.cfi_startproc
	pushl	%edi
	.cfi_def_cfa_offset 8
	.cfi_offset 7, -8
	pushl	%esi
	.cfi_def_cfa_offset 12
	.cfi_offset 6, -12
	pushl	%ebx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	call	__errno_location
	movl	16(%esp), %edx
	movl	20(%esp), %edi
	movl	%eax, %esi
#APP
# 9 "copia-q1-b.c" 1
	movl $5, %eax
	movl %edx, %ebx
	movl %edi, %ecx
	int $0x80
	cmpl $0, %eax
	jge 1f
	movl $2, %edi
	1:
	movl %eax, %edx 
	
# 0 "" 2
#NO_APP
	movl	%edi, (%esi)
	movl	%edx, %eax
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 12
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 8
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
.LFE11:
	.size	myopen, .-myopen
	.p2align 4
	.globl	myread
	.type	myread, @function
myread:
.LFB12:
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
.LFE12:
	.size	myread, .-myread
	.p2align 4
	.globl	mywrite
	.type	mywrite, @function
mywrite:
.LFB13:
	.cfi_startproc
	jmp	write
	.cfi_endproc
.LFE13:
	.size	mywrite, .-mywrite
	.p2align 4
	.globl	myclose
	.type	myclose, @function
myclose:
.LFB14:
	.cfi_startproc
	jmp	close
	.cfi_endproc
.LFE14:
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
.LFB15:
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
	movl	4(%ecx), %eax
	movl	%gs:20, %edx
	movl	%edx, -28(%ebp)
	xorl	%edx, %edx
	cmpl	$2, (%ecx)
	je	.L9
	pushl	%ecx
	pushl	(%eax)
	pushl	$.LC0
	pushl	stderr
	call	fprintf
	addl	$16, %esp
	movl	$1, %eax
.L8:
	movl	-28(%ebp), %edx
	subl	%gs:20, %edx
	jne	.L18
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
.L9:
	.cfi_restore_state
	pushl	%edx
	leal	-156(%ebp), %esi
	pushl	%edx
	pushl	$0
	pushl	4(%eax)
	call	myopen
	addl	$16, %esp
	movl	%eax, %edi
	testl	%eax, %eax
	jns	.L11
	subl	$12, %esp
	pushl	$.LC1
	call	perror
	addl	$16, %esp
	movl	$1, %eax
	jmp	.L8
	.p2align 4,,10
	.p2align 3
.L12:
	subl	$4, %esp
	pushl	%ebx
	pushl	%esi
	pushl	$1
	call	write
	addl	$16, %esp
	cmpl	%ebx, %eax
	jne	.L19
.L11:
	subl	$4, %esp
	pushl	$128
	pushl	%esi
	pushl	%edi
	call	read
	addl	$16, %esp
	movl	%eax, %ebx
	testl	%eax, %eax
	jg	.L12
	subl	$12, %esp
	pushl	%edi
	call	close
	addl	$16, %esp
	xorl	%eax, %eax
	jmp	.L8
.L19:
	subl	$12, %esp
	pushl	$.LC2
	call	perror
	addl	$16, %esp
	movl	$1, %eax
	jmp	.L8
.L18:
	call	__stack_chk_fail
	.cfi_endproc
.LFE15:
	.size	main, .-main
	.ident	"GCC: (GNU) 10.2.0"
	.section	.note.GNU-stack,"",@progbits
