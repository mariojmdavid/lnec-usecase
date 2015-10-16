echo "    "
echo "1 - GPU : 1"
time python OPENCL_CPU_GPU_PilotoCloud.py Obidos_2.png Out.png GPU 1
echo "2 - GPU : 1"
time python OPENCL_CPU_GPU_PilotoCloud.py Obidos_2.png Out.png GPU 1
echo "3 - GPU : 1"
time python OPENCL_CPU_GPU_PilotoCloud.py Obidos_2.png Out.png GPU 1
echo "    "
echo "    "
echo "1 - GPU : 10"
time python OPENCL_CPU_GPU_PilotoCloud.py Obidos_2.png Out.png GPU 10
echo "2 - GPU : 10"
time python OPENCL_CPU_GPU_PilotoCloud.py Obidos_2.png Out.png GPU 10
echo "3 - GPU : 10"
time python OPENCL_CPU_GPU_PilotoCloud.py Obidos_2.png Out.png GPU 10
echo "    "
echo "    "
echo "1 - GPU : 100"
time python OPENCL_CPU_GPU_PilotoCloud.py Obidos_2.png Out.png GPU 100
echo "2 - GPU : 100"
time python OPENCL_CPU_GPU_PilotoCloud.py Obidos_2.png Out.png GPU 100
echo "3 - GPU : 100"
time python OPENCL_CPU_GPU_PilotoCloud.py Obidos_2.png Out.png GPU 100
echo "    "
echo "    "

