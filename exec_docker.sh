#!/bin/sh

CDIR=`pwd`

docker run \
    --device=/dev/nvidia0:/dev/nvidia0 \
    --device=/dev/nvidiactl:/dev/nvidiactl \
    --device=/dev/nvidia-uvm:/dev/nvidia-uvm \
    -v ${CDIR}:/home \
    ubuntu_pyopencl time python /home/OPENCL_CPU_GPU_PilotoCloud.py /home/ImageFilter_mac.cl /home/Obidos_2.png /home/Out.png GPU 1

