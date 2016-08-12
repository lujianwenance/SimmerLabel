//
//  TimerTask.h
//  SimmerLabelDemo
//
//  Created by l on 16/8/12.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimerTask : NSObject

+ (instancetype)sharedInstance;

- (void)addTimerTaskWith:(NSTimeInterval)timeInterval target:(id)aTarget userInfo:(NSDictionary *)userInfo repeats:(BOOL)repeats processBlock:(dispatch_block_t)block;
- (void)removeTimerWittarget:(id)target;
- (void)removeAllTimers;

- (BOOL)containTarget:(id)target;

@end
