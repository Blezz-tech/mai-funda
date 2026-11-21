#!/usr/bin/env bash
# Сборка всех отчётов по лабораторным работам.
#
#   ./build.sh            -> dist/Лабораторная работа 1.pdf, dist/Лабораторная работа 2.pdf, ...
#   DIST=out ./build.sh   -> то же в папку out/
#   ./build.sh check      -> только проверки, без typst: ссылки на файлы,
#                            номера работ, дубли. Ничего не собирает.
#
# Берётся каждый файл вида ./*/**/main.typ (точка входа отчёта — main.typ,
# шаблон и общие куски ./lib/lab.typ). Папки */template/* — образец для
# новой работы, в сборку они не попадают.
#
# Номер работы читается из самого main.typ:
#
#   #report(
#     number: "1",
#
# Если в строке есть уточнение варианта («2 (8)»), номером считается
# первое число: «Лабораторная работа 2.pdf».
#
# Скрипт же используется в CI (.github/workflows/ci.yml и release.yml),
# поэтому любые изменения формата имени стоит проверять через ./build.sh.
set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"
cd "$(dirname "$0")"

ROOT="."                 # корень проекта: из него виден /lib/lab.typ
ENTRY="main.typ"         # точка входа каждой работы
PREFIX="Лабораторная работа"
DIST="${DIST:-dist}"
MODE="build"             # build | check (MODE=check — только проверки)

usage() {
  cat <<'EOF'
Использование: ./build.sh [check]

  (без аргументов)  собрать PDF всех работ в dist/ (или $DIST)
  check             только проверить ссылки, номера и дубли; typst не нужен

Переменные окружения:
  DIST=out          папка для PDF (по умолчанию dist)
EOF
}

case "${1:-}" in
  ""|build)         MODE="build" ;;
  check|--check|-n) MODE="check" ;;
  -h|--help|help)   usage; exit 0 ;;
  *)                echo "Неизвестный аргумент: $1" >&2; usage >&2; exit 2 ;;
esac

# number_of <main.typ> — печатает номер лабораторной работы из строки
#   number: "1"
number_of() {
  local file="$1" line raw num

  line=$(grep -m1 -E '^[[:space:]]*number[[:space:]]*:' "$file" || true)
  if [[ ! $line =~ number[[:space:]]*:[[:space:]]*\"([^\"]*)\" ]]; then
    echo "не найдено поле number: \"...\"" >&2
    return 1
  fi

  raw="${BASH_REMATCH[1]}"
  num=$(printf '%s\n' "$raw" | grep -oE '[0-9]+' | head -n1 || true)
  if [[ -z $num ]]; then
    echo "поле number: \"$raw\" не содержит номера работы" >&2
    return 1
  fi

  printf '%s\n' "$num"
}

# refs_of <main.typ> — пути из #console("...") и image("...")
refs_of() {
  grep -oE '(#console\(|image\()[[:space:]]*"[^"]+"' "$1" 2>/dev/null |
    sed -E 's/.*"([^"]+)"/\1/' || true
}

# check_refs <main.typ> — все ли файлы, на которые ссылается отчёт, на месте.
# Без этой проверки опечатка в пути («/fr/2/...» вместо «/lr/2/...»)
# всплывает только на компиляции, в середине сборки.
check_refs() {
  local file="$1" path
  local -a missing=()

  while IFS= read -r path; do
    [[ -n $path ]] || continue
    [[ $path == /* ]] || continue        # относительные пути — не наши
    [[ -f "$ROOT$path" ]] || missing+=("$path")
  done < <(refs_of "$file")

  if (( ${#missing[@]} )); then
    for path in "${missing[@]}"; do
      printf '  %s: нет файла %s\n' "$file" "$path" >&2
    done
    return 1
  fi
}

# ------------------------------------------------------------------
#  1. План сборки: все работы, их номера и ссылки.
#     Сначала проверяем всё, потом компилируем — иначе первая же
#     ошибка прячет остальные.
# ------------------------------------------------------------------
mapfile -t files < <(
  find . -type f -name "$ENTRY" \
    -not -path "./.*" \
    -not -path "*/template/*" |
    sort
)

if (( ${#files[@]} == 0 )); then
  echo "Ошибка: не найдено ни одного $ENTRY." >&2
  exit 1
fi

declare -A file_of_number=()
declare -a order=()
declare -a problems=()

for file in "${files[@]}"; do
  # ./lr/1/main.typ -> lr/1/main.typ
  rel="${file#./}"

  if ! check_refs "$rel"; then
    problems+=("$rel: битые ссылки на файлы")
    continue
  fi

  if ! number="$(number_of "$rel" 2>&1)"; then
    problems+=("$rel: $number")
    continue
  fi

  if [[ -n "${file_of_number[$number]:-}" ]]; then
    problems+=("номер ЛР $number встречается дважды: ${file_of_number[$number]} и $rel")
    continue
  fi

  file_of_number[$number]="$rel"
  order+=("$number")
done

if (( ${#problems[@]} )); then
  echo "Ошибка: сборка невозможна:" >&2
  printf '  * %s\n' "${problems[@]}" >&2
  exit 1
fi

# числовой порядок: 1, 2, 5, 10, а не 1, 10, 2, 5
mapfile -t order < <(printf '%s\n' "${order[@]}" | sort -n)

if [[ $MODE == check ]]; then
  echo "Проверки пройдены: работ — ${#order[@]}"
  for number in "${order[@]}"; do
    echo "  * ЛР $number <- ${file_of_number[$number]} -> $DIST/$PREFIX $number.pdf"
  done
  exit 0
fi

# ------------------------------------------------------------------
#  2. Сборка
# ------------------------------------------------------------------
if ! command -v typst >/dev/null 2>&1; then
  cat >&2 <<'EOF'
Ошибка: typst не найден в PATH.

Установите один из вариантов:
  * готовый бинарник: https://github.com/typst/typst/releases
  * cargo install --locked typst-cli
  * пакет из репозитория ОС (например, pacman -S typst / nix-shell -p typst)
EOF
  exit 1
fi

rm -rf "$DIST"
mkdir -p "$DIST"

rows=()

for number in "${order[@]}"; do
  rel="${file_of_number[$number]}"
  dir="${rel%/*}"
  out="$DIST/$PREFIX $number.pdf"

  echo "== $dir (number: \"$number\") -> $out"
  typst compile --root "$ROOT" "$rel" "$out"

  rows+=("| $number | \`$rel\` | \`$PREFIX $number.pdf\` |")
done

# Отчёт о сборке: его же читает job summary в GitHub Actions.
{
  echo "## Собранные отчёты"
  echo
  echo "| № ЛР | Исходник | PDF |"
  echo "| ---: | --- | --- |"
  printf '%s\n' "${rows[@]}"
  echo
  echo -n "Коммит \`${GITHUB_SHA:-$(git rev-parse --short HEAD 2>/dev/null || echo unknown)}\`"
  echo ", $(typst --version | head -n1)"
} > "$DIST/summary.md"

echo
cat "$DIST/summary.md"
echo
echo "Готово: ${#order[@]} PDF в $DIST/"
