//
//  NSArray+DataType.m
//  SimmerLabelDemo
//
//  Created by l on 16/8/12.
//  Copyright © 2016年 l. All rights reserved.
//

#import "NSArray+DataType.h"

@implementation NSArray (DataType)

- (BOOL)checkDataType:(Class)class {
    
    __block BOOL right = YES;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:class]) {
            right = NO;
            *stop = YES;
        }
    }];
    
    return right;
}

@end
