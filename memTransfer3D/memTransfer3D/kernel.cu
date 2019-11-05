
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

__global__ void threed_mem_transfer(int* input, int size)
{
	int tidx = threadIdx.x;
	int tidy = blockDim.x*threadIdx.y;
	int tidz = blockDim.x* blockDim.x*threadIdx.z;
	int xblock_index = blockDim.x * blockIdx.x;
	int row_index = blockDim.x * blockDim.y * gridDim.x * blockIdx.y;
	int page_index = blockDim.x * blockDim.y * blockDim.z * gridDim.x * gridDim.y * blockIdx.z;
	int gid = tidx + tidy + tidz + row_index + page_index;
	if (gid < size) {
		printf("gid: %d, value: %d \n", gid, input[gid]);
	}
}

int main() 
{
	int size = 64;
	int byte_size = size * sizeof(int);

	int* h_input;
	h_input = (int*)malloc(byte_size);

	time_t t;
	srand((unsigned) time(&t));
	for (int i = 0; i < size; i++) {
		h_input[i] = (int)(rand() & 0xff);
	}

	int* d_input;
	cudaMalloc((void**)& d_input, byte_size);

	cudaMemcpy(d_input, h_input, byte_size, cudaMemcpyHostToDevice);

	dim3 block(2,2,2);
	dim3 grid(2,2,2);

	threed_mem_transfer << <grid, block >> > (d_input, size);
	cudaDeviceSynchronize();

	cudaDeviceReset();
	return 0;
}