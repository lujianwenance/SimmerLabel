//
//  SimmerLabel.h
//  AnimationTest
//
//  Created by l on 16/8/10.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,AnimationDirection) {
    kAnimationDirectionRight,
    kAnimationDirectionLeft
};

@interface SimmerLabel : UIView

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, assign) NSTextAlignment textAlignment;

@property (nonatomic, strong) UIColor *animationColor;

- (void)runWithAnimationDirection:(AnimationDirection)direction;

@end
