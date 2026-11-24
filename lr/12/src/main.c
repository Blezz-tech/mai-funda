/* Лабораторная работа 12. Задание № 4
* Студент гр. М8О-113БВ-26 Маркусь Е.О. */


#include <stdio.h>
#include <stdlib.h>

int main() {
    int x;
    int res;

    while ((res = scanf("%d", &x)) != EOF) {
        if (res == 1) {
            unsigned int n = abs(x);
            unsigned int count = 0;

            while (n > 99) {
                unsigned int prev2 = n % 10;
                unsigned int prev1 = (n / 10) % 10;
                unsigned int curr = (n / 100) % 10;
                if (curr == prev1 + prev2) {
                    printf("%d ", curr);
                    count += 1;
                }
                n /= 10;
            }
            if (count > 0) {
                printf("\n");
            }
        } else {
            getchar(); 
        }
    }

    return 0;
}
