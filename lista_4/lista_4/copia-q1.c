#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>
#define TAM 128

int myopen (const char *pathname, int flags) {
    // return open(pathname, flags);
    int fd;
    __asm__("movl $5, %%eax\n\t" // open
            "movl %[pn], %%ebx\n\t" // ponteiro para nome do arquivo
            "movl %[f], %%ecx\n\t" // flags
            "int $0x80\n\t" // chamada de sistema
            "movl %%eax, %[fd] \n\t" // retorno do descritor
            :[fd]"=r"(fd) // lista de saída
            :[pn]"r"(pathname),[f]"r"(flags) // lista de entrada, forçando o uso de registradores
            :"%eax", "%ebx", "%ecx" // registradores modificados
        );
    return fd;
}

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
    char* pnome = argv[1];
    int arq;
    char buf[TAM];
    ssize_t lidos, escritos;
    if (argc != 2) {fprintf(stderr,"forma correta: %s <nomearquivo>\n", argv[0]); return 1;}
    arq = myopen (argv[1], O_RDONLY);
    if (arq<0) { perror("abertura de arquivo"); return 1;}
    while ((lidos = myread (arq, buf)) > 0)
        if ((mywrite (STDOUT_FILENO, buf, lidos) != lidos)){ perror("escrita:"); return 1;}
    myclose (arq);
    return 0;
}
