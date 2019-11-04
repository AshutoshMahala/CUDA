
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>

cudaError_t addWithCuda(int *c, const int *a, const int *b, unsigned int size);

/*__global__ void addkernel(int *c, const int *a, const int *b)
{
    int i = threadidx.x;
    c[i] = a[i] + b[i];
}*/

__global__ void hellow_cuda() {
	printf("hello CUDA world \n");
}

int main()
{

	/*hellow_cuda << <2, 5 >> > ();*/
	int nx, ny;
	nx = 16;
	ny = 4;

	dim3 block(8,2,1);
	dim3 grid(nx/block.x, ny/block.y);

	hellow_cuda << <grid, block >> > ();

	cudaDeviceSynchronize();

	cudaDeviceReset();

    return 0;
}