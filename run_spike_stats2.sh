#!/bin/bash

# Verifica se um arquivo ELF foi passado
if [ -z "$1" ]; then
  echo "Uso: ./run_spike_stats.sh arquivo.elf"
  exit 1
fi

ELF="$1"
OUTPUT_FILE="program_output.txt"
STATS_FILE="stats.txt"

# Cria um pipe temporário
TMP_LOG=$(mktemp)

# Executa o spike com log no terminal e salva em arquivo temporário
echo "[*] Executando spike com log..."
spike -l pk "$ELF" 2>&1 | tee "$TMP_LOG" > "$OUTPUT_FILE"

# Verifica se execução deu certo
if [ $? -ne 0 ]; then
  echo "[!] Erro na execução do spike. Verifique o ELF ou o spike/pk."
  rm -f "$TMP_LOG"
  exit 1
fi

# Extrai estatísticas do que foi exibido no terminal
echo "[*] Analisando log..."

TOTAL_INSTR=$(grep -c '^core' "$TMP_LOG")
TOTAL_LOADS=$(grep -c -E '\blb\b|\blh\b|\blw\b|\blbu\b|\blhu\b' "$TMP_LOG")
TOTAL_STORES=$(grep -c -E '\bsb\b|\bsh\b|\bsw\b' "$TMP_LOG")

# Mostra no terminal
echo "=== Estatísticas ==="
echo "Instruções executadas: $TOTAL_INSTR"
echo "Acessos de leitura (load): $TOTAL_LOADS"
echo "Acessos de escrita (store): $TOTAL_STORES"
echo "Saída do programa salva em: $OUTPUT_FILE"

# Salva em stats.txt
{
  echo "=== Estatísticas ==="
  echo "Instruções executadas: $TOTAL_INSTR"
  echo "Acessos de leitura (load): $TOTAL_LOADS"
  echo "Acessos de escrita (store): $TOTAL_STORES"
} > "$STATS_FILE"

echo "Estatísticas salvas em: $STATS_FILE"

# Limpa o temporário
rm -f "$TMP_LOG"
