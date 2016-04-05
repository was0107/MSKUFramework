//
//  SKUControl.m
//  B5MSKUFramework
//
//  Created by Micker on 15/8/19.
//  Copyright (c) 2015年 micker. All rights reserved.
//

#import "SKUControl.h"
#import "UIView+Factory.h"


#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey : @"UIKeyboardBoundsUserInfoKey")

@interface SKUControl()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView       *topView;
@property (nonatomic, strong) UIView       *bottomView;
@property (nonatomic, strong) UIView       *topLineView;
@property (nonatomic, strong) UIView       *keyboardView;

@end


@implementation SKUControl {
    CGFloat _animateHeight;
    CGRect  _numberRect;
}
@synthesize imageView       = _imageView;
@synthesize priceLabel      = _priceLabel;
@synthesize storeLabel      = _storeLabel;
@synthesize chooseLabel     = _chooseLabel;
@synthesize closeButton     = _closeButton;
@synthesize numberControl   = _numberControl;

- (id) initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if (self) {
        _contentSize = frame.size;
        _padding = 8.0f;
        _fontSize = 14.0f;
        _imageViewSize = 100.0f;
        _animateHeight = 80.0f;
        [self keyboardView];
        [self.topView addSubview:self.priceLabel];
        [self.topView addSubview:self.storeLabel];
        [self.topView addSubview:self.chooseLabel];

        [self addSubview:self.topView];
        [self addSubview:self.topLineView];
        [self addSubview:self.closeButton];
        [self addSubview:self.imageView];
        [self addSubview:self.scrollView];
        [self setup];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

#pragma mark --
#pragma mark --Action

- (IBAction)closeButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeSKUAction)]) {
        [self.delegate closeSKUAction];
    }
}

- (IBAction)finishInputAction:(id)sender {
    [self endEditing:YES];
}

- (void) configScrollView {
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(configScrollViewData:)]) {
        [self.delegate configScrollViewData:self.scrollView];
    }
    CGSize size = self.scrollView.contentSize;
    CGRect rect = self.numberControl.frame;
    if (size.height - rect.size.height - 2 * _padding <= self.scrollView.bounds.size.height) {
        
    }
    rect.origin.y = size.height + _padding;
    
    [self.scrollView addSubview:[UIView lineViewWithFrame:
                                 CGRectMake(_padding,
                                            size.height + _padding,
                                            _contentSize.width - 2 *_padding, 1)
                                                        color:kWhiteGrayColor]];
    
    self.numberControl.frame = rect;
    size.height += self.numberControl.frame.size.height + 1 *_padding;
    
    [self.scrollView addSubview:[UIView lineViewWithFrame:
                                 CGRectMake(_padding,
                                            size.height - 1,
                                            _contentSize.width - 2 *_padding,1)
                                                        color:kWhiteGrayColor]];
    size.height += _padding;

    if (size.height <= self.scrollView.bounds.size.height) {
        size.height = self.scrollView.bounds.size.height + 1.0f;
    }
    [self.scrollView setContentSize:size];
    
    [self.scrollView addSubview:self.numberControl];
    _numberRect = self.numberControl.frame;
}

- (void) reloadData {
    [self configScrollView];
    if (self.delegate && [self.delegate respondsToSelector:
                          @selector(configImageView:price:store:choose:number:)]) {
        [self.delegate configImageView:self.imageView
                                 price:self.priceLabel
                                 store:self.storeLabel
                                choose:self.chooseLabel
                                number:self.numberControl];
    }
}


#pragma mark --
#pragma mark -- Keyboad 

