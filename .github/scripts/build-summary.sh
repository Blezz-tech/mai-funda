#!/usr/bin/env bash
# Сводка по собранным PDF: dist/summary.md.
# Используется в job summary (CI) и в теле релиза (CD).
#
#   .github/scripts/build-summary.sh
#
# Собирать перед этим: ./build.sh. Скрипт ничего не компилирует, только
# читает dist/*.pdf и исходники main.typ.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

DIST="${DIST:-dist}"
ENTRY="main.typ"

# source_of <номер> — какой main.typ даёт этот номер
source_of() {
  local want="$1" file number

  while IFS= read -r file; do
    number=$(grep -m1 -oE 'number[[:space:]]*:[[:space:]]*"[0-9]+' "$file" |
      grep -oE '[0-9]+' || true)
    if [[ $number == "$want" ]]; then
      printf '%s\n' "${file#./}"
      return 0
    fi
  done < <(
    find . -type f -name "$ENTRY" \
      -not -path "./.*" \
      -not -path "*/template/*" |
      sort
  )

  printf '—\n'
}

mapfile -t pdfs < <(find "$DIST" -maxdepth 1 -name '*.pdf' | sort -V)

{
  echo "## Собранные отчёты"
  echo
  echo "| № ЛР | Исходник | PDF |"
  echo "| ---: | --- | --- |"

  for pdf in "${pdfs[@]}"; do
    name="$(basename "$pdf")"
    number=$(printf '%s\n' "$name" | grep -oE '[0-9]+' | head -n1 || true)
    echo "| ${number:-—} | \`$(source_of "$number")\` | \`$name\` |"
  done

  echo
  echo -n "Коммит \`${GITHUB_SHA:-$(git rev-parse --short HEAD 2>/dev/null || echo unknown)}\`"
  echo ", $(typst --version | head -n1)"
} > "$DIST/summary.md"

cat "$DIST/summary.md"
