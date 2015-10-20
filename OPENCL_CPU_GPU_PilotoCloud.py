import time
import pyopencl as cl
import sys
import PIL.Image as Image # Python Image Library (PIL)
import PIL.ImageFilter as ImgFilter
import numpy as np
#import matplotlib.pyplot as plt


t0 = time.clock()

def scale_img(img, type):
    n_colors = {"8": 255., "16": 65536. ,"32": 1.}
    if type == 8:
        out_type = np.uint8
    elif type == 16:
        out_type = np.uint16
    elif type == 32:
        out_type = np.float32
    else:
        print "ERROR! Check <type> argument!!!"
    img_new = np.array(img*n_colors[str(type)]/img.max(), dtype=out_type)
    return img_new


#
#  Create an OpenCL context on the first available platform using
#  either a GPU or CPU depending on what is available.
#
def CreateContext():
    platforms = cl.get_platforms()
    if len(platforms) == 0:
        print "Failed to find any OpenCL platforms."
        sys.exit(1)
    # Next, create an OpenCL context on the first platform.  Attempt to
    # create a GPU-based context, and if that fails, try to create
    # a CPU-based context.
    devices = platforms[0].get_devices(cl.device_type.GPU)
    if len(devices) == 0:
        print "Could not find GPU device, trying CPU..."
        devices = platforms[0].get_devices(cl.device_type.CPU)
        if len(devices) == 0:
            print "Could not find OpenCL GPU or CPU device."
            sys.exit(1)
    # Create a context using the first device
    context = cl.Context([devices[0]])
    return context, devices[0]


#
#  Create an OpenCL program from the kernel source file
#
def CreateProgram(context, device, fileName):
    kernelFile = open(fileName, 'r')
    kernelStr = kernelFile.read()
    # Load the program source
    program = cl.Program(context, kernelStr)
    # Build the program and check for errors
    program.build(devices=[device])
    return program


def CreateImageObj(context, imgSize, channelOrder=cl.channel_order.RGBA,
				   channelType=cl.channel_type.UNSIGNED_INT8,
				   memFlags=cl.mem_flags.WRITE_ONLY):
    # Create ouput image object
    clImageFormat = cl.ImageFormat(channelOrder, channelType)
    ImageObj = cl.Image(context, memFlags, clImageFormat, imgSize)
    return ImageObj


#
#  Load an image using the Python Image Library and create an OpenCL
#  image out of it
#
def LoadImage(context, fileName):
    im = Image.open(fileName)
    img = np.array(im)
    IMG1 = scale_img(img, 8)
    im = Image.fromarray(IMG1)
    # Make sure the image is RGBA formatted
    if im.mode != "RGBA":
        im = im.convert("RGBA")
    IMG1 = np.array(im)
    if len(IMG1.shape) > 2:
        nchannels = IMG1.shape[-1]
    else:
        nchannels = None
    t0 = time.clock()
    clImage = cl.image_from_array(context, IMG1, num_channels=nchannels,
                                  mode="r", norm_int=False)
    t1 = time.clock()
    print t1 - t0, " Load to GPU..."
    return clImage, im.size, IMG1


#
#  Save an image using the Python Image Library (PIL)
#
def SaveImage(fileName, buffer, imgSize):
    im = Image.fromstring("RGBA", imgSize, buffer.tostring())
    im.save(fileName)


#
#  Round up to the nearest multiple of the group size
#
def RoundUp(groupSize, globalSize):
    r = globalSize % groupSize;
    if r == 0:
        return globalSize;
    else:
        return globalSize + groupSize - r;


