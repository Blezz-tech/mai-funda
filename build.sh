#!/usr/bin/env bash
# Компиляция отчётов по лабораторным работам в dist/.
#
#   ./build.sh            -> dist/Лабораторная работа 1.pdf, dist/Лабораторная работа 2.pdf, …
#   DIST=out ./build.sh   -> то же в папку out/
#
# Берётся каждый ./*/**/main.typ (папки */template/* — образец, не отчёт).
# Номер работы читается из самого main.typ:
#
#   #report(
#     number: "1",
#
# Если в строке есть уточнение варианта («2 (8)»), номером считается
# первое число: «Лабораторная работа 2.pdf».
#
# Скрипт ничего не проверяет и ничего не устанавливает: нужен только
# typst в PATH. Проверки (ссылки на файлы, номера, дубли) и всё остальное
# для GitHub Actions — в .github/scripts/.
set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"
cd "$(dirname "$0")"

DIST="${DIST:-dist}"
PREFIX="Лабораторная работа"

rm -rf "$DIST"
mkdir -p "$DIST"

mapfile -t files < <(
  find . -type f -name main.typ \
    -not -path "./.*" \
    -not -path "*/template/*" |
    sort
)

for file in "${files[@]}"; do
  # ./lr/2/main.typ -> 2 по строке number: "1 (2)"
  number=$(grep -m1 -oE 'number[[:space:]]*:[[:space:]]*"[0-9]+' "$file" |
    grep -oE '[0-9]+' || true)

  out="$DIST/$PREFIX $number.pdf"

  echo "== ${file#./} -> $out"
  typst compile --root . "$file" "$out"
done

echo "Готово: ${#files[@]} PDF в $DIST/"
