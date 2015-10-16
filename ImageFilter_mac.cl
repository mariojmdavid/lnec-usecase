
// Gaussian filter of image
__kernel void gaussian_filter(__read_only image2d_t srcImg,
                              __write_only image2d_t dstImg,
                              sampler_t sampler, int width, int height)
{
  // Gaussian Kernel is:
  // 1  2  1
  // 2  4  2
  // 1  2  1

  //    float4 kernelWeights[9] = {1.0f/16.0f, 2.0f/16.0f, 1.0f/16.0f,
  //                               2.0f/16.0f, 4.0f/16.0f, 2.0f/16.0f,
  //                               1.0f/16.0f, 2.0f/16.0f, 1.0f/16.0f };
  int4 kernelWeights[9] = {1,2,1,
                           2,4,2,
                           1,2,1};
  int scale=16;
  int offset=0;
      
  //    int4 kernelWeights[25] = {0, 1, 2, 1, 0,
  //                              1, 2, 3, 2, 1,
  //                              2, 3, 4, 3, 2,
  //			                        1, 2, 3, 2, 1,
  //			                        0, 1, 2, 1, 0};
  //    int scale=41;			     
  int2 outImageCoord = (int2) (get_global_id(0), get_global_id(1));
  if (outImageCoord.x <= width && outImageCoord.y <= height)
  {
    int4 outColor = (int4)(0,0,0,0);
    outColor=((read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y-1))*kernelWeights[0])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y-1))*kernelWeights[1])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y-1))*kernelWeights[2])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y  ))*kernelWeights[3])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y  ))*kernelWeights[4])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y  ))*kernelWeights[5])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y+1))*kernelWeights[6])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y+1))*kernelWeights[7])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y+1))*kernelWeights[8]))/scale;
    outColor=outColor+offset;			    
    // Write the output value to image
    write_imagei(dstImg, outImageCoord, outColor);
    }
}

// Smooth filter of image
__kernel void smooth_filter(__read_only image2d_t srcImg,
                            __write_only image2d_t dstImg, sampler_t sampler,
                            int width, int height)
{
  int4 kernelWeights[9] = {1, 1, 1,
                           1, 5, 1,
                           1, 1, 1};
  int scale=13;
  int offset=0;    
  int2 outImageCoord = (int2) (get_global_id(0), get_global_id(1));
  if (outImageCoord.x <= width && outImageCoord.y <= height)
  {
    int4 outColor = (int4)(0,0,0,0);
    outColor=((read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y-1))*kernelWeights[0])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y-1))*kernelWeights[1])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y-1))*kernelWeights[2])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y  ))*kernelWeights[3])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y  ))*kernelWeights[4])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y  ))*kernelWeights[5])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y+1))*kernelWeights[6])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y+1))*kernelWeights[7])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y+1))*kernelWeights[8]))/scale;
    outColor=outColor+offset;			    
    // Write the output value to image
    write_imagei(dstImg, outImageCoord, outColor);
  }
}

// Smooth more filter of image
__kernel void smooth_more_filter(__read_only image2d_t srcImg,
                                 __write_only image2d_t dstImg,
                                 sampler_t sampler, int width, int height)
{
  int4 kernelWeights[25] = {1,  1,  1,  1,  1,
                            1,  5,  5,  5,  1,
                			      1,  5, 44,  5,  1,
			                      1,  5,  5,  5,  1,
			                      1,  1,  1,  1,  1};
  int scale=100;
  int offset=0;    
  int2 outImageCoord = (int2) (get_global_id(0), get_global_id(1));
  if (outImageCoord.x <= width && outImageCoord.y <= height)
  {
    int4 outColor = (int4)(0,0,0,0);
    outColor=((read_imagei(srcImg, sampler, (int2)(outImageCoord.x-2, outImageCoord.y-2))*kernelWeights[0])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y-2))*kernelWeights[1])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y-2))*kernelWeights[2])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y-2))*kernelWeights[3])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+2, outImageCoord.y-2))*kernelWeights[4])+
     				  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-2, outImageCoord.y-1))*kernelWeights[5])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y-1))*kernelWeights[6])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y-1))*kernelWeights[7])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y-1))*kernelWeights[8])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+2, outImageCoord.y-1))*kernelWeights[9])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-2, outImageCoord.y))*kernelWeights[10])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y))*kernelWeights[11])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y))*kernelWeights[12])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y))*kernelWeights[13])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+2, outImageCoord.y))*kernelWeights[14])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-2, outImageCoord.y+1))*kernelWeights[15])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y+1))*kernelWeights[16])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y+1))*kernelWeights[17])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y+1))*kernelWeights[18])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+2, outImageCoord.y+1))*kernelWeights[19])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-2, outImageCoord.y+2))*kernelWeights[20])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y+2))*kernelWeights[21])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y+2))*kernelWeights[22])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y+2))*kernelWeights[23])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+2, outImageCoord.y+2))*kernelWeights[24]))/scale;
    outColor=outColor+offset;			    
    // Write the output value to image
    write_imagei(dstImg, outImageCoord, outColor);
  }
}

