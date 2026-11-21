#!/usr/bin/env bash
# Ставит статический бинарник Typst нужной версии в /usr/local/bin.
#
#   TYPST_VERSION=v0.15.1 .github/scripts/install-typst.sh
set -euo pipefail

TYPST_VERSION="${TYPST_VERSION:-v0.15.1}"

case "$(uname -m)" in
  x86_64)  target=x86_64-unknown-linux-musl ;;
  aarch64) target=aarch64-unknown-linux-musl ;;
  *) echo "::error::Неизвестная архитектура: $(uname -m)"; exit 1 ;;
esac

url="https://github.com/typst/typst/releases/download/${TYPST_VERSION}/typst-${target}.tar.xz"

installed=""
for attempt in 1 2 3; do
  if curl -fsSL --retry 3 --retry-delay 2 --connect-timeout 20 \
       "$url" -o /tmp/typst.tar.xz &&
     tar -xJf /tmp/typst.tar.xz -C /tmp &&
     sudo install -m 0755 "/tmp/typst-${target}/typst" /usr/local/bin/typst; then
    installed=1
    break
  fi
  echo "::warning::Typst ${TYPST_VERSION}: попытка $attempt не удалась"
  sleep 5
done

if [[ -z $installed ]]; then
  echo "::error::Не удалось скачать Typst ${TYPST_VERSION} с $url"
  exit 1
fi

typst --version
