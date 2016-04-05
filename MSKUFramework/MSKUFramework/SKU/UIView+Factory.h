//
//  UIView+Factory.h
//  MSKUFramework
//
//  Created by Micker on 16/4/5.
//  Copyright © 2016年 micker. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kWhiteGrayColor [UIColor colorWithRed:209.0f/255.0f green:213.0f/255.0f blue:219.0f/255.0f alpha:1.0f]

@interface UIView (Factory)

+ (UIView *) lineViewWithFrame:(CGRect) frame color:(UIColor *) color;

@end
