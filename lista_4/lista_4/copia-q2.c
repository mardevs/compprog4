#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>
#define TAM 128

ssize_t myread(int fd, void *buf) {
    return read(fd, buf, TAM);
}

ssize_t mywrite(int fd, const void *buf, size_t count) {
    return write(fd, buf, count);
}

int myclose(int fd) {
    return close(fd);
}

int main (int argc, char** argv) {
    int arq;
    char buf[TAM];
    ssize_t lidos, escritos;
    if (argc != 2) {
        fprintf(stderr,"forma correta: %s <nomearquivo>\n", argv[0]);
        return 1;
    }
    // arq =  myopen (argv[1], O_RDONLY);
    char* pnome = argv[1];
    __asm__("movl $5, %%eax\n\t" // open
            "movl %[pn], %%ebx\n\t" // ponteiro para nome do arquivo
            "movl %[f], %%ecx\n\t" // flags
            "int $0x80\n\t" // chamada de sistema
            "cmpl $0, %%eax\n\t" // EAX eh negativo se ocorreu um problema
            "jge 1f\n\t"  // Se EAX nao ocorreu um problema, pula para o final do programa
            "movl $2, %[er]\n\t" // Atribui o valor 2 a errno
            "1:\n\t"
            "movl %%eax, %[fd] \n\t" // retorno do descritor
            :[fd]"=r"(arq),[er]"=r"(errno) // lista de saida
            :[pn]"r"(pnome),[f]"r"(O_RDONLY) // lista de entrada, forcando o uso de registradores
            :"%eax", "%ebx", "%ecx" // registradores modificados
        );

    if (arq < 0) {
        perror("abertura de arquivo");
        return 1;
    }

    while ((lidos = myread (arq, buf)) > 0) {
        if ((mywrite (STDOUT_FILENO, buf, lidos) != lidos)) {
            perror("escrita:");
            return 1;
        }
    }

    myclose (arq);
    return 0;
}