// BLUR filter of image
__kernel void blur_filter(__read_only image2d_t srcImg,
                          __write_only image2d_t dstImg, sampler_t sampler,
                          int width, int height)
{
  int4 kernelWeights[25] = {1,  1,  1,  1,  1,
	                 		      1,  0,  0,  0,  1,
			                      1,  0,  0,  0,  1,
			                      1,  0,  0,  0,  1,
			                      1,  1,  1,  1,  1};
  int scale=16;
  int offset=0;    
  int2 outImageCoord = (int2) (get_global_id(0), get_global_id(1));
  if (outImageCoord.x <= width && outImageCoord.y <= height)
  {
    int4 outColor = (int4)(0,0,0,0);
    outColor=((read_imagei(srcImg, sampler, (int2)(outImageCoord.x-2, outImageCoord.y-2))*kernelWeights[0])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y-2))*kernelWeights[1])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y-2))*kernelWeights[2])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y-2))*kernelWeights[3])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+2, outImageCoord.y-2))*kernelWeights[4])+
    				  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-2, outImageCoord.y-1))*kernelWeights[5])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y-1))*kernelWeights[6])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y-1))*kernelWeights[7])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y-1))*kernelWeights[8])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+2, outImageCoord.y-1))*kernelWeights[9])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-2, outImageCoord.y))*kernelWeights[10])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y))*kernelWeights[11])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y))*kernelWeights[12])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y))*kernelWeights[13])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+2, outImageCoord.y))*kernelWeights[14])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-2, outImageCoord.y+1))*kernelWeights[15])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y+1))*kernelWeights[16])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y+1))*kernelWeights[17])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y+1))*kernelWeights[18])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+2, outImageCoord.y+1))*kernelWeights[19])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-2, outImageCoord.y+2))*kernelWeights[20])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y+2))*kernelWeights[21])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y+2))*kernelWeights[22])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y+2))*kernelWeights[23])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+2, outImageCoord.y+2))*kernelWeights[24]))/scale;
    outColor=outColor+offset;
    // Write the output value to image
    write_imagei(dstImg, outImageCoord, outColor);
  }
}

// Contour filter of image
__kernel void contour_filter(__read_only image2d_t srcImg,
                             __write_only image2d_t dstImg, sampler_t sampler,
                             int width, int height)
{
  int4 kernelWeights[9] = {-1, -1, -1,
                 			     -1,  8, -1,
			                     -1, -1, -1};
  int scale=1;
  int offset=255;    
  int2 outImageCoord = (int2) (get_global_id(0), get_global_id(1));
  if (outImageCoord.x <= width && outImageCoord.y <= height)
  {
    int4 outColor = (int4)(0,0,0,0);
    outColor=((read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y-1))*kernelWeights[0])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y-1))*kernelWeights[1])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y-1))*kernelWeights[2])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y  ))*kernelWeights[3])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y  ))*kernelWeights[4])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y  ))*kernelWeights[5])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y+1))*kernelWeights[6])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y+1))*kernelWeights[7])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y+1))*kernelWeights[8]))/scale;
    outColor=outColor+offset;			    
    // Write the output value to image
    write_imagei(dstImg, outImageCoord, outColor);
  }
}

// Detail filter of image
__kernel void detail_filter(__read_only image2d_t srcImg,
                            __write_only image2d_t dstImg, sampler_t sampler,
                            int width, int height)
{
  int4 kernelWeights[9] = {0, -1,  0,
                 			    -1, 10, -1,
			                     0, -1,  0};
  int scale=6;
  int offset=0;    
  int2 outImageCoord = (int2) (get_global_id(0), get_global_id(1));
  if (outImageCoord.x <= width && outImageCoord.y <= height)
  {
    int4 outColor = (int4)(0,0,0,0);
    outColor=((read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y-1))*kernelWeights[0])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y-1))*kernelWeights[1])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y-1))*kernelWeights[2])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y  ))*kernelWeights[3])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y  ))*kernelWeights[4])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y  ))*kernelWeights[5])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y+1))*kernelWeights[6])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y+1))*kernelWeights[7])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y+1))*kernelWeights[8]))/scale;
    outColor=outColor+offset;			    
    // Write the output value to image
    write_imagei(dstImg, outImageCoord, outColor);
  }
}

// EDGE_ENHANCE filter of image
__kernel void edge_enhance_filter(__read_only image2d_t srcImg,
                                  __write_only image2d_t dstImg,
                                  sampler_t sampler, int width, int height)
{
  int4 kernelWeights[9] = {-1, -1, -1,
			                     -1, 10, -1,
			                     -1, -1, -1};
  int scale=2;
  int offset=0;    
  int2 outImageCoord = (int2) (get_global_id(0), get_global_id(1));
  if (outImageCoord.x <= width && outImageCoord.y <= height)
  {
   	int4 outColor = (int4)(0,0,0,0);
    outColor=((read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y-1))*kernelWeights[0])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y-1))*kernelWeights[1])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y-1))*kernelWeights[2])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y  ))*kernelWeights[3])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y  ))*kernelWeights[4])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y  ))*kernelWeights[5])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y+1))*kernelWeights[6])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y+1))*kernelWeights[7])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y+1))*kernelWeights[8]))/scale;
    outColor=outColor+offset;			    
    // Write the output value to image
    write_imagei(dstImg, outImageCoord, outColor);
  }
}

