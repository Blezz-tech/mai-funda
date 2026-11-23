/* Лабораторная работа 12. Задание № 4
* Студент гр. М8О-113БВ-26 Маркусь Е.О. */


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
