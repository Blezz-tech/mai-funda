// ============================================================
//  Оформление отчёта (курсовая работа, МАИ, каф. 806)
//  Порт вёрстки из ODT-файла. Всё «оформление» — здесь.
// ============================================================

#let doc-meta = (
  university: "Московский авиационный институт",
  university-sub: "(Национальный исследовательский университет)",
  faculty: "Факультет компьютерных наук и прикладной математики",
  doc-type: "Курсовая работа",
  course-line: "по курсу",
  course: "«Фундаментальная информатика»",
  semester: "I",
  task: "1",
  student: "Маркусь Евгений Олегович",
  group: "М8О-113БВ-25",
  list-no: "17",
  contacts: "markus.jenya04@yandex.ru",
  work-done: "«6» октября 2025г.",
  teacher: "каф. 806 Никулин Сергей Петрович",
  handed: "«6» октября 2025г.",
)

// ------------------------------------------------------------
//  Глобальные настройки страницы и текста
// ------------------------------------------------------------
#let setup(
  doc,
  body-font: "Times New Roman",
  mono-font: "Hack",
  body-size: 12pt,
  margins: (top: 1.25cm, bottom: 1.25cm, left: 3cm, right: 1.5cm),
  numbering: true,
) = {
  set page(
    paper: "a4",
    margin: margins,
    numbering: if numbering { "1" } else { none },
  )
  set text(font: (body-font,), size: 12pt, lang: "ru", hyphenate: true)
  set par(justify: true, leading: 0.55em, spacing: 0.55em, first-line-indent: 0pt)
  set list(indent: 1.2em, spacing: 0.25em, marker: [–])
  set enum(indent: 1.2em, spacing: 0.25em)
  set heading(numbering: none)
  show heading: it => block(above: 1.1em, below: 0.5em, it)
  set figure(kind: image, gap: 0.3em)
  set figure.caption(separator: none)
  show figure.caption: it => block(
    above: 0.4em,
    below: 1.1em,
    text(size: 11pt, it.body),
  )
  set table(stroke: 0.5pt)
  show table.cell: it => {
    set text(size: 8pt)
    set par(justify: false, leading: 0.55em)
    align(center + horizon, it)
  }
  // моноширинные листинги: без рамки, плотный интерлиньяж
  show raw.where(block: true): it => {
    set text(font: (mono-font,), size: 8pt, lang: "en", hyphenate: false)
    set par(justify: false, leading: 0.34em, spacing: 0.34em)
    // длинные строки терминала/листинга переносим по правому краю текста
    block(width: 100%, inset: 0pt, above: 0.6em, below: 0.6em, it)
  }
  show raw.where(block: false): it => text(font: (mono-font,), size: 0.92em, it)
  doc
}

// ------------------------------------------------------------
//  Титульный лист (по образцу ODT: всё по центру, реквизиты справа)
// ------------------------------------------------------------
#let title-page(m) = {
  set page(numbering: none)
  set par(justify: false, leading: 1.05em, spacing: 0.45em)
  align(center)[
    #text(size: 16pt, weight: "bold")[#m.university] \
    #text(weight: "bold")[#m.university-sub]
    #v(0.9cm)
    #text(size: 12pt, weight: "bold")[#m.faculty])
    #v(2.8cm)
    #text(size: 28pt, weight: "bold")[#m.doc-type] \
    #v(0.9cm)
    #text(size: 14pt, weight: "bold")[#m.course-line] \
    #v(0.25cm)
    #text(size: 16pt, weight: "bold")[#m.course] \
    #v(0.9cm)
    #text(size: 14pt, weight: "bold")[#m.semester семестр] \
    #text(size: 14pt, weight: "bold")[Задание № #m.task]
  ]
  v(4cm)
  align(right)[
    Студент #m.student \
    группы #m.group \
    № по списку #m.list-no \
    Контакты: #m.contacts \
    Работа выполнена: #m.work-done \
    Преподаватель: #m.teacher \
    Отчет сдан: #m.handed \
    Итоговая оценка: \_\_\_\_\_ \
    Подпись преподавателя: \_\_\_\_\_\_\_\_\_\_
  ]
  pagebreak()
  set page(numbering: "1")
}

// ------------------------------------------------------------
//  Нумерованный пункт отчёта: «1. Тема: …»
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

#let item-plain(num, head) = item(num, head, none)

// ------------------------------------------------------------
//  Листинг из файла (моноширинный, без рамки)
// ------------------------------------------------------------
// путь задаётся от корня проекта (например "/lr/1/src/main.c")
#let listing(path) = {
  let text-content = read(if path.starts-with("/") { path } else { "/" + path })
  block(width: 100%, raw(text-content, block: true, lang: "text"))
}

