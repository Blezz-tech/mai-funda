// ============================================================
//  СТАРЫЙ титульный лист (сохранён из lib/template.typ).
//  Оставлен как есть для справки и для старых работ.
//  Новый шаблон из LaTeX лежит рядом: template/template.typ
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
//  Титульный лист (по образцу ODT: всё по центру, реквизиты справа)
// ------------------------------------------------------------
#let title-page(m) = {
  set page(numbering: none)
  set par(justify: false, leading: 1.05em, spacing: 0.45em)
  align(center)[
    #set text(weight: "bold")
    #text(size: 16pt)[#m.university] \
    #m.university-sub
    #v(0.9cm)
    #m.faculty \
    #v(2.8cm)
    #text(size: 28pt)[#m.doc-type] \
    #v(0.9cm)
    #text(size: 14pt)[#m.course-line] \
    #v(0.9cm)
    #text(size: 16pt)[#m.course] \
    #v(0.9cm)
    #text(size: 14pt)[#m.semester семестр] \
    #text(size: 14pt)[Задание № #m.task]

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

// ============================================================
//  Старая шапка ЛР (тоже из lib/template.typ, для полноты).
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
