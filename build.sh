# Сборка всех лабораторных работ: ./build.sh -> dist/<путь>.pdf
set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"
cd "$(dirname "$0")"

ROOT="."
DIST="dist"
ENTRY="main.typ"

if ! command -v typst >/dev/null 2>&1; then
  echo "Ошибка: не найден typst в PATH." >&2
  echo "Установите: cargo install typst-cli" >&2
  echo "Или добавьте бинарник в PATH." >&2
  exit 1
fi

rm -rf "$DIST"
mkdir -p "$DIST"

mapfile -t files < <(
  find . -type f -name "$ENTRY" -print | sort
)

if (( ${#files[@]} == 0 )); then
  echo "Не найдено ни одного $ENTRY." >&2
  exit 1
fi

for file in "${files[@]}"; do
  # ./lr/1/main.typ -> lr/1
  rel_dir="${file#./}"
  rel_dir="${rel_dir%/*}"

  out="$DIST/${rel_dir//\//_}.pdf"
  mkdir -p "$(dirname "$out")"

  echo "== $rel_dir -> $out"
  typst compile --root "$ROOT" "$file" "$out"
done

echo "Готово: PDF-файлы в $DIST/"
