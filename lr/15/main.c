/* Лабораторная работа 15. Задание № 27
* Студент гр. М8О-113БВ-26 Маркусь Е.О. */

/* Удаление повторяющихся CTPOK матрицы (оставить только первую из них). */

#include "stdio.h"

int main() {
    int n;
    int m[8][8];
    scanf("%d", &n);
    int rows = n;
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            scanf("%d", &m[i][j]);
        }
    }
    for (int i = 0; i < rows; ++i) {
        for (int k = i + 1; k < rows; ++k) {
            int is_equal = 1;
            for (int j = 0; j < n; ++j) {
                if (m[i][j] != m[k][j]) {
                    is_equal = 0;
                    break;
                }
            }
            if (is_equal) {
                for (int t = k; t < rows - 1; ++t) {
                    for (int j = 0; j < n; ++j) {
                        m[t][j] = m[t + 1][j];
                    }
                }
                --rows;
                --k;
            }
        }
    }
    for (int i = 0; i < rows; ++i) {
        for (int j = 0; j < n; ++j) {
            printf("%d ", m[i][j]);
        }
        printf("\n");
    }
    return 0;
}
