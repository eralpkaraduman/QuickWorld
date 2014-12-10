//
//  UIImage+Color.h
//  CevapTV_iPad
//
//  Created by eralp on 8/14/13.
//  Copyright (c) 2013 Publik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

+(UIImage*)imageWithColor:(UIColor*)color;
+(UIImage*)imageWithColor:(UIColor*)color withSize:(CGSize)rectSize;
-(UIImage *)colorize:(UIColor *)theColor;
@end
