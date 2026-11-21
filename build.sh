#!/usr/bin/env bash
# Сборка всех отчётов по лабораторным работам.
#
#   ./build.sh            -> dist/Лабораторная работа 1.pdf, dist/Лабораторная работа 2.pdf, ...
#   DIST=out ./build.sh   -> то же в папку out/
#
# Берётся каждый файл вида ./*/**/main.typ (точка входа отчёта — main.typ,
# шаблон ./lib/lab.typ общий). Номер работы читается из самого main.typ:
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

# number_of <main.typ> — печатает номер лабораторной работы из строки
#   number: "1"
number_of() {
  local file="$1" line raw num

  line=$(grep -m1 -E '^[[:space:]]*number[[:space:]]*:' "$file" || true)
  if [[ ! $line =~ number[[:space:]]*:[[:space:]]*\"([^\"]*)\" ]]; then
    echo "Ошибка: в $file не найдено поле number: \"...\"" >&2
    return 1
  fi

  raw="${BASH_REMATCH[1]}"
  num=$(printf '%s\n' "$raw" | grep -oE '[0-9]+' | head -n1 || true)
  if [[ -z $num ]]; then
    echo "Ошибка: в $file поле number: \"$raw\" не содержит номера работы" >&2
    return 1
  fi

  printf '%s\n' "$num"
}

rm -rf "$DIST"
mkdir -p "$DIST"

mapfile -t files < <(find . -type f -name "$ENTRY" -not -path "./.*" | sort)

if (( ${#files[@]} == 0 )); then
  echo "Ошибка: не найдено ни одного $ENTRY." >&2
  exit 1
fi

declare -A seen=()
rows=()

for file in "${files[@]}"; do
  # ./lr/1/main.typ -> lr/1/main.typ
  rel="${file#./}"
  dir="${rel%/*}"

  number=$(number_of "$rel") || exit 1

  if [[ -n "${seen[$number]:-}" ]]; then
    echo "Ошибка: номер ЛР $number встречается дважды:" >&2
    echo "  ${seen[$number]}" >&2
    echo "  $rel" >&2
    exit 1
  fi
  seen[$number]="$rel"

  out="$DIST/$PREFIX $number.pdf"

  echo "== $dir (number: \"$number\") -> $out"
  typst compile --root "$ROOT" "$file" "$out"

  rows+=("| $number | \`$rel\` | \`$PREFIX $number.pdf\` |")
done

# Отчёт о сборке: его же читает job summary в GitHub Actions.
{
  echo "## Собранные отчёты"
  echo
  echo "| № ЛР | Исходник | PDF |"
  echo "| ---: | --- | --- |"
  printf '%s\n' "${rows[@]}" | sort -t'|' -k2,2n
  echo
  echo -n "Коммит \`${GITHUB_SHA:-$(git rev-parse --short HEAD 2>/dev/null || echo unknown)}\`"
  echo ", $(typst --version | head -n1)"
} > "$DIST/summary.md"

echo
cat "$DIST/summary.md"
echo
echo "Готово: ${#files[@]} PDF в $DIST/"
