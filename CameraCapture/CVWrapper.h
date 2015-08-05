//
//  CVWrapper.h
//  GoDrawing
//
//  Created by Dengzeyu on 15/8/4.
//  Copyright © 2015年 Dengzeyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CVWrapper : NSObject

+(UIImage *)startCanny:(float) cannyvalue andImage:(UIImage*)image;
+(UIImage *) showcannyimage:(float)values andimage:(UIImage *)image;
+(UIImage *) sumiao:(UIImage *)yuantu;
+(void)cvMatFromUIImage:(UIImage *)image;
@end