// ------------------------------------------------------------
//  Строка терминала: приглашение + команда
// ------------------------------------------------------------
// приглашение терминала: передаётся полная строка с командой
#let prompt-line(cmd, size: 8.5pt) = block(
  above: 0.5em,
  below: 0.3em,
  text(font: ("Cousine",), size: size, lang: "en", cmd),
)

// ------------------------------------------------------------
//  Картинка с подписью (сопрограмма / тест)
// ------------------------------------------------------------
#let shot(path, width: 100%, caption: none) = figure(
  image(if path.starts-with("/") { path } else { "/" + path }, width: width),
  caption: caption,
)

// ------------------------------------------------------------
//  Строка теста:  №1  λ0(λ) -> λ0λ1(λ)
// ------------------------------------------------------------
#let test-row(n, input, output) = block(
  above: 0.15em,
  below: 0.15em,
  grid(
    columns: (2.4em, 1fr),
    text(weight: "bold")[№#n], [#input #h(0.5em) $arrow.r$ #h(0.5em) #output],
  ),
)

// ============================================================
//  Вариант оформления для ЛАБОРАТОРНЫХ работ (ЛР 1, ЛР 2).
//  Отличается от курсовой только «шапкой»: заголовок по центру,
//  реквизиты — блоком с отступом слева (как в ODT).
// ============================================================

#let lab-meta = (
  title: "Отчёт по лабораторной работе №1 по курсу «Фундаментальная информатика».",
  student: "Выполнил студент группы М8О-113БВ-25: Маркусь Евгений Олегович № по списку 17.",
  extras: (
    "Контакты: mrkus.jenya04@yandex.ru",
    "Работа выполнена: «16» сентября 2025 г.",
    "Преподаватель: каф. 806 Никулин Сергей Петрович",
    "Входной контроль знаний с оценкой: _____",
    "Отчет сдан «30» сентября 2025 г.",
    "Итоговая оценка: _____",
    "Подпись преподавателя: __________",
  ),
)

// шапка ЛР: всё на первой странице, реквизиты с отступом
#let lab-head(m) = {
  set par(justify: false, leading: 1.0em, spacing: 0.35em)
  align(center, text(size: 12pt, weight: "bold", m.title))
  v(0.35em)
  block(inset: (left: 3.5em), text(size: 11pt, [
    #m.student
  ]))
  v(0.35em)
  block(inset: (left: 3.5em), text(size: 11pt, m.extras.join(linebreak())))
  v(0.7em)
}

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

// заголовок-подпись внутри протокола: «Тест 3», «Сессия 2»
#let sub-caption(body) = block(
  above: 0.7em,
  below: 0.25em,
  text(weight: "bold", body),
)

// подпись перед блоком вывода: «Входные данные:» / «Выходные данные:»
#let io-label(body) = block(above: 0.35em, below: 0.1em, text(size: 11pt, body))

// ---------- общие блоки для всех отчётов ----------

// список «оборудование / ПО» с отступом (в ODT это были табы).
// Точка в конце автоматически добавляется к последнему пункту.
#let indented-list(items, inset: (left: 1.5em)) = {
  let last = items.len() - 1
  block(
    inset: inset,
    items
      .enumerate()
      .map(((i, it)) => {
        if i != last { [– #it] } else if type(it) == str {
          if it.ends-with(".") { [– #it] } else { [– #(it + ".")] }
        } else { [– #it.] }
      })
      .join(linebreak()),
  )
}

// ---------- общие списки для всех отчётов ----------
// Единое оборудование и по всем четырём работам; правится здесь.
#let default-equipment = (
  "Процессор Intel® Core™ i5-12400F",
  "ОП 32 ГБ",
  "SSD 1 ТБ",
  "Монитор 23.8\" AOC 24G2SAE/BK черный",
)

// Единое программное обеспечение; правится здесь.
#let default-software = (
  "Операционная система семейства Unix подсемейство Linux",
  "Наименование NixOS версия 26.11",
  "Интерпретатор команд zsh версия 5.9.2 (x86_64-pc-linux-gnu)",
  "Система программирования gcc версия 16.2.0",
  "Редактор текстов vscode версия 1.144.0",
)

// дневник отладки: 7 колонок, как в исходных ODT
#let diary(rows) = align(center)[
  #table(
    columns: (0.8cm, 1.7cm, 2.2cm, 1.8cm, 3.1cm, 4.5cm, 2.9cm),
    align: center + horizon,
    stroke: 0.5pt,
    table.header([№], [Лаб. или дом.], [Дата], [Время], [Событие], [Действие по исправлению], [Примечание]),
    ..rows.map(r => r.map(c => [#c])).flatten(),
  )
]

// «Подпись студента ____» справа
#let signature() = block(
  above: 2.5em,
  width: 100%,
  align(right)[
    #text(size: 11pt)[Подпись студента]
    #box(width: 4.5cm, line(length: 100%, stroke: 0.5pt))
  ],
)

// вывод работы (п. 11)
#let conclusion(body) = block(above: 0.3em, body)

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
      text(font: ("Cousine",), size: 7.3pt, lang: "en", l)
      linebreak()
    }
  }
})

