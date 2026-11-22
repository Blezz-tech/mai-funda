#include "stdio.h"
#include "stdlib.h"

int max(int a, int b);
int min(int a, int b);
// int abs(int a);

// Вычисление предиката делимости на 3 десятичного числа
int main() {
    const int i0 = -30;
    const int j0 = -4;
    const int l0 = 12;

    int i = i0;
    int j = j0;
    int l = l0;
    int k = 0;
    while (k <= 50) {
        if ((j <= -i - 10) && (j >= -i - 20)) {
            break;
        }
        int ik = abs(i - l) + min(j % 10, (l*k) % 10) - 20;
        int jk = max(k - i, min(j, max(i - l, j - l))) % 30;
        int lk = ((l*l) % 20) - (max(i, j) % (k + 1));
        i = ik;
        j = jk;
        l = lk;
        k += 1;
    }
    if (k <= 50) {
        printf("Отлинчо\n");
    } else {
        printf("Не попали\n");
    }
    return 0;
}

int max(int a, int b) {
    if (a > b) {
        return a;
    }
    return b;
}

int min(int a, int b) {
    if (a < b) {
        return a;
    }
    return b;
}
