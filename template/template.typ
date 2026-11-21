// ============================================================
//  Шаблон отчёта по лабораторной работе (МАИ, каф. 806).
//  Конвертирован из LaTeX-шаблона (article, a4paper, tempora,
//  geometry top=2cm bottom=2cm left=1.5cm right=1.5cm,
//  extsizes 11pt, linespread 0.9, pagestyle empty).
//
//  Соответствие LaTeX -> Typst:
//    \LabNumber, \Discipline, \StudentGroup, ...  -> lab-meta dict
//    \Texti ... \Textxii                          -> report(...) аргументы
//    \EmptyLinesi ... \EmptyLinesxii              -> empty-* аргументы
//    \void, \mrule, \arulefill, \uline            -> void(), mrule(), u()
//    \PrintEmptyLines{n}                          -> empty-lines(n)
//    enumerate [label=\textbf{\arabic*.}]         -> item("1.", ...)
//    minipage 0.45\textheight (п. 6, 7, 9)       -> block(height: 11.5cm)
//    tabular дневника (7 колонок)                 -> diary()
// ============================================================

// ------------------------------------------------------------
//  Гарнитуры: tempora в LaTeX — это Times-подобный шрифт.
//  Typst берёт первую найденную из цепочки.
// ------------------------------------------------------------
#let default-body-font = (
  "Times New Roman",
  "Liberation Serif",
  "Tinos",
  "DejaVu Serif",
)
#let default-mono-font = (
  "Hack",
  "Liberation Mono",
  "Cousine",
  "DejaVu Sans Mono",
)

// ------------------------------------------------------------
//  Реквизиты шапки (LaTeX: \LabNumber, \Discipline, ...).
//  Значения по умолчанию — как в исходном .tex.
// ------------------------------------------------------------
#let lab-meta = (
  lab-number: "00",
  discipline: "Практикум на ЭВМ",
  student-group: "М8О-100Б-20",
  student-name: "Иванов Иван Иванович",
  student-number: "00",
  student-contacts: "ya@yandex.ru",
  date-of-completion: "«1» января 2022 г.",
  teacher: "ст. преп. каф. 806 Дубинин А.В.",
  number-variant: "",
)

// ------------------------------------------------------------
//  Глобальные настройки страницы и текста.
//  LaTeX: geometry top=2cm bottom=2cm left=1.5cm right=1.5cm,
//  extsizes 11pt, linespread 0.9, \pagestyle{empty} (без номеров).
// ------------------------------------------------------------
#let setup(
  doc,
  body-font: default-body-font,
  mono-font: default-mono-font,
  body-size: 11pt,
  margins: (top: 2cm, bottom: 2cm, left: 1.5cm, right: 1.5cm),
  numbering: false,
) = {
  set page(
    paper: "a4",
    margin: margins,
    numbering: if numbering { "1" } else { none },
  )
  set text(font: body-font, size: body-size, lang: "ru", hyphenate: true)
  // linespread{0.9} в LaTeX ~ плотный интерлиньяж
  set par(justify: true, leading: 0.45em, spacing: 0.45em, first-line-indent: 0pt)
  set list(indent: 1.2em, spacing: 0.25em, marker: [–])
  set enum(indent: 1.2em, spacing: 0.25em)
  set heading(numbering: none)
  show heading: it => block(above: 1.1em, below: 0.5em, it)
  set figure(kind: image, gap: 0.3em)
  set figure.caption(separator: none)
  show figure.caption: it => block(
    above: 0.4em,
    below: 1.1em,
    text(size: 10pt, it.body),
  )
  set table(stroke: 0.5pt)
  show table.cell: it => {
    set text(size: 8pt)
    set par(justify: false, leading: 0.55em)
    align(center + horizon, it)
  }
  show raw.where(block: true): it => {
    set text(font: mono-font, size: 8pt, lang: "en", hyphenate: false)
    set par(justify: false, leading: 0.34em, spacing: 0.34em)
    block(width: 100%, inset: 0pt, above: 0.6em, below: 0.6em, it)
  }
  show raw.where(block: false): it => text(font: mono-font, size: 0.92em, it)
  doc
}

// ------------------------------------------------------------
//  Линии для заполнения (LaTeX: \void, \mrule, \arulefill, \uline).
// ------------------------------------------------------------

// \void — пустая линия на всю ширину (для пустых полей)
#let void() = box(width: 100%, stroke: (bottom: 0.4pt), inset: (bottom: 1pt), h(1fr))

// \mrule{len} — линия фиксированной длины
#let mrule(len) = box(width: len, stroke: (bottom: 0.4pt), inset: (bottom: 1pt), h(1fr))

// \uline{...} — подчёркнутый текст
#let u(t) = underline(t)

// \PrintEmptyLines{n} — n пустых линий
#let empty-lines(n) = {
  for _ in range(n) {
    void()
    linebreak()
  }
}

