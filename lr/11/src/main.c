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

void print_ones(int n) {
    switch (n) {
        case 1:
            printf("one");
            break;
        case 2:
            printf("two");
            break;
        case 3:
            printf("three");
            break;
        case 4:
            printf("four");
            break;
        case 5:
            printf("five");
            break;
        case 6:
            printf("six");
            break;
        case 7:
            printf("seven");
            break;
        case 8:
            printf("eight");
            break;
        case 9:
            printf("nine");
            break;
        case 10:
            printf("ten");
            break;
        case 11:
            printf("eleven");
            break;
        case 12:
            printf("twelve");
            break;
        case 13:
            printf("thirteen");
            break;
        case 14:
            printf("fourteen");
            break;
        case 15:
            printf("fifteen");
            break;
        case 16:
            printf("sixteen");
            break;
        case 17:
            printf("seventeen");
            break;
        case 18:
            printf("eighteen");
            break;
        case 19:
            printf("nineteen");
            break;
    }
}

void print_tens(int n) {
    switch (n) {
        case 2:
            printf("twenty");
            break;
        case 3:
            printf("thirty");
            break;
        case 4:
            printf("forty");
            break;
        case 5:
            printf("fifty");
            break;
        case 6:
            printf("sixty");
            break;
        case 7:
            printf("seventy");
            break;
        case 8:
            printf("eighty");
            break;
        case 9:
            printf("ninety");
            break;
    }
}

void print_english(int n)
{
    if (n < 20) {
        print_ones(n);
        printf("\n");
    } else if (n % 10 == 0) {
        print_tens(n / 10);
        printf("\n");
    } else {
        print_tens(n / 10);
        printf(" ");
        print_ones(n % 10);
        printf("\n");
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