if __name__ == '__main__':
    t3 = time.clock()
    if len(sys.argv) != 5:
        use = " <inputImageFile> <outputImageFile> <device:CPU/GPU> <ntimes>"
        sys.exit("USAGE: " + sys.argv[0] + use)
    device = sys.argv[3]
    ntimes = np.int(sys.argv[4])
    if device == "GPU":
        t4 = time.clock()
        # Create an OpenCL context on first available platform
        context, device = CreateContext();
        if context == None:
            print "Failed to create OpenCL context."
            sys.exit(1)
        t5 = time.clock()
        print t5 - t4, " Create Context..."
        # Create a command-queue on the first device available
        # on the created context
        commandQueue = cl.CommandQueue(context, device)
        t6 = time.clock()
        print t6 - t5, " Create CommandQueue..."
        # Make sure the device supports images, otherwise exit
        if not device.get_info(cl.device_info.IMAGE_SUPPORT):
            print "OpenCL device does not support images."
            sys.exit(1)
        t7 = time.clock()
        # Load input image from file and load it into an OpenCL image object
        imageObjects = [ 0, 0, 0]
        imageObjects[0], imgSize , IMG_1 = LoadImage(context, sys.argv[1])
        t8 = time.clock()
        print t8 - t7, " Load Image..."
        # Create output1 image object
        imageObjects[1] = CreateImageObj(context, imgSize,
                                        channelOrder=cl.channel_order.RGBA,
                                        channelType=cl.channel_type.UNSIGNED_INT8,
                                        memFlags=cl.mem_flags.READ_WRITE)
        imageObjects[2] = CreateImageObj(context,imgSize,
                                        channelOrder=cl.channel_order.RGBA,
                                        channelType=cl.channel_type.UNSIGNED_INT8,
                                        memFlags=cl.mem_flags.READ_WRITE)
        t9 = time.clock()
        print t9 - t8, " Create Image Object..."
        # Create sampler for sampling image object
        sampler = cl.Sampler(context, False, cl.addressing_mode.CLAMP_TO_EDGE,
                             cl.filter_mode.NEAREST)
        t10 = time.clock()
        print t10 - t9, " Create Sampler..."
        # Create OpenCL program
        program = CreateProgram(context, device, "/home/ImageFilter_mac.cl")
        t11 = time.clock()
        print t11 - t10, "Create Program..."
        globalWorkSize = (imgSize[0],imgSize[1])
        origin = (0, 0, 0)
        region = (imgSize[0], imgSize[1], 1)
        t12 = time.clock()
        program.smooth_more_filter(commandQueue, globalWorkSize, None,
                                   imageObjects[0], imageObjects[1], sampler,
                                   np.int32(imgSize[0]),
                                   np.int32(imgSize[1])).wait()
        program.detail_filter(commandQueue, globalWorkSize, None,
			               imageObjects[1], imageObjects[2], sampler,
			               np.int32(imgSize[0]),
                              np.int32(imgSize[1])).wait()
        program.smooth_filter(commandQueue, globalWorkSize, None,
			               imageObjects[2], imageObjects[1], sampler,
			               np.int32(imgSize[0]),
			               np.int32(imgSize[1])).wait()
        for i in xrange(ntimes):
            if i%2 == 0:
                m, n = 1, 2
            else:
                m, n = 2, 1
        program.blur_filter(commandQueue, globalWorkSize, None,
			             imageObjects[m], imageObjects[n], sampler,
			             np.int32(imgSize[0]),
			             np.int32(imgSize[1])).wait()
        t13=time.clock()
        print t13 - t12, " Run Kernel..."
        t14 = time.clock()
        buf2 = np.zeros(imgSize[0] * imgSize[1] * 4, np.uint8)
        cl.enqueue_read_image(commandQueue, imageObjects[2],
                              origin, region, buf2, is_blocking=True)
        IMG_3 = buf2.reshape(imgSize[1], imgSize[0], 4)
        t15 = time.clock()
        print t15 - t14, " Read Image from GPU..."
        print "Executed program succesfully."
        t16 = time.clock()
        print t16 - t4, " Total GPU..."

    else: ## device == CPU
        t4 = time.clock()
        im = Image.open(sys.argv[1])
        img = np.array(im)
        IMG_1 = scale_img(img, 8)
        img1 = Image.fromarray(IMG_1)
        # Make sure the image is RGBA formatted
        if img1.mode != "RGBA":
            img1 = img1.convert("RGBA")
            IMG_1 = np.array(img1)

        t5 = time.clock()
        img_aux = img1.filter(ImgFilter.SMOOTH_MORE)
        img_aux = img_aux.filter(ImgFilter.DETAIL)
        img_aux = img_aux.filter(ImgFilter.SMOOTH)
        for i in xrange(ntimes):
            img_aux = img_aux.filter(ImgFilter.BLUR)
        IMG_3 = np.array(img_aux)
        t6=time.clock()
        print t6 - t5, " Run Kernel..."
        print t6 - t4, " Total CPU..."
    sys.exit(0)
