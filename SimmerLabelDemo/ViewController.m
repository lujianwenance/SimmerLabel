//
//  ViewController.m
//  SimmerLabelDemo
//
//  Created by l on 16/8/12.
//  Copyright © 2016年 l. All rights reserved.
//

#import "ViewController.h"
#import "SimmerLabel.h"

@interface ViewController ()

@property (nonatomic, strong) SimmerLabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor grayColor];
    
    _label = [[SimmerLabel alloc] init];
    _label.text = @"> 滑动来解锁屏幕";
    _label.frame = CGRectMake(0, 0, 200, 50);
    _label.center = self.view.center;
    _label.textAlignment = NSTextAlignmentCenter;
    [_label runWithAnimationDirection:kAnimationDirectionRight];
    [self.view addSubview:_label];
}

@end
