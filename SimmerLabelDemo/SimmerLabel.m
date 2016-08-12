//
//  SimmerLabel.m
//  AnimationTest
//
//  Created by l on 16/8/10.
//  Copyright © 2016年 l. All rights reserved.
//

#import "SimmerLabel.h"
#import "TimerTask.h"
#import "NSArray+DataType.h"

@interface SimmerInner : UIView

@property (nonatomic, strong) UILabel *animationLabel;
@property (nonatomic, strong) UIView *mask;

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) UIColor *animationColor;

@end

@implementation SimmerInner


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _animationLabel = [[UILabel alloc] init];
        _animationLabel.textColor = [[UIColor cyanColor] colorWithAlphaComponent:0.5f];
        [self addSubview:_animationLabel];
        [self creatMask];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _animationLabel = [[UILabel alloc] init];
        _animationLabel.textColor = [[UIColor cyanColor] colorWithAlphaComponent:0.5f];
        [self addSubview:_animationLabel];
        [self creatMask];
        [self updataFrame:frame];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    [self updataFrame:frame];
}

- (void)setColors:(NSArray *)colors {

    if (colors.count == 0 || ![colors checkDataType:[UIColor class]]) {
        return;
    }
    
    NSMutableArray *colorArray = [NSMutableArray array];
    [colors enumerateObjectsUsingBlock:^(UIColor *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [colorArray addObject:(__bridge id)obj.CGColor];
    }];
    
    _colors = [colorArray copy];
    _gradientLayer.colors = _colors;
}

- (void)setAnimationColor:(UIColor *)animationColor {
    _animationColor = animationColor;
    _animationLabel.textColor = [animationColor colorWithAlphaComponent:0.5];
}

- (void)creatMask{
    
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.colors           = @[(__bridge id)[UIColor clearColor].CGColor,
                                        (__bridge id)[UIColor whiteColor].CGColor,
                                        (__bridge id)[UIColor whiteColor].CGColor,
                                        (__bridge id)[UIColor clearColor].CGColor];
    _gradientLayer.locations        = @[@(0.01), @(0.1), @(0.3),@(0.4)];
    _gradientLayer.startPoint       = CGPointMake(0, 0);
    _gradientLayer.endPoint         = CGPointMake(1, 0);
    
    self.mask     = [[UIView alloc] init];
    [self.mask.layer addSublayer:_gradientLayer];
    self.maskView = self.mask;
}

- (void)updataFrame:(CGRect)frame {
    
    _animationLabel.frame = frame;
    _gradientLayer.frame = _animationLabel.bounds;
    _mask.frame = _animationLabel.bounds;
}

- (CGRect)initMaskDirection:(AnimationDirection)direction {

    switch (direction) {
        case kAnimationDirectionLeft:
        {
            CGRect frame = self.mask.frame;
            frame.origin.x = CGRectGetWidth(frame);
            self.mask.frame = frame;
        }
            break;
        case kAnimationDirectionRight:
        {
            CGRect frame    = self.mask.frame;
            frame.origin.x = 0;
            self.mask.frame    = frame;
        }
            break;
    }
    
    return self.mask.frame;
}

- (CGRect)getMaskDirection:(AnimationDirection)direction {
    
    CGRect frame;
    switch (direction) {
        case kAnimationDirectionLeft:
        {
            frame = self.mask.frame;
            frame.origin.x -= CGRectGetWidth(frame);
        }
            break;
        case kAnimationDirectionRight:
        {
            frame = self.mask.frame;
            frame.origin.x += CGRectGetWidth(frame);
            
        }
            break;
    }
    return frame;
}

@end

@interface SimmerLabel()

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) SimmerInner *innerView;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) AnimationDirection direction;

@end

@implementation SimmerLabel

- (void)dealloc {
    [[TimerTask sharedInstance] removeTimerWittarget:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _contentLabel = [[UILabel alloc] init];
        [self addSubview:_contentLabel];
        
        _innerView = [[SimmerInner alloc] init];
        [self addSubview:_innerView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _contentLabel = [[UILabel alloc] init];
        [self addSubview:_contentLabel];
        
        _innerView = [[SimmerInner alloc] init];
        [self addSubview:_innerView];
        
        [self updataFrame:frame];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updataFrame:frame];
}

- (void)updataFrame:(CGRect)frame {
    _contentLabel.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    _innerView.frame = _contentLabel.frame;
}

- (void)setText:(NSString *)text {
    _text = text;
    _contentLabel.text = text;
    _innerView.animationLabel.text = text;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    _contentLabel.font = font;
    _innerView.animationLabel.font = font;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    _contentLabel.textColor = textColor;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textAlignment = textAlignment;
    _contentLabel.textAlignment = textAlignment;
    _innerView.animationLabel.textAlignment = textAlignment;
}

- (void)setAnimationColor:(UIColor *)animationColor {
    _animationColor = animationColor;
    _innerView.animationColor = animationColor;
}

- (void)runWithAnimationDirection:(AnimationDirection)direction {
    _direction = direction;
    [self createTimer];
}

- (void)createTimer {
    
    if ([[TimerTask sharedInstance] containTarget:self]) {
        [[TimerTask sharedInstance] removeTimerWittarget:self];
    }
    
    [self run];
    
    [[TimerTask sharedInstance] addTimerTaskWith:2.01 target:self userInfo:nil repeats:YES processBlock:^{
        [self run];
    }];
}

- (void)run {
    
    [_innerView initMaskDirection:_direction];
    switch (_direction) {
        case kAnimationDirectionLeft:
        {
            [UIView animateWithDuration:2 animations:^{
                _innerView.mask.frame = [_innerView getMaskDirection:_direction];
            } completion:^(BOOL finished) {
                _innerView.mask.frame = [_innerView initMaskDirection:_direction];;
            }];
        }
            break;
        case kAnimationDirectionRight:
        {
            [UIView animateWithDuration:2 animations:^{
                _innerView.mask.frame = [_innerView getMaskDirection:_direction];
            } completion:^(BOOL finished) {
                _innerView.mask.frame = [_innerView initMaskDirection:_direction];;
            }];
        }
            break;
    }
}

@end
