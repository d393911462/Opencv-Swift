//
//  OpenCVController.cpp
//  avfoundation
//
//  Created by Dengzeyu on 14-10-30.
//  Copyright (c) 2014年 Dengzeyu. All rights reserved.
//

#import "OpenCVController.h"
class ImageHelper
{
public:
    IplImage getimagefrommat(cv::Mat mat)
    {
        IplImage ipl_image=mat;
        return ipl_image;
    }
    
    void FillInternalContours(IplImage *pBinary, double dAreaThre)
    {
        double dConArea;
        CvSeq *pContour = NULL;
        CvSeq *pConInner = NULL;
        CvMemStorage *pStorage = NULL;
        // ÷¥––Ãıº˛
        if (pBinary)
        {
            // ≤È’“À˘”–¬÷¿™
            pStorage = cvCreateMemStorage(0);
            cvFindContours(pBinary, pStorage, &pContour, sizeof(CvContour), CV_RETR_CCOMP, CV_CHAIN_APPROX_SIMPLE);
            // ÃÓ≥‰À˘”–¬÷¿™
            cvDrawContours(pBinary, pContour, CV_RGB(255, 255, 255), CV_RGB(255, 255, 255), 2, CV_FILLED, 8, cvPoint(0, 0));
            // Õ‚¬÷¿™—≠ª∑
            int wai = 0;
            int nei = 0;
            for (; pContour != NULL; pContour = pContour->h_next)
            {
                wai++;
                // ƒ⁄¬÷¿™—≠ª∑
                for (pConInner = pContour->v_next; pConInner != NULL; pConInner = pConInner->h_next)
                {
                    nei++;
                    // ƒ⁄¬÷¿™√Êª˝
                    dConArea = fabs(cvContourArea(pConInner, CV_WHOLE_SEQ));
                    printf("%f\n", dConArea);
                }
                CvRect rect = cvBoundingRect(pContour, 0);
                cvRectangle(pBinary, cvPoint(rect.x, rect.y), cvPoint(rect.x + rect.width, rect.y + rect.height), CV_RGB(255, 255, 255), 1, 8, 0);
            }
            
            printf("wai = %d, nei = %d", wai, nei);
            cvReleaseMemStorage(&pStorage);
            pStorage = NULL;
        }
    }
    int Otsu(IplImage* src)
    {
        int height = src->height;
        int width = src->width;
        
        //histogram
        float histogram[256] = { 0 };
        for (int i = 0; i < height; i++)
        {
            unsigned char* p = (unsigned char*)src->imageData + src->widthStep * i;
            for (int j = 0; j < width; j++)
            {
                histogram[*p++]++;
            }
        }
        //normalize histogram
        int size = height * width;
        for (int i = 0; i < 256; i++)
        {
            histogram[i] = histogram[i] / size;
        }
        
        //average pixel value
        float avgValue = 0;
        for (int i = 0; i < 256; i++)
        {
            avgValue += i * histogram[i];  //’˚∑˘ÕºœÒµƒ∆Ωæ˘ª“∂»
        }
        
        int threshold = 0;
        float maxVariance = 0;
        float w = 0, u = 0;
        for (int i = 0; i < 256; i++)
        {
            w += histogram[i];  //ºŸ…Ëµ±«∞ª“∂»iŒ™„–÷µ, 0~i ª“∂»µƒœÒÀÿ(ºŸ…ËœÒÀÿ÷µ‘⁄¥À∑∂ŒßµƒœÒÀÿΩ–◊ˆ«∞æ∞œÒÀÿ) À˘’º’˚∑˘ÕºœÒµƒ±»¿˝
            u += i * histogram[i];  // ª“∂»i ÷Æ«∞µƒœÒÀÿ(0~i)µƒ∆Ωæ˘ª“∂»÷µ£∫ «∞æ∞œÒÀÿµƒ∆Ωæ˘ª“∂»÷µ
            
            float t = avgValue * w - u;
            float variance = t * t / (w * (1 - w));
            if (variance > maxVariance)
            {
                maxVariance = variance;
                threshold = i;
            }
        }
        
        return threshold;
    }
    void Canny(IplImage* src,IplImage *dsc)
    {
        IplImage * gray=cvCreateImage(cvGetSize(src), src->depth, 1);
        dsc=cvCreateImage(cvGetSize(gray), src->depth, 1);
        cvCvtColor(src, gray, cv::COLOR_BGR2GRAY);
        cvCanny(gray, &dsc, 100, 300);
        cvReleaseImage(&gray);
        
        //return *dsc;
    }
    
    
};
@implementation OpenCVController
cv::Mat masks;
IplImage * dst1t;
+(cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

+(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    cvMat.release();
    return finalImage;
}


+(UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    CVImageBufferRef    buffer;
    buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CVPixelBufferLockBaseAddress(buffer, 0);
    
    void*    base;
    size_t      width, height, bytesPerRow;
    base = CVPixelBufferGetBaseAddress(buffer);
    width = CVPixelBufferGetWidth(buffer);
    height = CVPixelBufferGetHeight(buffer);
    bytesPerRow = CVPixelBufferGetBytesPerRow(buffer);
    
    CGColorSpaceRef colorSpace;
    CGContextRef    cgContext;
    colorSpace = CGColorSpaceCreateDeviceRGB();
    cgContext = CGBitmapContextCreate(
                                      base, width, height, 8, bytesPerRow, colorSpace,
                                      kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    
    CGImageRef  cgImage;
    UIImage*    image;
    cgImage = CGBitmapContextCreateImage(cgContext);
    image = [UIImage imageWithCGImage:cgImage scale:1.0f
                          orientation:UIImageOrientationUp];
    CGImageRelease(cgImage);
    CGContextRelease(cgContext);
    
    CVPixelBufferUnlockBaseAddress(buffer, 0);
    return image;
}

@end
