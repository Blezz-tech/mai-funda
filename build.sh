#!/usr/bin/env bash
# Сборка всех отчётов: ./build.sh  ->  pdf/<работа>.pdf
# Каждая работа (папка с main.typ) собирается в pdf/<имя-папки>.pdf,
# где '/' заменяется на '-' (kr/1 -> pdf/kr-1.pdf, empty -> pdf/empty.pdf).
# Работа, у которой компиляция падает, не прерывает сборку остальных;
# список неудач выводится в конце.
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
cd "$(dirname "$0")"

mkdir -p pdf

WORKS=(kr/1 kr/2 lr/1 lr/2 empty)
FAILED=()

if command -v typst >/dev/null 2>&1; then
  for d in "${WORKS[@]}"; do
    [ -d "$d" ] || continue
    name="${d//\//-}"
    echo "== $d -> pdf/$name.pdf"
    if ( cd "$d" && typst compile --root .. main.typ "../pdf/$name.pdf" ); then
      :
    else
      echo "!! ОШИБКА сборки $d"
      FAILED+=("$d")
    fi
  done
elif python3 -c "import typst" >/dev/null 2>&1; then
  # запасной вариант: PyPI-пакет `typst` (pip install --user typst)
  python3 - << 'PY'
import typst, os, sys
works = ["kr/1", "kr/2", "lr/1", "lr/2", "empty"]
failed = []
os.makedirs("pdf", exist_ok=True)
for d in works:
    if not os.path.isdir(d):
        continue
    name = d.replace("/", "-")
    print(f"== {d} -> pdf/{name}.pdf")
    try:
        pdf = typst.compile(f"{d}/main.typ", root=".")
        with open(f"pdf/{name}.pdf", "wb") as f:
            f.write(pdf)
    except Exception as e:
        print(f"!! ОШИБКА сборки {d}: {e}", file=sys.stderr)
        failed.append(d)
if failed:
    sys.exit(1)
PY
  rc=$?
  if [ $rc -ne 0 ]; then
    # python вывел список неудач; запомним, чтобы в конце вернуть ненулевой код
    FAILED+=(python-failed)
  fi
else
  echo "Ошибка: нужен typst 0.13+ (CLI в PATH) или запасной вариант: pip install --user typst" >&2
  exit 1
fi

if [ ${#FAILED[@]} -gt 0 ]; then
  echo
  echo "Сборка завершена с ошибками в: ${FAILED[*]}" >&2
  exit 1
fi
echo "готово"
