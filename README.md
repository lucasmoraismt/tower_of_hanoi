# Torre de Hanoi em Assembly x86

Projeto desenvolvido para a disciplina de Arquitetura de Computadores e Sistemas Operacionais do curso de Sistemas de Informação do Centro de Informática (CIn) da UFPE, orientado pelo professor Sérgio Cavalcanti.

## 🧩 Sobre o Problema

A Torre de Hanoi é um quebra-cabeça matemático clássico que consiste em mover uma pilha de discos de uma torre de origem para uma torre de destino, utilizando uma torre auxiliar, seguindo três regras simples:

1. Apenas um disco pode ser movido por vez
2. Um disco maior nunca pode ficar sobre um menor
3. Todos os discos devem estar em alguma torre, exceto o que está sendo movido

## ⚙ Requisitos do Sistema

- Sistema operacional Linux (32-bit ou 64-bit com suporte a 32-bit)
- NASM versão 2.15 ou superior
- Pacote `gcc-multilib` (para linkagem em sistemas 64-bit)
- Terminal básico com acesso a linha de comando

## 📥 Guia de Instalação

### Instalação do NASM

Para sistemas Debian/Ubuntu:

```bash
sudo apt-get update
sudo apt-get install nasm
```

### Instalação das dependências para 64-bit

```bash
sudo apt-get install gcc-multilib
```

## 🚀 Executando a Aplicação

1. Clone o repositório:

```bash
git clone https://github.com/lucasmoraismt/tower_of_hanoi.git
cd tower_of_hanoi/assembly
```

2. Monte o código Assembly:

```bash
nasm -f elf32 tower_of_hanoi.asm -o tower.o
```

3. Faça a linkagem:

```bash
ld -m elf_i386 tower.o -o tower
```

4. Execute o programa:

```bash
./tower
```

5. Siga as instruções no terminal:

```
Enter a two-digit number (01 to 99): 03
Move disk 01 from tower A to tower C
Move disk 02 from tower A to tower B
Move disk 01 from tower C to tower B
...
```
