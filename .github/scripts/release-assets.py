#!/usr/bin/env python3
"""Ассеты релиза из dist/*.pdf.

    .github/scripts/release-assets.py

Делает в корне репозитория:
  * lab-reports.zip           — архив, внутри имена ровно как в dist/;
  * release-assets/lab-N.pdf  — те же PDF отдельными файлами;
  * release-assets/list.txt   — строки «путь#подпись» для gh release.

GitHub переписывает имена ассетов релиза в ASCII
(«Лабораторная работа 1.pdf» -> «1.pdf»), поэтому кириллическое имя
доживает до скачивания только внутри архива и в подписи ассета.
"""
import pathlib
import re
import sys
import zipfile

DIST = pathlib.Path("dist")
ASSETS = pathlib.Path("release-assets")


def main() -> int:
    pdfs = sorted(DIST.glob("*.pdf"))
    if not pdfs:
        print("dist/*.pdf пуст — нечего упаковывать", file=sys.stderr)
        return 1

    with zipfile.ZipFile("lab-reports.zip", "w", zipfile.ZIP_DEFLATED) as zf:
        for pdf in pdfs:
            zf.write(pdf, arcname=pdf.name)
    print("В архиве:", ", ".join(p.name for p in pdfs))

    ASSETS.mkdir(exist_ok=True)
    seen: dict[str, str] = {}
    lines: list[str] = []

    for pdf in pdfs:
        match = re.search(r"\d+", pdf.stem)
        if not match:
            print(f"в имени {pdf.name} нет номера работы", file=sys.stderr)
            return 1
        num = match.group(0)
        if num in seen:
            print(
                f"номер {num} встречается дважды: {seen[num]} и {pdf.name}",
                file=sys.stderr,
            )
            return 1
        seen[num] = pdf.name

        copy = ASSETS / f"lab-{num}.pdf"
        copy.write_bytes(pdf.read_bytes())
        lines.append(f"{copy}#{pdf.stem}")

    (ASSETS / "list.txt").write_text("\n".join(lines) + "\n")
    print("\n".join(lines))
    return 0


if __name__ == "__main__":
    sys.exit(main())
