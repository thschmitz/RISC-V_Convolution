#!/bin/bash

# Gera o log
qemu-riscv64 -d in_asm,cpu,exec hello.elf 2> qemu_log.txt

# Conta algumas estatísticas simples
instrs=$(grep -c '^0x' qemu_log.txt)
loads=$(grep -i -c '\<ld\>' qemu_log.txt)
stores=$(grep -i -c '\<st\>' qemu_log.txt)
jumps=$(grep -i -c -E '\<jal\>|\<ret\>' qemu_log.txt)

# Exibe
echo "Instruções executadas: $instrs"
echo "Loads                : $loads"
echo "Stores               : $stores"
echo "Jumps                : $jumps"
