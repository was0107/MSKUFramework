//
//  ViewController.m
//  testSKUApplication
//
//  Created by Micker on 16/4/5.
//  Copyright © 2016年 micker. All rights reserved.
//

#import "ViewController.h"
#import "SKUControl.h"

@interface ViewController ()<SKUControlDelegate>

@property (nonatomic, strong) SKUControl *skuControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.skuControl];
    [self.skuControl reloadData];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (SKUControl *) skuControl {
    if (!_skuControl) {
        _skuControl = [[SKUControl alloc] initWithFrame:CGRectMake(0,self.view.bounds.size.height - 398 - 50,
                                                                   self.view.bounds.size.width, 398)];
        _skuControl.backgroundColor = [UIColor clearColor];
        _skuControl.delegate = self;
    }
    return _skuControl;
}


#pragma mark --
#pragma mark --SKUControlDelegate

- (void) configScrollViewData:(UIScrollView *) scrollView {
    NSUInteger rowCount = 10;
    for (int i = 0; i < 4 * rowCount; i++) {
        int row = i / 4;
        int colomn = i % 4;
        UILabel *label = [[UILabel alloc] initWithFrame:
                          CGRectMake(80 * colomn + 10 * (colomn + 1), 40 * row + 10 * (row + 1), 80, 40)];
        label.text = [NSString stringWithFormat:@"sku-%d--",i];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor redColor];
        [scrollView addSubview:label];
    }
    
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, rowCount * 50);
    
}
- (void) configImageView:(UIImageView *) imageView
                   price:(UILabel *) priceLabel
                   store:(UILabel *) storeLabel
                  choose:(UILabel *) chooseLabel
                  number:(NumberChooseControl *) numberControl {
    //    imageView.image = [UIImage imageNamed:@"mail"];
    priceLabel.text = @"￥399.9";
    storeLabel.text = @"库存24044件";
    chooseLabel.text = @"请选择颜色分类";
    numberControl.maxNumber = 5;
    numberControl.minNumber = 2;
}

@end
