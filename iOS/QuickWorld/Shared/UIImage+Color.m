//
//  UIImage+Color.m
//  CevapTV_iPad
//
//  Created by eralp on 8/14/13.
//  Copyright (c) 2013 Publik. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

+(UIImage*)imageWithColor:(UIColor*)color{

    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+(UIImage*)imageWithColor:(UIColor*)color withSize:(CGSize)rectSize{
    
    CGRect rect = CGRectMake(0, 0, rectSize.width, rectSize.height);

    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(UIImage *)colorize:(UIColor *)theColor{
    
    UIImage *baseImage = self;
    
    //CGFloat f = [[UIScreen mainScreen] scale];
    
    CGSize baseSize = CGSizeMake(baseImage.size.width,baseImage.size.height);
    
    UIGraphicsBeginImageContextWithOptions(baseSize, NO, baseImage.scale);
    //UIGraphicsBeginImageContext(baseSize);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, baseSize.width, baseSize.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSaveGState(ctx);
    CGContextClipToMask(ctx, area, baseImage.CGImage);
    [theColor set];
    CGContextFillRect(ctx, area);
    CGContextRestoreGState(ctx);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextDrawImage(ctx, area, baseImage.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
