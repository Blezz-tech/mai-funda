/* Лабораторная работа 11. Задание № 33
* Студент гр. М8О-113БВ-25 Маркусь Е.О. */

/*
Алгоритм программы

Читать входной текст посимвольно, разбивая его на слова по разделителям.

Для каждого слова проверять, является ли оно восьмеричным числом. Допускать один знак + или - только в начале слова; после него должна быть хотя бы одна цифра.

По мере чтения цифр накапливать модуль числа по формуле:

новое значение = предыдущее значение × 8 + текущая цифра.

Если встретился недопустимый символ или значение превысило 077, пропускать остаток слова.

На границе слова, если число допустимо и его модуль не меньше 017, выводить его значение словами на английском языке.

Продолжать обработку до конца файла. Последнее слово обработать и в том случае, если после него нет разделителя.
*/

#include <stdio.h>

enum State {
    START,
    NUMBER,
    BAD
};

int is_separator(int c)
{
    return c == ' ' || c == ',' || c == '\t' || c == '\n' || c == '\r';
}

void print_english(int n)
{
    const char* ones[] = {
        "zero", "one", "two", "three", "four",
        "five", "six", "seven", "eight", "nine",
        "ten", "eleven", "twelve", "thirteen", "fourteen",
        "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"
    };

    const char* tens[] = {
        "", "", "twenty", "thirty", "forty",
        "fifty", "sixty", "seventy", "eighty", "ninety"
    };

    if (n < 20) {
        printf("%s\n", ones[n]);
    } else if (n % 10 == 0) {
        printf("%s\n", tens[n / 10]);
    } else {
        printf("%s %s\n", tens[n / 10], ones[n % 10]);
    }
}

int main(void)
{
    const int lower = 017;
    const int upper = 077;

    enum State state = START;
    int value = 0;
    int sign_allowed = 1;
    int c;

    for (;;) {
        c = getchar();

        if (c == EOF || is_separator(c)) {
            if (state == NUMBER && value >= lower) {
                print_english(value);
            }

            if (c == EOF) { break; }
            state = START;
            value = 0;
            sign_allowed = 1;
        } else if (state != BAD) {
            if (state == START && sign_allowed && (c == '+' || c == '-')) {
                sign_allowed = 0;
            } else if (c >= '0' && c <= '7') {
                value = value * 8 + (c - '0');
                state = NUMBER;
                sign_allowed = 0;

                if (value > upper) {
                    state = BAD;
                }
            } else {
                state = BAD;
            }
        }
    }

    return 0;
}
