/* Лабораторная работа 13. Задание № 1
 * Студент гр. М8О-113БВ-26 Маркусь Е.О. */

/* Есть ли слово, все гласные (согласные) которого различны? */

#include "stdio.h"

const unsigned int VOWELS = (1u << ('a' - 'a'))
                          | (1u << ('e' - 'a'))
                          | (1u << ('i' - 'a'))
                          | (1u << ('o' - 'a'))
                          | (1u << ('u' - 'a'));

// const unsigned int CONSONANTS = ~VOWELS;

enum State {
    SEARCH,
    BAD,
    EXIST
};

int is_separator(int c) {
    return c == ' ' || c == '\t' || c == '\n' || c == '\r' || c == EOF;
}

unsigned int letter_to_mask(int c) {
    if ('a' <= c && c <= 'z') {
        return 1u << (c - 'a');
    }
    if ('A' <= c && c <= 'Z') {
        return 1u << (c - 'A');
    }
    return 0;
}

int main(void) {
    enum State state = SEARCH;
    unsigned int seen = 0;
    int c;

    do {
        c = getchar();

        if (state == EXIST) {
            continue;
        }

        if (is_separator(c)) {
            if (state == SEARCH && seen != 0) {
                state = EXIST;
            } else {
                state = SEARCH;
                seen = 0;
            }
        } else if (state == SEARCH) {
            unsigned int mask = letter_to_mask(c);
            if (VOWELS & mask) {
                if (seen & mask) {
                    state = BAD;
                } else {
                    seen |= mask;
                }
            }
        }
    } while (c != EOF);

    printf(state == EXIST ? "Да\n" : "Нет\n");
    return 0;
}
