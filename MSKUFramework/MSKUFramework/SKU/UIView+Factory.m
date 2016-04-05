//
//  UIView+Factory.m
//  MSKUFramework
//
//  Created by Micker on 16/4/5.
//  Copyright © 2016年 micker. All rights reserved.
//

#import "UIView+Factory.h"

@implementation UIView (Factory)

+ (UIView *) lineViewWithFrame:(CGRect) frame color:(UIColor *) color {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    return view;
}

@end
