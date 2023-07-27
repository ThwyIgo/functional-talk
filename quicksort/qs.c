#include <stdio.h>

void swap(int *a, int *b) {
  int t = *a;
  *a = *b;
  *b = t;
}

int partition(int array[], int low, int high) {
    int pivot = array[high];

    int i = (low - 1);

    for (int j = low; j < high; j++) {
        if (array[j] <= pivot) {
            i++;
            swap(&array[i], &array[j]);
        }
    }

    swap(&array[i + 1], &array[high]);

    return (i + 1);
}

void quickSort(int array[], int low, int high) {
    if (low < high) {
        int pi = partition(array, low, high);

        quickSort(array, low, pi - 1);
        quickSort(array, pi + 1, high);
    }
}

void printArray(int array[], int size) {
  for (int i = 0; i < size; ++i) {
    printf("%d ", array[i]);
  }
  putchar('\n');
}

#define N 10000
int main() {
    int data[N];
    FILE* numstxt = fopen("nums.txt", "r");
    for (int i = 0; i < N; i++)
        fscanf(numstxt, "%d", &data[i]);
    fclose(numstxt);

    quickSort(data, 0, N - 1);
    printArray(data, N);

    return 0;
}
