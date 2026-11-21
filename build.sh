#!/usr/bin/env bash
# Сборка всех отчётов: ./build.sh  ->  <папка>/out.pdf
set -euo pipefail
export PATH="$HOME/.local/bin:$PATH"
cd "$(dirname "$0")"

if command -v typst >/dev/null 2>&1; then
  for d in kr/1 kr/2 lr/1 lr/2; do
    [ -d "$d" ] || continue
    echo "== $d"
    ( cd "$d" && typst compile --root .. main.typ out.pdf )
  done
elif python3 -c "import typst" >/dev/null 2>&1; then
  # запасной вариант: PyPI-пакет `typst` (pip install --user typst)
  python3 - << 'PY'
import typst
for d in ["kr/1", "kr/2", "lr/1", "lr/2"]:
    import os
    if not os.path.isdir(d):
        continue
    print(f"== {d}")
    pdf = typst.compile(f"{d}/main.typ", root=".")
    with open(f"{d}/out.pdf", "wb") as f:
        f.write(pdf)
PY
else
  echo "Ошибка: нужен typst 0.13+ (CLI в PATH) или запасной вариант: pip install --user typst" >&2
  exit 1
fi
echo "готово"
