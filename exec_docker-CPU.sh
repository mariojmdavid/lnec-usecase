#!/bin/sh

CDIR=`pwd`
#DOCK_IMG=lnec_gpu_ubuntu
DOCK_IMG=ubuntu_pyopencl

docker run \
    -v ${CDIR}:/home \
    ${DOCK_IMG} time python /home/OPENCL_CPU_GPU_PilotoCloud.py /home/ImageFilter_mac.cl /home/Obidos_2.png /home/Out.png CPU 1

