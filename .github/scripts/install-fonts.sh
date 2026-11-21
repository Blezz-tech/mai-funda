#!/usr/bin/env bash
# Шрифты из шрифтовой цепочки lib/lab.typ:
#   Times New Roman (основной текст), Hack (консоль), Liberation (аналоги).
#
#   REQUIRE_TIMES=false .github/scripts/install-fonts.sh
#
# REQUIRE_TIMES=true (по умолчанию) — падать, если настоящий Times New Roman
# поставить не удалось. С false — предупредить: текст наберётся метрически
# совместимым Liberation Serif.
set -euo pipefail

REQUIRE_TIMES="${REQUIRE_TIMES:-true}"

# retry_apt <пакеты...> — apt-get install с повторами: зеркала на раннерах
# иногда отвечают 5xx, это не повод краснеть сборке.
retry_apt() {
  local attempt
  for attempt in 1 2 3; do
    if sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
         --no-install-recommends "$@"; then
      return 0
    fi
    echo "::warning::apt-get install $*: попытка $attempt не удалась"
    sudo apt-get update || true
    sleep 5
  done
  return 1
}

sudo apt-get update
retry_apt fonts-hack fonts-liberation fonts-dejavu-core fontconfig ||
  { echo "::error::Не удалось поставить базовые шрифты"; exit 1; }

if typst fonts | grep -qxF "Times New Roman"; then
  echo "Times New Roman уже есть"
  exit 0
fi

# Настоящий Times New Roman: пакет ttf-mscorefonts-installer лежит в
# multiverse и требует принятия EULA, поэтому preseed + noninteractive.
# Сами шрифты он тянет с SourceForge — это самое ненадёжное место в
# пайплайне, отсюда три попытки.
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  --no-install-recommends software-properties-common
sudo add-apt-repository -y multiverse
sudo apt-get update
echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" |
  sudo debconf-set-selections

ok=""
for attempt in 1 2 3; do
  echo "Попытка установки ttf-mscorefonts-installer: $attempt"
  if sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
       --no-install-recommends ttf-mscorefonts-installer; then
    ok=1
    break
  fi
  # недокачанный пакет остаётся в «полуустановленном» виде, поэтому перед
  # повтором чиним состояние и обновляем индексы
  sudo DEBIAN_FRONTEND=noninteractive dpkg --configure -a || true
  sudo apt-get update || true
  sleep 5
done

# Times New Roman кладётся в /usr/share/fonts/truetype/msttcorefonts.
sudo fc-cache -f >/dev/null 2>&1 || true

if [[ -z $ok ]]; then
  if [[ $REQUIRE_TIMES == "true" ]]; then
    echo "::error::ttf-mscorefonts-installer не установился за 3 попытки — Times New Roman недоступен"
    exit 1
  fi
  echo "::warning::Times New Roman недоступен, текст наберётся Liberation Serif (метрически совместим)"
fi