// EDGE_ENHANCE_MORE filter of image
__kernel void edge_enhance_more_filter(__read_only image2d_t srcImg,
                                       __write_only image2d_t dstImg,
                                       sampler_t sampler, int width, int height)
{
  int4 kernelWeights[9] = {-1, -1, -1,
                			     -1,  9, -1,
                			     -1, -1, -1};
  int scale=1;
  int offset=0;    
  int2 outImageCoord = (int2) (get_global_id(0), get_global_id(1));
  if (outImageCoord.x <= width && outImageCoord.y <= height)
  {
   	int4 outColor = (int4)(0,0,0,0);
    outColor=((read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y-1))*kernelWeights[0])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y-1))*kernelWeights[1])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y-1))*kernelWeights[2])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y  ))*kernelWeights[3])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y  ))*kernelWeights[4])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y  ))*kernelWeights[5])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y+1))*kernelWeights[6])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y+1))*kernelWeights[7])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y+1))*kernelWeights[8]))/scale;
    outColor=outColor+offset;			    
    // Write the output value to image
    write_imagei(dstImg, outImageCoord, outColor);
  }
}

// Emboss filter of image
__kernel void emboss_filter(__read_only image2d_t srcImg,
                            __write_only image2d_t dstImg, sampler_t sampler,
                            int width, int height)
{
  int4 kernelWeights[9] = {-1,  0,  0,
			                      0,  1,  0,
			                      0,  0,  0};
  int scale=1;
  int offset=128;    
  int2 outImageCoord = (int2) (get_global_id(0), get_global_id(1));
  if (outImageCoord.x <= width && outImageCoord.y <= height)
  {
    int4 outColor = (int4)(0,0,0,0);
    outColor=((read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y-1))*kernelWeights[0])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y-1))*kernelWeights[1])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y-1))*kernelWeights[2])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y  ))*kernelWeights[3])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y  ))*kernelWeights[4])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y  ))*kernelWeights[5])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y+1))*kernelWeights[6])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y+1))*kernelWeights[7])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y+1))*kernelWeights[8]))/scale;
    outColor=outColor+offset;			    
    // Write the output value to image
    write_imagei(dstImg, outImageCoord, outColor);
  }
}

// Find edges filter of image
__kernel void find_edges_filter(__read_only image2d_t srcImg,
                                __write_only image2d_t dstImg,
                                sampler_t sampler, int width, int height)
{
  int4 kernelWeights[9] = {-1, -1, -1,
	                 		     -1,  8, -1,
			                     -1, -1, -1};
  int scale=1;
  int offset=0;    
  int2 outImageCoord = (int2) (get_global_id(0), get_global_id(1));
  if (outImageCoord.x <= width && outImageCoord.y <= height)
  {
    int4 outColor = (int4)(0,0,0,0);
    outColor=((read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y-1))*kernelWeights[0])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y-1))*kernelWeights[1])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y-1))*kernelWeights[2])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y  ))*kernelWeights[3])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y  ))*kernelWeights[4])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y  ))*kernelWeights[5])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y+1))*kernelWeights[6])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y+1))*kernelWeights[7])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y+1))*kernelWeights[8]))/scale;
    outColor=outColor+offset;			    
    // Write the output value to image
    write_imagei(dstImg, outImageCoord, outColor);
  }
}

// Sharpen filter of image
__kernel void sharpen_filter(__read_only image2d_t srcImg,
                             __write_only image2d_t dstImg, sampler_t sampler,
                             int width, int height)
{
  int4 kernelWeights[9] = {-2, -2, -2,
                 			     -2, 32, -2,
			                     -2, -2, -2};
  int scale=16;
  int offset=0;    
  int2 outImageCoord = (int2) (get_global_id(0), get_global_id(1));
  if (outImageCoord.x <= width && outImageCoord.y <= height)
  {
    int4 outColor = (int4)(0,0,0,0);
    outColor=((read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y-1))*kernelWeights[0])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y-1))*kernelWeights[1])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y-1))*kernelWeights[2])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y  ))*kernelWeights[3])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y  ))*kernelWeights[4])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y  ))*kernelWeights[5])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x-1, outImageCoord.y+1))*kernelWeights[6])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x  , outImageCoord.y+1))*kernelWeights[7])+
        		  (read_imagei(srcImg, sampler, (int2)(outImageCoord.x+1, outImageCoord.y+1))*kernelWeights[8]))/scale;
    outColor=outColor+offset;			    
    // Write the output value to image
    write_imagei(dstImg, outImageCoord, outColor);
  }
}
