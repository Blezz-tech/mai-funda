#!/usr/bin/env bash
# Проверка отчётов без сборки: ссылки на файлы, номера работ, дубли.
# typst не нужен, поэтому в CI этот шаг идёт до установки шрифтов.
#
#   .github/scripts/check-reports.sh
#
# Проверяется:
#   * каждый #console("...") и image("...") указывает на существующий файл;
#   * в каждом main.typ есть number: "...", и в нём есть цифра;
#   * номера работ не повторяются (иначе PDF молча перезапишут друг друга).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

ENTRY="main.typ"

# number_of <main.typ> — печатает номер лабораторной работы
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
declare -a problems=()

for file in "${files[@]}"; do
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
done

if (( ${#problems[@]} )); then
  echo "Ошибка: сборка невозможна:" >&2
  printf '  * %s\n' "${problems[@]}" >&2
  exit 1
fi

echo "Проверки пройдены: работ — ${#files[@]}"
