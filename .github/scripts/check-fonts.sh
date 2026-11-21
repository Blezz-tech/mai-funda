#!/usr/bin/env bash
# Проверка, что в системе есть гарнитуры из цепочек lib/lab.typ.
# Без них Typst молча подставит встроенный шрифт и вёрстка разъедется,
# поэтому здесь падаем, а не предупреждаем.
#
#   REQUIRE_TIMES=false .github/scripts/check-fonts.sh
set -euo pipefail

REQUIRE_TIMES="${REQUIRE_TIMES:-true}"

available="$(typst fonts)"
echo "$available" | sort -u

missing=()
for font in "Hack" "Liberation Serif" "Liberation Mono"; do
  if grep -qxF "$font" <<<"$available"; then
    echo "ok: $font"
  else
    missing+=("$font")
  fi
done

if grep -qxF "Times New Roman" <<<"$available"; then
  echo "ok: Times New Roman"
elif [[ $REQUIRE_TIMES == "true" ]]; then
  missing+=("Times New Roman")
else
  echo "::warning::Times New Roman нет — используется Liberation Serif"
fi

if (( ${#missing[@]} )); then
  echo "::error::Не найдены шрифты: ${missing[*]}"
  exit 1
fi
