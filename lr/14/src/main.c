/* Лабораторная работа 14. Задание № 1
* Студент гр. М8О-113БВ-26 Маркусь Е.О. */

#include "stdio.h"

/* вар 1
7 11 14 16
4  8 12 15
2  5  9 13
1  3  6 10
*/

int main() {
    int m[7][7];

    int n; // размерность

    scanf("%d", &n);
    for (int j = 0; j != n; ++j)
        for (int i = 0; i != n; ++i)
            scanf("%d", &m[i][j]);
    
    for (int d = n - 1; d > -n; --d) {
        int x = 0;
        int y = d;
        while (x < n && y < n) {
            if (y < 0) {
                ++x;
                ++y;
                continue;
            }
            printf("%d ", m[x][y]);
            ++x;
            ++y;
        }
    }
    printf("\n");
    return 0;
}