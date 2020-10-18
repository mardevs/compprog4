myopen:
.LFB11:
	pushl	%edi				// guardando na pilha valor atual dos registradores que serão usados na função 
	pushl	%esi				// guardando na pilha valor atual dos registradores que serão usados na função 
	pushl	%ebx				// guardando na pilha valor atual dos registradores que serão usados na função 
	call	__errno_location	// chama a função __errno_location para obter o endereço da localização de 'errno'.
								// 'errno' não está em uma posição fixa pois pode variar dependendo da thread
								// que está sendo executada.
								// Fonte : http://refspecs.linux-foundation.org/LSB_4.0.0/LSB-Core-generic/LSB-Core-generic/baselib---errno-location.html
	movl	%eax, %esi			// copia o endereço de 'errno' para %esi
	movl	16(%esp), %edx		// copia o primeiro parâmetro da função (pathname) para %edx, que é 
								// o registrador alocado pelo compilador para a entrada '[pn]'
	movl	20(%esp), %edi		// copia o segundo parâmetro da função (flags) para %edi, que é 
								// o registrador alocado pelo compilador para a entrada '[f]'
#APP 							// início do comando asm 
# 9 "copia-q1-b.c" 1
	movl $5, %eax				// a interrupção 0x80 com 'eax = 5' equivale à syscall 'open' 
	movl %edx, %ebx				// passa 'pathname' como primeiro parâmetro para a syscall 'open'
	movl %edi, %ecx				// passa o valor de 'flags' como segundo parâmetro para a syscall 'open'
	int $0x80					// executa a interrupção 0x80, realizando uma syscall 
	cmpl $0, %eax				// compara 'file descriptor' retornado pela syscall com 0. 
								// O retorno é negativo se não foi possível abrir o arquivo.
	jge 1f						// se foi aberto com sucesso, pula para a próxima instrução
	movl $2, %edi				// copia o valor '2' para %edi
	1:							
	movl %eax, %edx 			// copia o 'file descriptor' para %edx
	
# 0 "" 2
#NO_APP							// fim do comando asm
	movl	%edi, (%esi)		// copia o valor '2' para errno, caso o arquivo não tenha sido aberto com sucesso.
								// O registrador %edi foi alocado pelo compilador para a saída '[er]'
	movl	%edx, %eax			// copia o 'file descriptor' para o retorno da função. O registrador '%edx' foi
								// alocado pelo compilador para a saída '[fd]'
	popl	%ebx				// pegando de volta da pilha o valor dos registradores guardados no início da função
	popl	%esi				// pegando de volta da pilha o valor dos registradores guardados no início da função
	popl	%edi				// pegando de volta da pilha o valor dos registradores guardados no início da função
	ret							// retorna da função

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
	subl	$16, %esp
	pushl	28(%esp)
	pushl	28(%esp)
	pushl	28(%esp)
	call	write
	addl	$28, %esp
	ret

.LFE13:

myclose:

.LFB14:
	subl	$24, %esp
	pushl	28(%esp)
	call	close
	addl	$28, %esp
	ret

.LFE14:

.LC0:
	.string	"forma correta: %s <nomearquivo>\n"

.LC1:
	.string	"abertura de arquivo"

.LC2:
	.string	"escrita:"

main:

.LFB15:
	leal	4(%esp), %ecx		// coloca o endereço de 'argc' em %ecx
	andl	$-16, %esp			// alinha a pilha em um múltiplo de 16
	pushl	-4(%ecx)			// armazena o antigo valor de %esp na pilha
	pushl	%ebp				// registro de ativação da main
	movl	%esp, %ebp			// registro de ativação da main
	pushl	%edi				// guarda na pilha valor atual dos registradores que serão usados na função 
	pushl	%esi				// guarda na pilha valor atual dos registradores que serão usados na função 
	pushl	%ebx				// guarda na pilha valor atual dos registradores que serão usados na função 
	pushl	%ecx				// guarda na pilha valor atual dos registradores que serão usados na função 
	subl	$152, %esp			// abre um espaço de 152 bytes na pilha, dos quais 128 bytes pertencem à variável 'buf'
	movl	4(%ecx), %eax		// copia 'argv' para %eax
	movl	%gs:20, %edx		// copia em %edx o valor atual de [%gs:20] para realizar um teste de corrupção posteriormente
	movl	%edx, -28(%ebp)		// guarda na pilha o valor atual de [%gs:20]
	xorl	%edx, %edx			// zera %edx
	cmpl	$2, (%ecx)			// compara 'argc' com '2'
	je	.L10					// se 'argc' = 2, vai para .L10. Caso contrário :
	subl	$4, %esp			// abre 4 bytes na pilha	
	pushl	(%eax)				// passa como terceiro parâmetro 'argv[0]', ou seja, o nome do programa
	pushl	$.LC0				// passa como segundo parâmetro a string em .LC0
	pushl	stderr				// passa como primeiro parâmetro o file descriptor da saída padrão de erro
	call	fprintf				// chama a função 'fprintf'
	addl	$16, %esp			// libera 16 bytes da pilha
	movl	$1, %eax			// copia '1' para o retorno da main
