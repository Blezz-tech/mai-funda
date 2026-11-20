#!/usr/bin/env bash
# Сборка всех отчётов: ./build.sh  ->  <папка>/out.pdf
set -euo pipefail
export PATH="$HOME/.local/bin:$PATH"
cd "$(dirname "$0")"
for d in kr1 kr2 lr1 lr2; do
  [ -d "$d" ] || continue
  echo "== $d"
  ( cd "$d" && typst compile --root .. --font-path ../fonts main.typ out.pdf )
done
echo "готово"