// ------------------------------------------------------------
//  Описание одного теста: заголовок, вход, выход
// ------------------------------------------------------------
#let test-case(title, input, output) = block(
  above: 0.75em,
  below: 0.3em,
  [
    #text(weight: "bold")[#title]
    #v(0.15em)
    #io-label[Входные данные:]
    #block(inset: (left: 1.2em), text(font: ("Cousine",), size: 8.5pt, lang: "en", if type(input) == array {
      input.join(linebreak())
    } else { input }))
    #v(0.15em)
    #io-label[Выходные данные:]
    #block(inset: (left: 1.2em), text(font: ("Cousine",), size: 8.5pt, lang: "en", output.join(linebreak())))
  ],
)

// ============================================================
//  Отчёт целиком: общая структура пунктов 1–11.
//  Всё общее (шапка титульного листа/ЛР, нумерация и названия
//  пунктов, пояснения в скобках, оборудование, ПО, дневник,
//  подпись) живёт здесь. В main.typ работы остаётся только
//  содержимое: тема, цель, задание, алгоритм, сценарий,
//  протокол, строки дневника и заключение.
// ============================================================
#let report(
  // "course" — титульный лист курсовой, "lab" — шапка лабораторной
  cover: "lab",
  // реквизиты для титульного листа / шапки (по умолчанию — как в template.typ)
  meta: none,
  // содержимое пунктов
  topic: none, // 1. Тема
  goal: none, // 2. Цель работы
  task: none, // 3. Задание
  idea: none, // 6. Идея, метод, алгоритм решения задачи
  scenario: none, // 7. Сценарий выполнения работы
  protocol-body: none, // 8. Распечатка протокола
  diary-rows: (), // 9. Дневник отладки (строки таблицы)
  comments: [[по существу работы: замечания отсутствуют.]], // 10. Замечания автора
  conclusion-body: none, // 11. Вывод
  // необщие строки ПО, добавляются к общему списку (например, утилита nam)
  software-extra: (),
) = {
  let m = if meta != none { meta } else if cover == "course" { doc-meta } else { lab-meta }
  if cover == "course" { title-page(m) } else { lab-head(m) }

  // ============================== 1–3 ==============================
  item("1.", "Тема:", topic)
  item("2.", "Цель работы:", goal)
  item("3.", "Задание:", task)

  // ============================== 4 ==============================
  item("4.", "Оборудование:", [
    Оборудование ПЭВМ студента, если использовалось:
  ])
  v(0.3em)
  indented-list(default-equipment)

  // ============================== 5 ==============================
  item("5.", "Программное обеспечение:", [
    Программное обеспечение ПЭВМ студента, если использовалось:
  ])
  v(0.3em)
  indented-list(default-software + software-extra)

  // ============================== 6 ==============================
  item("6.", "Идея, метод, алгоритм решения задачи", [
    [в формах: словесной, псевдокода, графической (блок-схема, диаграмма,
    рисунок, таблица) или формальные спецификации с пред- и постусловиями]:
  ])
  idea

  // ============================== 7 ==============================
  item("7.", "Сценарий выполнения работы", [
    [(план работы, первоначальный текст программы в черновике (можно на
    отдельном листе) и тесты либо соображения по тестированию)].
  ])
  scenario

  v(0.5em)
  [Пункты 1–7 отчета составляются строго до начала лабораторной работы.]

  admit()

  // ============================== 8 ==============================
  item("8.", "Распечатка протокола", [
    [(подклеить листинг окончательного варианта программы с тестовыми
    примерами, подписанный преподавателем)].
  ])
  protocol-body

  // ============================== 9 ==============================
  item("9.", "Дневник отладки", [
    [должен содержать дату и время сеансов отладки и основные события
    (ошибки в сценарии и программе, нестандартные ситуации) и краткие
    комментарии к ним. В дневнике отладки приводятся сведения об
    использовании других ЭВМ, существенном участии преподавателя и других
    лиц в написании и отладке программы.]
  ])
  v(0.4em)
  diary(diary-rows)

  // ============================== 10–11 ==============================
  item("10.", "Замечания автора", comments)

  item("11.", "Вывод:", none)
  conclusion(conclusion-body)

  signature()
}
