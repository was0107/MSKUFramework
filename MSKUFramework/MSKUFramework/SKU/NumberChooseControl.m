//
//  NumberChooseControl.m
//  B5MSKUFramework
//
//  Created by Micker on 15/8/19.
//  Copyright (c) 2015年 micker. All rights reserved.
//

#import "NumberChooseControl.h"

#define kWhiteGrayColor [UIColor colorWithRed:209.0f/255.0f green:213.0f/255.0f blue:219.0f/255.0f alpha:1.0f]

@interface NumberChooseControl() <UITextFieldDelegate>
@property (nonatomic, strong) UILabel   *tipLabel;
@property (nonatomic, strong) UIButton  *decreaseButton;
@property (nonatomic, strong) UIButton  *increaseButton;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation NumberChooseControl {
    CGSize _contentSize;
    CGFloat _padding;
    CGFloat _fontSize;
}

- (id) initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if (self) {
        _contentSize = frame.size;
        _padding = 8.0f;
        _fontSize = 20.0f;
        [self addSubview:self.tipLabel];
        [self addSubview:self.decreaseButton];
        [self addSubview:self.textField];
        [self addSubview:self.increaseButton];
        
        self.minNumber = 1;
        self.maxNumber = NSUIntegerMax;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark --
#pragma mark -- Action

- (void) enableButtonWithValue:(NSInteger) currentNumber {
    _increaseButton.enabled = (currentNumber < _maxNumber);
    _decreaseButton.enabled = (currentNumber > _minNumber);
}

- (void) setMaxNumber:(NSInteger)maxNumber {
    _maxNumber = maxNumber;
    NSInteger currentNumber = [self.textField.text integerValue];
    if (currentNumber > _maxNumber) {
        self.currentValue = currentNumber = _maxNumber;
    }
    [self enableButtonWithValue:currentNumber];
}

- (void) setMinNumber:(NSInteger)minNumber {
    _minNumber = minNumber;
    NSInteger currentNumber = [self.textField.text integerValue];
    if (currentNumber < _minNumber) {
        self.currentValue = currentNumber = _minNumber;
    }
    [self enableButtonWithValue:currentNumber];
}

- (IBAction)decreaseButtonAction:(id)sender {
    NSInteger currentNumber = [self.textField.text integerValue];
    currentNumber--;
    if (currentNumber >= _minNumber) {
        self.currentValue = currentNumber;
    }
    [self enableButtonWithValue:currentNumber];
}

- (IBAction)increaseButtonAction:(id)sender {
    NSInteger currentNumber = [self.textField.text integerValue];
    currentNumber++;
    if (currentNumber <= _maxNumber) {
        self.currentValue = currentNumber;
    } else {
        currentNumber = _maxNumber;
    }
    [self enableButtonWithValue:currentNumber];
}

- (void) setCurrentValue:(NSInteger)currentValue {
    NSInteger result = currentValue;
    if (result > _maxNumber || result < _minNumber) {
        result = _minNumber;
    }
    self.textField.text = [NSString stringWithFormat:@"%@", @(result)];
}

#pragma mark --
#pragma mark -- getter

- (UITextField *) inputTextField {
    return self.textField;
}

- (UILabel *) leftTipLabel {
    return self.tipLabel;
}

- (NSInteger) currentValue {
    NSInteger currentNumber = [self.textField.text integerValue];
    return currentNumber;
}

- (UILabel *) tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:
                     CGRectMake(0,_padding,80,_contentSize.height - 2 * _padding)];
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.font = [UIFont systemFontOfSize:_fontSize - 3];
        _tipLabel.text = @"购买数量";
    }
    return _tipLabel;
}

- (UIButton *) decreaseButton {
    if (!_decreaseButton) {
        _decreaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _decreaseButton.frame = CGRectMake(_contentSize.width - 130 , _padding, 40, 40);
        _decreaseButton.titleLabel.font = [UIFont boldSystemFontOfSize:_fontSize];
        [_decreaseButton setTitle:@"-" forState:UIControlStateNormal];
        [_decreaseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_decreaseButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_decreaseButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
        [_decreaseButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        _decreaseButton.layer.borderWidth = 1.0f;
        _decreaseButton.layer.borderColor = [kWhiteGrayColor CGColor];
        [_decreaseButton addTarget:self action:@selector(decreaseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _decreaseButton;
}

- (UITextField *) textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:
                      CGRectMake(_contentSize.width - 90 - 1, _padding, 50, 40)];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.layer.borderWidth = 1.0f;
        _textField.delegate = self;
        _textField.text = @"1";
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.layer.borderColor = [kWhiteGrayColor CGColor];
        _textField.font = [UIFont boldSystemFontOfSize:_fontSize];
    }
    return _textField;
}

- (UIButton *) increaseButton {
    if (!_increaseButton) {
        _increaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _increaseButton.frame =
        CGRectMake(_contentSize.width - 40 - 2, _padding, 40, 40);
        _increaseButton.titleLabel.font = [UIFont boldSystemFontOfSize:_fontSize];
        [_increaseButton setTitle:@"+" forState:UIControlStateNormal];
        [_increaseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_increaseButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [_increaseButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_increaseButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
        _increaseButton.layer.borderWidth = 1.0f;
        _increaseButton.layer.borderColor = [kWhiteGrayColor CGColor];
        [_increaseButton addTarget:self action:@selector(increaseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _increaseButton;
}

#pragma mark --
#pragma mark -- UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length == 0) {
        self.currentValue = _minNumber;
        [self enableButtonWithValue:self.currentValue];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString *result = [NSMutableString stringWithString:textField.text];
    [result replaceCharactersInRange:range withString:string];
    if (result.length == 0) {
        return YES;
    }
    NSInteger currentNumber = [result integerValue];
    if (currentNumber <= _maxNumber && currentNumber >= _minNumber) {
        [self enableButtonWithValue:currentNumber];
        return YES;
    }
    return NO;
}

@end