- (void)setup {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TPKeyboardAvoiding_keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TPKeyboardAvoiding_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)TPKeyboardAvoiding_keyboardWillShow:(NSNotification*)notification {
    CGRect keyboardRect = [self convertRect:[[[notification userInfo] objectForKey:_UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    if (CGRectIsEmpty(keyboardRect)) {
        return;
    }
    self.scrollView.scrollEnabled = NO;
    [self.scrollView setFrame:
     CGRectMake(0, _animateHeight , _contentSize.width, 56 + 2 * _padding)];
    CGSize size = [self.scrollView contentSize];
    [self.scrollView setContentOffset:CGPointMake(0, size.height - 56 - 1 * _padding)];
    [self addSubview:self.bottomView];
    __block typeof(self) blockSelf = self;
    [UIView animateWithDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]
                          delay:0
                        options:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]
                     animations:^{
                         
     blockSelf.bottomView.frame = CGRectMake(0, _animateHeight + 56 , _contentSize.width,
                                             _contentSize.height);
     
     blockSelf.imageView.frame = CGRectMake(_padding, _padding ,
                                            _animateHeight-2*_padding, _animateHeight-2*_padding);
     
     blockSelf.closeButton.frame = CGRectMake(_contentSize.width - 40, 0 , 40, 40);
     
     blockSelf.topView.frame = CGRectMake(0, 0, _contentSize.width, _animateHeight);
     
     blockSelf.priceLabel.frame = CGRectMake(_animateHeight, _padding,
                                             _contentSize.width - _animateHeight - _padding,20);
     
     blockSelf.storeLabel.frame = CGRectMake(_animateHeight, _padding + 20,
                                             _contentSize.width - _animateHeight - _padding,20);
     
     blockSelf.chooseLabel.frame = CGRectMake(_animateHeight, _padding + 40,
                                              _contentSize.width - _animateHeight - _padding,20);
        
    } completion:^(BOOL finished) {
    }];
}

- (void)TPKeyboardAvoiding_keyboardWillHide:(NSNotification*)notification {
    CGRect keyboardRect = [self convertRect:[[[notification userInfo] objectForKey:_UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    if (CGRectIsEmpty(keyboardRect)) {
        return;
    }
    __block typeof(self) blockSelf = self;
    [self.bottomView removeFromSuperview];
    self.scrollView.frame = CGRectMake(0, _imageViewSize + _padding, _contentSize.width, _contentSize.height - _imageViewSize - _padding);
    [UIView animateWithDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]
                          delay:0
                        options:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]
                     animations:^{
                         
    blockSelf.imageView.frame = CGRectMake(_padding, 0 ,_imageViewSize, _imageViewSize);

    blockSelf.closeButton.frame = CGRectMake(_contentSize.width - 40, _padding * 2 , 40, 40);

    blockSelf.topView.frame = CGRectMake(0, 2 * _padding, _contentSize.width, _imageViewSize);

    blockSelf.priceLabel.frame = CGRectMake(_padding * 2 + _imageViewSize,_padding + 5,
                                         _contentSize.width - _imageViewSize - 3* _padding,20);

    blockSelf.storeLabel.frame = CGRectMake(_padding * 2 + _imageViewSize, _padding + 25,
                                         _contentSize.width - _imageViewSize - 3* _padding,20);

    blockSelf.chooseLabel.frame = CGRectMake(_padding * 2 + _imageViewSize, _padding + 45,
                                          _contentSize.width - _imageViewSize - 3* _padding,20);
                     } completion:^(BOOL finished) {
                         blockSelf.scrollView.scrollEnabled = YES;
                         blockSelf.bottomView.frame = CGRectMake(0, _contentSize.height + 44, _contentSize.width,
                                                                 _contentSize.height - _animateHeight);
                     }];
}

#pragma mark --
#pragma mark --getter

- (UIView *) topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:
                    CGRectMake(0, 2 * _padding, _contentSize.width, _imageViewSize)];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

- (UIView *) bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:
                       CGRectMake(0, _contentSize.height + 44, _contentSize.width, _contentSize.height - _animateHeight)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [_bottomView addSubview:self.keyboardView];
    }
    return _bottomView;
}


- (UIView *) topLineView {
    if (!_topLineView) {
        _topLineView = [UIView lineViewWithFrame:
                        CGRectMake(_padding, _imageViewSize + _padding - 1,
                                   _contentSize.width - 2 * _padding,1)
                                                   color:kWhiteGrayColor];
    }
    return _topLineView;
}

- (UIImageView *) imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:
                      CGRectMake(_padding, 0 ,_imageViewSize, _imageViewSize)];
        _imageView.backgroundColor = kWhiteGrayColor;
        _imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _imageView.layer.borderWidth = 2.0f;
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 4.0f;
    }
    return _imageView;
}

- (UILabel *) priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:
                     CGRectMake(_padding * 2 + _imageViewSize,
                                _padding + 5,
                                _contentSize.width - _imageViewSize - 3* _padding,20)];
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.font = [UIFont systemFontOfSize:_fontSize + 1];
        _priceLabel.text = @"购买数量";
        _priceLabel.textColor = [UIColor orangeColor];
    }
    return _priceLabel;
}

- (UILabel *) storeLabel {
    if (!_storeLabel) {
        _storeLabel = [[UILabel alloc] initWithFrame:
                     CGRectMake(_padding * 2 + _imageViewSize, _padding + 25,
                                _contentSize.width - _imageViewSize - 3* _padding,20)];
        _storeLabel.backgroundColor = [UIColor clearColor];
        _storeLabel.font = [UIFont systemFontOfSize:_fontSize];
        _storeLabel.text = @"库存24044件";
        _storeLabel.textColor = [UIColor blackColor];
    }
    return _storeLabel;
}

- (UILabel *) chooseLabel {
    if (!_chooseLabel) {
        _chooseLabel = [[UILabel alloc] initWithFrame:
                     CGRectMake(_padding * 2 + _imageViewSize, _padding + 45,
                                _contentSize.width - _imageViewSize - 3* _padding,20)];
        _chooseLabel.backgroundColor = [UIColor clearColor];
        _chooseLabel.font = [UIFont systemFontOfSize:_fontSize];
        _chooseLabel.text = @"请选择颜色分类";
        _chooseLabel.textColor = [UIColor blackColor];
    }
    return _chooseLabel;
}

- (UIButton *) closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(_contentSize.width - 40, _padding * 2 , 40, 40);
        _closeButton.backgroundColor = kWhiteGrayColor;
        [_closeButton addTarget:self
                         action:@selector(closeButtonAction:)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (NumberChooseControl *) numberControl {
    if (!_numberControl) {
        _numberControl = [[NumberChooseControl alloc] initWithFrame:CGRectMake(_padding, _padding, _contentSize.width - 2 * _padding, 56)];
    }
    return _numberControl;
}

- (UIScrollView *) scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:
                       CGRectMake(0, _imageViewSize + _padding, _contentSize.width, _contentSize.height - _imageViewSize - _padding)];
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}

- (UIView *) keyboardView {
    if (!_keyboardView) {
        _keyboardView = [[UIView alloc] initWithFrame:
                         CGRectMake(0, 44, _contentSize.width, 44)];
        _keyboardView.backgroundColor = kWhiteGrayColor;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(_contentSize.width - 60, 0, 60, 44);
        [button setTitle:@"完成" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(finishInputAction:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        [_keyboardView addSubview:button];
    }
    return _keyboardView;
}


@end
