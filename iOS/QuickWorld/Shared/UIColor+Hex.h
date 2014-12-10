//
//  UIColor+Hex.h
//  CevapTV_iPad
//
//  Created by eralp on 7/18/13.
//  Copyright (c) 2013 Publik. All rights reserved.
//


// [UIColor colorWithHex:0xffff0000]; // red
// [UIColor colorWithHex:0x770000FF]; // half-transparent blue

#import <UIKit/UIKit.h>

@interface UIColor (Hex)
+ (UIColor *) colorWithHex:(uint) hex;
@end