// ------------------------------------------------------------
//  Шапка отчёта (LaTeX: minipage с \fbox + заголовок + реквизиты).
//  Слева — рамка 1.7 x 2.1 см, справа — заголовок и реквизиты.
// ------------------------------------------------------------
#let lab-header(m) = {
  set par(justify: false, leading: 0.9em, spacing: 0.35em)
  grid(
    columns: (2.1cm, 1fr),
    gutter: 0.4cm,
    align: horizon,
    // \fbox{\rule[2.1cm]{1.7cm}{0pt}} + \vspace{3.5cm}
    block[
      #box(width: 1.7cm, height: 2.1cm, stroke: 0.5pt)
      #v(3.5cm)
    ],
    block[
      #align(center, text(size: 14pt, weight: "bold")[
        Отчет по лабораторной работе № #u(m.lab-number) по курсу #u(m.discipline)
      ])
      #v(0.6em)
      #text(size: 11pt)[
        Студент группы #u(m.student-group + " " + m.student-name), № по списку #u(m.student-number) \
        Контакты www, e-mail, icq, skype #u(m.student-contacts)
      ]
      #v(0.6em)
      #text(size: 11pt)[
        Работа выполнена: #m.date-of-completion \
        Преподаватель: #u(m.teacher) \
        Входной контроль знаний с оценкой #mrule(3.3cm) \
        Отчет сдан « #h(0.3cm) » #mrule(1.5cm) 202 #mrule(0.3cm) г., итоговая оценка #mrule(0.5cm)
      ]
      #v(0.4em)
      #align(right)[Подпись преподавателя #mrule(3cm)]
    ],
  )
  v(0.8em)
}

// ------------------------------------------------------------
//  Нумерованный пункт отчёта: «1. Тема: …»
//  LaTeX: \item \textbf{Тема:} \arulefill{\Texti}
// ------------------------------------------------------------
#let item(num, head, body) = block(
  above: 0.85em,
  below: 0.15em,
  if body == none {
    [#text(weight: "bold")[#num]#h(0.45em)#text(weight: "bold")[#head]]
  } else {
    [#text(weight: "bold")[#num]#h(0.45em)#text(weight: "bold")[#head]#h(0.45em)#body]
  },
)

// «Допущен к выполнению работы.  Подпись преподавателя _______»
#let admit() = block(
  above: 0.9em,
  below: 0.4em,
  grid(
    columns: (1fr, 5cm),
    align: horizon,
    [Допущен к выполнению работы.],
    align(right)[
      #text(size: 9pt)[подпись преподавателя] \
      #v(-0.25em)
      #line(length: 100%, stroke: 0.4pt)
    ],
  ),
)

// ------------------------------------------------------------
//  Листинг из файла (моноширинный, без рамки)
// ------------------------------------------------------------
#let listing(path) = {
  let text-content = read(if path.starts-with("/") { path } else { "/" + path })
  block(width: 100%, raw(text-content, block: true, lang: "text"))
}

// ------------------------------------------------------------
//  Протокол работы: текстовый файл, построчно моноширинным,
//  маркеры ⟦IMG:n⟧ заменяются рисунками с подписями.
// ------------------------------------------------------------
#let protocol(path, images: (:), width: 78%) = block(width: 100%, {
  let lines = read(if path.starts-with("/") { path } else { "/" + path }).split("\n")
  for l in lines {
    let l = l.replace("\t", "    ")
    if l.trim() == "" {
      v(0.28em)
    } else if l.contains("⟦IMG:") {
      let key = l.split("⟦IMG:").at(1).replace("⟧", "")
      let img = images.at(key, default: none)
      if img != none {
        figure(
          image(if img.at(0).starts-with("/") { img.at(0) } else { "/" + img.at(0) }, width: width),
          caption: if img.len() > 1 { img.at(1) } else { none },
        )
      }
    } else {
      text(font: default-mono-font, size: 7.3pt, lang: "en", l)
      linebreak()
    }
  }
})

