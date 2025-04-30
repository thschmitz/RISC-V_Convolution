#include <stdint.h>
#include "image_data.h"

#define CHANNELS 1

int sobel_x[9] = {
  -1, 0, 1,
  -2, 0, 2,
  -1, 0, 1,
};

int sobel_y[9] = {
  -1, -2, -1,
   0,  0,  0,
   1,  2,  1,
};

int abs_int(int value) {
    return value < 0 ? -value : value;
}

int main() {
    int width = 512;
    int height = 512;
    const uint8_t *data = (const uint8_t *)image_data;

    volatile uint64_t checksum = 0; // usar checksum para resultado final

    for (int y = 1; y < height - 1; ++y) {
        for (int x = 1; x < width - 1; ++x) {
            int sbl_x = 0;
            int sbl_y = 0;

            for (int ky = 0; ky < 3; ++ky) {
                for (int kx = 0; kx < 3; ++kx) {
                    int offset_x = kx - 1;
                    int offset_y = ky - 1;
                    int curr_x = x + offset_x;
                    int curr_y = y + offset_y;
                    int kernel_index = ky * 3 + kx;
                    int data_index = curr_y * width + curr_x;

                    sbl_x += sobel_x[kernel_index] * data[data_index];
                    sbl_y += sobel_y[kernel_index] * data[data_index];
                }
            }

            // Aproximação da magnitude: somatório das componentes (sem raiz quadrada)
            int mag = abs_int(sbl_x) + abs_int(sbl_y);

            // Limita a 255
            if (mag > 255) {
                mag = 255;
            }

            checksum += (uint8_t)mag;
        }
    }

    // Finaliza de alguma forma visível para debug
    return (int)(checksum & 0xFFFFFFFF);
}
