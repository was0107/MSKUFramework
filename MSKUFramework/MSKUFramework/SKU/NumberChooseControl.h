//
//  NumberChooseControl.h
//  B5MSKUFramework
//
//  Created by Micker on 15/8/19.
//  Copyright (c) 2015年 micker. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * 商品数量选择控件，支持设置最小值、最大值
 * 且对输入的数值超出最大值时，仍取最后一次的有效值
 */

@interface NumberChooseControl : UIControl

@property (nonatomic, assign) NSInteger minNumber; //default 1;

@property (nonatomic, assign) NSInteger maxNumber;  //default NSUIntegerMax;

@property (nonatomic, assign) NSInteger currentValue;   //current value

@property (nonatomic, assign) UITextField *inputTextField;  //input field

@property (nonatomic, assign) UILabel   *leftTipLabel;      //buy count

@end