// ------------------------------------------------------------
//  Дневник отладки: 7 колонок, как в LaTeX (tabular).
//  Если строк нет — одна пустая строка высотой 0.45\textheight.
// ------------------------------------------------------------
#let diary(rows) = align(center)[
  #table(
    columns: (0.8cm, 1.7cm, 2.2cm, 1.8cm, 3.1cm, 4.5cm, 2.9cm),
    align: center + horizon,
    stroke: 0.5pt,
    table.header([№], [Лаб. или дом.], [Дата], [Время], [Событие], [Действие по исправлению], [Примечание]),
    ..if rows.len() == 0 {
      ([], [], [], [], [], [], [ #v(11.5cm) ])
    } else {
      rows.map(r => r.map(c => [#c])).flatten()
    },
  )
]

// ------------------------------------------------------------
//  Блок 0.45\textheight для п. 6 и 7 (LaTeX minipage).
//  Высота текста A4 при полях 2+2 см: 29.7 - 4 = 25.7 см,
//  0.45 * 25.7 ≈ 11.5 см.
// ------------------------------------------------------------
#let tall-block(body) = block(
  width: 95%,
  if body == none {
    [ #v(11.5cm) ]
  } else {
    body
  },
)

// ============================================================
//  Отчёт целиком: структура пунктов 1–11 из LaTeX-шаблона.
//  В main.typ работы остаются только отличия — содержимое
//  пунктов. Номера, названия, пояснения в скобках, шапка,
//  «Допущен...», подпись живут здесь.
// ============================================================
#let report(
  meta: none,
  // содержимое пунктов (LaTeX: \Texti ... \Textxii)
  topic: none, // 1. Тема
  goal: none, // 2. Цель работы
  task: none, // 3. Задание
  equipment-lab: none, // 4. Оборудование (лабораторное)
  equipment-student: none, // 4. Оборудование ПЭВМ студента
  software-lab: none, // 5. ПО (лабораторное)
  software-student: none, // 5. ПО ЭВМ студента
  idea: none, // 6. Идея, метод, алгоритм
  scenario: none, // 7. Сценарий выполнения работы
  protocol-body: none, // 8. Распечатка протокола
  diary-rows: (), // 9. Дневник отладки
  comments: none, // 10. Замечания автора
  conclusion: none, // 11. Выводы
  fixes: none, // устранение недочётов (после п. 11)
  // количество пустых линий (LaTeX: \EmptyLines*)
  empty-topic: 1,
  empty-goal: 2,
  empty-task: 3,
  empty-equipment-lab: 1,
  empty-equipment-student: 1,
  empty-software-lab: 1,
  empty-software-student: 1,
  empty-comments: 3,
  empty-conclusion: 10,
  empty-fixes: 5,
) = {
  let m = if meta != none { meta } else { lab-meta }
  lab-header(m)

  // ============================== 1–3 ==============================
  item("1.", "Тема:", if topic != none { topic })
  empty-lines(empty-topic)

  item("2.", "Цель работы:", if goal != none { goal })
  empty-lines(empty-goal)

  item("3.", "Задание", if m.number-variant != "" {
    [(вариант № #m.number-variant): ]
  } else { none })
  if task != none { task }
  empty-lines(empty-task)

  // ============================== 4 ==============================
  item("4.", "Оборудование", [(лабораторное):])
  if equipment-lab != none { equipment-lab }
  empty-lines(empty-equipment-lab)
  [text(style: "italic")[Оборудование ПЭВМ студента, если использовалось:]]
  if equipment-student != none { equipment-student }
  empty-lines(empty-equipment-student)

  // ============================== 5 ==============================
  item("5.", "Программное обеспечение", [(лабораторное):])
  if software-lab != none { software-lab }
  empty-lines(empty-software-lab)
  [text(style: "italic")[Программное обеспечение ЭВМ студента, если использовалось:]]
  if software-student != none { software-student }
  empty-lines(empty-software-student)

  // ============================== 6 ==============================
  item("6.", "Идея, метод, алгоритм решения задачи", [
    {\footnotesize решение задачи (в формах: словесной, псевдокода,
    графической [блок-схема, диаграмма, рисунок, таблица] или формальные
    спецификации с пред- и постусловиями)}
  ])
  tall-block(idea)

  // ============================== 7 ==============================
  item("7.", "Сценарий выполнения работы", [
    {\footnotesize (план работы, первоначальный текст программы
    в черновике [можно на отдельном листе] и тесты либо соображения
    по тестированию)}
  ])
  tall-block(scenario)

v(0.5em)
[text(style: "italic")[Пункты 1–7 отчета составляются строго до начала лабораторной работы.]]

  admit()
  pagebreak()

  // ============================== 8 ==============================
  item("8.", "Распечатка протокола", [
    {\footnotesize (подклеить листинг окончательного варианта программы
    с тестовыми примерами, подписанный преподавателем)}
  ])
  if protocol-body != none { protocol-body }
  pagebreak()

  // ============================== 9 ==============================
  item("9.", "Дневник отладки", [
    {\footnotesize должен содержать дату и время сеансов отладки и основные
    события (ошибки в сценарии и программе, нестандартные ситуации) и краткие
    комментарии к ним. В дневнике отладки приводятся сведения об использовании
    ЭВМ, существенном участии преподавателя и других лиц в написании и отладке
    программы.}
  ])
  v(0.4em)
  diary(diary-rows)

  // ============================== 10–11 ==============================
  item("10.", "Замечания автора", [{\footnotesize по существу работы:}])
  if comments != none { comments }
  empty-lines(empty-comments)

  item("11.", "Выводы:", if conclusion != none { conclusion })
  empty-lines(empty-conclusion)

  [Недочёты при выполнении задания могут быть устранены следующим образом:]
  if fixes != none { fixes }
  empty-lines(empty-fixes)
  align(right)[Подпись студента #mrule(4cm)]
}
