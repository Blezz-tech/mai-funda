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
    enum State state = START;
    int prev1 = 0;
    int prev2 = 0;
    int sign_allowed = 1;
    int c;
    int count = 0;

    for (;;) {
        c = getchar();
        if (c == EOF || is_separator(c)) {
            if (c == EOF) { break; }
            state = START;
            sign_allowed = 1;
            count = 0;
        } else if (state != BAD) {
            if (state == START && sign_allowed && (c == '+' || c == '-')) {
                sign_allowed = 0;
            } else if (c >= '0' && c <= '9') {
                state = NUMBER;
                sign_allowed = 0;

                switch (count) {
                    case 0:
                        prev1 = c;
                        break;
                    case 1:
                        prev2 = c;
                        break;
                    case 2:
                        if (c == (prev1 + prev2)) {
                            printf(prev2);
                        }
                        prev1 = prev2;
                        prev2 = c;
                        break;
                }
            } else {
                state = BAD;
            }
        }
    }

    return 0;
}
