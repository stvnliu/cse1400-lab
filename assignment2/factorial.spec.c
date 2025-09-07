#include <stdio.h>
int factorial(int n) {
	if (n == 0) {
		return 1;
	} else {
		return n * factorial(n - 1);
	}
}

int main() {
	printf("Result of 10 factorial is: %d\n", factorial(5));
	return 0;
}
