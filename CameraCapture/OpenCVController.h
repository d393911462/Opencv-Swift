//
//  OpenCVController.h
//  avfoundation
//
//  Created by Dengzeyu on 14-10-30.
//  Copyright (c) 2014年 Dengzeyu. All rights reserved.
//

#ifndef __avfoundation__OpenCVController__
#define __avfoundation__OpenCVController__

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <opencv2/opencv.hpp>

@interface OpenCVController : NSObject
+(cv::Mat)cvMatFromUIImage:(UIImage *)image;
+(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat;
+(UIImage *)imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer;
+(UIImage *)startCanny:(float) cannyvalue andImage:(UIImage*)image;
+(UIImage *) showcannyimage:(float)values andimage:(UIImage *)image;
+(UIImage *) sumiao:(UIImage *)yuantu;
@end

#endif /* defined(__avfoundation__OpenCVController__) */
