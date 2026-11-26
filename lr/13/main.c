/* Лабораторная работа 13. Задание № 29
* Студент гр. М8О-113БВ-26 Маркусь Е.О. */

/* Есть ли слово, содержащее более одной прописной буквы? */

#include "stdio.h"
#include "stdint.h"

int is_sepraator(int c) {
    return c == ' ' || c == '\n' || c == '\r' || c == '\t';
}

int is_upper_case_english(int c) {
    return 'A' <= c && c <= 'Z';
}

int is_upper_case_russian(int c) {
    return (0x90 <= c && c <= 0xAF) || c == 0x81;
}

int main() {
    int count = 0;
    int c;
    int is_exist = 0;
    for (;;) {
        c = getchar();
        if (c == 0xD0) {
            int c1 = getchar();
            if(is_upper_case_russian(c1)) {
                ++count;
            }            
        } else if (is_upper_case_english(c)) {
            ++count;
        }
        if (count > 1) {
            is_exist = 1;
            break;
        }
        if(is_sepraator(c)) {
            count = 0;
            continue;
        }
        if (c == EOF)  {
            break;
        }
    }
    if (is_exist) {
        printf("\nЕсть\n");
    } else {
        printf("\nНет\n");
    }
    return 0;
}
