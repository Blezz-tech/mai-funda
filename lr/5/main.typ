#import "/lib/lab.typ": setup, report, console

#show: setup.with()

#report(
  number: "2 (8)",
  // done: "«14» октября 2025 г.",
  // handed: "«14» октября 2025 г.",
  topic: [Системы программирования на языке Си.],
  goal: [
    изучение конкретной системы программирования на Си и получение навыков
    подготовки текстов и отладки программ.
  ],
  task: [
    – изучить и освоить возможности системы программирования на языке Си;
    – составить и отладить простейшую программу на Си (программа вычисления
    корней квадратного уравнения с целочисленными коэффициентами).
  ],
  software-extra: (
    "Система сборки GNU Make версии 4.4.1",
  ),
  idea: [
    Начало работы программы

    Приглашение к вводу данных

    Ввод коэффициента *a*

    Приглашение к вводу данных

    Ввод коэффициента *b*

    Приглашение к вводу данных

    Ввод коэффициента *c*

    Контрольный вывод введённых данных

    Обработка данных
    
    Вывод результата

    Завершение работы программы
  ],
  scenario: [
    main.c:

    #console("/lr/5/src/main.c", lang: "c")

    Makefile:

    #console("/lr/5/src/Makefile", lang: "makefile")

    *Описание тестов* (проверка тестов происходит в конце протокола):

    Тест 1

    #console("/lr/5/tests/descriptions/1.txt")

    Тест 2

    #console("/lr/5/tests/descriptions/2.txt")

    Тест 3

    #console("/lr/5/tests/descriptions/3.txt")

    Тест 4

    #console("/lr/5/tests/descriptions/4.txt")

    Тест 5

    #console("/lr/5/tests/descriptions/5.txt")

    Тест 6

    #console("/lr/5/tests/descriptions/6.txt")

    Тест 7

    #console("/lr/5/tests/descriptions/7.txt")
  ],
  protocol: [
    *1. Синтаксическая ошибка*

    #console("/lr/5/protos/proto1.txt")

    *2. Правильная работа программы*

    #console("/lr/5/protos/proto2.txt")

    *3. Ошибка во время выполнения (неверный ответ, деление на ноль)*

    #console("/lr/5/protos/proto3.txt")

    *4. Результаты тестирования*

    Тест 1

    #console("/lr/5/tests/results/1.txt")

    Тест 2

    #console("/lr/5/tests/results/2.txt")

    Тест 3

    #console("/lr/5/tests/results/3.txt")

    Тест 4

    #console("/lr/5/tests/results/4.txt")

    Тест 5

    #console("/lr/5/tests/results/5.txt")

    Тест 6

    #console("/lr/5/tests/results/6.txt")

    Тест 7

    #console("/lr/5/tests/results/7.txt")
  ],
  diary-rows: (
    ("1", "дом.", "14.10.2025", "21:20–22:15", "Выполнение работы", "Нет", "Нет"),
    ("2", "дом.", "15.10.2025", "7:10–7:55", "Доработка работы",
      [Добавлено тестирование программы. Добавлен раздел «Правильная работа
       программы»],
      [Нет]),
  ),
  conclusion: [
    Был прочитан файл задания. Были изучены команды и применены на примере.
    Лабораторная работа выполнена.
  ],
)