.L9:
	movl	-28(%ebp), %edx		// copia para %edx o valor anterior de [%gs:20] guardado
	subl	%gs:20, %edx		// compara valor atual de [%gs:20] com o valor guardado anteriormente
	jne	.L18					// desvia para .L18 se houve estouro de pilha
	leal	-16(%ebp), %esp		// libera espaço da pilha fazendo-a voltar ao mesmo estado que estava após executar a 
	                            // instrução 'pushl	%ecx'.
	popl	%ecx				// pega de volta da pilha o valor dos registradores guardados no início da função
	popl	%ebx				// pega de volta da pilha o valor dos registradores guardados no início da função
	popl	%esi				// pega de volta da pilha o valor dos registradores guardados no início da função
	popl	%edi				// pega de volta da pilha o valor dos registradores guardados no início da função
	popl	%ebp				// pega de volta da pilha o valor dos registradores guardados no início da função
	leal	-4(%ecx), %esp		// devolve o antigo valor de %esp para a pilha
	ret							// retorna da função main

.L10:
	subl	$8, %esp			// abre 8 bytes na pilha
	pushl	$0					// passa '0' como segundo parâmetro. Sendo a constante 'O_RDONLY' igual a '0'
	pushl	4(%eax)				// passa 'arq[1]' (o nome do arquivo) como primeiro parâmetro
	call	myopen				// chama a função 'myopen' com os parâmetros 'pnome' e 'O_RDONLY'
	movl	%eax, %edi			// copia o 'file descriptor', ou 'arq', retornado para %edi
	addl	$16, %esp			// libera 16 bytes da pilha
	leal	-156(%ebp), %esi	// coloca o endereço de 'buf' em %esi
	testl	%eax, %eax			// checa se 'arq' < 0, realizando um and
	js	.L19					// se 'arq' < 0, pula para .L19

.L12:
	subl	$8, %esp			// abre 8 bytes na pilha
	pushl	%esi				// passa como segundo parâmetro o endereço de 'buf'
	pushl	%edi				// passa como primeiro parâmetro 'arq'
	call	myread				// chama a função 'myread' para ler até 128 bytes do arquivo 'arq' para o buffer 'buf'
	movl	%eax, %ebx			// copia o número de bytes lidos para %ebx
	addl	$16, %esp			// libera 16 bytes da pilha
	testl	%eax, %eax      	// checa se 'lidos' > 0, realizando um and
	jle	.L20					// se 'lidos' <= 0, pula para .L20 para terminar o loop
	subl	$4, %esp			// abre 4 bytes na pilha
	pushl	%ebx				// passa 'lidos' como terceiro parâmetro para a função 'write'
	pushl	%esi				// passa como segundo parâmetro o endereço de 'buf'
	pushl	$1					// passa '1', ou seja, 'STDOUT_FILENO' como primeiro parâmetro
	call	write 				// chama a função 'write' para escrever o conteúdo de 'buf' na saída padrão
	addl	$16, %esp			// libera 16 bytes da pilha
	cmpl	%eax, %ebx			// compara o número de bytes escritos com o número de bytes lidos
	je	.L12					// se os números forem iguais, volta para o início do loop. Caso contrário :
	subl	$12, %esp			// abre 12 bytes na pilha
	pushl	$.LC2				// passa como parâmetro da função 'perror' a string em .LC1
	call	perror				// chama a função 'perror'
	addl	$16, %esp			// libera 16 bytes da pilha
	movl	$1, %eax			// copia '1' para o retorno da main
	jmp	.L9						// pula para .L9 para encerrar a função
.L19:
	subl	$12, %esp			// abre 12 bytes na pilha
	pushl	$.LC1				// passa como parâmetro da função 'perror' a string em .LC1
	call	perror				// chama a função 'perror'
	addl	$16, %esp			// libera 16 bytes da pilha
	movl	$1, %eax			// copia '1' para o retorno da main
	jmp	.L9						// pula para .L9  para encerrar a função
.L20:
	subl	$12, %esp			// abre 12 bytes na pilha
	pushl	%edi				// passa como parâmetro 'arq' para a função 'myclose'
	call	myclose				// chama a função 'myclose' para fechar o arquivo aberto.
	addl	$16, %esp			// libera 16 bytes da pilha
	movl	$0, %eax			// copia '0' para o retorno da main
	jmp	.L9						// pula para .L9  para encerrar a função
.L18:
	call	__stack_chk_fail	// chama a função '__stack_chk_fail', que aborta o programa devido
								// ao estouro de pilha e termina sua execução 

.LFE15:
	.ident	"GCC: (GNU) 10.2.0"
