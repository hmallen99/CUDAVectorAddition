#include <iostream>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>

__global__ void add(int *a, int *b, int *c) {
	c[blockIdx.x] = a[blockIdx.x] + b[blockIdx.x];
}

void random_ints(int* a, int N) {
	for (int i = 0; i < N; i++) {
		a[i] = rand() % 10;
	}
}

#define N 10
int main(void)
{
	int *a, *b, *c;
	int *d_a, *d_b, *d_c;
	int size = N * sizeof(int);

	cudaMalloc((void **)&d_a, size);
	cudaMalloc((void **)&d_b, size);
	cudaMalloc((void **)&d_c, size);

	a = (int *)malloc(size); random_ints(a, N);
	b = (int *)malloc(size); random_ints(b, N);
	c = (int *)malloc(size);

	cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);

	add<<<N, 1>>> (d_a, d_b, d_c);

	cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);

	for (int i = 0; i < N; i++) {
		std::cout << a[i] << " + " << b[i] << " = " << c[i] << std::endl;
	}

	free(a); free(b); free(c);
	cudaFree(d_a); cudaFree(d_c); cudaFree(d_c);
	
    return 0;
}

