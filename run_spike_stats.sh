#!/bin/bash

# Verifica se um arquivo ELF foi passado
if [ -z "$1" ]; then
  echo "Uso: ./run_spike_stats.sh arquivo.elf"
  exit 1
fi

ELF="$1"
LOG_FILE="logfile"
OUTPUT_FILE="program_output.txt"

# Executa o spike com log
echo "[*] Executando spike com log..."
spike -l --log=logfile pk "$ELF" > "$OUTPUT_FILE" 2> "$LOG_FILE"

# Verifica se execução deu certo
if [ $? -ne 0 ]; then
  echo "[!] Erro na execução do spike. Verifique o ELF ou o spike/pk."
  exit 1
fi

# Extrai estatísticas
echo "[*] Analisando log..."

TOTAL_INSTR=$(grep -c '^core' "$LOG_FILE")
TOTAL_LOADS=$(grep -c -E '\blb\b|\blh\b|\blw\b|\blbu\b|\blhu\b' "$LOG_FILE")
TOTAL_STORES=$(grep -c -E '\bsb\b|\bsh\b|\bsw\b' "$LOG_FILE")

echo "=== Estatísticas ==="
echo "Instruções executadas: $TOTAL_INSTR"
echo "Acessos de leitura (load): $TOTAL_LOADS"
echo "Acessos de escrita (store): $TOTAL_STORES"
echo "Saída do programa salva em: $OUTPUT_FILE"
