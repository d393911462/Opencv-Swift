//
//  CVWrapper.m
//  GoDrawing
//
//  Created by Dengzeyu on 15/8/4.
//  Copyright © 2015年 Dengzeyu. All rights reserved.
//

#import "CVWrapper.h"
#import "OpenCVController.h"
@implementation CVWrapper

+(UIImage *)startCanny:(float) cannyvalue andImage:(UIImage*)image
{
   return  [OpenCVController startCanny:cannyvalue andImage:image];
}
+(UIImage *) showcannyimage:(float)values andimage:(UIImage *)image
{
    return [OpenCVController showcannyimage:values andimage:image];
}
+(UIImage *) sumiao:(UIImage *)yuantu
{
   return  [OpenCVController sumiao:yuantu];
}
+(void)cvMatFromUIImage:(UIImage *)image
{
    cv::Mat currentImage= [OpenCVController cvMatFromUIImage:image];//  当前帧的Mat
}
@end
