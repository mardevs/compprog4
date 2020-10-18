
myopen:
.LFB11:
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	call	__errno_location
	movl	16(%esp), %edx		// ordem das instruções movl foi modificada
	movl	20(%esp), %edi
	movl	%eax, %esi			// o primeiro movl agora é o último antes do comando asm
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
	popl	%esi
	popl	%edi
	ret

.LFE11:

myread:
.LFB12:
	subl	$16, %esp
	pushl	$128
	pushl	28(%esp)
	pushl	28(%esp)
	call	read
	addl	$28, %esp
	ret

.LFE12:

mywrite:
.LFB13:
								// diferentemente da otimização -O1, a otimização -O2
								// não executa o 'pushl' dos parâmetros para a função 'write',
	jmp	write					// já que não é realizado um 'call' para a função 'write' e sim
								// um 'jmp'. Os parâmetros que a função 'write' encontrará na pilha 
								// serão os mesmos que foram passados na chamada contida na main.
								// Uma vez que o 'jmp' foi executado, não é necessário uma instrução
								// 'ret' em 'mywrite', dado que quando a função 'write' executar a
								// sua instrução 'ret', ela voltará diretamente para a main.
.LFE13:

myclose:
.LFB14:
	jmp	close					// a mesma explicação da função 'mywrite' se aplica aqui
.LFE14:

.LC0:
	.string	"forma correta: %s <nomearquivo>\n"
.LC1:
	.string	"abertura de arquivo"
.LC2:
	.string	"escrita:"
main:
.LFB15:
	leal	4(%esp), %ecx
	andl	$-16, %esp
	pushl	-4(%ecx)
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	pushl	%ecx
	subl	$152, %esp
	movl	4(%ecx), %eax
	movl	%gs:20, %edx
	movl	%edx, -28(%ebp)
	xorl	%edx, %edx
	cmpl	$2, (%ecx)
	je	.L9						// o nome das labels é diferente
	pushl	%ecx				// ao invés de abrir 4 bytes na pilha, o compilador
								// empilhou o valor de %ecx, somente para preencher
								// um espaço de 4 bytes na pilha pois a instrução 
								//'pushl %ecx' é codificada com menos bytes que a
								// instrução 'subl $4, %esp'
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
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	leal	-4(%ecx), %esp
	ret
.L9:
	pushl	%edx				// 'pushl' de %edx realizado duas vezes
								// para substituir um 'subl $8, %esp'
								// como descrito acima.

	leal	-156(%ebp), %esi    // instrução movida para cima

	pushl	%edx				// 'pushl' de %edx realizado duas vezes
								// para substituir um 'subl $8, %esp'
								// como descrito acima.
	pushl	$0
	pushl	4(%eax)
	call	myopen
	addl	$16, %esp         	// 'movl' e 'addl' tiveram ordem invertidas
	movl	%eax, %edi
	testl	%eax, %eax
	jns	.L11					// a comparação com a flag de sinal é negada,
								// fazendo com que os blocos de código sejam invertidos.
								
								// o bloco a seguir equivale ao bloco .L19 do -O1
	subl	$12, %esp
	pushl	$.LC1
	call	perror
	addl	$16, %esp
	movl	$1, %eax
	jmp	.L8
.L12:
	subl	$4, %esp
	pushl	%ebx
	pushl	%esi
	pushl	$1
	call	write
	addl	$16, %esp
	cmpl	%ebx, %eax
	jne	.L19
.L11:							// o bloco a seguir equivale ao .L12 do -O1
								// o compilador realizou inline da função 'myread'
	subl	$4, %esp			// em vez de abrir 8 espaços, são abertos 4 pois
								// será passado mais um parâmetro
	pushl	$128				// o parâmetro 'TAM' também é passado para a função 'read'
	pushl	%esi
	pushl	%edi
	call	read				// a função read é chamada em vez da 'myread'
	addl	$16, %esp			// inverteu a ordem das instruções 'movl' e 'addl'
	movl	%eax, %ebx
	testl	%eax, %eax
	jg	.L12					// o teste de menor ou igual é trocado por um teste de
								// maior que, invertendo a ordem dos blocos mais uma vez
								// o bloco a seguir equivale ao .L20 em -O1
	subl	$12, %esp
	pushl	%edi
	call	close				// a função 'close' é chamada ao invés da 'myclose'
	addl	$16, %esp
	xorl	%eax, %eax			// é executado um 'xorl' de %eax com ele mesmo para zerá-lo
								// ao invés de passar o valor '0' para %eax utilizando a 
								// instrução 'movl'. Isso é realizado pois a instrução
								// 'xorl %eax, %eax' é codificada com menos bytes que a
								// instrução 'movl $0, %eax'
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
.LFE15:
	.ident	"GCC: (GNU) 10.2.0"
