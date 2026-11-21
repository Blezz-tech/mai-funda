// Пустой отчёт по шаблону из LaTeX (template/template.typ).
// Заполните поля ниже — остальное (шапка, нумерация, пустые линии,
// дневник, подписи) делает шаблон.
#import "../template/template.typ": *

#show: setup.with()

#report(
  // Реквизиты шапки (по умолчанию — как в LaTeX: № 00, Практикум на ЭВМ, ...).
  // meta: (
  //   lab-number: "1",
  //   discipline: "Фундаментальная информатика",
  //   student-group: "М8О-113БВ-25",
  //   student-name: "Маркусь Евгений Олегович",
  //   student-number: "17",
  //   student-contacts: "markus.jenya04@yandex.ru",
  //   date-of-completion: "«16» сентября 2025 г.",
  //   teacher: "каф. 806 Никулин Сергей Петрович",
  //   number-variant: "1",
  // ),
  topic: [],
  goal: [],
  task: [],
  equipment-lab: [],
  equipment-student: [],
  software-lab: [],
  software-student: [],
  idea: [],
  scenario: [],
  protocol-body: [],
  diary-rows: (),
  comments: [],
  conclusion: [],
  fixes: [],
)
