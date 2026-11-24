#include <stdio.h>

float machine_eps() {
    float e = 1.0f;
    while(1.0f + e*0.5f > 1.0f) {
        e *= 0.5f;
    }
    return e;
}


int main() {
    float e = machine_eps();
    printf("%f", e);
    return 0;
}
